import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'app_localizations.dart';
import 'package:notetakr/model/note.dart';
import 'package:notetakr/model/note_model.dart';
import 'package:path/path.dart';

import 'AddNote.dart';
import 'MyNote.dart';

final _model = NoteModel(); 


class Settings extends StatefulWidget {
  Settings();
  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  
  MyNotesPageState() {

  }

  @override
  Widget build(BuildContext context) {
    var addSnackbar = SnackBar(
      content: Text('Add Button Pressed'),
    );

    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context).translate('setting_string')),
        
      ),
      body: Container(
        child: Text("Addd settings here"),
    ));
  }




}





