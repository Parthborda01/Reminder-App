import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:student_dudes/Data/Model/time_table_model.dart';

class FirebaseServices {
  static Future addTimeTable(TimeTable timeTable) async {
    DocumentReference reference = FirebaseFirestore.instance
        .collection("TimeTables")
        .doc("${timeTable.semester} ${timeTable.department} ${timeTable.className}");

    try {
      await reference.set(timeTable.toJson()).then((value) {
        log("${timeTable.semester} ${timeTable.department} ${timeTable.className} <<------ Timetable Added");
      });
    } on Exception catch (e) {
      return (e);
    }
  }

  static Future addImageToFirebase(File image, String path) async {
    Reference reference = FirebaseStorage.instance.ref().child(path);
    TaskSnapshot value = await reference.putFile(image);
    log("Image Added Successfully ${value.storage}");
  }

  static Future<String> fireImage(String path) {
    Reference reference = FirebaseStorage.instance.ref().child(path);
    return reference.getDownloadURL();
  }

  static Stream<List<TimeTable>> getFirebaseData() {
    return FirebaseFirestore.instance
        .collection("TimeTables")
        .snapshots()
        .map((event) => event.docs.map((e) => TimeTable.fromJson(e.data())).toList());
  }

  static Future<List<TimeTable>> getFirebaseDataAsFuture() async {
    return (await FirebaseFirestore.instance
        .collection("TimeTables")
        .get()).docs.map((e) => TimeTable.fromJson(e.data())).toList();
  }

  static Future<void> removeTimeTable(String name) async {
    await FirebaseFirestore.instance.collection("TimeTables").doc(name).delete();
  }

  static Future tokenSave(List<String> timeTableName) async {
    String id = "";
    String token = "";

    token = await FirebaseMessaging.instance.getToken() ?? "";

    if (Platform.isAndroid) {
      id = await DeviceInfoPlugin().androidInfo.then((value) => value.id ?? "");
    } else if (Platform.isIOS) {
      id = await DeviceInfoPlugin().iosInfo.then((value) => value.identifierForVendor ?? "");
    }

    if (id.isNotEmpty && token.isNotEmpty) {
      DocumentReference reference = FirebaseFirestore.instance.collection("Tokens").doc(id);
      try {
        await reference.set({"name": timeTableName.join(","), "token": token});
      } on Exception catch (e) {
        return (e);
      }
    }
  }

  static Future<void> sendFCMMessage(String tableName, String title, String body) async {
    final a = await FirebaseFirestore.instance.collection("Tokens").get();
    List<Map> users = a.docs.map((e) => e.data()).toList();
    List<String> tokens = [];
    for (Map i in users) {
      List<String> classNames = i["name"].split(",");
      bool doesSend = false;
      for (String className in classNames) {
        if (className == tableName) {
          doesSend = true;
        }
      }
      if (doesSend) {
        tokens.add(i["token"]);
      }
    }
    String url = "https://fcm.googleapis.com/fcm/send";
    if (tokens.isNotEmpty) {
      final http.Response response = await http.post(Uri.parse(url),
          body: json.encode({
            "registration_ids": tokens,
            "notification": {"title": title, "body": body, "android_channel_id": "update", "sound": true},
            "data": {"title": title, "body": body}
          }),
          headers: {
            "Authorization":
                "key=AAAAFVwCx2o:APA91bEavlM95exfIM2uCkoMxJ3h76RcD6oiKOazlx0ob51LLmSnj1eM0gRaqMAHyvOylPfS3YGxl674oTlwVC3JsmQd7hyXTCx_IodkEpEgvAgThioSp9NPbFVUQPxlPeaPjBqOsYy-",
            "Content-Type": "application/json",
          });
      if (response.statusCode == 200) {
        log(response.body);
      } else {
        throw Exception("Error in API POST  ${response.statusCode}");
      }
    }
  }
}
