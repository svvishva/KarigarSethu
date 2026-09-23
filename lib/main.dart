import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'core/theme.dart';
import 'core/constants.dart';
import 'package:karigarsethu/screens/login_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:karigarsethu/l10n/app_localizations.dart';
import 'package:karigarsethu/screens/login_screen.dart';
import 'package:karigarsethu/screens/language_selection_screen.dart';
import 'package:karigarsethu/screens/splash_screen.dart';
import 'core/locale_notifier.dart';
import 'core/theme_notifier.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final localeNotifier = LocaleNotifier();
final themeNotifier = ThemeNotifier();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const KarigarSethuApp());
}

class KarigarSethuApp extends StatelessWidget {
  const KarigarSethuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, _) {
        return ValueListenableBuilder<Locale>(
          valueListenable: localeNotifier,
          builder: (context, locale, _) {
            return MaterialApp(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              locale: locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('hi'),
                Locale('mr'),
                Locale('te'),
                Locale('ta'),
                Locale('ml'),
              ],
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}


