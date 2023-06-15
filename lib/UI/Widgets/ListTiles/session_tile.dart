import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_dudes/Data/Model/Hive/timetables.dart';
import 'package:student_dudes/Util/time_util.dart';

class SessionTile {

  static Widget sessionTile({context,required SessionHive session,required bool switchValue,required Function(bool) onChange}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      color: Theme.of(context).colorScheme.background,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(session.subjectName,style: Theme.of(context).textTheme.headlineLarge),
              Text(session.facultyName,style: Theme.of(context).textTheme.headlineSmall),
              Text(TimeUtil.calculatePeriod(session.time, session.duration),style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(session.location,style: Theme.of(context).textTheme.headlineMedium),
              CupertinoSwitch(
                  value: switchValue,
                  onChanged: onChange
              )
            ],
          )
        ],
      ),
    );
  }
}