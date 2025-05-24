import 'package:expense_tracker/utils/customSnackbar.dart';
import 'package:expense_tracker/utils/password_file_management.dart';
import 'package:expense_tracker/utils/password_validator.dart';
import 'package:flutter/material.dart';

// MAIN FUNCTION

void validatePasswordChange(BuildContext context, String oldPassword, String newPassword) {
  // First check if TextFields are not empty
  if (oldPassword == "" || newPassword == "") // If one of the TextFields are empty
      {
    snackbarDeleteAndOverrite(context, 'Please Complete the Text Fields',color: Colors.red);
  }
  else // Both TextFields have content
      {
    // First check for password match
    bool passwordMatch = checkForPasswordMatch(oldPassword);
    if(!passwordMatch) // passwords match
        {
      snackbarDeleteAndOverrite(context, 'Current Password not Matching', color: Colors.red);
    }
    else // Passwords do match
      {
        // Check for new password to be valid
        bool validNewPassword = checkForNewPasswordValidation(context, newPassword);
        if(validNewPassword) // New Password is Valid
          {
          changeActualPassword(context, newPassword);
          Navigator.pop(context);
        }
      }
  }
}

// SIDE FUNCTIONS
String? getCurrentPassword() {
  return PasswordFileManager.storedPassword;
}

bool checkForPasswordMatch(String oldPassword) {
  String? currentPassword = getCurrentPassword();
  if (currentPassword == oldPassword) {
    return true;
  } else
    return false;
}

bool checkForNewPasswordValidation(BuildContext context,String newPassword){
  String? invalidMessage = PasswordValidator.validate(newPassword);
  if(invalidMessage!=null) {
    snackbarDeleteAndOverrite(context, invalidMessage,color: Colors.red);
    return false;
  }
  else // if  invalidMessage is null, which means no problems on validation, we can return true, New Password is Valid
    {
      return true;
    }
}

void changeActualPassword(BuildContext context, String newPassword) async {
  await PasswordFileManager.deletePasswordFile(context);
  await PasswordFileManager.createPasswordFile(context);
  await PasswordFileManager.writeNewPassword(context, newPassword);
  snackbarDeleteAndOverrite(context, "✅ Password Succesfully Changed!", color: Colors.green);
}
