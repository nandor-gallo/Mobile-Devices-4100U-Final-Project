import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyNote extends StatelessWidget {
  String note_name;

  MyNote(String note_name) {
    this.note_name = note_name;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(note_name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _navigateToAddNotes(note_name);
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          new Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: new Text(
                  "1 Description that is too long in text format(Here Data is coming from API) jdlksaf j klkjjflkdsjfkddfdfsdfds " +
                      "2 Description that is too long in text format(Here Data is coming from API) d fsdfdsfsdfd dfdsfdsf sdfdsfsd d " +
                      "3 Description that is too long in text format(Here Data is coming from API)  adfsfdsfdfsdfdsf   dsf dfd fds fs" +
                      "4 Description that is too long in text format(Here Data is coming from API) dsaf dsafdfdfsd dfdsfsda fdas dsad" +
                      "5 Description that is too long in text format(Here Data is coming from API) dsfdsfd fdsfds fds fdsf dsfds fds " +
                      "6 Description that is too long in text format(Here Data is coming from API) asdfsdfdsf fsdf sdfsdfdsf sd dfdsf" +
                      "7 Description that is too long in text format(Here Data is coming from API) df dsfdsfdsfdsfds df dsfds fds fsd" +
                      "8 Description that is too long in text format(Here Data is coming from API)" +
                      "9 Description that is too long in text format(Here Data is coming from API)" +
                      "10 Description that is too long in text format(Here Data is coming from API)",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddNotes(String note_name) {
    //TODO;
  }
}
