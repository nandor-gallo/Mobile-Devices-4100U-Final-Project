import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notetakr/model/note_model.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'app_localizations.dart';
import 'model/note.dart';



final _model = NoteModel();

class AddNote extends StatefulWidget{
  final _model = NoteModel();

  String courseCode; 

  AddNote(String courseCode)
  {
    this.courseCode = courseCode;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddNoteState(this.courseCode);
  }   
  }


  class AddNoteState extends State<AddNote> 
  { 

    bool _isListening = false;
    bool _speechRecognitionAvailable = false; 
    SpeechRecognition _speech; 
    String courseCode; 
    String  transcription= ""; 
  
    AddNoteState(String courseCode)
    {
      this.courseCode = courseCode; 
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
    String note_name,note_content; 
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text(AppLocalizations.of(context).translate('add_note_string')),

      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            Padding(
            padding: const EdgeInsets.all(4),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('notename_string'), 
              ),
              onChanged: (text) 
              {
                note_name = text; 
              },
            )
            ), 
            Padding(
              padding:  const EdgeInsets.all(4),
              child: TextField(
                
                decoration: InputDecoration(hintText: AppLocalizations.of(context).translate('content_string')),
                keyboardType: TextInputType.multiline,
                onChanged: (text_2) 
                {
                 note_content = text_2; 
                },
                maxLines: 7,
              ),
              
            
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FloatingActionButton(
                  heroTag:  'Add Button',
                  child:  Icon(Icons.check),
                  onPressed: () 
                  {
                    _save_note_to_db(new Note(noteName:note_name,courseCode: this.courseCode,   dateCreated: date,dateEdited: date,noteData: note_content)); 
                    Navigator.pop(context);
                  },
                ),
                FloatingActionButton(
                  heroTag: ' Mic Button',
                  child: Icon(Icons.mic),
                  onPressed: () 
                  {
                    _isListening = ! _isListening; 
                    if(_isListening  && _speechRecognitionAvailable)
                    {
                      _speech.listen(locale: 'en_US').then((text) =>  print(text));
                    }
                    start(); 
                    showDialog(
                      context: context, 
                      builder: (BuildContext context)
                      { 
                        return new Dialog(
                          child: Container(
                            height: 150,
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                              IconButton(
                                icon:  Icon(Icons.cancel),
                                iconSize: 40,
                                color: Colors.cyan,
                                onPressed: () 
                                {
                                  if(_isListening) 
                                  {
                                    _speech.stop().then(
                                      (result) => setState(() => _isListening = false) 
                                    );
                                  }
                                  _isListening = !_isListening;
                                  
                                  Navigator.pop(context);
                                },
                                

                              )
                              ],
                            ),
                          ),
                        );
                      }
                    );
                    
                  },
                )
              ],
            )

          ],
        ),
      ),

    );
  

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
    setState(
        () =>  languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) => setState(() => transcription = text);

  void onRecognitionComplete() => setState(() => _isListening = false);

    void setAvailabilityHandler(void onSpeechAvailability(bool result)) => _speech.setAvailabilityHandler(onSpeechAvailability);


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


  Future<void> _save_note_to_db(Note note) async{
    print('Inserting new note'); 
    _model.insertNote(note);  
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
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

 