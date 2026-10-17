import 'package:expense_tracker/utils/password_validator.dart';

/// Checks a password change request. Returns an error message to show the user,
/// or null if the change is allowed.
String? validatePasswordChange({
  required String? storedPassword,
  required String currentPassword,
  required String newPassword,
}) {
  if (currentPassword.isEmpty || newPassword.isEmpty) {
    return 'Please Complete the Text Fields';
  }
  if (storedPassword == null || currentPassword != storedPassword) {
    return 'Current Password not Matching';
  }
  return PasswordValidator.validate(newPassword);
}
