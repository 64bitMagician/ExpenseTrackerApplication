import 'package:flutter/material.dart';
import '../utils/money.dart';

class CustomizableString {

  /// "12,50 € - Coffee" style text used by both the expense and income lists.
  static Text entryText(BuildContext context, String amount, String name) {
    final formattedAmount = formatMoney(parseStoredAmount(amount));

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: formattedAmount,
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
