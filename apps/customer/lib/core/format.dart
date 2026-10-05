import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../l10n/l10n.dart';

final _rupees = NumberFormat('#,##0', 'en_US');
final _rupeesCents = NumberFormat('#,##0.00', 'en_US');

bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

/// True when [value] falls on today's date (phone time).
bool isToday(DateTime value) => _sameDay(value.toLocal(), DateTime.now());

/// Money, dates and times in the language the customer chose.
extension Formatting on BuildContext {
  String get _locale => Localizations.localeOf(this).languageCode;

  /// 325000 cents -> "Rs. 3,250" (රු. / ரூ. in Sinhala / Tamil)
  String lkr(int cents) {
    final value = cents / 100;
    return '${l10n.currencyPrefix} ${cents % 100 == 0 ? _rupees.format(value) : _rupeesCents.format(value)}';
  }

  String time(DateTime value) => DateFormat('h:mm a', _locale).format(value.toLocal());

  String day(DateTime value) {
    final local = value.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(local.year, local.month, local.day);
    if (date == today) return l10n.today;
    if (date == today.subtract(const Duration(days: 1))) return l10n.yesterday;
    if (date == today.add(const Duration(days: 1))) return l10n.tomorrow;
    return DateFormat(local.year == now.year ? 'EEE d MMM' : 'd MMM y', _locale).format(local);
  }

  String window(DateTime start, DateTime end) =>
      '${day(start)} · ${DateFormat('h:mm', _locale).format(start.toLocal())} – ${DateFormat('h:mm a', _locale).format(end.toLocal())}';
}

String initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  return parts.take(2).map((p) => p[0].toUpperCase()).join();
}

/// Sri Lankan mobile number to E.164: "077 123 4567" / "771234567" -> "+94771234567".
String? toSriLankaE164(String input) {
  var digits = input.replaceAll(RegExp(r'\D'), '');
  if (digits.startsWith('94')) digits = digits.substring(2);
  if (digits.startsWith('0')) digits = digits.substring(1);
  if (!RegExp(r'^7\d{8}$').hasMatch(digits)) return null;
  return '+94$digits';
}

/// "+94771234567" -> "+94 77 123 4567"
String prettyPhone(String e164) {
  final m = RegExp(r'^\+94(\d{2})(\d{3})(\d{4})$').firstMatch(e164);
  return m == null ? e164 : '+94 ${m[1]} ${m[2]} ${m[3]}';
}
