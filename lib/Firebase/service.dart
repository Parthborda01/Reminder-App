import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_dudes/Data/Model/time_table_model.dart';

class FirebaseServices {

  static Future addTimeTable(TimeTable timeTable) async {
    DocumentReference reference = FirebaseFirestore.instance
        .collection("TimeTables")
        .doc("${timeTable.semester} ${timeTable.department} ${timeTable.className}");

    try {
      await reference.set(timeTable.toJson()).then((value) {
        print("${timeTable.semester} ${timeTable.department} ${timeTable.className} <<------------ Added");
      });
    } on Exception catch (e) {
      return (e);
    }
  }
}
