import 'dart:async';
import 'package:sqflite/sql.dart';
import 'package:notetakr/utils/db_utils.dart';
import 'assignment.dart';

class AssignmentModel {
  Future<void> insertCourse(Assignment assignment) async {
    var db = await DBUtils.init();
    db.insert(
      'assignments',
      assignment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCourse(Assignment assignment) async {
    var db = await DBUtils.init();
    db.update(
      'courses', 
      assignment.toMap(), 
      where: 'id = ?',
      whereArgs: [assignment.id],
    );   
  }

  Future<List<Assignment>> getAllCourse() async {
    var db = await DBUtils.init();
    final List<Map<String,dynamic>> maps = await db.query('assignments');
    List<Assignment> assignments = [];
    for (int i = 0; i < maps.length; i++) {
      assignments.add(Assignment.fromMap(maps[i]));
    }
    return assignments;
  }

}
