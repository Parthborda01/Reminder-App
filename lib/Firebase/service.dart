import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  static Future tokenSave(List<String> timeTableName) async {

    String id = "";
    String token = "";

    token = await FirebaseMessaging.instance.getToken()?? "";

    if(Platform.isAndroid){
      id= await DeviceInfoPlugin().androidInfo.then((value) => value.id?? "");

    }else if(Platform.isIOS){
      id = await DeviceInfoPlugin().iosInfo.then((value) => value.identifierForVendor?? "");
    }

    if(id.isNotEmpty && token.isNotEmpty){
      DocumentReference reference = FirebaseFirestore.instance
          .collection("Tokens")
          .doc(id);
      try {
        await reference.set({"name": timeTableName.join(","),"token": token }).then((value) {
          print("FCM Token Saved ✅✅✅✅");
        });
      } on Exception catch (e) {
        return (e);
      }
    }

    //RKQ1.201004.002
    //

    //

  }


}
