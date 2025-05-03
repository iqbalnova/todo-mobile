import '../../../core/common/db/database_helper.dart';
import '../../../core/common/exception.dart';
import '../models/task_table.dart';

abstract class TaskLocalDataSource {
  Future<String> insertTask(TaskTable task);
  Future<String> updateTask(TaskTable task);
  Future<String> deleteTask(int id);
  Future<TaskTable?> getTaskById(int id);
  Future<List<TaskTable>> getAllTasks();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final DatabaseHelper databaseHelper;

  TaskLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertTask(TaskTable task) async {
    try {
      await databaseHelper.insertTask(task);
      return 'Task added successfully';
    } catch (e) {
      throw DatabaseException('Insert failed: ${e.toString()}');
    }
  }

  @override
  Future<String> updateTask(TaskTable task) async {
    try {
      await databaseHelper.updateTask(task);
      return 'Task updated successfully';
    } catch (e) {
      throw DatabaseException('Update failed: ${e.toString()}');
    }
  }

  @override
  Future<String> deleteTask(int id) async {
    try {
      await databaseHelper.deleteTask(id);
      return 'Task deleted successfully';
    } catch (e) {
      throw DatabaseException('Delete failed: ${e.toString()}');
    }
  }

  @override
  Future<TaskTable?> getTaskById(int id) async {
    final result = await databaseHelper.getTaskById(id);
    return result;
  }

  @override
  Future<List<TaskTable>> getAllTasks() async {
    return await databaseHelper.getAllTasks();
  }
}
