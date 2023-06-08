import 'dart:convert';

import 'lecturePositionModel.dart';

TimeTable timeTableFromJson(String str) => TimeTable.fromJson(json.decode(str));

String timeTableToJson(TimeTable data) => json.encode(data.toJson());

class TimeTable {
  String? classRoom;
  String? className;
  String? img;
  List<DayOfWeek>? weekDays;

  TimeTable({this.classRoom, this.className, this.weekDays});

  TimeTable.fromJson(Map<String, dynamic> json) {
    classRoom = json['classroom'];
    className = json['classname'];
    img = json['image'];
    weekDays =
        List<DayOfWeek>.from(json["days"].map((x) => DayOfWeek.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['classroom'] = classRoom;
    data['classname'] = className;
    data['image'] = img;
    if (weekDays != null) {
      data['days'] = List<dynamic>.from(weekDays!.map((x) => x.toJson()));
    }
    return data;
  }
}

class DayOfWeek {
  String? day;
  List<Session>? sessions;

  DayOfWeek({this.day, this.sessions});

  DayOfWeek.fromJson(Map<String, dynamic> json) {
    day = json['day'] ?? "";
    sessions =
        List<Session>.from(json["session"].map((x) => Session.fromJson(x)));
  }

  Map<String, dynamic> toJson() => {"day": day, "session": Session};
}

class Session {
  bool? isLab;
  String? id;
  String? subjectName;
  String? facultyName;
  String? location;
  String? time;
  int? duration;

  Session(
      {this.id,
      this.subjectName,
      this.isLab = false,
      this.facultyName,
      this.location,
      this.duration,
      this.time});

  Session.fromJson(Map<String, dynamic> json) {
    subjectName = json['subjectName'];
    isLab = json['isLab'];
    facultyName = json['facultyName'];
    location = json['location'];
    time = json['time'];
    duration = json['duration'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subjectName'] = subjectName;
    data['isLab'] = isLab;
    data['id'] = id;
    data['facultyName'] = facultyName;
    data['location'] = location;
    data['time'] = time;
    data['duration'] = duration;
    return data;
  }
}
