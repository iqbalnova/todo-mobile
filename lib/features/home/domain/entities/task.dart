import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int? id;
  final String title;
  final String description;
  final DateTime deadline;
  final bool isCompleted;

  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.isCompleted,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? deadline,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, description, deadline, isCompleted];
}
