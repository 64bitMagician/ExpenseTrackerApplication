import 'package:expense_tracker/utils/change_password_validator.dart';
import 'package:expense_tracker/utils/password_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PasswordValidator', () {
    test('accepts a password meeting all rules', () {
      expect(PasswordValidator.validate('secret123!'), isNull);
    });

    test('rejects passwords missing a rule', () {
      expect(PasswordValidator.validate('short1!'), contains('10 characters'));
      expect(PasswordValidator.validate('1234567890!'), contains('letter'));
      expect(PasswordValidator.validate('abcdefghij!'), contains('number'));
      expect(PasswordValidator.validate('abcdefghij1'), contains('special character'));
    });
  });

  group('validatePasswordChange', () {
    const stored = 'oldPassword1!';

    test('requires both fields', () {
      expect(
        validatePasswordChange(storedPassword: stored, currentPassword: '', newPassword: 'newPassword1!'),
        'Please Complete the Text Fields',
      );
    });

    test('rejects a wrong current password', () {
      expect(
        validatePasswordChange(storedPassword: stored, currentPassword: 'wrong', newPassword: 'newPassword1!'),
        'Current Password not Matching',
      );
    });

    test('rejects when no password has been set', () {
      expect(
        validatePasswordChange(storedPassword: null, currentPassword: 'x', newPassword: 'newPassword1!'),
        'Current Password not Matching',
      );
    });

    test('validates the new password', () {
      expect(
        validatePasswordChange(storedPassword: stored, currentPassword: stored, newPassword: 'weak'),
        isNotNull,
      );
    });

    test('allows a valid change', () {
      expect(
        validatePasswordChange(storedPassword: stored, currentPassword: stored, newPassword: 'newPassword1!'),
        isNull,
      );
    });
  });
}
