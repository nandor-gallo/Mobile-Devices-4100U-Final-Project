import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notetakr/AssignmentsChartPage.dart';
import 'package:notetakr/TodaysPolls.dart';
import 'package:notetakr/app_localizations.dart';
import 'package:notetakr/map.dart' as mapPage;
import 'package:notetakr/model/assignment.dart';
import 'package:notetakr/model/assignment_model.dart';
import 'package:notetakr/model/class_model.dart';
import 'package:notetakr/model/course.dart';
import 'package:notetakr/model/program.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:notetakr/model/program.dart';
import 'package:notetakr/settings.dart';
import 'MyNotesPage.dart';
import 'model/program.dart';
import 'myhttpwidget.dart';
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
  final _class_model = CourseModel();

  List<Course> my_list;
  final _lec_model = CourseModel();
  TabController _tabController;

  List<Course> my_courses = new List();

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
                    text:
                        AppLocalizations.of(context).translate('notes_string'),
                    icon: Icon(Icons.list),
                  ),
                  Tab(
                      text: AppLocalizations.of(context)
                          .translate('assignments_string'),
                      icon: Icon(Icons.note)),
                ]),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Tab(
                  //Grid of Classes
                  child: FutureBuilder(
                      future: _lec_model.getAllCourse(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                         my_list = snapshot.data; 
                         return  GridView.count(
                              primary: true,
                              crossAxisCount: 4,
                              children: ( my_list
                                  .map((lecture) =>
                                      new LectureWidget(this.context,lecture))
                                  .toList()));
                          
                        } else {
                          return new Center (child:Text("Please Add Courses"));
                        }
                      })),
              Tab(child: AssignmentChartsPage()),
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
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                ),
              ),
              ListTile(
                leading: Icon(Icons.map),
                title: Text(
                    AppLocalizations.of(context).translate('campusmap_string')),
                onTap: () {
                  print("Navigate to Maps Page");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => mapPage.Map()));
                },
              ),
              ListTile(
                leading: Icon(Icons.pages),
                title: Text(AppLocalizations.of(context)
                    .translate('offerd_courses_string')),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => myhttpWidget()));
                },
              ),
              ListTile(
                  leading: Icon(Icons.assessment),
                  title: Text(AppLocalizations.of(context)
                      .translate('todayspoll_string')),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TodaysPollsPage()));
                  }),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(
                    AppLocalizations.of(context).translate('setting_string')),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Settings()));
                },
              ),
            ],
          )),
        ));
  }

  Dialog _AddCourseDialog() {
    var new_lecture;
    var new_code;
    
    DateTime now = DateTime.now();
    String class_time = _toTimeString(now); 
    String class_day = _toDateString(now);
    final my_controller_1 = TextEditingController();
    final my_controller_2 = TextEditingController();

    
    Future<void> _AddLecturetoDB(Course course) async {
      print('Inside Add lecture to DB $course');
       if(course.courseName==null) 
       {
         print('Course input is null'); 
         return; 
       }


      _lec_model.insertCourse(course);
    }

    return new Dialog(
        backgroundColor: Colors.cyan,
        child: SingleChildScrollView(
            child: Card(
                child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                    AppLocalizations.of(context).translate('add_class_string'),
                    style: TextStyle(color: Colors.cyan, fontSize: 15))),
            Padding(
                padding: const EdgeInsets.all(4),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText:
                        AppLocalizations.of(context).translate('class_string'),
                  ),
                  onChanged: (text) {
                    new_lecture = text;
                  },
                  controller: my_controller_1,
                )),
            Padding(
              padding: const EdgeInsets.all(4),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: AppLocalizations.of(context)
                        .translate('course_string')),
                onChanged: (code) {
                  new_code = code;
                },
              controller: my_controller_2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RaisedButton(
                    child: Text(AppLocalizations.of(context)
                        .translate('coursedays_string')),
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
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                    child: Text(AppLocalizations.of(context)
                        .translate('coursetime_string')),
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
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(_toTimeString(_classDates)),
                  ),
                ],
              ),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text(
                      AppLocalizations.of(context).translate('add_string')),
                  onPressed: () {
                    Course course;
                    course = new Course(
                        courseName: new_lecture,
                        courseCode: new_code,
                        courseDays: _toDateString(_classDates),
                        courseTime: _toTimeString(_classDates),

                    );
                    print("Inside add course dialog $course");
                    _AddLecturetoDB(course);
                    print("$new_lecture (end of lec), $new_code (end of code)");
                    //Send a notification
                    _notificationLater(_classDates);
                    //Display Snack Bar
                    _displayClassAddBar(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text(
                      AppLocalizations.of(context).translate('cancel_string')),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        ))));
  }

  Dialog _AddAssignmentDialog() {
    DateTime now = DateTime.now();
    String new_assignment = "";
    String due_alert = _toTimeString(now);
    String due_time = _toDateString(now);
    final my_controller = TextEditingController();

    return new Dialog(
        //Dialog for adding assignmment
        backgroundColor: Colors.cyan,
        child: SingleChildScrollView(
            child: Card(
                child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                    AppLocalizations.of(context)
                        .translate('addassignment_string'),
                    style: TextStyle(color: Colors.cyan, fontSize: 15))),
            Padding(
                padding: const EdgeInsets.all(4),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: AppLocalizations.of(context)
                        .translate('assign_title_string'),
                  ),
                  onChanged: (text) {
                    new_assignment = text;
                  },
                  controller: my_controller,
                )),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RaisedButton(
                    child: Text(AppLocalizations.of(context)
                        .translate('duedate_string')),
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
                          due_time = _toDateString(_classDates);
                          print("due time $due_time");
                        });
                      });
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: new Text(_toDateString(_classDates)),
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
                    child: Text(AppLocalizations.of(context)
                        .translate('timedue_string')),
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
                          due_alert = _toTimeString(_classDates);
                          print('Due Alert:$due_alert');
                        });
                      });
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(_toTimeString(_classDates)),
                  ),
                ],
              ),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text(
                      AppLocalizations.of(context).translate('add_string')),
                  onPressed: () {
                    //Send a notification
                    print(new_assignment);

                    //TODO: Fix the assignments dialog to display courses
                    setState(() {});
                    Assignment current_assignmet = new Assignment(
                        assignmentName: my_controller.text,
                        courseId: 'CSCI 3030',
                        dueAlert: due_alert,
                        dueDate: due_time);
                    _notificationLater(_classDates);
                    _Add_assignment(current_assignmet);
                    _displayAssignmentAddBar(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text(
                      AppLocalizations.of(context).translate('cancel_string')),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        ))));
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
    final snackBar = SnackBar(
        content: Text(
            AppLocalizations.of(context).translate('new_class_added_dialog')));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _displayAssignmentAddBar(BuildContext context) {
    final snackBar = SnackBar(
        content: Text(AppLocalizations.of(context)
            .translate('new_assignment_added_dialog')));
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

  void _Add_assignment(Assignment assignment) {
    print("Inside add assignment Lecture Page $assignment");

    _model.insertAssignment(assignment);
  }

  Future<List<Course>> _getAllCourses() async {
    return _lec_model.getAllCourse();
  }
}

// Future<void> _completedAssignment() async {
//     print(selectedItem);
//     _model.deleteGrade(selectedItem);
//   }

class LectureWidget extends StatelessWidget {
  Course title;
  BuildContext context;
  final _model = CourseModel();
  
  LectureWidget(context, Course title) {
    this.context = context;
    this.title = title;
  }
  @override
  Widget build(BuildContext context) {
    return new GestureDetector( 
    onLongPress: () 
    {
      
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return AlertDialog(
          title: Text("Delete ${title.courseName}"),
          actions: <Widget>[
            new FlatButton(
              child: Text("Cancel"),
              onPressed: () 
              {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: Text('Delete'),
              onPressed: ()
              {
                _model.deleteCourse(this.title);
                setState(){

                }
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
    },
    child: Card(
        color: Colors.blueAccent,
        child: InkWell(
            splashColor: Colors.blue,
            onTap: () {
              print('Card tapped.');
              _navigatetoAddPage(context, this.title.courseName);
            },
            child: Container(
              width: 300,
              height: 100,
              child: Center(
                child: Text(this.title.courseName),
              ),
            ))
          
            
            ));
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
