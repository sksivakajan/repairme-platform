import 'package:intl/intl.dart';

final _rupees = NumberFormat('#,##0', 'en_US');
final _rupeesCents = NumberFormat('#,##0.00', 'en_US');

/// 325000 cents -> "Rs. 3,250"
String formatLkr(int cents) {
  final value = cents / 100;
  return 'Rs. ${cents % 100 == 0 ? _rupees.format(value) : _rupeesCents.format(value)}';
}

String formatTime(DateTime value) => DateFormat('h:mm a').format(value.toLocal());

String formatDay(DateTime value) {
  final local = value.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(local.year, local.month, local.day);
  if (day == today) return 'Today';
  if (day == today.subtract(const Duration(days: 1))) return 'Yesterday';
  if (day == today.add(const Duration(days: 1))) return 'Tomorrow';
  return DateFormat(local.year == now.year ? 'EEE d MMM' : 'd MMM y').format(local);
}

String formatWindow(DateTime start, DateTime end) =>
    '${formatDay(start)} · ${DateFormat('h:mm').format(start.toLocal())} – ${DateFormat('h:mm a').format(end.toLocal())}';

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
