import 'dart:async';
import 'package:sqflite/sql.dart';
import 'db_utils.dart';
import 'note.dart';

class NoteModel {
  Future<void> insertNote(Note note) async {
    var db = await DBUtils.init();
    db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateNote(Note note) async {
    var db = await DBUtils.init();
    db.update(
      'notes', 
      note.toMap(), 
      where: 'id = ?',
      whereArgs: [note.id],
    );   
  }

  Future<List<Note>> getAllNotes() async {
    var db = await DBUtils.init();
    final List<Map<String,dynamic>> maps = await db.query('notes');
    List<Note> notes = [];
    for (int i = 0; i < maps.length; i++) {
      notes.add(Note.fromMap(maps[i]));
    }
    return notes;
  }

}
