// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('NoteTakR')
      )
    );
  }
}