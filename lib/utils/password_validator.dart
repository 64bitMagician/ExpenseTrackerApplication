class PasswordValidator {
  static String? validate(String password) {
    if (password.length < 10) {
      return 'Password must be at least 10 characters long.';
    }

    if (!RegExp(r'[A-Za-z]').hasMatch(password)) {
      return 'Password must include at least one letter.';
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must include at least one number.';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Password must include at least one special character.';
    }

    return null; // All good
  }
}
