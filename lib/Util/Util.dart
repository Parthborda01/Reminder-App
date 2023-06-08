import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Util {

  static String calculatePeriod(String startTime, int duration) {
    final formatter = DateFormat('hh:mm');

    // Parse start time into DateTime object
    DateTime startDateTime = formatter.parse(startTime);

    // Add duration in hours to the start time
    DateTime endDateTime = startDateTime.add(Duration(hours: duration));

    // Format start and end times into the desired string format
    String startTimeString = formatter.format(startDateTime);
    String endTimeString = formatter.format(endDateTime);

    return '$startTimeString TO $endTimeString';
  }

  static TimeOfDay convertToTimeOfDay(String timeString) {

    String startTime = timeString;
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