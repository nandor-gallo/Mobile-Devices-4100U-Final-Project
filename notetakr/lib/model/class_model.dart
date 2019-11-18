import 'dart:async';
import 'package:sqflite/sql.dart';
import 'package:notetakr/utils/db_utils.dart';
import 'course.dart';

class CourseModel {
  Future<void> insertCourse(Course course) async {
    var db = await DBUtils.init();
    db.insert(
      'courses',
      course.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCourse(Course course) async {
    var db = await DBUtils.init();
    db.update(
      'courses', 
      course.toMap(), 
      where: 'id = ?',
      whereArgs: [course.id],
    );   
  }

    Future<int> deleteCourse(Course course) async{
    var db = await DBUtils.init();

    return await db.delete(
      'courses',
      where: 'courseCode = ?',
      whereArgs: [course.courseCode]
    );
  }


  Future<List<Course>> getAllCourse() async {
    var db = await DBUtils.init();
    final List<Map<String,dynamic>> maps = await db.query('courses');
    List<Course> courses = [];
    for (int i = 0; i < maps.length; i++) {
      courses.add(Course.fromMap(maps[i]));
    }
    return courses;
  }

}
