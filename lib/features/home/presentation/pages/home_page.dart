import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/features/home/domain/entities/task.dart';
import '../../../core/common/utils.dart';
import '../../../core/routes/app_routes.dart';
import '../bloc/task/task_bloc.dart';
import '../bloc/task/task_event.dart';
import '../bloc/task/task_state.dart';

class HomePage extends StatefulWidget {
  final GetIt locator;
  const HomePage({super.key, required this.locator});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    _fetchTasks();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _fetchTasks() {
    context.read<TaskBloc>().add(FetchTasks());
  }

  void _deleteTask(int id, String title) {
    context.read<TaskBloc>().add(DeleteTaskById(id));
    _showDeleteToast(title);
    _fetchTasks();
  }

  void _showDeleteToast(String title) {
    Fluttertoast.showToast(
      msg: '$title deleted',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.error,
      textColor: Theme.of(context).colorScheme.onError,
    );
  }

  void _toggleTaskCompletion(int id, bool isCompleted, String title) async {
    if (isCompleted) {
      // If trying to uncheck a completed task, show alert
      _showCompletedTaskAlert();
      return;
    }

    // If trying to complete a task, show confirmation
    final confirmed = await _showCompleteConfirmation(title);
    if (confirmed) {
      // ignore: use_build_context_synchronously
      context.read<TaskBloc>().add(
        ToggleCompleteTask(id: id, isCompleted: true),
      );
      _fetchTasks();
    }
  }

  void _navigateToTaskDetail(Task task) {
    Navigator.pushNamed(
      context,
      AppRoutes.taskDetail,
      arguments: {'detailData': task, 'isCompleted': task.isCompleted},
    );
  }

  void _navigateToTaskForm() {
    Navigator.pushNamed(context, AppRoutes.taskForm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: _buildTaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToTaskForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Main task list builder using BLoC pattern
  Widget _buildTaskList() {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskLoaded) {
          return _buildTaskListContent(state.tasks);
        } else if (state is TaskError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }

  // Content of the task list when tasks are loaded
  Widget _buildTaskListContent(List tasks) {
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks available.'));
    }

    return ListView.builder(
      itemCount: tasks.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) => _buildTaskItem(tasks[index]),
    );
  }

  // Individual task item
  Widget _buildTaskItem(Task task) {
    return Dismissible(
      key: Key(task.id.toString()),
      background: _buildDismissibleBackground(),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteTask(task.id!, task.title),
      child: _buildTaskCard(task),
    );
  }

  // Background for dismissible items (delete action)
  Widget _buildDismissibleBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  // Card for task item
  Widget _buildTaskCard(Task task) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged:
              (value) => _toggleTaskCompletion(
                task.id!,
                task.isCompleted && (value == false),
                task.title,
              ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: _buildTaskSubtitle(task),
        isThreeLine: true,
        onTap: () => _navigateToTaskDetail(task),
      ),
    );
  }

  // Subtitle section for task items
  Widget _buildTaskSubtitle(Task task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(task.description, overflow: TextOverflow.ellipsis, maxLines: 3),
        const SizedBox(height: 4),
        Text(
          'Deadline: ${DateFormat('MMM dd, yyyy HH:mm').format(task.deadline)}',
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Dialog methods
  Future<void> _showCompletedTaskAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Task Already Completed'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Once a task is marked as completed, it cannot be unchecked.',
                ),
                SizedBox(height: 8),
                Text('Completed tasks are permanently marked as done.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Understand'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showCompleteConfirmation(String taskTitle) async {
    bool result = false;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Complete Task?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to mark "$taskTitle" as complete?'),
                const SizedBox(height: 8),
                const Text(
                  'Once completed, this task cannot be unchecked or edited.',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Complete'),
              onPressed: () {
                result = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return result;
  }
}
