import 'package:flutter/widgets.dart';

import '../data/models.dart';
import 'l10n.dart';

extension TradeText on BuildContext {
  /// A top-rated technician's trade as a job title, in the customer's language.
  String tradeOf(TopTechnician technician) => switch (technician.categorySlug) {
        'electrical' || 'fans-lights' => l10n.tradeElectrician,
        'plumbing' => l10n.tradePlumber,
        'ac' => l10n.tradeAc,
        'refrigerators' || 'washing-machines' => l10n.tradeAppliance,
        'mechanic' => l10n.tradeMechanic,
        'doors-locks' => l10n.tradeLocksmith,
        'carpentry' => l10n.tradeCarpenter,
        'general' => l10n.tradeHandyman,
        _ => technician.categoryName ?? l10n.tradeTechnician,
      };
}
