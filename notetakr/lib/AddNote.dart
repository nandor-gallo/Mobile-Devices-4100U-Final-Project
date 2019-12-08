import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notetakr/model/note_model.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'app_localizations.dart';
import 'model/note.dart';


class AddNote extends StatefulWidget {

  String courseCode;
  bool edit = false;
  Note note;

  AddNote(String courseCode, {note,edit=false} ) {
    this.courseCode = courseCode;
    if(edit)
    {
      this.edit=edit;
      this.note = note;
    }
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddNoteState(this.courseCode,note:this.note,edit:this.edit);
  }
}

class AddNoteState extends State<AddNote> {
  final _model = NoteModel();

  bool _isListening = false;
  bool _speechRecognitionAvailable = false;
  bool _edit = false;
  SpeechRecognition _speech;
  String courseCode;
  String transcription = "";
  Note _note;

  AddNoteState(String courseCode, {note,edit}) {
    this.courseCode = courseCode;
    if(edit){
    this._edit = edit;
    this._note = note;
    }
  }

  @override
  initState() {
    activateSpeechRecognizer();
    super.initState();
  }

  // TODO: implement build
  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    String date = new DateTime(now.year, now.month, now.day).toString();
    if(_note==null)
    {
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
                    initialValue: _note.noteData,
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('content_string')),
                    keyboardType: TextInputType.multiline,
                    onChanged: (text_2) {
                      _note.noteData = text_2;
                    },
                    maxLines: 11,
                  ),
                ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child:Row(
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
                          _speech
                              .listen(locale: 'en_US')
                              .then((text) => print(text));
                        }
                        start();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return new Dialog(
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.cancel),
                                        iconSize: 40,
                                        color: Colors.cyan,
                                        onPressed: () {
                                          if (_isListening) {
                                            _speech.stop().then((result) =>
                                                setState(() =>
                                                    _isListening = false));
                                          }
                                          _isListening = !_isListening;

                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    )
                  ],
                ))
              ],
            ),
          ),
        ));
 
 
 
}

 
 
 
  

  void start() => _speech
      .listen(locale: 'en_US')
      .then((result) => print('_MyAppState.start => result $result'));

  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));

  void stop() => _speech.stop().then((result) {
        setState(() => _isListening = result);
      });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(() => languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) => setState(() => transcription = text);

  void onRecognitionComplete() => setState(() => _isListening = false);

  void setAvailabilityHandler(void onSpeechAvailability(bool result)) =>
      _speech.setAvailabilityHandler(onSpeechAvailability);

  //void errorHandler() => activateSpeechRecognizer();

  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = new SpeechRecognition();
    setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }
}


class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

const languages = const [
  const Language('Francais', 'fr_FR'),
  const Language('English', 'en_US'),
  const Language('Pусский', 'ru_RU'),
  const Language('Italiano', 'it_IT'),
  const Language('Español', 'es_ES'),
];
