import 'dart:io';
import 'package:expense_tracker/utils/password_validator.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'customSnackbar.dart';

class PasswordFileManager {
  //DATA
  static String? storedPassword;



  static Future<String> get getStoragePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> getPasswordFile() async {
    final path = await getStoragePath;
    return File('$path/password.txt');
  }

  static Future<void> createPasswordFile(BuildContext context) async {
    final file = await getPasswordFile();
    if (!(await file.exists())) { // if does not file exists
      {
        await file.writeAsString('');
        snackbarDeleteAndOverrite(context,"Created password.txt");
      }
    }
  }

  static Future<bool> checkIfPasswordFileExists() async {
    final file = await getPasswordFile();
    return await file.exists();
  }

  static Future<void> deletePasswordFile(BuildContext context) async {
    final file = await getPasswordFile();
    if (await file.exists()) {
      await file.delete();
      storedPassword = null;
      snackbarDeleteAndOverrite(context,"Deleted password.txt");
    } else {
      snackbarDeleteAndOverrite(context,"password.txt does not exist");
    }
  }

  static Future<void> loadPassword() async {
    final file = await getPasswordFile();
    if (await file.exists()) {
      storedPassword = await file.readAsString();
      if (storedPassword != null && storedPassword!.trim().isEmpty) { // in case the password is just blank spaces
        storedPassword = null;
      }
    }
  }

  static Future<void> writeNewPassword(BuildContext context, String password) async {
    final file = await getPasswordFile();
    final currentContent = await file.readAsString();
    if (currentContent.trim().isEmpty) {
      await file.writeAsString(password);
      storedPassword = password;
    } else {
      stderr.writeln("Password file is not empty.");
    }
  }

  static Future<bool> isPasswordSet() async {
    final file = await getPasswordFile();
    return file.existsSync() && (await file.readAsString()).trim().isNotEmpty;
  }

  static bool handleLogin(TextEditingController controller, BuildContext context) {
    if (controller.text == storedPassword) {
      snackbarDeleteAndOverrite(context,"✅ Login Successful!");
      return true;
    } else {
      snackbarDeleteAndOverrite(context,"❌ Incorrect Password!");
      return false;
    }
  }

  static Future<bool> handleSetupPassword(TextEditingController controller, BuildContext context) async {
    final password = controller.text;
    final validationMessage = PasswordValidator.validate(password);

    if (validationMessage != null) {
      snackbarDeleteAndOverrite(context, validationMessage,color: Colors.redAccent);
      return false;
    }

    // Ensure the file exists before reading or writing
    final file = await getPasswordFile();
    if (!(await file.exists())) {
      await file.create(recursive: true);
    }

    final current = await file.readAsString();
    if (current.trim().isEmpty) {
      await writeNewPassword(context, password);
      snackbarDeleteAndOverrite(context, "✅ Password Set Successfully!");
      return true;
    } else {
      snackbarDeleteAndOverrite(context, "Password already set.");
      return false;
    }
  }
}
