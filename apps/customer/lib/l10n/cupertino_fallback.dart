import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Flutter ships Cupertino text for neither Sinhala nor Tamil. The app only uses
/// Material widgets, so English fills the gap instead of a debug-mode warning.
class CupertinoFallbackDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const CupertinoFallbackDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) => GlobalCupertinoLocalizations.delegate.isSupported(locale)
      ? GlobalCupertinoLocalizations.delegate.load(locale)
      : DefaultCupertinoLocalizations.delegate.load(locale);

  @override
  bool shouldReload(CupertinoFallbackDelegate old) => false;
}
