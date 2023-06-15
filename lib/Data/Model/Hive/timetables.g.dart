// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetables.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeTableHiveAdapter extends TypeAdapter<TimeTableHive> {
  @override
  final int typeId = 0;

  @override
  TimeTableHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeTableHive(
      classroom: fields[0] as String,
      classname: fields[1] as String,
      department: fields[2] as String,
      semester: fields[3] as int,
      createdTime: fields[4] as String,
      image: fields[5] as String?,
      days: (fields[6] as List).cast<DayOfWeekHive>(),
      id: fields[7] as String,
      isSelected: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TimeTableHive obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.classroom)
      ..writeByte(1)
      ..write(obj.classname)
      ..writeByte(2)
      ..write(obj.department)
      ..writeByte(3)
      ..write(obj.semester)
      ..writeByte(4)
      ..write(obj.createdTime)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.days)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(8)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeTableHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DayOfWeekHiveAdapter extends TypeAdapter<DayOfWeekHive> {
  @override
  final int typeId = 1;

  @override
  DayOfWeekHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayOfWeekHive(
      day: fields[0] as String,
      session: (fields[1] as List).cast<SessionHive>(),
    );
  }

  @override
  void write(BinaryWriter writer, DayOfWeekHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.session);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayOfWeekHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionHiveAdapter extends TypeAdapter<SessionHive> {
  @override
  final int typeId = 2;

  @override
  SessionHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionHive(
      id: fields[0] as String,
      isLab: fields[1] as bool,
      subjectName: fields[2] as String,
      facultyName: fields[3] as String,
      location: fields[4] as String,
      time: fields[5] as String,
      duration: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SessionHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isLab)
      ..writeByte(2)
      ..write(obj.subjectName)
      ..writeByte(3)
      ..write(obj.facultyName)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.time)
      ..writeByte(6)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
