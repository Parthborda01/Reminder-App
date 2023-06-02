import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';


class TaskLectureTiletemp extends StatefulWidget {
  const TaskLectureTiletemp({Key? key, required this.Lecture}) : super(key: key);

  final Lecture;

  @override
  State<TaskLectureTiletemp> createState() => _TaskLectureTiletempState();
}

class _TaskLectureTiletempState extends State<TaskLectureTiletemp> {
  bool notifier = true;

  @override
  Widget build(BuildContext context) {

    var DeviceWidth = MediaQuery.of(context).size.width;
    var DeviceHeight = MediaQuery.of(context).size.height;

    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 2, left: 10, right: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 0,
                ),
                if (widget.Lecture.subjectName.length > 10)
                  SizedBox(
                    height: 30,
                    width: 230,
                    child: Marquee(
                      scrollAxis: Axis.horizontal,
                      blankSpace: 20,
                      text: "${widget.Lecture.subjectName}",
                      velocity: 60,
                      // style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  )
                else
                  Text(
                    "${widget.Lecture.subjectName}",
                    // style: Theme.of(context).textTheme.headlineSmall,
                  ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "${widget.Lecture.facultyName}",
                  // style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  "${widget.Lecture.time}",
                  // style: Theme.of(context).textTheme.headlineSmall,
                )
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text(
                    widget.Lecture.location,
                    // style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Switch(
                  value: notifier,
                  inactiveTrackColor: Colors.transparent,
                  // trackOutlineColor: MaterialStateProperty.all<Color>((notifier ? Colors.lightBlueAccent : deadColor)),
                  inactiveThumbColor:
                  ((notifier ? Colors.lightBlueAccent : Colors.grey)),
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
}
