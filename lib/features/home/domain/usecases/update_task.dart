import 'package:dartz/dartz.dart';
import '../../../core/common/failure.dart';
import '../entities/task.dart' as entity;
import '../repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<Either<Failure, String>> execute(entity.Task task) {
    return repository.updateTask(task);
  }
}
