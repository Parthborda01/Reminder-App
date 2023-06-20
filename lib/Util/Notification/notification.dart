import 'package:flutter/material.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:student_dudes/Data/Model/time_table_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:student_dudes/Data/Model/time_table_model.dart';

@pragma('vm:entry-point')
Future<void> _onNotificationButtonPressed(NotificationResponse res) async {
  if (res.actionId == 'vibrate') {
    await SoundMode.setSoundMode(RingerModeStatus.vibrate);
  } else if (res.actionId == 'silent') {
    await SoundMode.setSoundMode(RingerModeStatus.silent);
  }
}

class LocalNotification {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialization() async {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );
    await _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: _onNotificationButtonPressed,
        onDidReceiveNotificationResponse: _onNotificationButtonPressed);
  }

  static void scheduleNotification(Session session, DateTime time) async {
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
            AndroidNotificationAction(
              "silent",
              "Mute",
            ),
            AndroidNotificationAction(
              "vibrate",
              "Vibrate",
            ),
          ],
        ),
      );

      DateTime a = DateTime(
        time.year,
        time.month,
        time.day,
        int.parse(session.time!.split(":").first) < 6
            ? int.parse(session.time!.split(":").first) + 12
            : int.parse(session.time!.split(":").first),
        int.parse(session.time!.split(":").last),
        0,
        0,
        0,
      );

      await _notificationsPlugin.zonedSchedule(
          int.parse(session.id!.split(" ").first.substring(10, session.id!.split(" ").first.length)),
          "${session.subjectName} (${session.facultyName})",
          "Your ${session.isLab! ? "Lab session" : "Lecture"} at ${session.location} in 10 minutes",
          tz.TZDateTime.from(a.subtract(const Duration(minutes: 10)), tz.local),
          notificationDetails,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          // ignore: deprecated_member_use
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime).then((value) {
            print("✅✅ Notification Assigned");
      });
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> clearAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
    } on Exception catch (e) {
      debugPrint("Error to clear notification: ${e.toString()}");
    }
  }

  static Future<void> clearNotificationByID(String id) async {
    try {
      await _notificationsPlugin.cancel(int.parse(id.split(" ").first.substring(10, id.split(" ").first.length)));
    } on Exception catch (e) {
      debugPrint("Error to clear notification: ${e.toString()}");
    }
  }

  static Future<bool> activeStatusById(String idString) async {
    int id = int.parse(idString.split(" ").first.substring(10, idString.split(" ").first.length));
    List<PendingNotificationRequest> notifications = await _notificationsPlugin.pendingNotificationRequests();
    return notifications.any((element) => element.id == id);
  }
}
