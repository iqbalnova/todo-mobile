import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/delete_task.dart';
import '../../../domain/usecases/get_all_tasks.dart';
import '../../../domain/usecases/insert_task.dart';
import '../../../domain/usecases/update_task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetAllTasks getAllTasks;
  final DeleteTask deleteTask;
  final UpdateTask updateTask;
  final InsertTask insertTask;

  TaskBloc({
    required this.getAllTasks,
    required this.deleteTask,
    required this.updateTask,
    required this.insertTask,
  }) : super(TaskInitial()) {
    on<FetchTasks>((event, emit) async {
      final result = await getAllTasks.execute();

      result.fold(
        (failure) {
          emit(TaskError(failure.message));
        },
        (tasks) {
          emit(TaskLoaded(tasks));
        },
      );
    });

    on<CreateTaskEvent>((event, emit) async {
      emit(CreateTaskLoading());
      final result = await insertTask.execute(event.task);
      result.fold((failure) => emit(CreateTaskFailed()), (task) {
        emit(CreateTaskSuccess());
      });
    });

    on<UpdateTaskEvent>((event, emit) async {
      emit(UpdateTaskLoading());
      final result = await updateTask.execute(event.task);
      result.fold((failure) => emit(UpdateTaskFailed()), (task) {
        emit(UpdateTaskSuccess());
      });
    });

    on<DeleteTaskById>((event, emit) async {
      if (state is TaskLoaded) {
        await deleteTask.execute(event.id);
      }
    });

    on<ToggleCompleteTask>((event, emit) async {
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        final task = currentState.tasks.firstWhere((t) => t.id == event.id);
        final updatedTask = task.copyWith(isCompleted: event.isCompleted);
        await updateTask.execute(updatedTask);
      }
    });
  }
}
