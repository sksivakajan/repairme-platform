import 'package:flutter/widgets.dart';

import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';

extension L10nContext on BuildContext {
  /// The text for the language the customer chose.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
