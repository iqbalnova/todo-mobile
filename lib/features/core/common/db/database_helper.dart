// lib/data/datasources/task_database_helper.dart
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../home/data/models/task_table.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static const String _tableName = 'tasks';

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'task.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            deadline TEXT,
            isCompleted INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertTask(TaskTable task) async {
    final db = await database;
    return await db.insert(_tableName, task.toMap());
  }

  Future<int> updateTask(TaskTable task) async {
    final db = await database;
    return await db.update(
      _tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<TaskTable?> getTaskById(int id) async {
    final db = await database;
    final result = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return TaskTable.fromMap(result.first);
    }
    return null;
  }

  Future<List<TaskTable>> getAllTasks() async {
    final db = await database;
    final result = await db.query(_tableName);
    return result.map((e) => TaskTable.fromMap(e)).toList();
  }
}
