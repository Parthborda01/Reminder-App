import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:pdfx/pdfx.dart';
import 'package:student_dudes/Data/Model/time_table_model.dart';
import 'package:student_dudes/UI/Theme/theme_constants.dart';
import 'package:student_dudes/Util/Cubits/Theme/ThemeManager.dart';
import 'package:student_dudes/Util/ImageHelper/PickHelper.dart';
import 'package:student_dudes/Util/time_util.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ConstructorDialogLecture extends StatefulWidget {
  const ConstructorDialogLecture({super.key, required this.lectureData, required this.onChanged, this.fileData, required this.dayOfWeek});

  final String dayOfWeek;
  final FileData? fileData;
  final Session lectureData;
  final Function(Session) onChanged;

  @override
  State<ConstructorDialogLecture> createState() => _ConstructorDialogLectureState();
}

class _ConstructorDialogLectureState extends State<ConstructorDialogLecture> {
  TextEditingController subjectNameController = TextEditingController();
  TextEditingController facultyNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  int numberOfHours = 0;
  String time = "";

  @override
  void initState() {
    subjectNameController.text = widget.lectureData.subjectName ?? "";
    facultyNameController.text = widget.lectureData.facultyName ?? "";
    locationController.text = widget.lectureData.location ?? "";
    numberOfHours = widget.lectureData.duration ?? 1;
    time = widget.lectureData.time ?? "";
    super.initState();
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("For ${widget.dayOfWeek}", style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height: 10),
                if (widget.fileData != null) ...{
                  AspectRatio(
                    aspectRatio: widget.fileData!.width / widget.fileData!.height,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BlocBuilder<ThemeCubit, ThemeModes>(
                        builder: (context, themeMode) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.black),
                              color: themeMode == ThemeModes.system
                                  ? MediaQuery.of(context).platformBrightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.white
                                  : themeMode == ThemeModes.light
                                      ? Colors.transparent
                                      : Theme.of(context).dividerColor,
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                              blendMode: themeMode == ThemeModes.system
                                  ? MediaQuery.of(context).platformBrightness == Brightness.dark
                                      ? BlendMode.difference
                                      : BlendMode.darken
                                  : themeMode == ThemeModes.light
                                      ? BlendMode.multiply
                                      : BlendMode.darken,
                              child: PhotoView(
                                filterQuality: FilterQuality.high,
                                minScale: PhotoViewComputedScale.contained * 1.1,
                                maxScale: PhotoViewComputedScale.contained * 2.2,
                                backgroundDecoration: const BoxDecoration(color: Colors.white),
                                imageProvider: FileImage(widget.fileData!.imageFile),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                },
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Required";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.subject, color: Theme.of(context).textTheme.titleLarge?.color),
                                  label: const Text(
                                    "Subject",
                                    style: TextStyle(letterSpacing: 1),
                                  )),
                              controller: subjectNameController,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.toString().trim().isEmpty) {
                                  return "Required";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person_outline_rounded, color: Theme.of(context).textTheme.titleLarge?.color),
                                  label: const Text(
                                    "Faculty",
                                    style: TextStyle(letterSpacing: 1),
                                  )),
                              controller: facultyNameController,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.location_pin, color: Theme.of(context).textTheme.titleLarge?.color),
                              label: const Text(
                                "Location",
                                style: TextStyle(letterSpacing: 1),
                              )),
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
                            time: TimeUtil.convertToDateTime(TimeUtil.convertToTimeOfDay(time), DateTime.now()),
                            onTimeChange: (p0) {
                              time = DateFormat("hh:mm").format(p0);
                              setState(() {});
                            },
                          ),
                          Column(
                            children: [
                              Text("Hours⏱️", style: Theme.of(context).textTheme.labelLarge),
                              ToggleSwitch(
                                isVertical: true,
                                labels: const ["One", "Two"],
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
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
                            child: Text("Cancel", style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_key.currentState!.validate()) {
                                widget.onChanged(Session(
                                    id: widget.lectureData.id,
                                    facultyName: facultyNameController.text,
                                    location: locationController.text,
                                    subjectName: subjectNameController.text,
                                    duration: numberOfHours,
                                    time: time));
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text("Save", style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
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
      ),
    );
  }
}
