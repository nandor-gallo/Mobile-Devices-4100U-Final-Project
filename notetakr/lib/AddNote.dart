import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notetakr/model/note_model.dart';

import 'model/note.dart';

class AddNote extends StatelessWidget{
  final _model = NoteModel();

  String courseCode; 

  AddNote(String courseCode)
  {
    this.courseCode = courseCode;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    String date = new DateTime(now.year, now.month, now.day).toString();
    String note_name,note_content; 
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Add Note Page'),

      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            Padding(
            padding: const EdgeInsets.all(4),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Note Name', 
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
                
                decoration: InputDecoration(hintText: 'Content'),
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
                    note_content += _getStringfromMic(); 
                  },
                )
              ],
            )

          ],
        ),
      ),

    );

   
  }

  String _getStringfromMic() 
  {
    return " ";
  }

  Future<void> _save_note_to_db(Note note) async{
    print('Inserting new note'); 
    _model.insertNote(note);  
  }

}