import 'package:hive/hive.dart';

part 'timetables.g.dart';

@HiveType(typeId: 0)
class TimeTableHive extends HiveObject {
  @HiveField(0)
  late String classroom;

  @HiveField(1)
  late String classname;

  @HiveField(2)
  late String department;

  @HiveField(3)
  late int semester;

  @HiveField(4)
  late String createdTime;

  @HiveField(5)
  late String? image;

  @HiveField(6)
  late List<DayOfWeekHive> days;

  @HiveField(7)
  late String id;

  @HiveField(8)
  late bool isSelected;

  TimeTableHive({
    required this.classroom,
    required this.classname,
    required this.department,
    required this.semester,
    required this.createdTime,
    this.image,
    required this.days,
    required this.id,
    required this.isSelected
  });
}

@HiveType(typeId: 1)
class DayOfWeekHive extends HiveObject {
  @HiveField(0)
  String day;

  @HiveField(1)
  List<SessionHive> session;

  DayOfWeekHive({
    required this.day,
    required this.session,
  });
}

@HiveType(typeId: 2)
class SessionHive extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  bool isLab;

  @HiveField(2)
  String subjectName;

  @HiveField(3)
  String facultyName;

  @HiveField(4)
  String location;

  @HiveField(5)
  String time;

  @HiveField(6)
  int duration;

  SessionHive({
    required this.id,
    required this.isLab,
    required this.subjectName,
    required this.facultyName,
    required this.location,
    required this.time,
    required this.duration,
  });
}
