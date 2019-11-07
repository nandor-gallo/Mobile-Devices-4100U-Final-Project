import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'MyNote.dart';

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
  List<String> notes = ['note1','note2','note3','note4']; 

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
            icon: Icon(Icons.delete),
            onPressed: () {
              //TODO: Add Delete Functionality
            },
          )
        ],
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.all(3),
          children: notes.map((note)=> new NoteWidget(context, note)).toList() 
                        ),
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          //TODO: Make add Notes functionality
                          print("Include Add Notes Functionality");
                          Scaffold.of(this.context).showSnackBar(addSnackbar);
                        },
                        child: Icon(Icons.add),
                      ),
                    );
                  }
                
                 
                  }

 void _navigatetodescription(BuildContext context,  String s) {

      Navigator.push(context, MaterialPageRoute(builder: (context) => MyNote(s)));
  }

class NoteWidget extends StatelessWidget 
{
  String note_name; 
  BuildContext context;

  NoteWidget(BuildContext context, String note_name)
  {
    this.context = context; 
    this.note_name  = note_name; 
  } 
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Card(
      
      child: 
      
      InkWell(
        splashColor: Colors.cyan,
        onTap: () 
        {
          _navigatetodescription(context, note_name);
        }, 
        onLongPress: ()
        {
          _showDeleteDialog(context,note_name);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(note_name, style: TextStyle(color: Colors.black,fontSize: 30),),
                      ),
                      Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text('Date Created', style: TextStyle(color: Colors.grey,fontSize: 14),)
                      ),
                    ],
                  ),
                ),
              );
            }
          
            void _showDeleteDialog(BuildContext context, String note_name) {

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
                        child: Text("Delete $note_name",style: TextStyle(color:Colors.cyan,fontSize: 24)),
                        ),
                        ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child:Text("OK",style: TextStyle(color:Colors.cyan,fontSize: 18)),
                            onPressed: () {
                              print('Implement Delete Note');
                              Navigator.pop(context);  

                            },
                            ),
                            FlatButton(
                              child:Text("Cancel",style: TextStyle(color:Colors.cyan,fontSize: 18)),
                              onPressed: () 
                              {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ), 

                      ],
                    ),
                  );
                }
              );
            }
  
}