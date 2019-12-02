import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'LecturePage.dart';
import 'app_localizations.dart';

void main() => runApp(new NoteTakRApp());

class NoteTakRApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new RefreshConfiguration(
    headerBuilder: () => WaterDropHeader(),        // Configure the default header indicator. If you have the same header indicator for each page, you need to set this
         footerBuilder:  () => ClassicFooter(),        // Configure default bottom indicator
         headerTriggerDistance: 80.0,        // header trigger refresh trigger distance
         springDescription:  SpringDescription(stiffness: 170, damping: 16, mass: 1.9),         // custom spring back animate,the props meaning see the flutter api
         maxOverScrollExtent :100, //The maximum dragging range of the head. Set this property if a rush out of the view area occurs
         maxUnderScrollExtent:0, // Maximum dragging range at the bottom
         enableScrollWhenRefreshCompleted: true, //This property is incompatible with PageView and TabBarView. If you need TabBarView to slide left and right, you need to set it to true.
         enableLoadingWhenFailed : true, //In the case of load failure, users can still trigger more loads by gesture pull-up.
         hideFooterWhenNotFull: false, // Disable pull-up to load more functionality when Viewport is less than one screen
         enableBallisticLoad: true,
    
   child: MaterialApp(
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
    ));
  }
}
