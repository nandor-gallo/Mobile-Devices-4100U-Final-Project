import 'package:flutter/material.dart';
import 'MyNotesPage.dart';

class LectureList extends StatefulWidget {
  @override
  createState() => new _LectureListState();
}

class _LectureListState extends State<LectureList> {
  final List<String> lectures = [
    'CSCI 3100',
    'CSCI 4100',
    'CSCI 4500',
    ' Intro to Computer Science'
  ];

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              title: Text('NoteTakR'),
              bottom: TabBar(isScrollable: true, tabs: <Widget>[
                Tab(
                  text: 'Notes',
                  icon: Icon(Icons.list),
                ),
                Tab(text: 'Locations', icon: Icon(Icons.map)),
                Tab(text: 'Graphs', icon: Icon(Icons.multiline_chart)),
                Tab(text: 'Assignments',icon: Icon(Icons.note),),
              ]),
            ),
            body: TabBarView(
              children: <Widget>[

                Tab(
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
                  child: Text('Implements Graph Page'),
                ),
                Tab(
                  child: Text("Implement Assignments"),
                  )
                
              ],

            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add_comment),
              onPressed: () 
              {
                print("Add Lectures Page"); 
                showDialog(
                context: context,  
                builder: (BuildContext context) {
                 String new_lecture=""; 
                 
                 return new Dialog(
                  
                  backgroundColor: Colors.cyan,
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                        padding: const EdgeInsets.all(4),
                        child:Text('Add A New Lecture',style:TextStyle(color: Colors.cyan,fontSize: 15))
                        ),
                        Padding(
                        padding:  const EdgeInsets.all(4),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(), 
                            hintText: 'Lecture Name',
                          ),
                          onChanged: (text) {
                            new_lecture = text;
                          },
                        )
                        ),
                        ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text("Add"), 
                              onPressed: () 
                              {
                                //TODO: ADD notes to database 
                                _AddLecturetoDB(new_lecture); 
                                 Navigator.pop(context);                               
                                                              },
                                                            ),
                                                            FlatButton(
                                                              child: Text("Cancel"), 
                                                              onPressed: () 
                                                              {
                                                                  Navigator.pop(context); 
                                                              },
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  )
                                                );
                                                }
                                                );
                                              
                                              },
                                            ),
                                            )
                                            
                                            );
                                  }
                                
                                  void _AddLecturetoDB(String new_lecture) {
                                     print("Add Lecture $new_lecture to Database");

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
    // TODO: Implement build
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
