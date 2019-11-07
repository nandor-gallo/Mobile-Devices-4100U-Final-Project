import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
          children: <Widget>[
            ListTile(
              title: Text("Note Title"),
              subtitle: Text("Date Created"),
            ),
            ListTile(
              title: Text("Note Title"),
              subtitle: Text("Date Created"),
            ),
            ListTile(
              title: Text("Note Title"),
              subtitle: Text("Date Created"),
            ),
            ListTile(
              title: Text("Note Title"),
              subtitle: Text("Date Created"),
            ),
            ListTile(
              title: Text("Note Title"),
              subtitle: Text("Date Created"),
            ),
            ListTile(
              title: Text("Note Title"),
              subtitle: Text("Date Created"),
            ),
            ListTile(
              title: Text("Note Title"),
              subtitle: Text("Date Created"),
            ),
            ListTile(
              title: Text("Note Title"),
              subtitle: Text("Date Created"),
            ),
          ],
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