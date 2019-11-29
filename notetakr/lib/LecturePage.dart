import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notetakr/AssignmentsChartPage.dart';
import 'package:notetakr/TodaysPolls.dart';
import 'package:notetakr/map.dart' as prefix1;
import 'package:notetakr/model/assignment.dart';
import 'package:notetakr/model/assignment_model.dart';
import 'package:notetakr/model/class_model.dart';
import 'package:notetakr/model/program.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:notetakr/model/program.dart';
import 'MyNotesPage.dart';
import 'model/program.dart';
import 'utils/Notifications.dart';
import 'package:http/http.dart' as http;
import 'model/assignment_model.dart';

String selectedAssigmentID = "0";

class LectureList extends StatefulWidget {
  @override
  createState() => new _LectureListState();
}

class _LectureListState extends State<LectureList>
 
 
    with SingleTickerProviderStateMixin {
final _model = AssignmentModel();

  final List<String> lectures = [
    'CSCI 3100',
    'CSCI 4100',
    'CSCI 4500',
    ' Intro to Computer Science'
  ];

final _lec_model = CourseModel();
  TabController _tabController;

  List<Widget> listAssignmentWidget(AsyncSnapshot snapshot) {
    return snapshot.data.documents.map<Widget>((document) {
      return ListTile(
        title: Text(document["title"]),
        subtitle: Text(_toTimeStampString(document["due"])),
        leading: Icon(Icons.assignment),
        onTap: () {
          selectedAssigmentID = document.documentID;
          print(selectedAssigmentID);
          completedDialog(context);
        },
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  DateTime _classDates = DateTime.now();
  var _notifications = Notifications();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _notifications.init();
    String newAssignment = "";
    DateTime now = DateTime.now();
    //Tabs With Items
    return new DefaultTabController(
        length: 2,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('NoteTakR'),
            bottom: TabBar(
                isScrollable: true,
                controller: _tabController,
                tabs: <Widget>[
                  Tab(
                    text: 'Notes',
                    icon: Icon(Icons.list),
                  ),
                  Tab(text: 'Assignments', icon: Icon(Icons.note)),
                  
                  
                ]),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Tab(
                  //Grid of Classes
                  child: GridView.count(
                      primary: true,
                      crossAxisCount: 4,
                      children: (lectures
                          .map((lecture) =>
                              new LectureWidget(this.context, lecture))
                          .toList()))
                  //TODO: Implement a Future Builder Widget to get Data For the Notes
                  ),
              
               Tab(
                  child: AssignmentChartsPage()

                   ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_comment),
            onPressed: () {
              //Create a selected index, to change between pages, Different From adding assignments, to adding classes...
              print("Add Lectures Page");
              print(_tabController.index);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                   
                    if (_tabController.index == 0) {
                      return _AddCourseDialog();
                    } else if (_tabController.index != 0) {
                      return _AddAssignmentDialog(); 
                    }
                  });
            },
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.all(0.6),
              children: <Widget>[
                DrawerHeader(
                  child: Row(
                    children: <Widget>[
                      //@Dan Could you add the logo png here

                      Text("NoteTakR")
                    ],
                  ),
                
                ),
                ListTile(
                  leading: Icon(Icons.map),
                  title: Text("Campus Map"),
                  onTap: ()
                  {
                    print("Navigate to Maps Page");
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) => prefix1.Map()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.pages),
                  title: Text("Offered Courses"),
                  onTap: ()
                  {
                    Navigator.push(
        context, MaterialPageRoute(builder: (context) => myhttpWidget()));
                  },


                ),
                ListTile(
                  leading: Icon(Icons.assessment),
                  title: Text("Today's Poll"),
                  onTap: () 
                  {
                       Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodaysPollsPage()));
                  }
                ),

                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Settings"),
                  onTap: ()
                  {
                    Navigator.pop(context);
                  },
                ),

              ],
            )
          ),
        ));
  }
  Dialog _AddCourseDialog() 
  {
     String new_lecture = "";
    String new_code = "";
    DateTime now = DateTime.now();

    return new Dialog(
      
                          backgroundColor: Colors.cyan,
                          child: Card(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text('Add A New Class',
                                      style: TextStyle(
                                          color: Colors.cyan, fontSize: 15))),
                              Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Class Name',
                                    ),
                                    onChanged: (text) {
                                      new_lecture = text;
                                    },
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Course Code'),
                                  onChanged: (code) {
                                    new_code = code;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RaisedButton(
                                      child: Text('Course Days'),
                                      color: Colors.cyan,
                                      textColor: Colors.black,
                                      onPressed: () {
                                        showDatePicker(
                                          context: context,
                                          firstDate: now,
                                          lastDate: DateTime(2100),
                                          initialDate: now,
                                        ).then((value) {
                                          setState(() {
                                            _classDates = DateTime(
                                              value.year,
                                              value.month,
                                              value.day,
                                              _classDates.hour,
                                              _classDates.minute,
                                              _classDates.second,
                                            );
                                          });
                                        });
                                      },
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Text(_toDateString(_classDates)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RaisedButton(
                                      child: Text('Course Time'),
                                      color: Colors.cyan,
                                      textColor: Colors.black,
                                      onPressed: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay(
                                            hour: now.hour,
                                            minute: now.minute,
                                          ),
                                        ).then((value) {
                                          setState(() {
                                            _classDates = DateTime(
                                              _classDates.year,
                                              _classDates.month,
                                              _classDates.day,
                                              value.hour,
                                              value.minute,
                                            );
                                          });
                                        });
                                      },
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Text(_toTimeString(_classDates)),
                                    ),
                                  ],
                                ),
                              ),
                              ButtonBar(
                                children: <Widget>[
                                  FlatButton(
                                    child: Text("Add"),
                                    onPressed: () {
                                      _AddLecturetoDB(
                                          new_lecture, new_code, _classDates);
                                      //Send a notification
                                      _notificationLater(_classDates);
                                      //Display Snack Bar
                                      _displayClassAddBar(context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              )
                            ],
                          )));
  }
  

  Dialog _AddAssignmentDialog() 
  {
    
    DateTime now = DateTime.now();
      String new_lecture = "";
      String new_code = "";
      String new_assignment ="";
      String due_date = " ";
      String due_time = "";
    
    return new Dialog(
                          //Dialog for adding assignmment
                          backgroundColor: Colors.cyan,
                          child: Card(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text('Add An Assignment',
                                      style: TextStyle(
                                          color: Colors.cyan, fontSize: 15))),
                              Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Assignment Title',
                                    ),
                                    onChanged: (text) {
                                      new_assignment = text;
                                    },
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RaisedButton(
                                      child: Text('Due Date'),
                                      color: Colors.cyan,
                                      textColor: Colors.black,
                                      onPressed: () {
                                        showDatePicker(
                                          context: context,
                                          firstDate: now,
                                          lastDate: DateTime(2100),
                                          initialDate: now,
                                        ).then((value) {
                                          setState(() {
                                            _classDates = DateTime(
                                              value.year,
                                              value.month,
                                              value.day,
                                              _classDates.hour,
                                              _classDates.minute,
                                              _classDates.second,
                                            );
                                          });
                                        });
                                      },
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child:
                                          new Text(_toDateString(_classDates)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RaisedButton(
                                      child: Text('Time Due'),
                                      color: Colors.cyan,
                                      textColor: Colors.black,
                                      onPressed: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay(
                                            hour: now.hour,
                                            minute: now.minute,
                                          ),
                                        ).then((value) {
                                          setState(() {
                                            _classDates = DateTime(
                                              _classDates.year,
                                              _classDates.month,
                                              _classDates.day,
                                              value.hour,
                                              value.minute,
                                            );
                                          });
                                        });
                                      },
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Text(_toTimeString(_classDates)),
                                    ),
                                  ],
                                ),
                              ),
                              ButtonBar(
                                children: <Widget>[
                                  FlatButton(
                                    child: Text("Add"),
                                    onPressed: () {
                                      //Send a notification
                                      //TODO Add Assignments
                                      Assignment current_assignmet = new Assignment(assignmentName: new_assignment,courseId: 'CSCI 3030',dueAlert:"4:50",dueDate: "27/09/2018");
                                      _notificationLater(_classDates);
                                      _Add_assignment(current_assignmet);
                                      _displayAssignmentAddBar(context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              )
                            ],
                          )));
  }
  
  void completedDialog(BuildContext context) {
    var completed = Dialog(
        backgroundColor: Colors.cyan,
        child: Card(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Finished Assignment?',
                    style: TextStyle(color: Colors.cyan, fontSize: 15))),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text("Completed"),
                  onPressed: () {
                    _completedAssignment(selectedAssigmentID);
                    _displayAssignmentAddBar(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        )));
    showDialog(context: context, builder: (BuildContext context) => completed);
  }

  _displayClassAddBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('New Class Added!'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _displayAssignmentAddBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('New Assignment Added!'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<void> _notificationLater(var dateNotify) async {
    await _notifications.sendNotificationLater(
        'CSCI 4100 Assignment', 'Due: Thursday!', dateNotify, 'payload');
  }

  Future<void> _addAssignment(String title, DateTime d) async {
    Timestamp time = Timestamp.fromDate(d);
    _model.insertAssigmentFire(
        Firestore.instance.collection("Assignments").document().documentID,
        title,
        time);
  }

  Future<void> _completedAssignment(String id) async {
    _model.completedAssignment(id);
  }

  void _AddLecturetoDB(String new_lecture, String new_code, DateTime date) {
    print("Add Class $new_lecture  and $new_code to  Database With $date");
    //TODO: Insert new Lecture to model
  }

  void _Add_assignment(Assignment assignment)
  {
    _model.insertAssignment(assignment);
  }
}

// Future<void> _completedAssignment() async {
//     print(selectedItem);
//     _model.deleteGrade(selectedItem);
//   }

class LectureWidget extends StatelessWidget {
  String title;
  BuildContext context;
  LectureWidget(context, String title) {
    this.context = context;
    this.title = title;
  }
  @override
  Widget build(BuildContext context) {
    return new Card(
        color: Colors.blueAccent,
        child: InkWell(
            splashColor: Colors.blue,
            onTap: () {
              print('Card tapped.');
              _navigatetoAddPage(context, this.title);
            },
            child: Container(
              width: 300,
              height: 100,
              child: Center(
                child: Text(this.title),
              ),
            )));
  }

  void _navigatetoAddPage(context, String lecture) {
    print(" List Tile Widget passing Lecture: $lecture");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyNotesPage(lecture)));
  }
}

String _twoDigits(int value) {
  if (value < 10) {
    return '0$value';
  } else {
    return '$value';
  }
}


String _toDateString(DateTime dateTime) {
  return '${dateTime.year}/${dateTime.month}/${dateTime.day}';
}

String _toTimeStampString(Timestamp time) {
  return "DUE: " + _toDateString(time.toDate());
}

String _toTimeString(DateTime dateTime) {
  return '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}';
}

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
    return 
    Scaffold(
    appBar: new AppBar(
      title: Text("Ontario Tech U courses", style: TextStyle(fontStyle: FontStyle.italic),),

    ),
    
    body:FutureBuilder(
        future: getEvents(url),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ProgramElement> classes = snapshot.data.programs.program;
            classes.forEach((f) => print(f.title));
            return ListView(
                children:
                    classes.map((item) => new ProgramWidget(item)).toList());
          } else {
            return CircularProgressIndicator();
          }
        })
    );
  }

  Future<Program> getEvents(String url) async {
    var response = await http.get(url);

    return programFromJson(response.body);
    //TODO: Create an event class and  Return List of JSON
  }
}

class ProgramWidget extends StatelessWidget {
  prefix0.ProgramElement element;

  ProgramWidget(ProgramElement element) {
    this.element = element;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GestureDetector(
      onTap: () {},
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


