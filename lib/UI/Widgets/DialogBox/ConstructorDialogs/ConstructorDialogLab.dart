import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:pdfx/pdfx.dart';
import 'package:student_dudes/Data/Model/timeTableModel.dart';
import 'package:student_dudes/UI/Theme/ThemeConstants.dart';
import 'package:student_dudes/UI/Widgets/Helper/ExpandablePageView.dart';
import 'package:student_dudes/Util/Cubits/Theme/ThemeManager.dart';
import 'package:student_dudes/Util/ImageHelper/PickHelper.dart';
import 'package:student_dudes/Util/Util.dart';
import 'package:student_dudes/Util/LabSessionHelper.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ConstructorDialogLab extends StatefulWidget {
  const ConstructorDialogLab({super.key, required this.labData, required this.onChanged,required this.fileData});
  final Function(Session) onChanged;
  final Session? labData;
  final FileData fileData;
  @override
  State<ConstructorDialogLab> createState() => _ConstructorDialogLabState();
}

class _ConstructorDialogLabState extends State<ConstructorDialogLab> {
  List<Session> data = [];
  int numberOfHours = 0;
  late int selectedPage;

  @override
  void initState() {
    selectedPage = 0;
    numberOfHours = widget.labData?.duration ?? 1;
    data = LabUtils.labToSessions(widget.labData!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: widget.fileData!.width / widget.fileData!.height,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),

                  child: BlocBuilder<ThemeCubit, ThemeModes>(
                    builder: (context, ThemeMode) {
                      return Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),border: Border.all(color: Colors.black),color: ThemeMode == ThemeModes.system
                            ? MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                            ? Colors.white
                            : Colors.white
                            : ThemeMode == ThemeModes.light
                            ? Colors.transparent
                            : Theme.of(context).dividerColor,),

                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          blendMode: ThemeMode == ThemeModes.system
                              ? MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                              ? BlendMode.difference
                              : BlendMode.darken
                              : ThemeMode == ThemeModes.light
                              ? BlendMode.multiply
                              : BlendMode.darken,
                          child: PhotoView(
                            filterQuality: FilterQuality.high,
                            minScale: PhotoViewComputedScale.contained * 1.1,
                            maxScale: PhotoViewComputedScale.contained * 2.2,
                            backgroundDecoration: BoxDecoration(
                                color: Colors.white),
                            imageProvider:
                            FileImage(widget.fileData!.imageFile),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TimePickerSpinner(
                    highlightedTextStyle:
                        Theme.of(context).textTheme.headlineLarge,
                    normalTextStyle: Theme.of(context).textTheme.bodySmall,
                    spacing: 20,
                    itemHeight: 40,
                    is24HourMode: false,
                    isForce2Digits: true,
                    minutesInterval: 15,
                    time: Util.convertToDateTime(Util.convertToTimeOfDay(widget.labData?.time ?? ""), DateTime.now()),
                  ),
                  Column(
                    children: [
                      Text("Hours⏱️",
                          style: Theme.of(context).textTheme.labelLarge),
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
                  for (Session i in data) ...{
                    editFields(i),
                  }
                ],
              ),
              PageViewDotIndicator(
                currentItem: selectedPage,
                count: data.length,
                unselectedColor: deadColor,
                selectedColor: Theme.of(context).textTheme.titleMedium?.color ??
                    Colors.transparent,
                duration: const Duration(milliseconds: 200),
                unselectedSize: const Size(5, 5),
                size: const Size(8, 8),
                fadeEdges: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          fixedSize: MaterialStatePropertyAll(
                              Size.fromWidth(deviceWidth * 0.35)
                          ),
                          overlayColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.focused)) {
                                  return Colors.transparent;
                                }
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.transparent;
                                }
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.transparent;
                                }
                                return Colors.transparent; // Defer to the widget's default.
                              }),
                        ),
                        child: Text("Cancel",
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          widget.onChanged(Session(
                            id: widget.labData!.id,
                              isLab: true,
                              subjectName: LabUtils.labDataToString(data),
                              duration: numberOfHours,
                              location: widget.labData?.location,
                              facultyName: widget.labData?.facultyName,
                              time: widget.labData?.time));
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          fixedSize: MaterialStatePropertyAll(
                            Size.fromWidth(deviceWidth * 0.35)
                          )
                        ),
                        child: Text("Save",
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center),
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

  Widget editFields(Session labInfo) {
    TextEditingController batchNameController =
        TextEditingController(text: labInfo.time);
    TextEditingController subjectNameController =
        TextEditingController(text: labInfo.subjectName);
    TextEditingController locationController =
        TextEditingController(text: labInfo.location);
    TextEditingController facultyNameController =
        TextEditingController(text: labInfo.facultyName);

    batchNameController.selection = TextSelection.fromPosition(TextPosition(offset: batchNameController.text.length));
    subjectNameController.selection = TextSelection.fromPosition(TextPosition(offset: subjectNameController.text.length));
    locationController.selection = TextSelection.fromPosition(TextPosition(offset: locationController.text.length));
    facultyNameController.selection = TextSelection.fromPosition(TextPosition(offset: facultyNameController.text.length));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: batchNameController,
                  onChanged: (a) {
                    labInfo.time = a;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.people_alt_rounded,color: Theme.of(context).textTheme.titleLarge?.color),
                      label: const Text("Batch")),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: TextField(
                controller: subjectNameController,
                onChanged: (a) {
                  labInfo.subjectName = a;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.subject,color: Theme.of(context).textTheme.titleLarge?.color), label: const Text("Subject")),
                style: Theme.of(context).textTheme.headlineMedium,
              )),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: locationController,
                onChanged: (a) {
                  labInfo.location = a;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_pin,color: Theme.of(context).textTheme.titleLarge?.color),
                    label:
                        const Text("Location", style: TextStyle(letterSpacing: 1))),
                style: Theme.of(context).textTheme.headlineMedium,
              )),
              const SizedBox(width: 10),
              Expanded(
                  child: TextField(
                controller: facultyNameController,
                onChanged: (a) {
                  labInfo.facultyName = a;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_rounded,color: Theme.of(context).textTheme.titleLarge?.color),
                    label: const Text("Faculty")),
                style: Theme.of(context).textTheme.headlineMedium,
              )),
            ],
          ),
        ],
      ),
    );
  }
}
