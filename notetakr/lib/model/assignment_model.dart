import 'dart:async';
import 'package:sqflite/sql.dart';
import 'package:notetakr/utils/db_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'assignment.dart';

class AssignmentModel {
  void insertGrade(String id,String title, Timestamp dueDate) async {
    await Firestore.instance.collection("Assignments")
      .document(id)
      .setData({
        'title': title,
        'due': dueDate
      });
  }

  void completedAssignment(String id) {
  try {
    print(id);
    Firestore.instance.collection("Assignments")
        .document(id)
        .delete();
  } catch (e) {
    print(e.toString());
  }
}
}
