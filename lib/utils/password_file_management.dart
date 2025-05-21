import 'dart:io';
import 'package:expense_tracker/utils/password_validator.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class PasswordFileManager {
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
    if (!(await file.exists())) { // if file exists
      await file.writeAsString('');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Created password.txt")));
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted password.txt")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("password.txt does not exist")));
    }
  }

  static Future<void> loadPassword() async {
    final file = await getPasswordFile();
    if (await file.exists()) {
      storedPassword = await file.readAsString();
      if (storedPassword != null && storedPassword!.trim().isEmpty) {
        storedPassword = null;
      }
    }
  }

  static Future<void> writeNewPassword(String password) async {
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

  static void handleLogin(TextEditingController controller, BuildContext context) {
    if (controller.text == storedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Login Successful!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Incorrect Password!")));
    }
  }

  static Future<void> handleSetupPassword(TextEditingController controller, BuildContext context) async {
    final password = controller.text;
    final validationMessage = PasswordValidator.validate(password);

    if (validationMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationMessage), backgroundColor: Colors.redAccent),
      );
      return;
    }

    // Ensure the file exists before reading or writing
    final file = await getPasswordFile();
    if (!(await file.exists())) {
      await file.create(recursive: true);
    }

    final current = await file.readAsString();
    if (current.trim().isEmpty) {
      await writeNewPassword(password);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Password Set Successfully!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password already set.")));
    }
  }
}
