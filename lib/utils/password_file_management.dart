import 'package:shared_preferences/shared_preferences.dart';

/// Stores the login password in SharedPreferences so it works on every platform,
/// including web. Note: it is stored as plain text, so it is a convenience lock,
/// not real security.
class PasswordFileManager {
  static const String prefsKey = 'password';

  //DATA
  static String? storedPassword;

  static Future<void> loadPassword() async {
    final prefs = await SharedPreferences.getInstance();
    final content = prefs.getString(prefsKey);
    // in case the password is just blank spaces
    storedPassword = (content == null || content.trim().isEmpty) ? null : content;
  }

  static bool checkPassword(String input) => storedPassword != null && input == storedPassword;

  /// A single SharedPreferences write replaces the old password in one step, so a crash
  /// can never leave the password empty (which would let anyone set up a new one).
  static Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefsKey, password);
    storedPassword = password;
  }
}
