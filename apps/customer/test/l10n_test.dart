import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repairme_customer/l10n/cupertino_fallback.dart';
import 'package:repairme_customer/l10n/l10n.dart';

Future<AppLocalizations> _load(WidgetTester tester, String language) async {
  late AppLocalizations l10n;
  await tester.pumpWidget(
    MaterialApp(
      locale: Locale(language),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        CupertinoFallbackDelegate(),
      ],
      home: Builder(
        builder: (context) {
          l10n = context.l10n;
          return const SizedBox();
        },
      ),
    ),
  );
  return l10n;
}

void main() {
  testWidgets('English, Sinhala and Tamil are all available', (tester) async {
    expect(AppLocalizations.supportedLocales.map((l) => l.languageCode), containsAll(['en', 'si', 'ta']));

    final en = await _load(tester, 'en');
    final si = await _load(tester, 'si');
    final ta = await _load(tester, 'ta');

    expect(en.navHome, 'Home');
    expect(si.navHome, 'මුල් පිටුව');
    expect(ta.navHome, 'முகப்பு');
    expect({en.logOut, si.logOut, ta.logOut}.length, 3);
  });

  testWidgets('text with numbers fills them in', (tester) async {
    final en = await _load(tester, 'en');
    expect(en.techniciansOnline(1), startsWith('1 technician online'));
    expect(en.techniciansOnline(5), startsWith('5 technicians online'));
    expect(en.callNumber('+94 11 000 0000'), 'Call +94 11 000 0000');

    final si = await _load(tester, 'si');
    expect(si.techniciansOnline(5), contains('5'));
  });

  testWidgets('money prefix follows the language', (tester) async {
    expect((await _load(tester, 'en')).currencyPrefix, 'Rs.');
    expect((await _load(tester, 'si')).currencyPrefix, 'රු.');
    expect((await _load(tester, 'ta')).currencyPrefix, 'ரூ.');
  });
}
