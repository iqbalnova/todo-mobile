import 'package:dartz/dartz.dart';
import '../../../core/common/exception.dart';
import '../../../core/common/failure.dart';
import '../../domain/entities/task.dart' as entity;
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../models/task_table.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<entity.Task>>> getAllTasks() async {
    try {
      final result = await localDataSource.getAllTasks();
      return Right(result.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, entity.Task>> getTaskById(int id) async {
    try {
      final result = await localDataSource.getTaskById(id);
      if (result != null) {
        return Right(result.toEntity());
      } else {
        return Left(DatabaseFailure('Task not found'));
      }
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> insertTask(entity.Task task) async {
    try {
      final result = await localDataSource.insertTask(
        TaskTable.fromEntity(task),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, String>> updateTask(entity.Task task) async {
    try {
      final result = await localDataSource.updateTask(
        TaskTable.fromEntity(task),
      );

      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, String>> deleteTask(int id) async {
    try {
      final result = await localDataSource.deleteTask(id);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
