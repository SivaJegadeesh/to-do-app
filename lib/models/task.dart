import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isCompleted;

  @HiveField(2)
  DateTime? dueDate;

  @HiveField(3)
  int priority; // 0: Low, 1: Medium, 2: High

  @HiveField(4)
  String category;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  String? description;

  @HiveField(7)
  bool isSecure;

  @HiveField(8)
  String? passwordHash;

  Task({
    required this.title,
    this.isCompleted = false,
    this.dueDate,
    this.priority = 0,
    this.category = 'General',
    DateTime? createdAt,
    this.description,
    this.isSecure = false,
    this.passwordHash,
  }) : createdAt = createdAt ?? DateTime.now();
}
