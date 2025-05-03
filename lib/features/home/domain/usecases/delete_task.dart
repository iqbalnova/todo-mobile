import 'package:dartz/dartz.dart';
import '../../../core/common/failure.dart';
import '../repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<Either<Failure, String>> execute(int id) {
    return repository.deleteTask(id);
  }
}
