import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'app_localizations.dart';
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
