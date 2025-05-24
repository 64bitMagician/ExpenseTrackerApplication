import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomizableString {

  static Text expenseStrings(BuildContext context, String price, String name) {
    double parsedPrice = double.tryParse(price.replaceAll(",", ".")) ?? 0;

    // Format number with thousand separators as dots and 2 decimals
    final formatter = NumberFormat.currency(
      locale: 'de_DE',  // German locale uses '.' as thousand separator and ',' as decimal
      symbol: '€',
      decimalDigits: 2,
    );

    String formattedPrice = formatter.format(parsedPrice).trim();

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$formattedPrice",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const TextSpan(
            text: " - ",
            style: TextStyle(color: Colors.green, fontSize: 30),
          ),
          TextSpan(
            text: name,
            style: Theme.of(context).textTheme.bodyLarge,
            ),
        ],
      ),
    );
  }
}
