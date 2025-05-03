import 'package:equatable/equatable.dart';
import '../../../domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class FetchTasks extends TaskEvent {}

class CreateTaskEvent extends TaskEvent {
  final Task task;

  const CreateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskById extends TaskEvent {
  final int id;

  const DeleteTaskById(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleCompleteTask extends TaskEvent {
  final int id;
  final bool isCompleted;

  const ToggleCompleteTask({required this.id, required this.isCompleted});

  @override
  List<Object?> get props => [id, isCompleted];
}
