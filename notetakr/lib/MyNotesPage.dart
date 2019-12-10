import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notetakr/model/note.dart';
import 'package:notetakr/model/note_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'AddNote.dart';
import 'MyNote.dart';

final _model = NoteModel();

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
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  MyNotesPageState(String title) {
    this.title = title;
  }

  void _onRefresh() async {
    // monitor network fetch
    // if failed,use refreshFailed()
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    var addSnackbar = SnackBar(
      content: Text('Add Button Pressed'),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        actions: <Widget>[],
      ),
      body: Scrollbar(
          child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropMaterialHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text("pull up load");
                  } else if (mode == LoadStatus.loading) {
                    body = CircularProgressIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("release to load more");
                  } else {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: MainView(this.title))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Include Add Notes Functionality");
          _navigatetoAddNotes(context, title);
          Scaffold.of(this.context).showSnackBar(addSnackbar);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void _navigatetoAddNotes(BuildContext context, String course_code) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => AddNote(course_code)));
}

void _navigatetoEditNotes(BuildContext context, String course_code, Note note) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddNote(
                course_code,
                note: note,
                edit: true,
              )));
}

void _navigatetodescription(BuildContext context, Note s) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => MyNote(s)));
}

class NWS extends StatefulWidget {
  @override
  Note note;
  BuildContext context;

  NWS(BuildContext context, Note note) {
    this.context = context;
    this.note = note;
  }

  State<StatefulWidget> createState() {
    return NoteWidget(context, note);
  }
}

class NoteWidget extends State<NWS> {
  Note note;
  BuildContext context;
  final _model = NoteModel();

  NoteWidget(BuildContext context, Note note) {
    this.context = context;
    this.note = note;
  }
  @override
  Widget build(BuildContext context) {
    print('Inside NoteWidget, ${note}');
    return Card(
      child: InkWell(
        splashColor: Colors.cyan,
        onTap: () {
          _navigatetodescription(context, note);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                note.noteName,
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  note.dateCreated,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                )),
          ],
        ),
      ),
    );
  }
}

Future<List<Note>> _getAllNotes(String coursecode) async {
  var my_notes = await _model.getAllNotesforCourse(coursecode);

  return my_notes;
}

class MainView extends StatelessWidget {
  String title;

  MainView(String title) {
    print(title);
    this.title = title;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
        future: _getAllNotes(this.title),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Note> my_list = snapshot.data;

            return ListView.builder(
              itemCount: my_list.length,
              itemBuilder: (_, int index) {
                print(
                    'in item builder len of data: ${snapshot.data.length}, index: $index');
                print('in item builder: ${snapshot.data[index]}');
                return new Slidable(
                  key: Key("Main Sliable"),
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: NWS(context, my_list[index]),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                        caption: 'Edit',
                        color: Colors.blue,
                        icon: Icons.edit,
                        onTap: () {
                          print("Edit Pressed");
                          _navigatetoEditNotes(context,
                              my_list[index].courseCode, my_list[index]);
                        }),
                    IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          print('Delete');
                          setState() {
                            deleteNote(my_list[index]);
                            my_list.removeAt(index);
                          }
                        }),
                  ],
                );
              },
            );
          } else {
            return Center(
                child: Text('No Notes have been added for this course'));
          }
        });
  }

  void deleteNote(Note n) async {
    _model.deleteNote(n);
  }
}
