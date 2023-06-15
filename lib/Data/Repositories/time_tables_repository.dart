
import 'package:hive/hive.dart';
import 'package:student_dudes/Data/Model/Hive/timetables.dart';


class TimeTablesRepository {

  final Box<TimeTableHive> _timeTableBox = Hive.box<TimeTableHive>('time_tables');

  Future<void> storeTimeTable(TimeTableHive classroom) async {
    final box = await Hive.openBox<TimeTableHive>('time_tables');
    await box.add(classroom);
  }

  List<TimeTableHive> getAllTimeTables() {
    return _timeTableBox.values.toList();
  }

  TimeTableHive getATimeTable(int index) {
    return _timeTableBox.getAt(index)!;
  }

  Future<void> updateTimeTable(int index, TimeTableHive updatedClassroom) async {
    await _timeTableBox.putAt(index, updatedClassroom);
  }

  Future<void> deleteTimeTable(int index) async {
    await _timeTableBox.deleteAt(index);
  }

  Future<void> closeBox() async {
    await _timeTableBox.close();
  }

}
