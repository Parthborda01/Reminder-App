import 'dart:async';

import 'package:flutter/material.dart';
import 'package:student_dudes/Data/Model/Hive/timetables.dart';

class RemainingTimeScreen extends StatefulWidget {
  final Map? getNext;

  const RemainingTimeScreen({super.key, this.getNext});

  @override
  State<RemainingTimeScreen> createState() => _RemainingTimeScreenState();
}

class _RemainingTimeScreenState extends State<RemainingTimeScreen> {
  Timer? timer;
  Duration _remainingTime= const Duration();
  @override
  void initState() {
    super.initState();
      if (widget.getNext != null) {
        _remainingTime = widget.getNext!["time"].difference(DateTime.now());
        _startTimer();
      }
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() {
        _remainingTime = widget.getNext!["time"].difference(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  String _formatTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    final hoursText = hours > 0 ? '$hours hour${hours > 1 ? 's' : ''}' : '';
    final minutesText = minutes > 0 ? '$minutes minute${minutes > 1 ? 's' : ''}' : '';

    if (hoursText.isNotEmpty && minutesText.isNotEmpty) {
      return 'in $hoursText $minutesText';
    } else if (hoursText.isNotEmpty) {
      return 'in $hoursText';
    } else if (minutesText.isNotEmpty) {
      return 'in $minutesText';
    } else {
      return 'now';
    }
  }

  @override
  Widget build(BuildContext context) {
    SessionHive session = widget.getNext?["session"];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.getNext != null? "${session.isLab? "Lab": "Lecture"} ${_formatTime(_remainingTime)}": "Reminder",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 1),
            textAlign: TextAlign.center,
          ),
          Text(
            widget.getNext != null? "${session.subjectName}, ${session.facultyName}, ${session.location}" : "Subject",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}