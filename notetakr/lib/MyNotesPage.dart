import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notetakr/model/note.dart';
import 'package:notetakr/model/note_model.dart';
import 'package:path/path.dart';

import 'AddNote.dart';
import 'MyNote.dart';

final _model = NoteModel(); 


class MyNotesPage extends StatefulWidget {
  String title;
  MyNotesPage(String title) {
    this.title = title;
  }
  @override
  State<StatefulWidget> createState() => MyNotesPageState(this.title);
}

class MyNotesPageState extends State<MyNotesPage> {
  String title;
  List<String> notes = ['note1', 'note2', 'note3', 'note4'];

  MyNotesPageState(String title) {
    this.title = title;
  }

  @override
  Widget build(BuildContext context) {
    var addSnackbar = SnackBar(
      content: Text('Add Button Pressed'),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mic),
            onPressed: () {
              //TODO: Add Delete Functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              //TODO: Add Speech
            },
          )
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: _getAllNotes(this.title),
          builder: (context,snapshot) { 
        if(snapshot.hasData)
        {
          List<Note> my_list = snapshot.data;
          
          
        return ListView.builder(
          itemCount: my_list.length,
          itemBuilder: (_,int index) 
          {
            
            print('in item builder len of data: ${snapshot.data.length}, index: $index'); 
            print('in item builder: ${snapshot.data[index]}');
            return new NoteWidget(context,my_list[index]); 
          },
        );
        } 
        else 
        {
          Text('No Notes have been added for this course'); 
        }     
          }
      
      )
      
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //TODO: Make add Notes functionality
          print("Include Add Notes Functionality");
          _navigatetoAddNotes(context,title);
          Scaffold.of(this.context).showSnackBar(addSnackbar);
        },
        child: Icon(Icons.add),
      ),
    );
  }

Future<List<Note>> _getAllNotes(String coursecode) async 
{
  
   var my_notes = await _model.getAllNotesforCourse(coursecode); 
  
  return my_notes; 

}


}

void _navigatetoAddNotes(BuildContext context,String course_code)
{
  Navigator.push(context, MaterialPageRoute(builder: (context) => AddNote(course_code) ));
}

void _navigatetodescription(BuildContext context, Note s) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => MyNote(s)));
}

class NoteWidget extends StatelessWidget {
  Note note;
  BuildContext context;

  NoteWidget(BuildContext context, Note note) {
    this.context = context;
    this.note = note;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print('Inside NoteWidget, ${note}'); 
    return new Card(
      child: InkWell(
        splashColor: Colors.cyan,
        onTap: () {
          _navigatetodescription(context,note);
        },
        onLongPress: () {
          _showDeleteDialog(context, note);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                note.noteName, 
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  note.dateCreated,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                )),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Note note_name) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Dialog(
            //backgroundColor: Colors.cyan,
            elevation: 5,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text("Delete ${note_name.noteName}",
                      style: TextStyle(color: Colors.cyan, fontSize: 24)),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text("OK",
                          style: TextStyle(color: Colors.cyan, fontSize: 18)),
                      onPressed: () {
                        //Todo" Create Delete Note 
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text("Cancel",
                          style: TextStyle(color: Colors.cyan, fontSize: 18)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}



