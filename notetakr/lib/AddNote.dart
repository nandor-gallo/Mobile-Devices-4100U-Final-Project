import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notetakr/MicroPhonePage.dart';
import 'package:notetakr/model/note_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'app_localizations.dart';
import 'model/note.dart';

class AddNote extends StatefulWidget {
  String courseCode;
  bool edit = false;
  Note note;

  AddNote(String courseCode, {note, edit = false}) {
    this.courseCode = courseCode;
    if (edit) {
      this.edit = edit;
      this.note = note;
    }
  }

  @override
  State<StatefulWidget> createState() {
    return AddNoteState(this.courseCode, note: this.note, edit: this.edit);
  }
}

class AddNoteState extends State<AddNote> {
  final _model = NoteModel();
  TextEditingController _c;
  bool _isListening = false;
  bool _speechRecognitionAvailable = false;
  bool _edit = false;
  SpeechRecognition _speech;
  String courseCode;
  String transcription = "";
  Note _note;
  Map<PermissionGroup, PermissionStatus> permissions;

  void getPermission() async {
    print("Requesting permissions");
    permissions = await PermissionHandler().requestPermissions([
      PermissionGroup.microphone,
      PermissionGroup.speech,
    ]);
  }

  AddNoteState(String courseCode, {note, edit}) {
    this.courseCode = courseCode;
    if (edit) {
      this._edit = edit;
      this._note = note;
    }
  }

  @override
  initState() {
    getPermission();
    _c = new TextEditingController();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    String date = new DateTime(now.year, now.month, now.day).toString();
    if (_note == null) {
      _note = new Note();
      _note.courseCode = this.courseCode;
      _note.dateEdited = date;
      _note.dateCreated = date;
    }

    Future<void> _save_note_to_db(Note note) async {
      print('Inserting new note $note');
      _model.insertNote(note);
    }

    return new Scaffold(
        appBar: new AppBar(
          title:
              Text(AppLocalizations.of(context).translate('add_note_string')),
        ),
        body: new SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(4),
                    child: TextFormField(
                      initialValue: _note.noteName,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('notename_string'),
                      ),
                      onChanged: (text) {
                        _note.noteName = text;
                      },
                    )),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: TextFormField(
                    initialValue: (_note.noteData == null)
                        ? transcription
                        : (_note.noteData + transcription),
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('content_string')),
                    keyboardType: TextInputType.multiline,
                    onChanged: (text_2) {
                      _note.noteData = text_2;
                    },
                    maxLines: 20,
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FloatingActionButton(
                          heroTag: 'Add Button',
                          child: Icon(Icons.check),
                          onPressed: () {
                            print("Creating new note with $_note");
                            _save_note_to_db(_note);
                            Navigator.pop(context);
                          },
                        ),
                        FloatingActionButton(
                          heroTag: ' Mic Button',
                          child: Icon(Icons.mic),
                          onPressed: () {
                            _isListening = !_isListening;
                            if (_isListening && _speechRecognitionAvailable) {
                              _speech.listen(locale: 'en_US').then((text) => {
                                    print("After finishing:$text"),
                                    //transcription=text,
                                  });
                            }
                            //start();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => microphone(_note)));
                          },
                        )
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
