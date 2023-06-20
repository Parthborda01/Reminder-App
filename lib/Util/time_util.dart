import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtil {

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
    int hours = h < 6 ? h+12 : h;
    int minutes = int.parse(timeValues[1]);
    return TimeOfDay(hour: hours, minute: minutes);
  }

  static DateTime convertToDateTime(TimeOfDay timeOfDay, DateTime date) {
    return DateTime(date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute);
  }


  // Custom comparison function to compare time strings
  static int compareTime(String time1, String time2) {

    // Function to parse time string and convert it to an integer value
    int parseTime(String time) {
      List<String> timeParts = time.split(':');
      int hours = int.parse(timeParts[0]);
      int minutes = int.parse(timeParts[1]);
      if (hours >= 1 && hours <= 6) {
        hours += 12;
      }
      return hours * 60 + minutes;
    }

    int parsedTime1 = parseTime(time1);
    int parsedTime2 = parseTime(time2);
    return parsedTime1.compareTo(parsedTime2);
  }

  static DateTime getLastMonday() {
    DateTime now = DateTime.now().add(Duration(days: 2));
    int weekday = now.weekday;
    int daysAgo = (weekday + 6) % 7; // Number of days ago from the current weekday to Monday
    DateTime lastMonday = now.subtract(Duration(days: daysAgo));
    return lastMonday;
  }

  static DateTime? getNextOccurrenceOfDay(String dayString) {
    DateTime now = DateTime.now(); // Get the current date and time
    DateTime? nextOccurrence;

    // Calculate the next occurrence of the given day
    for (int i = 1; i <= 7; i++) {
      DateTime date = now.add(Duration(days: i));
      if (DateFormat('EEEE').format(date) == dayString) {
        nextOccurrence = date;
        break;
      }
    }
    return nextOccurrence;
  }

}