import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  static Future addImageToFirebase(File image,String path) async {

    Reference reference = FirebaseStorage.instance.ref().child(path);
    TaskSnapshot value = await reference.putFile(image);
    print("Image Added Successfully ${value.storage}");
  }

  static Future<String> fireImage(String path) {
    Reference reference = FirebaseStorage.instance.ref().child(path);

    return reference.getDownloadURL();
  }

  static Stream<List<TimeTable>> getFirebaseData() {
    return FirebaseFirestore.instance.collection("TimeTables").snapshots().map((event) => event.docs.map((e) => TimeTable.fromJson(e.data())).toList());
  }

}
