import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repairme_customer/core/format.dart';
import 'package:repairme_customer/screens/auth_screens.dart';

String type(String input) => SriLankaPhoneFormatter()
    .formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(text: input, selection: TextSelection.collapsed(offset: input.length)),
    )
    .text;

void main() {
  test('adds spaces as the number is typed', () {
    expect(type('7'), '7');
    expect(type('77'), '77');
    expect(type('771'), '77 1');
    expect(type('77123'), '77 123');
    expect(type('771234'), '77 123 4');
    expect(type('771234567'), '77 123 4567');
  });

  test('handles a leading 0 and stops at a full number', () {
    expect(type('0771234567'), '077 123 4567');
    expect(type('77123456789'), '77 123 4567');
    expect(type('77-123 45a67'), '77 123 4567');
  });

  test('formatted numbers still convert to E.164', () {
    expect(toSriLankaE164(type('771234567')), '+94771234567');
    expect(toSriLankaE164(type('0771234567')), '+94771234567');
  });
}
