// app_routes.dart
import 'package:expense_tracker/screens/change_password_screen.dart';
import 'package:expense_tracker/screens/dashboard_screen.dart';
import 'package:expense_tracker/screens/expenses_screen.dart';
import 'package:expense_tracker/screens/forgot_password_screen.dart';
import 'package:expense_tracker/screens/help_screen.dart';
import 'package:expense_tracker/screens/income_screen.dart';
import 'package:expense_tracker/screens/login_screen.dart';
import 'package:expense_tracker/screens/savings_screen.dart';
import 'package:expense_tracker/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String loginScreen = '/loginScreen';
  static const String helpScreen = '/helpScreen';
  static const String forgotPasswordScreen = '/forgotPasswordScreen';
  static const String expensesScreen = '/expensesScreen';
  static const String dashboardScreen = '/dashboardScreen';
  static const String incomeScreen = '/incomeScreen';
  static const String savingsScreen = '/savingsScreen';
  static const String settingsScreen = '/settingsScreen';
  static const String changePasswordScreen = '/changePasswordScreen';

  static Map<String, WidgetBuilder> get routes => {
    loginScreen: (context) => const LoginScreen(),
    helpScreen: (context) => const HelpScreen(),
    forgotPasswordScreen: (context) => const ForgotPasswordScreen(),
    expensesScreen: (context) => const ExpensesScreen(),
    dashboardScreen: (context) => const DashboardScreen(),
    incomeScreen: (context) => const IncomeScreen(),
    savingsScreen: (context) => const SavingsScreen(),
    settingsScreen: (context) => const SettingsScreen(),
    changePasswordScreen: (context) => const ChangePasswordScreen(),
  };
}
