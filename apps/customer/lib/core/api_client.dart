import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../config/env.dart';

/// An error from the API, with a message safe to show the customer.
class ApiException implements Exception {
  ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => message;
}

typedef AuthHeaderProvider = Future<String?> Function();

/// Thin JSON client for the RepairMe API.
class ApiClient {
  ApiClient({required this.authHeader, http.Client? client})
      : _client = client ?? http.Client();

  final AuthHeaderProvider authHeader;
  final http.Client _client;
  void Function()? onUnauthorized;

  static const _timeout = Duration(seconds: 20);

  Future<dynamic> get(String path) => _send('GET', path);
  Future<dynamic> post(String path, [Object? body]) => _send('POST', path, body);
  Future<dynamic> patch(String path, Object body) => _send('PATCH', path, body);
  Future<dynamic> put(String path, Object body) => _send('PUT', path, body);
  Future<dynamic> delete(String path) => _send('DELETE', path);

  Uri uri(String path) => Uri.parse('${Env.apiBaseUrl}/v1$path');

  Future<Map<String, String>> headers({bool json = true}) async {
    final auth = await authHeader();
    return {
      if (json) 'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (auth != null) 'Authorization': auth,
    };
  }

  Future<dynamic> _send(String method, String path, [Object? body]) async {
    final request = http.Request(method, uri(path))..headers.addAll(await headers());
    if (body != null) request.body = jsonEncode(body);
    return _handle(() => _client.send(request));
  }

  Future<dynamic> upload(String path, Uint8List bytes, String filename) async {
    final request = http.MultipartRequest('POST', uri(path))
      ..headers.addAll(await headers(json: false))
      ..files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename));
    return _handle(() => _client.send(request));
  }

  Future<Uint8List> getBytes(String path) async {
    final response = await _client
        .get(uri(path), headers: await headers(json: false))
        .timeout(_timeout);
    if (response.statusCode >= 400) {
      throw ApiException(response.statusCode, 'Could not load the image');
    }
    return response.bodyBytes;
  }

  Future<dynamic> _handle(Future<http.StreamedResponse> Function() send) async {
    final http.Response response;
    try {
      response = await http.Response.fromStream(await send().timeout(_timeout));
    } on Exception {
      throw ApiException(0, 'Cannot reach RepairMe. Check your connection and try again.');
    }

    final text = response.body;
    final decoded = text.isEmpty ? null : _tryDecode(text);
    if (response.statusCode < 400) return decoded;

    if (response.statusCode == 401) onUnauthorized?.call();
    throw ApiException(response.statusCode, _message(response.statusCode, decoded));
  }

  static dynamic _tryDecode(String text) {
    try {
      return jsonDecode(text);
    } on FormatException {
      return null;
    }
  }

  static String _message(int status, dynamic body) {
    if (body is Map && body['message'] != null) {
      final message = body['message'];
      if (message is List && message.isNotEmpty) return message.first.toString();
      if (message is String && status < 500) return message;
    }
    if (status == 401) return 'Please sign in again.';
    if (status == 404) return 'Not found.';
    return 'Something went wrong. Please try again.';
  }
}
