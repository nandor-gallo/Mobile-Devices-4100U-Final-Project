import 'package:flutter/material.dart';
import 'package:notetakr/model/note_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_recognition/speech_recognition.dart';

import 'AddNote.dart';
import 'model/note.dart';

const languages = const [
  const Language('Francais', 'fr_FR'),
  const Language('English', 'en_US'),
  const Language('Pусский', 'ru_RU'),
  const Language('Italiano', 'it_IT'),
  const Language('Español', 'es_ES'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class microphone extends StatefulWidget {
  Note _note;

  microphone(Note note) 
  {
    this._note = note; 
  }
  @override
  _microphoneState createState() => new _microphoneState(this._note);
}

class _microphoneState extends State<microphone> {
  SpeechRecognition _speech;
  final _model = NoteModel();
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  Note _note;
  String transcription = '';

   Map<PermissionGroup, PermissionStatus> permissions;

  void getPermission() async
  {
    getPermission(); 
    print("Requesting permissions");
    permissions = await PermissionHandler().requestPermissions([
      PermissionGroup.microphone,
      PermissionGroup.speech, 
    ]);
  }




  _microphoneState(Note note)
  {
    this._note=note; 
  }
  //String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  @override
  initState() {
    //getPermission();

    super.initState();
    activateSpeechRecognizer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);

    //_speech.setErrorHandler(errorHandler);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Record Note'),
          actions: [
            IconButton(
              icon:  Icon(Icons.save),
              onPressed: () {
                _note.noteData+=transcription;
                _model.updateNote(_note);
                 Navigator.push(
      context, MaterialPageRoute(builder: (context) => AddNote(_note.courseCode,note:_note,edit: true,)));

              },
            )
          ],
        ),
        body: new Padding(
            padding: new EdgeInsets.all(8.0),
            child: new Center(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  new Expanded(
                      child: new Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Colors.grey.shade200,
                          child: new Text(transcription,style: TextStyle(color: Colors.black),))),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  
                  _buildButton(
                    onPressed: _isListening ? () => cancel() : null,
                    label: 'Cancel',
                  ),

                  _buildButton(
                    onPressed: _speechRecognitionAvailable && !_isListening
                        ? () => start()
                        : null,
                    label: _isListening
                        ? 'Listening...'
                        : 'Listen (${selectedLang.code})',
                  ),
                  _buildButton(
                    onPressed: _isListening ? () => stop() : null,
                    label: 'Stop',
                  ),
                  ]
                  )
                ],
              ),
            )),

    );
  }

  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => languages
      .map((l) => new CheckedPopupMenuItem<Language>(
            value: l,
            checked: selectedLang == l,
            child: new Text(l.name),
          ))
      .toList();

  void _selectLangHandler(Language lang) {
    setState(() => selectedLang = lang);
  }

  Widget _buildButton({String label, VoidCallback onPressed}){
     IconData curr_icon;
     if(label=="Cancel"){
       curr_icon=Icons.cancel;
     }
     else if(label=="Stop")
     {
       curr_icon=Icons.stop;
     }
     else
     {
       curr_icon = Icons.mic;
     }


    return new Padding(
      
      padding: new EdgeInsets.all(12.0),
      child: new IconButton(
        color: Colors.cyan.shade600,
        onPressed: onPressed,
        icon:Icon(curr_icon),
      ));
  }

  void start() => _speech
      .listen(locale: selectedLang.code)
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
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) => setState(() => transcription = text);

  void onRecognitionComplete() => setState(() => _isListening = false);

  void errorHandler() => activateSpeechRecognizer();
}
