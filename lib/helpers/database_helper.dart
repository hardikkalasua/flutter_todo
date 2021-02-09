import 'dart:io';

import 'package:flutter_todo/models/note_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  String notesTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colNote = 'note';
  String colTimeline = 'timeline';
  String colStarred = 'starred';

  // Task Tables
  // Id | Title | Note | Timeline | Starred
  // 0     ''      ''       ''        ''
  // 2     ''      ''       ''        ''
  // 3     ''      ''       ''        ''

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'notes.db';
    final notesDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $notesTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colNote TEXT, $colTimeline TEXT, $colStarred INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(notesTable);
    return result;
  }

  Future<List<Note>> getNoteList() async {
    final List<Map<String, dynamic>> noteMapList = await getNoteMapList();
    final List<Note> noteList = [];
    noteMapList.forEach((noteMap) {
      noteList.add(Note.fromMap(noteMap));
    });
    return noteList;
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.db;
    final int result = await db.insert(notesTable, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    Database db = await this.db;
    final int result = await db.update(notesTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      notesTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }
}
