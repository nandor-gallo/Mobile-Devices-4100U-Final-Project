import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/note.dart';

/*Simple Page to show a note*/ 




class MyNote extends StatelessWidget {
  Note note;

  MyNote(Note note) {
    this.note = note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.noteName),
      ),
      body: Column(
        children: <Widget>[
          new Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: new Text(
                  note.noteData,
                  style: TextStyle( fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
