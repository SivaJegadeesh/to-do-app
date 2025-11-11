// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      title: fields[0] as String,
      isCompleted: fields[1] as bool,
      dueDate: fields[2] as DateTime?,
      priority: fields[3] as int,
      category: fields[4] as String,
      createdAt: fields[5] as DateTime,
      description: fields[6] as String?,
      isSecure: fields[7] as bool? ?? false,
      passwordHash: fields[8] as String?,
      isStarred: fields[9] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.isCompleted)
      ..writeByte(2)
      ..write(obj.dueDate)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.isSecure)
      ..writeByte(8)
      ..write(obj.passwordHash)
      ..writeByte(9)
      ..write(obj.isStarred);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
