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
  var _course; 
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
   
    DateTime now = DateTime.now();
    DateTime _classDates;
    print("Initial value:$_course");
    if(_course==null)
    {
      _course = new Course();  
      DateTime _classDates = now;
    }
    _course.courseTime = _toTimeString(now);
  
    _course.courseDays = "Mon:Wed"; 
    List<String> drop_vales = ["Mon",'Thu'];
    TextEditingController my_controller = new TextEditingController();
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
          Center(
          
            child: Text("Add a course",style: TextStyle(color: Colors.cyan, fontStyle: FontStyle.italic),)
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Course Name"),
              initialValue: _course.courseName,
              onChanged: (text)  {
                _course.courseName = text; 
              },
              //controller: my_controller,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.4),
             child: TextFormField(
              decoration: InputDecoration(hintText: "Course Code"),
              initialValue: _course.courseCode,
              onChanged: (text)  {
                _course.courseCode = text; 
              },
              
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
                          _course.courseTime = _toTimeString(_classDates);
                        });
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child:  Text(_course.courseTime),

                  ),
        ],
      ),
      
      
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: <Widget>[
            Text("Course days: "),
           DropdownButton<String>(
          value: drop_vales[0],
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(
          color: Colors.blue
        ),
        underline: Container(
          height: 2,
          color: Colors.blueAccent,
        ),
        onChanged: (String newValue) {
          setState(() {
            
            drop_vales[0]=newValue;
            
            _course.courseDays = drop_vales.toString();
          
            print(_course.courseDays);

          });
        },
        items: <String>['Mon', 'Wed', 'Tue', 'Thu','Fri']
          .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          })
          .toList(),

          
      ),
      //Drop down button for second Course days.
      DropdownButton<String>(
          value: drop_vales[1],
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(
          color: Colors.blue
        ),
        underline: Container(
          height: 2,
          color: Colors.blueAccent,
        ),
        onChanged: (String newValue) {
          setState(() {
             
            drop_vales[1]=newValue;
            _course.courseDays = drop_vales[1].toString();
            print(_course.courseDays);

          });
        },
        items: <String>['Mon', 'Wed', 'Tue', 'Thu','Fri']
          .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          })
          .toList(),
      ), 
           ] ),
      ),
        ButtonBar(
          children: <Widget>[
            RaisedButton(
              color: Colors.cyan,
              child: Text("Cancel"),
              onPressed: () 
              {
                Navigator.pop(context);
              },
            ),
            RaisedButton(
              color: Colors.cyan,
              child: Text("Ok"),
              onPressed: () 
              {
                print("Inside on pressed:$_course");
                print("Inside on pressed:${my_controller.toString()}");
                _AddLecturetoDB(_course);
                Navigator.pop(context);
              },
            )
          ],
        )
           ] ))));
      
      
      

      
  
  
  
  }

  Dialog _AddAssignmentDialog() {
    DateTime now = DateTime.now();
    Assignment _assign;
    if(_assign==null){
    _assign = new Assignment(); 
    }
    _assign.dueDate = _toDateString(now);
    _assign.dueAlert = _toTimeString(now); 
     DateTime _classDates = DateTime.now();



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
                child: TextFormField(
                  initialValue: _assign.assignmentName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: AppLocalizations.of(context)
                        .translate('assign_title_string'),
                  ),
                  onChanged: (text) {
                    _assign.assignmentName = text;
                  },
                  
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
                          _assign.dueDate = _toDateString(_classDates);
                        });
                      });
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: new Text(_assign.dueDate),
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
                          _assign.dueAlert = _toTimeString(_classDates);
                        
                        });
                      });
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(_assign.dueAlert),
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
                    _assign.courseId = "CSCI 2100";

                    //TODO: Fix the assignments dialog to display courses
                    print('Inside on Pressed add assignment: $_assign'); 
                    _notificationLater(_classDates);
                    if(_assign.assignmentName!=null)
                   { 
                     _Add_assignment(_assign); 
                     
                     }
                     else{
                       print("Null assignment");
                     }
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
