import 'dart:async';
import 'package:sqflite/sql.dart';
import 'package:notetakr/utils/db_utils.dart';
import 'assignment.dart';

class AssignmentModel {
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
      'assignments', 
      assignment.toMap(), 
      where: 'id = ?',
      whereArgs: [assignment.id],
    );   
  }

  Future<int> deleteAssignment(Assignment assignment) async{
    var db = await DBUtils.init();

    return await db.delete(
      'assignments',
      where: 'courseId = ?',
      whereArgs: [assignment.courseId]
    );
  }

  Future<List<Assignment>> getAllAssignment() async {
    var db = await DBUtils.init();
    final List<Map<String,dynamic>> maps = await db.query('assignments');
    List<Assignment> assignments = [];
    for (int i = 0; i < maps.length; i++) {
      assignments.add(Assignment.fromMap(maps[i]));
    }
    return assignments;
  }

}
