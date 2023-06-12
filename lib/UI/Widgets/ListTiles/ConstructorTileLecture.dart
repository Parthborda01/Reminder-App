import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:student_dudes/Data/Model/time_table_model.dart';
import 'package:student_dudes/Util/time_util.dart';

class ConstructorTileLecture extends StatefulWidget {
  const ConstructorTileLecture({super.key, required this.lectureData, required this.isSelected, required this.numberOfEmpty});
  final bool isSelected;
  final Session lectureData;
  final int numberOfEmpty;
  @override
  State<ConstructorTileLecture> createState() => _ConstructorTileLectureState();
}

class _ConstructorTileLectureState extends State<ConstructorTileLecture> {

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 20, left: 10,right: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
              color: widget.isSelected
                  ? Colors.blue.withOpacity(0.8)
                  : widget.numberOfEmpty > 0 ? Colors.amber
                  : Colors.transparent)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (widget.lectureData.subjectName!.length > 10)
                    SizedBox(
                      height: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .fontSize! + 8,
                      child: Marquee(
                        scrollAxis: Axis.horizontal,
                        blankSpace: 30,
                        text: widget.lectureData.subjectName != null &&
                                widget.lectureData.subjectName!
                                    .trim()
                                    .isNotEmpty
                            ? widget.lectureData.subjectName!
                            : "⚠️⚠️⚠️",
                        velocity: 50,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    )
                  else
                    Text(
                      widget.lectureData.subjectName != null &&
                              widget.lectureData.subjectName!
                                  .trim()
                                  .isNotEmpty
                          ? widget.lectureData.subjectName!
                          : "⚠️⚠️⚠️",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  const SizedBox(height: 2),
                  Text(
                    widget.lectureData.time != null &&

                            widget.lectureData.time!.trim().isNotEmpty
                        ? TimeUtil.calculatePeriod(widget.lectureData.time!, widget.lectureData.duration!)
                        : "⚠️⚠️⚠️",
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                ],
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      widget.lectureData.location != null &&
                              widget.lectureData.location!.trim().isNotEmpty
                          ? widget.lectureData.location!
                          : "⚠️⚠️⚠️",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Text(
                    widget.lectureData.facultyName != null &&
                        widget.lectureData.facultyName!.trim().isNotEmpty
                        ? widget.lectureData.facultyName!
                        : "⚠️⚠️⚠️",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
