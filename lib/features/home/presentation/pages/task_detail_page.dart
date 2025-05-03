import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/app_routes.dart';
import '../../domain/entities/task.dart';

class TaskDetailPage extends StatelessWidget {
  final Task task;

  const TaskDetailPage({super.key, required this.task});

  String getStatus(Task task) {
    if (task.isCompleted) return 'Completed';
    if (task.deadline.isBefore(DateTime.now())) return 'Overdue';
    return 'Ongoing';
  }

  Color getStatusColor(Task task) {
    if (task.isCompleted) return Colors.green;
    if (task.deadline.isBefore(DateTime.now())) return Colors.red;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          Visibility(
            visible: !task.isCompleted,
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.taskForm,
                  arguments: task,
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(task.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              'Deadline:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE, MMMM dd, yyyy HH:mm').format(task.deadline),
              style: TextStyle(
                fontSize: 16,
                color:
                    task.deadline.isBefore(DateTime.now()) && !task.isCompleted
                        ? Colors.red
                        : null,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Status:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: getStatusColor(task),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                getStatus(task),
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
