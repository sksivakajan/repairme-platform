// Models for the RepairMe API responses.

DateTime? _date(dynamic value) => value == null ? null : DateTime.parse(value as String);
double? _num(dynamic value) => value == null ? null : double.tryParse(value.toString());
List<T> _list<T>(dynamic value, T Function(Map<String, dynamic>) parse) =>
    (value as List? ?? []).map((e) => parse(e as Map<String, dynamic>)).toList();

enum BookingType { emergency, scheduled, inspection }

BookingType bookingTypeFrom(String value) => BookingType.values.byName(value.toLowerCase());
String bookingTypeApi(BookingType type) => type.name.toUpperCase();

String bookingTypeLabel(BookingType type) => switch (type) {
      BookingType.emergency => 'Emergency',
      BookingType.scheduled => 'Schedule',
      BookingType.inspection => 'Inspection',
    };

class ProblemType {
  ProblemType.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String;

  final String id;
  final String name;
}

class ServiceCategory {
  ServiceCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        slug = json['slug'] as String,
        name = json['name'] as String,
        description = json['description'] as String,
        iconKey = json['iconKey'] as String,
        isPopular = json['isPopular'] as bool,
        visitFeeCents = json['visitFeeCents'] as int,
        problemTypes = _list(json['problemTypes'], ProblemType.fromJson);

  final String id;
  final String slug;
  final String name;
  final String description;
  final String iconKey;
  final bool isPopular;
  final int visitFeeCents;
  final List<ProblemType> problemTypes;
}

class Catalog {
  Catalog.fromJson(Map<String, dynamic> json)
      : categories = _list(json['categories'], ServiceCategory.fromJson),
        onlineTechnicians = json['onlineTechnicians'] as int;

  final List<ServiceCategory> categories;
  final int onlineTechnicians;
}

class Profile {
  Profile.fromJson(Map<String, dynamic> json)
      : phoneNumber = json['phoneNumber'] as String?,
        fullName = json['fullName'] as String?,
        language = json['language'] as String,
        bookingCount = json['bookingCount'] as int,
        addressCount = json['addressCount'] as int,
        unreadNotifications = json['unreadNotifications'] as int;

  final String? phoneNumber;
  final String? fullName;
  final String language;
  final int bookingCount;
  final int addressCount;
  final int unreadNotifications;

  String get firstName => (fullName ?? '').trim().split(' ').first;
}

class AddressInput {
  AddressInput({
    required this.line1,
    required this.area,
    required this.city,
    this.houseNumber,
    this.landmark,
    this.latitude,
    this.longitude,
  });

  final String line1;
  final String area;
  final String city;
  final String? houseNumber;
  final String? landmark;
  final double? latitude;
  final double? longitude;

  Map<String, dynamic> toJson() => {
        'line1': line1,
        'area': area,
        'city': city,
        if (houseNumber != null && houseNumber!.isNotEmpty) 'houseNumber': houseNumber,
        if (landmark != null && landmark!.isNotEmpty) 'landmark': landmark,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };

  String get oneLine => [
        if (houseNumber != null && houseNumber!.isNotEmpty) houseNumber,
        line1,
        area,
      ].join(', ');
}

class SavedAddress {
  SavedAddress.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        label = json['label'] as String,
        isDefault = json['isDefault'] as bool,
        address = AddressInput(
          line1: json['line1'] as String,
          area: json['area'] as String,
          city: json['city'] as String,
          houseNumber: json['houseNumber'] as String?,
          landmark: json['landmark'] as String?,
          latitude: _num(json['latitude']),
          longitude: _num(json['longitude']),
        );

  final String id;
  final String label;
  final bool isDefault;
  final AddressInput address;

  String get labelText => label[0] + label.substring(1).toLowerCase();
}

class Technician {
  Technician.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        displayName = json['displayName'] as String,
        rating = _num(json['rating']),
        ratingCount = json['ratingCount'] as int,
        jobsCompleted = json['jobsCompleted'] as int;

  final String id;
  final String displayName;
  final double? rating;
  final int ratingCount;
  final int jobsCompleted;

  String get firstName => displayName.split(' ').first;
}

class BookingSummary {
  BookingSummary.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        reference = json['reference'] as String,
        type = bookingTypeFrom(json['type'] as String),
        status = json['status'] as String,
        title = json['title'] as String,
        categoryName = (json['category'] as Map)['name'] as String,
        categoryIcon = (json['category'] as Map)['iconKey'] as String,
        technician = json['technician'] == null
            ? null
            : Technician.fromJson(json['technician'] as Map<String, dynamic>),
        addressArea = json['addressArea'] as String,
        scheduledStart = _date(json['scheduledStart']),
        scheduledEnd = _date(json['scheduledEnd']),
        totalCents = json['totalCents'] as int?,
        cancelledBy = json['cancelledBy'] as String?,
        createdAt = _date(json['createdAt'])!;

  final String id;
  final String reference;
  final BookingType type;
  final String status;
  final String title;
  final String categoryName;
  final String categoryIcon;
  final Technician? technician;
  final String addressArea;
  final DateTime? scheduledStart;
  final DateTime? scheduledEnd;
  final int? totalCents;
  final String? cancelledBy;
  final DateTime createdAt;
}

class BookingEvent {
  BookingEvent.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String,
        note = json['note'] as String?,
        createdAt = _date(json['createdAt'])!;

  final String status;
  final String? note;
  final DateTime createdAt;
}

class BookingPhoto {
  BookingPhoto.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        kind = json['kind'] as String;

  final String id;
  final String kind;
}

class QuotationItem {
  QuotationItem.fromJson(Map<String, dynamic> json)
      : description = json['description'] as String,
        quantity = json['quantity'] as int,
        totalCents = json['totalCents'] as int;

  final String description;
  final int quantity;
  final int totalCents;
}

class Quotation {
  Quotation.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        status = json['status'] as String,
        note = json['note'] as String?,
        visitFeeCents = json['visitFeeCents'] as int,
        labourCents = json['labourCents'] as int,
        partsCents = json['partsCents'] as int,
        totalCents = json['totalCents'] as int,
        items = _list(json['items'], QuotationItem.fromJson);

  final String id;
  final String status;
  final String? note;
  final int visitFeeCents;
  final int labourCents;
  final int partsCents;
  final int totalCents;
  final List<QuotationItem> items;
}

class Payment {
  Payment.fromJson(Map<String, dynamic> json)
      : method = json['method'] as String,
        status = json['status'] as String,
        amountCents = json['amountCents'] as int,
        paidAt = _date(json['paidAt']);

  final String method;
  final String status;
  final int amountCents;
  final DateTime? paidAt;
}

class BookingDetail extends BookingSummary {
  BookingDetail.fromJson(super.json)
      : description = json['description'] as String,
        symptoms = (json['symptoms'] as List).cast<String>(),
        address = AddressInput(
          line1: json['address']['line1'] as String,
          area: json['address']['area'] as String,
          city: json['address']['city'] as String,
          houseNumber: json['address']['houseNumber'] as String?,
          landmark: json['address']['landmark'] as String?,
        ),
        paymentMethod = json['paymentMethod'] as String,
        visitFeeCents = json['visitFeeCents'] as int,
        etaMinutes = json['etaMinutes'] as int?,
        jobCode = json['jobCode'] as String?,
        events = _list(json['events'], BookingEvent.fromJson),
        photos = _list(json['photos'], BookingPhoto.fromJson),
        quotation = json['quotation'] == null
            ? null
            : Quotation.fromJson(json['quotation'] as Map<String, dynamic>),
        payment = json['payment'] == null
            ? null
            : Payment.fromJson(json['payment'] as Map<String, dynamic>),
        rating = (json['review'] as Map?)?['rating'] as int?,
        unreadMessages = json['unreadMessages'] as int,
        canCancel = json['canCancel'] as bool,
        canChat = json['canChat'] as bool,
        canAddPhotos = json['canAddPhotos'] as bool,
        super.fromJson();

  final String description;
  final List<String> symptoms;
  final AddressInput address;
  final String paymentMethod;
  final int visitFeeCents;
  final int? etaMinutes;
  final String? jobCode;
  final List<BookingEvent> events;
  final List<BookingPhoto> photos;
  final Quotation? quotation;
  final Payment? payment;
  final int? rating;
  final int unreadMessages;
  final bool canCancel;
  final bool canChat;
  final bool canAddPhotos;

  DateTime? eventAt(String status) {
    for (final event in events.reversed) {
      if (event.status == status) return event.createdAt;
    }
    return null;
  }

  Quotation? get pendingQuotation =>
      status == 'AWAITING_APPROVAL' && quotation?.status == 'PENDING' ? quotation : null;
}

class ChatMessage {
  ChatMessage.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        body = json['body'] as String,
        mine = json['mine'] as bool,
        readAt = _date(json['readAt']),
        createdAt = _date(json['createdAt'])!;

  final String id;
  final String body;
  final bool mine;
  final DateTime? readAt;
  final DateTime createdAt;
}

class AppNotification {
  AppNotification.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        bookingId = json['bookingId'] as String?,
        title = json['title'] as String,
        body = json['body'] as String,
        readAt = _date(json['readAt']),
        createdAt = _date(json['createdAt'])!;

  final String id;
  final String? bookingId;
  final String title;
  final String body;
  final DateTime? readAt;
  final DateTime createdAt;
}

class SupportTicket {
  SupportTicket.fromJson(Map<String, dynamic> json)
      : reference = json['reference'] as String,
        bookingReference = json['bookingReference'] as String?,
        subject = json['subject'] as String,
        status = json['status'] as String;

  final String reference;
  final String? bookingReference;
  final String subject;
  final String status;
}

/// A best-rated technician shown on the home screen (first name only).
class TopTechnician {
  TopTechnician.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'] as String,
        categorySlug = json['categorySlug'] as String?,
        categoryName = json['categoryName'] as String?,
        rating = _num(json['rating']) ?? 0,
        ratingCount = json['ratingCount'] as int,
        jobsCompleted = json['jobsCompleted'] as int;

  final String firstName;
  final String? categorySlug;
  final String? categoryName;
  final double rating;
  final int ratingCount;
  final int jobsCompleted;

  /// The trade as a job title: "Electrician", "Plumber"…
  String get trade => switch (categorySlug) {
        'electrical' || 'fans-lights' => 'Electrician',
        'plumbing' => 'Plumber',
        'ac' => 'AC technician',
        'refrigerators' || 'washing-machines' => 'Appliance repair',
        'mechanic' => 'Mechanic',
        'doors-locks' => 'Locksmith',
        'carpentry' => 'Carpenter',
        'general' => 'Handyman',
        _ => categoryName ?? 'Technician',
      };
}

class ConversationMessage {
  ConversationMessage.fromJson(Map<String, dynamic> json)
      : body = json['body'] as String,
        mine = json['mine'] as bool,
        createdAt = DateTime.parse(json['createdAt'] as String);

  final String body;
  final bool mine;
  final DateTime createdAt;
}

/// The chat with the technician of one booking.
class Conversation {
  Conversation.fromJson(Map<String, dynamic> json)
      : bookingId = json['bookingId'] as String,
        reference = json['reference'] as String,
        title = json['title'] as String,
        categoryIcon = json['categoryIcon'] as String,
        status = json['status'] as String,
        technicianName = json['technicianName'] as String,
        chatOpen = json['chatOpen'] as bool,
        lastMessage = json['lastMessage'] == null
            ? null
            : ConversationMessage.fromJson(json['lastMessage'] as Map<String, dynamic>),
        unreadCount = json['unreadCount'] as int,
        lastActivityAt = DateTime.parse(json['lastActivityAt'] as String);

  final String bookingId;
  final String reference;
  final String title;
  final String categoryIcon;
  final String status;
  final String technicianName;
  final bool chatOpen;
  final ConversationMessage? lastMessage;
  final int unreadCount;
  final DateTime lastActivityAt;
}
