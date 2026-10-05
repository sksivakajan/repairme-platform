import 'package:flutter/widgets.dart';

import '../data/models.dart';
import 'l10n.dart';

extension BookingText on BuildContext {
  String bookingTypeLabel(BookingType type) => switch (type) {
        BookingType.emergency => l10n.bookingTypeEmergency,
        BookingType.scheduled => l10n.bookingTypeSchedule,
        BookingType.inspection => l10n.bookingTypeInspection,
      };

  /// "HOME" / "OFFICE" / "OTHER" (as stored) in the customer's language.
  String addressLabelText(String label) => switch (label) {
        'HOME' => l10n.addressHome,
        'OFFICE' => l10n.addressOffice,
        'OTHER' => l10n.addressOther,
        _ => label,
      };
}
