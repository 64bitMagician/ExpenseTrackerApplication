// appRoutes.dart
import 'package:expense_tracker/screens/dashboardScreen.dart';
import 'package:expense_tracker/screens/expenses_screen.dart';
import 'package:expense_tracker/screens/forgot_password_screen.dart';
import 'package:expense_tracker/screens/help_screen.dart';
import 'package:expense_tracker/screens/income_screen.dart';
import 'package:expense_tracker/screens/login_screen.dart';
import 'package:expense_tracker/screens/savings_screen.dart';
import 'package:expense_tracker/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String loginScreen = '/';
  static const String helpScreen = '/helpScreen';
  static const String forgotPasswordScreen = '/forgotPasswordScreen';
  static const String expensesScreen = '/expensesScreen';
  static const String dashboardScreen = '/dashboardScreen';
  static const String incomeScreen = '/incomeScreen';
  static const String savingsScreen = '/savingsScreen';
  static const String settingsScreen = '/settingsScreen';

  static Map<String, WidgetBuilder> get routes => {
    loginScreen: (context) => LoginScreen(),
    helpScreen: (context) => HelpScreen(),
    //settingsScreen: (context) => SettingsScreen(),
    forgotPasswordScreen: (context) => ForgotPasswordScreen(),
    expensesScreen: (context) => ExpensesScreen(),
    dashboardScreen: (context) => DashboardScreen(),
    incomeScreen: (context) => IncomeScreen(),
    savingsScreen: (context) => SavingsScreen(),
    settingsScreen: (context) => SettingsScreen(),
  };
}
