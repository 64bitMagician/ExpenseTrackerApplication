import 'package:flutter/material.dart';

/// Hides the current snackbar (if any) and shows [message] instead.
void showReplacingSnackbar(BuildContext context, String message, {Color? color}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
}
