import 'dart:typed_data';

import 'models.dart';

class DraftPhoto {
  DraftPhoto(this.bytes, this.filename);

  final Uint8List bytes;
  final String filename;
}

/// A booking being put together across the request screens (C07–C12).
class BookingDraft {
  BookingDraft({required this.category, required this.type});

  final ServiceCategory category;
  BookingType type;

  ProblemType? problemType;
  String description = '';
  final Set<String> symptoms = {};
  final List<DraftPhoto> photos = [];

  String? savedAddressId;
  AddressInput? address;
  bool saveAddress = true;
  String addressLabel = 'HOME';

  DateTime? windowStart;
  DateTime? windowEnd;

  bool get needsSchedule => type != BookingType.emergency;

  String get title => problemType?.name ?? category.name;

  Map<String, dynamic> toJson() => {
        'categoryId': category.id,
        if (problemType != null) 'problemTypeId': problemType!.id,
        'type': bookingTypeApi(type),
        'description': description.trim(),
        'symptoms': symptoms.toList(),
        if (savedAddressId != null)
          'addressId': savedAddressId
        else ...{
          'address': address!.toJson(),
          'saveAddress': saveAddress,
          'addressLabel': addressLabel,
        },
        if (needsSchedule && windowStart != null) ...{
          'scheduledStart': windowStart!.toUtc().toIso8601String(),
          'scheduledEnd': windowEnd!.toUtc().toIso8601String(),
        },
        'paymentMethod': 'CASH',
      };
}
