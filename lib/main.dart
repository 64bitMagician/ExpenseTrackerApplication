import 'package:expense_tracker/screens/onboarding_screen.dart';
import 'package:expense_tracker/screens/splash_screen.dart';
import 'package:expense_tracker/theme/app_theme.dart';
import 'package:expense_tracker/utils/legacy_migration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Browsers have no file system, so only mobile/desktop can have legacy data files
  if (!kIsWeb) {
    try {
      await migrateLegacyFiles(await getApplicationDocumentsDirectory());
    } catch (e) {
      debugPrint('Legacy data migration failed, will retry on next start: $e');
    }
  }

  final prefs = await SharedPreferences.getInstance();
  final onboardingDone = prefs.getBool('onboardingDone') ?? false;

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
      // If onboardingDone is true, start at the splash screen, else show onboarding first
      home: onboardingDone ? const SplashScreen() : const OnboardingScreen(),
      routes: AppRoutes.routes,
      // On wide browser windows keep a phone-sized layout centered on the page
      builder: kIsWeb
          ? (context, child) => ColoredBox(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: child,
                  ),
                ),
              )
          : null,
    );
  }
}
