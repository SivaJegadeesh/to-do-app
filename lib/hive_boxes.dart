import 'package:hive/hive.dart';
import '../models/task.dart';

class Boxes {
  static Box<Task> getTasks() => Hive.box<Task>('tasks');
}
