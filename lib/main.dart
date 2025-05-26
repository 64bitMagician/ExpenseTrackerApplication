import 'package:expense_tracker/screens/dashboardScreen.dart';
import 'package:expense_tracker/screens/login_screen.dart';
import 'package:expense_tracker/screens/splash_screen.dart';
import 'package:expense_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appRoutes.dart';
import 'onboardingScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final onboardingDone = prefs.getBool('onboardingDone') ?? false;
  // Initialize Current Balance. It shall be 0 only the first time you run the app.
  // After that the state shall be preserved.
  if(prefs.getDouble("currentBalanceDoubleType")==null)
    prefs.setDouble("currentBalanceDoubleType", 0);

  runApp(ExpenseTrackerApp(onboardingDone: onboardingDone));
}

class ExpenseTrackerApp extends StatelessWidget {
  final bool onboardingDone;
  const ExpenseTrackerApp({super.key, required this.onboardingDone});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // your theme
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // If onboardingDone is true, start at dashboard, else show onboarding first
      home: onboardingDone ? const SplashScreen() : OnboardingScreen(),
      routes: AppRoutes.routes,
    );
  }
}
