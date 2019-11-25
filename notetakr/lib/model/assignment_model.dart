import 'dart:async';
import 'package:sqflite/sql.dart';
import 'package:notetakr/utils/db_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'assignment.dart';

class AssignmentModel {
  void insertGrade(String id, String title, Timestamp dueDate) async {
    await Firestore.instance
        .collection("Assignments")
        .document(id)
        .setData({'title': title, 'due': dueDate});
  }

  void completedAssignment(String id) {
    try {
      print(id);
      Firestore.instance.collection("Assignments").document(id).delete();
    } catch (e) {
      print(e.toString());
    }
  }


  // Local Functions for assignment storage
  Future<void> insertAssignment(Assignment assignment) async {
    var db = await DBUtils.init();
    db.insert(
      'assignments',
      assignment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateAssignment(Assignment assignment) async {
    var db = await DBUtils.init();
    db.update(
      'courses', 
      assignment.toMap(), 
      where: 'id = ?',
      whereArgs: [assignment.id],
    );   
  }

  Future<List<Assignment>> getAllAssignments() async {
    var db = await DBUtils.init();
    final List<Map<String,dynamic>> maps = await db.query('assignments');
    List<Assignment> assignments = [];
    for (int i = 0; i < maps.length; i++) {
      assignments.add(Assignment.fromMap(maps[i]));
    }
    return assignments;
  }
}
