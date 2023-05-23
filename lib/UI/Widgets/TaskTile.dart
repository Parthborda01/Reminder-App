import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:student_dudes/UI/Theme/ThemeConstants.dart';

class TaskLectureTile extends StatefulWidget {
  const TaskLectureTile(
      {Key? key,
      required this.Lecture,
      required this.LectureTime,
      required this.LectureLocation})
      : super(key: key);

  final String Lecture;
  final String LectureTime;
  final String LectureLocation;

  @override
  State<TaskLectureTile> createState() => _TaskLectureTileState();
}

class _TaskLectureTileState extends State<TaskLectureTile> {
  bool notifier = true;

  @override
  Widget build(BuildContext context) {
    var DeviceWidth = MediaQuery.of(context).size.width;
    var DeviceHeight = MediaQuery.of(context).size.height;

    if (RegExp(r"\(|\)").hasMatch(widget.Lecture)) {
      List lecture = widget.Lecture.split(RegExp(r"\(|\)"));
      lecturename = lecture[0];
      lecturename = lecturename.replaceAll("\n", "");
      facultyname = lecture[1];
    } else {
      lecturename = "PWP";
      facultyname = "PVD";
    }
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Text(
                  lecturename,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  facultyname,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  widget.LectureTime,
                  style: Theme.of(context).textTheme.headlineSmall,
                )
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    widget.LectureLocation,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Switch(
                  value: notifier,
                  inactiveTrackColor: deadColor,
                  onChanged: (value) {
                    setState(() {
                      notifier = value;
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String lecturename = 'FREE';

  String facultyname = '';
}
