import 'package:dartz/dartz.dart';
import '../entities/task.dart' as entity;
import '../../../core/common/failure.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<entity.Task>>> getAllTasks();
  Future<Either<Failure, entity.Task>> getTaskById(int id);
  Future<Either<Failure, String>> insertTask(entity.Task task);
  Future<Either<Failure, String>> updateTask(entity.Task task);
  Future<Either<Failure, String>> deleteTask(int id);
}
