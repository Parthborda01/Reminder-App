import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:student_dudes/Data/Model/timeTableModel.dart';
import 'package:student_dudes/UI/Theme/ThemeConstants.dart';
import 'package:student_dudes/UI/Widgets/Helper/ExpandablePageView.dart';
import 'package:student_dudes/Util/Util.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ConstructorDialogLab extends StatefulWidget {
  const ConstructorDialogLab({super.key, required this.labData});

  final List<LabSession> labData;

  @override
  State<ConstructorDialogLab> createState() => _ConstructorDialogLabState();
}

class _ConstructorDialogLabState extends State<ConstructorDialogLab> {
  int numberOfHours = 0;
  late int selectedPage;
  @override
  void initState() {
    selectedPage = 0;
    numberOfHours = Util.setNumberOfHours(widget.labData[0].time??"");

    for(LabSession batchName in widget.labData){
      print(batchName.batchName);
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 4,sigmaX: 4),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                    time: Util.convertToDateTime(Util.convertToTimeOfDay(widget.labData[0].time??""), DateTime.now()),
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
              ExpandablePageView(
                onPageChanged: (page) {
                  setState(() {
                    selectedPage = page;
                  });
                },
                children: [
                  for(LabSession labSession in widget.labData)...{
                    editFields(labSession),
                  }
              ],),
              PageViewDotIndicator(
                  currentItem: selectedPage,
                  count: widget.labData.length,
                  unselectedColor: deadColor,
                  selectedColor: Theme.of(context).textTheme.titleMedium?.color?? Colors.transparent,
                  duration: const Duration(milliseconds: 200),
                  unselectedSize: const Size(5, 5),
                  size: const Size(8,8),
                  fadeEdges: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
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
                      )
                    ],
                  ),
                ),
              )
              ],
          ),
          ),
        ),
      );
  }

  Widget editFields(LabSession labInfo) {
    TextEditingController batchNameController = TextEditingController(text: labInfo.batchName);
    TextEditingController subjectNameController = TextEditingController(text: labInfo.subjectName);
    TextEditingController locationController = TextEditingController(text: labInfo.location);
    TextEditingController facultyNameController = TextEditingController(text: labInfo.facultyName);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: batchNameController,
                  decoration: const InputDecoration(
                      prefixIcon:Icon(Icons.people_alt_rounded),
                      label: Text("Batch")
                  ),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: TextField(
                controller: subjectNameController,
                decoration: const InputDecoration(
                    prefixIcon:Icon(Icons.subject),
                    label: Text("Subject")
                ),
                style: Theme.of(context).textTheme.headlineMedium,
              )
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                        prefixIcon:Icon(Icons.location_pin),
                        label: Text("Location",style: TextStyle(letterSpacing: 3))
                    ),
                    style: Theme.of(context).textTheme.headlineMedium,
                  )
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: TextField(
                    controller: facultyNameController,
                    decoration: const InputDecoration(
                        prefixIcon:Icon(Icons.location_pin),
                        label: Text("Faculty")
                    ),
                    style: Theme.of(context).textTheme.headlineMedium,
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }
}
