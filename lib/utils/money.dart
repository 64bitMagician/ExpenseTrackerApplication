import 'package:intl/intl.dart';

final NumberFormat _currencyFormat = NumberFormat.currency(
  locale: 'de_DE', // '.' as thousand separator and ',' as decimal
  symbol: '€',
  decimalDigits: 2,
);

/// Formats an amount the same way everywhere in the app, e.g. "1.234,50 €".
String formatMoney(double amount) => _currencyFormat.format(amount);

/// Rounds to whole cents so sums and comparisons don't suffer from floating-point drift.
double roundToCents(double amount) => (amount * 100).round() / 100;

/// Parses an amount typed by the user. Accepts both "12.5" and "12,5" as well as
/// spaces as thousand separators ("1 000"). Returns null for anything that is not a
/// positive, finite number.
double? parseAmount(String input) {
  final normalized = input.trim().replaceAll(' ', '').replaceAll(',', '.');
  final value = double.tryParse(normalized);
  if (value == null || !value.isFinite || value <= 0) return null;
  return roundToCents(value);
}

/// Reads an amount stored in a CSV file. Older versions of the app saved incomes
/// without validation, so unreadable values count as 0 instead of crashing.
double parseStoredAmount(String stored) =>
    double.tryParse(stored.trim().replaceAll(',', '.')) ?? 0;
