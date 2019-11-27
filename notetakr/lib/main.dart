import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'LecturePage.dart';
import 'app_localizations.dart';

void main() => runApp(new NoteTakRApp());

class NoteTakRApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      title: 'NoteTakR',
      // SplashScreen while app is loading
      home: SplashScreen.navigate(
        name: 'assets/NoteTakR.flr',
        next: (context) => LectureList(),
        until: () => Future.delayed(Duration(seconds: 3)),
        startAnimation: 'Erase', // Plays Erase animation
      ),
      supportedLocales: [Locale('en', 'US'), Locale('fr', 'FR')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
    );
  }
}
