import 'package:flutter/material.dart';
import 'package:student_dudes/Data/Model/time_table_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:student_dudes/Data/Model/time_table_model.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialization() async {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("ic_launcher"),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );
    await _notificationsPlugin.initialize(initializationSettings);
  }

  static void show(Session session, DateTime day) async {
    try {
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            "notification",
            "notification channel",
            category: AndroidNotificationCategory.alarm,
            channelDescription: "description",
            importance: Importance.max,
            priority: Priority.max,
            actions: <AndroidNotificationAction>[
              AndroidNotificationAction("1", "Mute", cancelNotification: true,
              ),
            ]),
      );

      DateTime a = DateTime(
          day.year,
          day.month,
          day.day,
          int.parse(session.time!.split(":").first) < 6
              ? int.parse(session.time!.split(":").first) + 12
              : int.parse(session.time!.split(":").first),
          int.parse(session.time!.split(":").last),
          0,
          0,
          0,
      );

      await _notificationsPlugin
          .zonedSchedule(
              int.parse(session.id!.split(" ").first.substring(10, session.id!.split(" ").first.length)),
              "${session.subjectName}",
              "Your ${session.isLab! ? "Lab session" : "Lecture"} at ${session.location} in 15 minutes",
              tz.TZDateTime.from(a, tz.local),
              notificationDetails,
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              // ignore: deprecated_member_use
              androidAllowWhileIdle: true,
              matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime)
          .then((value) {
      });
      // print(a);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }
}
