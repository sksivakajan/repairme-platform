import 'dart:typed_data';

import '../core/api_client.dart';
import 'booking_draft.dart';
import 'models.dart';

/// All RepairMe API calls used by the customer app.
class Repository {
  Repository(this.api);

  final ApiClient api;

  // Things that barely change are kept for a couple of minutes, so moving around
  // the app (and coming back to Home) doesn't ask the server again every time.
  final _cache = <String, ({DateTime at, Future<Object?> value})>{};

  Future<T> _cached<T>(String key, Duration ttl, Future<T> Function() load) {
    final hit = _cache[key];
    if (hit != null && DateTime.now().difference(hit.at) < ttl) return hit.value as Future<T>;
    final future = load();
    _cache[key] = (at: DateTime.now(), value: future);
    // A failed request must not be remembered.
    future.then<void>((_) {}, onError: (Object _) {
      if (identical(_cache[key]?.value, future)) _cache.remove(key);
    });
    return future;
  }

  /// Forget cached answers (after signing out, for example).
  void clearCache() {
    _cache.clear();
    _primedProfile = null;
  }

  Profile? _primedProfile;
  DateTime? _primedAt;

  /// Hands over the profile fetched while the app was starting, so Home can use it
  /// straight away instead of asking again. It is used once, and only if fresh.
  void primeProfile(Profile profile) {
    _primedProfile = profile;
    _primedAt = DateTime.now();
  }

  Future<Catalog> catalog() => _cached(
        'catalog',
        const Duration(minutes: 2),
        () async => Catalog.fromJson(await api.get('/service-categories') as Map<String, dynamic>),
      );

  Future<Profile> profile() async {
    final primed = _primedProfile;
    final at = _primedAt;
    _primedProfile = null;
    if (primed != null && at != null && DateTime.now().difference(at) < const Duration(seconds: 10)) {
      return primed;
    }
    return Profile.fromJson(await api.get('/me') as Map<String, dynamic>);
  }

  /// Only the fields you pass change. An empty email or birthday clears it.
  Future<Profile> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? birthday,
    String? gender,
    String? language,
  }) async =>
      Profile.fromJson(await api.patch('/me', {
        'firstName': ?firstName,
        'lastName': ?lastName,
        'email': ?email,
        'birthday': ?birthday,
        'gender': ?gender,
        'language': ?language,
      }) as Map<String, dynamic>);

  /// First-time account setup after the mobile number is verified.
  Future<Profile> completeProfile({
    required String firstName,
    required String lastName,
    String? email,
    required List<DocumentRef> accepted,
  }) async =>
      Profile.fromJson(await api.post('/me/complete-profile', {
        'firstName': firstName,
        'lastName': lastName,
        if (email != null && email.isNotEmpty) 'email': email,
        'acceptedDocuments': [for (final d in accepted) d.toJson()],
      }) as Map<String, dynamic>);

  Future<Profile> changePhone(String e164) async =>
      Profile.fromJson(await api.put('/me/phone', {'phoneNumber': e164}) as Map<String, dynamic>);

  Future<void> deleteAccount(String reason, String? details) => api.post('/me/delete', {
        'reason': reason,
        if (details != null && details.trim().isNotEmpty) 'details': details.trim(),
      });

  Future<void> uploadProfilePhoto(Uint8List bytes, String filename) => api.upload('/me/photo', bytes, filename);
  Future<Uint8List> profilePhoto() => api.getBytes('/me/photo');
  Future<void> removeProfilePhoto() => api.delete('/me/photo');

  Future<EmergencyContact?> emergencyContact() async {
    final json = await api.get('/me/emergency-contact');
    return json is Map<String, dynamic> && json.isNotEmpty ? EmergencyContact.fromJson(json) : null;
  }

  Future<EmergencyContact> saveEmergencyContact(String name, String relationship, String phone) async =>
      EmergencyContact.fromJson(await api.put('/me/emergency-contact', {
        'name': name,
        'relationship': relationship,
        'phoneNumber': phone,
      }) as Map<String, dynamic>);

  Future<void> removeEmergencyContact() => api.delete('/me/emergency-contact');

  Future<NotificationPrefs> saveNotificationPreferences(NotificationPrefs prefs) async =>
      NotificationPrefs.fromJson(await api.patch('/me/notification-preferences', prefs.toJson()) as Map<String, dynamic>);

  Future<List<LegalDocument>> legalDocuments() async =>
      (await api.get('/legal/documents') as List)
          .map((e) => LegalDocument.fromJson(e as Map<String, dynamic>))
          .toList();

  Future<LegalDocument> legalDocument(String type) async =>
      LegalDocument.fromJson(await api.get('/legal/documents/$type') as Map<String, dynamic>);

  Future<void> acceptLegal(List<DocumentRef> documents) =>
      api.post('/me/legal-acceptances', {'documents': [for (final d in documents) d.toJson()]});

  Future<List<SavedAddress>> addresses() async =>
      (await api.get('/addresses') as List)
          .map((e) => SavedAddress.fromJson(e as Map<String, dynamic>))
          .toList();

  Future<void> deleteAddress(String id) => api.delete('/addresses/$id');

  Map<String, dynamic> _addressBody(AddressInput address, String label, bool isDefault) => {
        ...address.toJson(),
        'label': label,
        'isDefault': isDefault,
      };

  Future<SavedAddress> createAddress(AddressInput address, {required String label, bool isDefault = false}) async =>
      SavedAddress.fromJson(await api.post('/addresses', _addressBody(address, label, isDefault)) as Map<String, dynamic>);

  Future<SavedAddress> updateAddress(String id, AddressInput address, {required String label, bool isDefault = false}) async =>
      SavedAddress.fromJson(await api.put('/addresses/$id', _addressBody(address, label, isDefault)) as Map<String, dynamic>);

  Future<BookingDetail> createBooking(BookingDraft draft) async =>
      BookingDetail.fromJson(await api.post('/bookings', draft.toJson()) as Map<String, dynamic>);

  Future<List<BookingSummary>> bookings(String tab) async =>
      (await api.get('/bookings?tab=$tab') as List)
          .map((e) => BookingSummary.fromJson(e as Map<String, dynamic>))
          .toList();

  Future<BookingDetail> booking(String id) async =>
      BookingDetail.fromJson(await api.get('/bookings/$id') as Map<String, dynamic>);

  Future<BookingDetail> cancel(String id, String reason, {String? details}) async =>
      BookingDetail.fromJson(await api.post('/bookings/$id/cancel', {
        'reason': reason,
        if (details != null && details.isNotEmpty) 'details': details,
      }) as Map<String, dynamic>);

  Future<BookingDetail> decideQuotation(String id, String quotationId, {required bool approve}) async =>
      BookingDetail.fromJson(await api.post(
        '/bookings/$id/quotations/$quotationId/${approve ? 'approve' : 'decline'}',
      ) as Map<String, dynamic>);

  Future<BookingDetail> choosePayment(String id, String method) async =>
      BookingDetail.fromJson(
          await api.post('/bookings/$id/payment', {'method': method}) as Map<String, dynamic>);

  Future<BookingDetail> review(String id, int rating, List<String> tags, String? comment) async =>
      BookingDetail.fromJson(await api.post('/bookings/$id/review', {
        'rating': rating,
        'tags': tags,
        if (comment != null && comment.trim().isNotEmpty) 'comment': comment.trim(),
      }) as Map<String, dynamic>);

  Future<void> uploadPhoto(String bookingId, Uint8List bytes, String filename) =>
      api.upload('/bookings/$bookingId/photos', bytes, filename);

  Future<Uint8List> photoBytes(String bookingId, String photoId) =>
      api.getBytes('/bookings/$bookingId/photos/$photoId');

  Future<List<ChatMessage>> messages(String bookingId) async =>
      (await api.get('/bookings/$bookingId/messages') as List)
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList();

  Future<void> sendMessage(String bookingId, String body) =>
      api.post('/bookings/$bookingId/messages', {'body': body});

  Future<List<AppNotification>> notifications() async =>
      (await api.get('/notifications') as List)
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList();

  Future<void> readAllNotifications() => api.post('/notifications/read-all');

  Future<List<SupportTicket>> tickets() async =>
      (await api.get('/support/tickets') as List)
          .map((e) => SupportTicket.fromJson(e as Map<String, dynamic>))
          .toList();

  Future<void> createTicket(String subject, String message, {String? bookingId}) =>
      api.post('/support/tickets', {
        'subject': subject,
        'message': message,
        'bookingId': ?bookingId,
      });

  Future<List<TopTechnician>> topTechnicians() => _cached(
        'topTechnicians',
        const Duration(minutes: 2),
        () async => (await api.get('/technicians/top-rated') as List)
            .map((e) => TopTechnician.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Future<List<Conversation>> conversations() async =>
      (await api.get('/conversations') as List)
          .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
          .toList();
}
