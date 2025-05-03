import 'package:dartz/dartz.dart';
import '../../../core/common/failure.dart';
import '../entities/task.dart' as entity;
import '../repositories/task_repository.dart';

class GetAllTasks {
  final TaskRepository repository;

  GetAllTasks(this.repository);

  Future<Either<Failure, List<entity.Task>>> execute() {
    return repository.getAllTasks();
  }
}
