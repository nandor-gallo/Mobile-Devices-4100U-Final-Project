// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:flutter/material.dart';

import 'MyNotesPage.dart';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'NoteTakR',
      home: new LectureList()
    );
  }
}

class LectureList extends StatefulWidget {
  @override
  createState() => new LecutureListState();
}

class LecutureListState extends State<LectureList> {
 
  final List<String> Lectures = ['CSCI 3100','CSCI 4100','CSCI 4500',' Intro to Computer Science'];
 
  @override
  Widget build(BuildContext context) {
    return new 
    DefaultTabController(
    length:3,
    child: Scaffold(
      appBar: AppBar(
        title:  Text('NoteTakR'),
        bottom: TabBar(
          isScrollable: true,
          tabs: <Widget>[
            Tab(text:'Notes',icon: Icon(Icons.list),),
            Tab(text:'Locations',icon: Icon(Icons.map)),
            Tab(text: 'Graphs',icon: Icon(Icons.multiline_chart)),
            
          ]
        ),
      ),
      body: TabBarView(children: <Widget>[
        Tab(
          child: GridView.count(
            primary: true,
            crossAxisCount: 4,
            children: (Lectures.map((Lecture)=> new LectureWidget(this.context,Lecture)).toList())
          )
          //TODO: Implment a Future Builder Widget to get Data For the Notes
        ),
        Tab(
          child: Text('Implement Locations Widgets'),
        ),
        Tab(
          child: Text('Implements Grpah Page'),
        )
      ],)

    ));
  }
}

class LectureWidget extends StatelessWidget
{ 
  String title; 
  BuildContext context;
  LectureWidget(context, String title)
  {
    this.context = context; 
    this.title= title;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      decoration: BoxDecoration(color: Colors.grey),
      child: GestureDetector(
      onTap: () 
      {
        //TODO: Navigate to Notes Page
        _NavigatetoAddPage(this.context,this.title); 
              },
        
              child: Padding(
                padding: const EdgeInsets.all(0.5),
                child: Text(this.title),),
            ));
          }
        
  
  void  _NavigatetoAddPage(context,String lecture) {
    print(" List Tile  Widget  passing Lecture: $lecture");
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => MyNotesPage(lecture)
    ));

  }        
  
}
