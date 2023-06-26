import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_dudes/Data/Model/Hive/timetables.dart';

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
    DateTime now = DateTime.now().add(const Duration(days: 2));
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


  static String getNameOfWeekDay(int day){
    return ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday","Sunday"][day -1];
  }

  static SessionHive? findNextSession(List<SessionHive> dateTimeList,DateTime abc) {

    // Sort the list of DateTime objects in ascending order
    dateTimeList.sort((a, b) {
      return convertToDateTime(convertToTimeOfDay(a.time),DateTime.now()).compareTo(convertToDateTime(convertToTimeOfDay(b.time),DateTime.now()));
    });

    // // Get the current DateTime
    // DateTime now = abc;

    // Iterate through the sorted list and find the first DateTime that is greater than the current DateTime
    for (SessionHive session in dateTimeList) {
      if (convertToDateTime(convertToTimeOfDay(session.time),abc).isAfter(DateTime.now()) && session.alert) {
        return session;
      }
    }

    // If no future DateTime is found, return null or handle the case as per your requirements
    return null;
  }
}