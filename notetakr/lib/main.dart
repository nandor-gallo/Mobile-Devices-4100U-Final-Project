import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'LecturePage.dart';

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
          name: 'assets/intro.flr',
          next: (context) => LectureList(),
          until: () => Future.delayed(Duration(seconds: 3)),
          backgroundColor: Color(0xff03a94),
          startAnimation: '1',
        ),
    );
  }
}