import 'dart:typed_data';

import '../core/api_client.dart';
import 'booking_draft.dart';
import 'models.dart';

/// All RepairMe API calls used by the customer app.
class Repository {
  Repository(this.api);

  final ApiClient api;

  Future<Catalog> catalog() async =>
      Catalog.fromJson(await api.get('/service-categories') as Map<String, dynamic>);

  Future<Profile> profile() async =>
      Profile.fromJson(await api.get('/me') as Map<String, dynamic>);

  Future<Profile> updateProfile({String? fullName, String? language}) async =>
      Profile.fromJson(await api.patch('/me', {
        'fullName': ?fullName,
        'language': ?language,
      }) as Map<String, dynamic>);

  Future<List<SavedAddress>> addresses() async =>
      (await api.get('/addresses') as List)
          .map((e) => SavedAddress.fromJson(e as Map<String, dynamic>))
          .toList();

  Future<void> deleteAddress(String id) => api.delete('/addresses/$id');

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

  Future<List<TopTechnician>> topTechnicians() async =>
      (await api.get('/technicians/top-rated') as List)
          .map((e) => TopTechnician.fromJson(e as Map<String, dynamic>))
          .toList();

  Future<List<Conversation>> conversations() async =>
      (await api.get('/conversations') as List)
          .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
          .toList();
}
