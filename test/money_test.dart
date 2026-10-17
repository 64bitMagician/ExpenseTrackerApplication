import 'package:expense_tracker/utils/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseAmount', () {
    test('accepts dot and comma as decimal separator', () {
      expect(parseAmount('12.5'), 12.5);
      expect(parseAmount('12,5'), 12.5);
    });

    test('ignores surrounding whitespace and spaces as thousand separators', () {
      expect(parseAmount('  7 '), 7);
      expect(parseAmount('1 000'), 1000);
    });

    test('rounds to whole cents', () {
      expect(parseAmount('3.14159'), 3.14);
    });

    test('rejects zero, negative and non-numeric input', () {
      for (final input in ['', '0', '-50', 'abc', '12.5.3', 'NaN', 'Infinity']) {
        expect(parseAmount(input), isNull, reason: '"$input" should be rejected');
      }
    });
  });

  group('parseStoredAmount', () {
    test('reads values written by older app versions', () {
      expect(parseStoredAmount('12.5'), 12.5);
      expect(parseStoredAmount('12,5'), 12.5);
    });

    test('treats unreadable values as 0 instead of throwing', () {
      expect(parseStoredAmount('abc'), 0);
      expect(parseStoredAmount(''), 0);
    });
  });

  group('formatMoney', () {
    // de_DE puts a non-breaking space before the euro sign
    String normalize(String s) => s.replaceAll(' ', ' ');

    test('uses German formatting with euro sign', () {
      expect(normalize(formatMoney(1234.5)), '1.234,50 €');
      expect(normalize(formatMoney(0)), '0,00 €');
    });

    test('formats negative balances', () {
      expect(normalize(formatMoney(-20)), '-20,00 €');
    });
  });
}
