import 'dart:async';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DBUtils {
  static Future<Database> init() async {
    return openDatabase(
      path.join(await getDatabasesPath(), 'notetakr.db'),
      onCreate: (db, version) {
        if (version > 1) {
          // downgrade path
        }
        db.execute('CREATE TABLE assignments(id INTEGER PRIMARY KEY, name TEXT, courseId TEXT, dueDate TEXT, dueAlert Text)');
        db.execute('CREATE TABLE note(id INTEGER PRIMARY KEY, name TEXT, dateCreated TEXT, dateEdited TEXT, noteData Text)');
        db.execute('CREATE TABLE lecture(id INTEGER PRIMARY KEY, name TEXT, courseId TEXT)');
      },
      version: 1,
    );
  }
}