import 'dart:async';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DBUtils {
  static Future<Database> init() async {
    return openDatabase(
      path.join(await getDatabasesPath(), 'notetakr.db'),
      onCreate: (db, version) {
        if (version == 1) {
          db.execute(
              'CREATE TABLE assignments(id INTEGER PRIMARY KEY, assignmentName TEXT, courseId TEXT, dueDate TEXT, dueAlert Text)');
          db.execute(
              'CREATE TABLE notes(id INTEGER PRIMARY KEY, noteName TEXT, dateCreated TEXT, dateEdited TEXT, noteData Text)');
          db.execute(
              'CREATE TABLE courses(id INTEGER PRIMARY KEY, courseName TEXT, courseId TEXT)');
        } else {}
      },
      version: 1,
    );
  }
}