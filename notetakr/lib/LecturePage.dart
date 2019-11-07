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
        length: 3,
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
                )
              ],
            )));
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
    return new Container(
        decoration: BoxDecoration(color: Colors.grey),
        child: GestureDetector(
          onTap: () {
            //TODO: Navigate to Notes Page
            _navigatetoAddPage(this.context, this.title);
          },
          child: Padding(
            padding: const EdgeInsets.all(0.5),
            child: Text(this.title),
          ),
        ));
  }

  void _navigatetoAddPage(context, String lecture) {
    print(" List Tile Widget passing Lecture: $lecture");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyNotesPage(lecture)));
  }
}
