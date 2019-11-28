// Using firebase to store the daily poll results
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

bool isVoted = false;

class Poll {
  final String answer;
  final int votes;
  final DocumentReference reference;

  Poll.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['answer'] != null),
        assert(map['votes'] != null),
        answer = map['answer'],
        votes = map['votes'];

  Poll.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Poll<$answer:$votes>";
}

class TodaysPollsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodaysPollsState();
  }
}

class TodaysPollsState extends State<TodaysPollsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(
            "Which prof would you say is your favourite?",
            textScaleFactor: 0.9,
          )),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('pollresults').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 32.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final pollresults = Poll.fromSnapshot(data);

    return Padding(
      key: ValueKey(pollresults.answer),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          border: Border.all(width: 4.0, color: Colors.black),
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: ListTile(
            title:
                Text(pollresults.answer, style: TextStyle(color: Colors.white)),
            trailing: (isVoted)
                ? Text("Votes: " + pollresults.votes.toString(),
                    style: TextStyle(color: Colors.white))
                : Text(""),
            onTap: () {
              if (!isVoted) {
                pollresults.reference.updateData({'votes': FieldValue.increment(1)});
                isVoted = true;
              }
            }),
      ),
    );
  }
}
