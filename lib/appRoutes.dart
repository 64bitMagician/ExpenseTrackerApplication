// appRoutes.dart
import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:expense_tracker/screens/dashboardScreen.dart';
import 'package:expense_tracker/screens/expenses_screen.dart';
import 'package:expense_tracker/screens/forgot_password_screen.dart';
import 'package:expense_tracker/screens/help_screen.dart';
import 'package:expense_tracker/screens/login_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String loginScreen = '/';
  static const String helpScreen = '/helpScreen';
  static const String settingsScreen = '/settingsScreen';
  static const String forgotPasswordScreen = '/forgotPasswordScreen';
  static const String expensesScreen = '/expensesScreen';
  static const String dashboardScreen = '/dashboardScreen';
  static const String addExpenseScreen = '/addExpenseScreen';

  static Map<String, WidgetBuilder> get routes => {
    loginScreen: (context) => LoginScreen(),
    helpScreen: (context) => HelpScreen(),
    //settingsScreen: (context) => SettingsScreen(),
    forgotPasswordScreen: (context) => ForgotPasswordScreen(),
    expensesScreen: (context) => ExpensesScreen(),
    dashboardScreen: (context) => DashboardScreen(),
    addExpenseScreen:  (context) => AddExpenseScreen(),
  };
}
