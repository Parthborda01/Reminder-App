import 'package:flutter/material.dart';

class Util {

  static int setNumberOfHours(String timeString) {

    DateTime parseTime(String timeString) {
      List<String> timeParts = timeString.split(':');
      int hours = int.parse(timeParts[0]);
      int minutes = int.parse(timeParts[1]);
      DateTime now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hours, minutes);
    }

    List<String> times = timeString.split(' to ');
    DateTime startTime = parseTime(times[0]);
    DateTime endTime = parseTime(times[1]);
    Duration duration = endTime.difference(startTime);
    if(duration == const Duration(hours: 1)){
      return 1;
    }
    else{
      return 2;
    }
  }

  static TimeOfDay convertToTimeOfDay(String timeString) {
    List<String> timeParts = timeString.split(' to ');
    String startTime = timeParts[0];
    List<String> timeValues = startTime.split(':');


    int h = int.parse(timeValues[0]);
    int hours = h < 6? h+12 : h;
    int minutes = int.parse(timeValues[1]);
    return TimeOfDay(hour: hours, minute: minutes);
  }

  static DateTime convertToDateTime(TimeOfDay timeOfDay, DateTime date) {
    return DateTime(date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute);
  }
}