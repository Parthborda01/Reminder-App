import 'package:student_dudes/Data/Model/Hive/timetables.dart';
import 'package:student_dudes/Data/Model/time_table_model.dart';

class ModelConverter {
  static TimeTableHive convertToHive(TimeTable timetable,bool isSelected) {
    return TimeTableHive(
      isSelected: isSelected,
      classroom: timetable.classRoom ?? '',
      id: timetable.id ?? '',
      classname: timetable.className ?? '',
      department: timetable.department ?? '',
      semester: timetable.semester ?? 0,
      createdTime: timetable.createdTime ?? '',
      image: timetable.image,
      days: timetable.weekDays?.map((dayOfWeek) {
        return DayOfWeekHive(
          day: dayOfWeek.day ?? '',
          session: dayOfWeek.sessions?.map((session) {
            return SessionHive(
              id: session.id ?? '',
              isLab: session.isLab ?? false,
              subjectName: session.subjectName ?? '',
              facultyName: session.facultyName ?? '',
              location: session.location ?? '',
              time: session.time ?? '',
              duration: session.duration ?? 0,
            );
          }).toList() ?? [],
        );
      }).toList() ?? [],
    );
  }

  static TimeTable convertToPODO(TimeTableHive timetableHive) {
    return TimeTable(
      classRoom: timetableHive.classroom,
      className: timetableHive.classname,
      department: timetableHive.department,
      semester: timetableHive.semester,
      createdTime: timetableHive.createdTime,
      image: timetableHive.image,
      weekDays: timetableHive.days.map((dayOfWeekHive) {
        return DayOfWeek(
          day: dayOfWeekHive.day,
          sessions: dayOfWeekHive.session.map((sessionHive) {
            return Session(
              id: sessionHive.id,
              isLab: sessionHive.isLab,
              subjectName: sessionHive.subjectName,
              facultyName: sessionHive.facultyName,
              location: sessionHive.location,
              time: sessionHive.time,
              duration: sessionHive.duration,
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
