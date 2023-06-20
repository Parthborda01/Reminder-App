import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_dudes/Data/Model/Hive/timetables.dart';
import 'package:student_dudes/UI/Theme/theme_constants.dart';
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
              Text(session.subjectName,style: session.alert? Theme.of(context).textTheme.headlineLarge : Theme.of(context).textTheme.headlineLarge?.copyWith(color: deadColor)),
              Text(session.facultyName,style: session.alert? Theme.of(context).textTheme.headlineSmall : Theme.of(context).textTheme.headlineSmall?.copyWith(color: deadColor) ),
              Text(TimeUtil.calculatePeriod(session.time, session.duration),style: session.alert? Theme.of(context).textTheme.headlineSmall : Theme.of(context).textTheme.headlineSmall?.copyWith(color: deadColor) ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(session.location,style: session.alert? Theme.of(context).textTheme.headlineMedium : Theme.of(context).textTheme.headlineMedium?.copyWith(color: deadColor)),
              CupertinoSwitch(
                // applyTheme: true,
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