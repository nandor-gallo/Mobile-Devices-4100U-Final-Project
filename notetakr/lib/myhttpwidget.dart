import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notetakr/model/class_model.dart';
import 'package:notetakr/model/course.dart';
import 'package:notetakr/model/note_model.dart';
import 'app_localizations.dart';
import 'model/note.dart';
import 'model/program.dart';

class myhttpWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return myhttpWidgetState();
  }
}

class myhttpWidgetState extends State<myhttpWidget> {
  final String url = "https://ontariotechu.ca/programs/index.json";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(
          title: Text(
            AppLocalizations.of(context).translate('ontariotech_string'),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        body: FutureBuilder(
            future: getEvents(url),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<ProgramElement> classes = snapshot.data.programs.program;
                classes.forEach((f) => print(f.title));
                return ListView(
                    children: classes
                        .map((item) => new ProgramWidget(item))
                        .toList());
              } else {
                return CircularProgressIndicator();
              }
            }));
  }

  Future<Program> getEvents(String url) async {
    var response = await http.get(url);

    return programFromJson(response.body);
    //TODO: Create an event class and  Return List of JSON
  }
}

class ProgramWidget extends StatelessWidget {
  ProgramElement element;

  ProgramWidget(ProgramElement element) {
    this.element = element;
  }
  final _model = CourseModel();

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onLongPress: () {

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return new Dialog(
                  child: Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(3.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.cyan)),
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.save),
                        title:
                            Text("Add to your courses: ${this.element.title}"),
                        subtitle:
                            Text("Code ${this.element.programType.toString()}"),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.cyan,
                            child: Text("OK"),
                            onPressed: () {
                              Course c = new Course(
                                  courseName: this.element.title,
                                  courseCode:
                                      this.element.programType.toString());
                              _model.insertCourse(c);
                              Navigator.pop(context);
                            },
                          ),
                          RaisedButton(
                            color: Colors.cyan,
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ));
            });
      },
      child: Card(
        child: Column(
          children: <Widget>[
            Text(
              this.element.title,
              style: TextStyle(color: Colors.cyan, fontSize: 16),
            ),
            Text(
              this.element.summary,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              '${this.element.faculty}',
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
