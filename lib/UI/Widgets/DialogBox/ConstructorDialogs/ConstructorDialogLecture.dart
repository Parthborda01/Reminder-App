import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:student_dudes/Data/Model/timeTableModel.dart';
import 'package:student_dudes/UI/Theme/ThemeConstants.dart';
import 'package:student_dudes/Util/Util.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ConstructorDialogLecture extends StatefulWidget {
  const ConstructorDialogLecture({super.key, required this.lectureData});

  final Session lectureData;

  @override
  State<ConstructorDialogLecture> createState() =>
      _ConstructorDialogLectureState();
}

class _ConstructorDialogLectureState extends State<ConstructorDialogLecture> {

  TextEditingController subjectNameController = TextEditingController();
  TextEditingController facultyNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  int numberOfHours = 0;

  @override
  void initState() {
    subjectNameController.text = widget.lectureData.subjectName ?? "";
    facultyNameController.text = widget.lectureData.facultyName ?? "";
    locationController.text = widget.lectureData.location ?? "";
    numberOfHours = Util.setNumberOfHours(widget.lectureData.time??"");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          prefixIcon:Icon(Icons.subject),
                            label: Text("Subject")
                        ),
                        controller: subjectNameController,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                            prefixIcon:Icon(Icons.person_outline_rounded),
                            label: Text("Faculty")
                        ),
                        controller: facultyNameController,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_pin),
                        label: Text("Location")
                    ),
                    controller: locationController,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TimePickerSpinner(
                      highlightedTextStyle: Theme.of(context).textTheme.headlineLarge,
                      normalTextStyle: Theme.of(context).textTheme.bodySmall,
                      spacing: 20,
                      itemHeight: 40,
                      is24HourMode: false,
                      isForce2Digits: true,
                      minutesInterval: 15,
                      time: Util.convertToDateTime(Util.convertToTimeOfDay(widget.lectureData.time??""), DateTime.now()),
                    ),
                    Column(
                      children: [
                        Text("Hours⏱️",style: Theme.of(context).textTheme.labelLarge),
                        ToggleSwitch(
                          isVertical: true,
                          labels: const ["One", "Twice"],
                          initialLabelIndex: numberOfHours - 1,
                          totalSwitches: 2,
                          activeBgColor: [deadColor],
                          cornerRadius: 15,
                          inactiveBgColor: Colors.transparent,
                          inactiveFgColor: deadColor,
                          animate: true,
                          animationDuration: 200,
                          onToggle: (index) {
                            numberOfHours = index! + 1;
                            if(numberOfHours == 2){
                              //TODO: set time string to 2 Hours
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                          child: Container(
                            width: deviceWidth * 0.35,
                            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text("Cancel",style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        InkWell(
                          child: Container(
                            width: deviceWidth * 0.35,
                            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                            decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                                borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text("Save",style: Theme.of(context).textTheme.bodyMedium ,textAlign: TextAlign.center),
                          ),
                          onTap: () {

                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
