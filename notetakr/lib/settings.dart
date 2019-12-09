import 'package:day_night_switch/day_night_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notetakr/themes.dart';
import 'package:provider/provider.dart';
import 'app_localizations.dart';



class Settings extends StatefulWidget {
  Settings();
  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<Settings> {
   SettingsState();
  var _darkTheme = false;
  @override
  Widget build(BuildContext context) {
       final themeNotifier = Provider.of<ThemeNotifier>(context);
          _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return new Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('setting_string')),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              ListTile(
            title: Text('Theme'),
            contentPadding: const EdgeInsets.only(left: 16.0),
            trailing: Transform.scale(
              scale: 0.4,
              child: DayNightSwitch(
                value: _darkTheme,
                onChanged: (val) {
                  setState(() {
                    _darkTheme = val;
                  });
                  onThemeChanged(val, themeNotifier);
                },
              ),
            )),
              
            ],
          )
        ));
  }

  
  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);

    /*    
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
    */
  }
  
}
