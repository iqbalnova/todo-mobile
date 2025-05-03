import '../../domain/entities/task.dart';

class TaskModel {
  final int? id;
  final String title;
  final String description;
  final DateTime deadline;
  final bool isCompleted;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.isCompleted,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    deadline: DateTime.parse(json['deadline']),
    isCompleted: json['isCompleted'] == 1,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'deadline': deadline.toIso8601String(),
    'isCompleted': isCompleted ? 1 : 0,
  };

  Task toEntity() => Task(
    id: id,
    title: title,
    description: description,
    deadline: deadline,
    isCompleted: isCompleted,
  );

  factory TaskModel.fromEntity(Task task) => TaskModel(
    id: task.id,
    title: task.title,
    description: task.description,
    deadline: task.deadline,
    isCompleted: task.isCompleted,
  );
}
