import '../../domain/entities/task.dart';

class TaskTable {
  final int? id;
  final String title;
  final String description;
  final String deadline; // disimpan sebagai ISO String
  final int isCompleted; // 1 atau 0

  TaskTable({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.isCompleted,
  });

  factory TaskTable.fromMap(Map<String, dynamic> map) => TaskTable(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    deadline: map['deadline'],
    isCompleted: map['isCompleted'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'deadline': deadline,
    'isCompleted': isCompleted,
  };

  Task toEntity() => Task(
    id: id,
    title: title,
    description: description,
    deadline: DateTime.parse(deadline),
    isCompleted: isCompleted == 1,
  );

  factory TaskTable.fromEntity(Task task) => TaskTable(
    id: task.id,
    title: task.title,
    description: task.description,
    deadline: task.deadline.toIso8601String(),
    isCompleted: task.isCompleted ? 1 : 0,
  );
}
