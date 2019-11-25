import 'dart:convert';
import 'package:notetakr/AssignmentsChartPage.dart';
import 'package:notetakr/TodaysPolls.dart';
import 'package:notetakr/model/program.dart' as prefix0;

import 'package:flutter/material.dart';
import 'package:notetakr/model/program.dart';
import 'MyNotesPage.dart';
import 'model/program.dart';
import 'utils/Notifications.dart';
import 'package:http/http.dart' as http;


class LectureList extends StatefulWidget {
  @override
  createState() => new _LectureListState();
}

class _LectureListState extends State<LectureList> with SingleTickerProviderStateMixin {
  final List<String> lectures = [
    'CSCI 3100',
    'CSCI 4100',
    'CSCI 4500',
    ' Intro to Computer Science'
  ];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 6);
  }

  DateTime _classDates = DateTime.now();
  var _notifications = Notifications();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _notifications.init();
    DateTime now = DateTime.now();
    //Tabs With Items
    return new DefaultTabController(
        length: 6,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('NoteTakR'),

            bottom: TabBar(isScrollable: true,controller: _tabController, tabs: <Widget>[
              Tab(
                text: 'Notes',
                icon: Icon(Icons.list),
              ),
              Tab(text: 'Campus Map', icon: Icon(Icons.map)),
              Tab(text: 'Graphs', icon: Icon(Icons.multiline_chart)),
              Tab(
                text: 'Assignments',
                icon: Icon(Icons.note),
              ),
              Tab(text:'Offered Courses', icon: Icon(Icons.pages)),
              Tab(text:'Daily Poll', icon: Icon(Icons.assessment)),
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
                child: Text('Implement Locations Widgets'),
              ),
              Tab(

                  child: AssignmentChartsPage()

              ),
              Tab(
                  //List of Assignments
                  child: ListView(
                      primary: true,
                      children: (lectures
                          .map((lecture) => new AssignmentWidget())
                          .toList()))
                  //TODO: Implement a Future Builder Widget to get Data For the Assignments
                  ),
                  Tab(
                     child: myhttpWidget(),
                  ),
              Tab(
                  child: TodaysPollsPage(),
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
                    String new_lecture = "";
                    String new_code = "";
                    if(_tabController.index==0){
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
                    }else if(_tabController.index == 3){
                       return new Dialog(
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
                                    new_lecture = text;
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
                                    //_notificationLater(_classDates);
                                    //Display Snack Bar
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
                  });
            },
          ),
        ));
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
    print(dateNotify);
    await _notifications.sendNotificationLater(
        'CSCI 4100 Assignment', 'Due: Thursday!', dateNotify, 'payload');
  }

  void _AddLecturetoDB(String new_lecture, String new_code, DateTime date) {
    print("Add Class $new_lecture  and $new_code to  Database With $date");
    //TODO: Insert new Lecture to model
  }
}

class AssignmentWidget extends StatelessWidget {
  String title;
  DateTime dueDate;

  BuildContext context;
  AssignmentWidget({this.title, this.dueDate, this.context});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Assignment 1 CSCI 2040"),
      subtitle: Text("DUE: " + _toDateString(DateTime.now())),
      leading: Icon(Icons.find_in_page),
      //Implement a notification
      //Implment swipe on completion
      //Edit Due Date
      onTap: () {
        print("Hello");
      },
    );
  }
}




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
        color: Colors.blueGrey,
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

String _toTimeString(DateTime dateTime) {
  return '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}';
}


class myhttpWidget extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return myhttpWidgetState();
  }

}

class myhttpWidgetState extends State<myhttpWidget>
{
  final String url = "https://ontariotechu.ca/programs/index.json";



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future:  getEvents(url),
      builder: (context,snapshot)
      {
        if(snapshot.hasData)
        {
          List<ProgramElement> classes = snapshot.data.programs.program;
          classes.forEach((f) => print(f.title));
          return ListView(children: classes.map((item ) => new ProgramWidget(item)).toList());
        }
        else
        {
          return CircularProgressIndicator();
        }
      }
    );
  }

  Future<Program> getEvents(String url)  async
  {
    var response = await http.get(url);

    return programFromJson(response.body);
    //TODO: Create an event class and  Return List of JSON

  }


}

class ProgramWidget extends StatelessWidget
{
  prefix0.ProgramElement element;

  ProgramWidget(ProgramElement element)
  {
    this.element = element;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GestureDetector(
      onTap: ()
      {}
      ,
      child: Card(

        child: Column(
          children: <Widget>[
            Text(this.element.title,style: TextStyle(color: Colors.cyan,fontSize:16),),
            Text(this.element.summary,style: TextStyle(color:Colors.grey,fontSize: 12),),
            Text('${this.element.faculty}',style: TextStyle(color: Colors.grey, fontSize: 10),),
          ],
        ),
      ),
    );
  }

}
