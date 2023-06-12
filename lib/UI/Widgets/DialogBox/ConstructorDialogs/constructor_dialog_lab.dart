import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:pdfx/pdfx.dart';
import 'package:student_dudes/Data/Model/time_table_model.dart';
import 'package:student_dudes/UI/Theme/theme_constants.dart';
import 'package:student_dudes/Util/Cubits/Theme/ThemeManager.dart';
import 'package:student_dudes/Util/ImageHelper/PickHelper.dart';
import 'package:student_dudes/Util/time_util.dart';
import 'package:student_dudes/Util/lab_session_util.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ConstructorDialogLab extends StatefulWidget {
  const ConstructorDialogLab(
      {super.key,
      this.labData,
      required this.onChanged,
      required this.fileData, required this.dayOfWeek});

  final String dayOfWeek;
  final Function(Session) onChanged;
  final Session? labData;
  final FileData fileData;

  @override
  State<ConstructorDialogLab> createState() => _ConstructorDialogLabState();
}

class _ConstructorDialogLabState extends State<ConstructorDialogLab> {
  List<Session> data = [];
  int numberOfHours = 0;
  int selectedPage = 0;
  int errorPage = 0;
  String time = "";

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  PageController controller = PageController();

  @override
  void initState() {
    selectedPage = 0;
    numberOfHours = widget.labData?.duration ?? 1;
    if (widget.labData != null) {
      data = LabUtils.labToSessions(widget.labData!);
    } else {
      data.add(Session());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("For ${widget.dayOfWeek}",style: Theme.of(context).textTheme.headlineMedium,textAlign: TextAlign.center),
                const SizedBox(
                  height: 10,
                ),
                AspectRatio(
                  aspectRatio: widget.fileData.width / widget.fileData.height,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BlocBuilder<ThemeCubit, ThemeModes>(
                      builder: (context, themeMode) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.black),
                            color: themeMode == ThemeModes.system
                                ? MediaQuery.of(context).platformBrightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.white
                                : themeMode == ThemeModes.light
                                    ? Colors.transparent
                                    : Theme.of(context).dividerColor,
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                            blendMode: themeMode == ThemeModes.system
                                ? MediaQuery.of(context).platformBrightness ==
                                        Brightness.dark
                                    ? BlendMode.difference
                                    : BlendMode.darken
                                : themeMode == ThemeModes.light
                                    ? BlendMode.multiply
                                    : BlendMode.darken,
                            child: PhotoView(
                              filterQuality: FilterQuality.high,
                              minScale: PhotoViewComputedScale.contained * 1.1,
                              maxScale: PhotoViewComputedScale.contained * 2.2,
                              backgroundDecoration:
                                  const BoxDecoration(color: Colors.white),
                              imageProvider:
                                  FileImage(widget.fileData.imageFile),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TimePickerSpinner(
                      onTimeChange: (p0) {
                        time = DateFormat("hh:mm").format(p0);
                        setState(() {});
                      },
                      highlightedTextStyle:
                          Theme.of(context).textTheme.headlineLarge,
                      normalTextStyle: Theme.of(context).textTheme.bodySmall,
                      spacing: 20,
                      itemHeight: 40,
                      is24HourMode: false,
                      isForce2Digits: true,
                      minutesInterval: 15,
                      time: widget.labData?.time != null
                          ? TimeUtil.convertToDateTime(
                              TimeUtil.convertToTimeOfDay(
                                  widget.labData?.time ?? ""),
                              DateTime.now())
                          : DateTime.now(),
                    ),
                    Column(
                      children: [
                        Text("Hours⏱️",
                            style: Theme.of(context).textTheme.labelLarge),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: data.length > 1
                            ? () {
                                controller.animateToPage(selectedPage,
                                    duration: Duration(
                                        milliseconds:
                                            (selectedPage - data.length).abs() *
                                                100),
                                    curve: Curves.easeInOutCubic);
                                data.removeAt(selectedPage);
                                setState(() {});
                              }
                            : null,
                        icon: const Icon(Icons.delete_outline_rounded)),
                    IconButton(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            data.add(Session());
                            controller.animateToPage(data.length - 1,
                                duration: Duration(
                                    milliseconds:
                                        (selectedPage - data.length).abs() *
                                            100),
                                curve: Curves.easeInOutCubic);
                          } else {
                            controller.animateToPage(errorPage,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.easeInOutCubic);
                          }
                          setState(() {});
                        },
                        icon: const Icon(Icons.add)),
                  ],
                ),
                SizedBox(
                  height: 210,
                  child: Form(
                    key: _key,
                    child: PageView(
                      controller: controller,
                      onPageChanged: (page) {
                        setState(() {
                          selectedPage = page;
                        });
                        if (!_key.currentState!.validate()) {
                          controller.animateToPage(errorPage,
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOutCubic);
                        }
                      },
                      children: [
                        for (int i = 0; i < data.length; i++) ...{
                          editFields(data[i], i),
                        }
                      ],
                    ),
                  ),
                ),
                PageViewDotIndicator(
                  currentItem: selectedPage,
                  count: data.length,
                  unselectedColor: deadColor,
                  selectedColor:
                      Theme.of(context).textTheme.titleMedium?.color ??
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
                        Expanded(
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color>(
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
                                return Colors
                                    .transparent; // Defer to the widget's default.
                              }),
                            ),
                            child: Text("Cancel",
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_key.currentState!.validate()) {
                                if (widget.labData != null) {
                                  widget.onChanged(Session(
                                      id: widget.labData!.id,
                                      isLab: true,
                                      subjectName:
                                          LabUtils.labDataToString(data),
                                      duration: numberOfHours,
                                      location: widget.labData?.location,
                                      facultyName: widget.labData?.facultyName,
                                      time: time));
                                } else {
                                  widget.onChanged(Session(
                                      id: DateTime.now()
                                          .microsecondsSinceEpoch
                                          .toString(),
                                      isLab: true,
                                      subjectName:
                                          LabUtils.labDataToString(data),
                                      duration: numberOfHours,
                                      location: "unused",
                                      facultyName: "unused",
                                      time: time));
                                }
                                Navigator.of(context).pop();
                              } else {
                                controller.animateToPage(errorPage,
                                    duration: Duration(
                                        milliseconds:
                                            (selectedPage - errorPage).abs() *
                                                100),
                                    curve: Curves.easeInOutCubic);
                              }
                            },
                            child: Text("Save",
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center),
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

  Widget editFields(Session labInfo, int page) {
    TextEditingController batchNameController =
        TextEditingController(text: labInfo.time ?? "");
    TextEditingController subjectNameController =
        TextEditingController(text: labInfo.subjectName ?? "");
    TextEditingController locationController =
        TextEditingController(text: labInfo.location ?? "");
    TextEditingController facultyNameController =
        TextEditingController(text: labInfo.facultyName ?? "");

    batchNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: batchNameController.text.length));
    subjectNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: subjectNameController.text.length));
    locationController.selection = TextSelection.fromPosition(
        TextPosition(offset: locationController.text.length));
    facultyNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: facultyNameController.text.length));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (!(value != null && value.trim().isNotEmpty)) {
                      errorPage = page;
                      return "Required!";
                    } else {
                      if (!RegExp(r"[A-Z]\d+$").hasMatch(value.trim())) {
                        errorPage = page;
                        return "Invalid!";
                      }
                      return null;
                    }
                  },
                  controller: batchNameController,
                  onChanged: (a) {
                    labInfo.time = a;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.people_alt_rounded,
                          color: Theme.of(context).textTheme.titleLarge?.color),
                      label: const Text("Batch",
                          style: TextStyle(letterSpacing: 1))),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (!(value != null && value.trim().isNotEmpty)) {
                    errorPage = page;
                    return "Required!";
                  } else {
                    return null;
                  }
                },
                controller: subjectNameController,
                onChanged: (a) {
                  labInfo.subjectName = a;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.subject,
                        color: Theme.of(context).textTheme.titleLarge?.color),
                    label: const Text("Subject",
                        style: TextStyle(letterSpacing: 1))),
                style: Theme.of(context).textTheme.headlineMedium,
              )),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (!(value != null && value.trim().isNotEmpty)) {
                    errorPage = page;
                    return "Required!";
                  } else {
                    return null;
                  }
                },
                controller: locationController,
                onChanged: (a) {
                  labInfo.location = a;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_pin,
                        color: Theme.of(context).textTheme.titleLarge?.color),
                    label: const Text("Location",
                        style: TextStyle(letterSpacing: 1))),
                style: Theme.of(context).textTheme.headlineMedium,
              )),
              const SizedBox(width: 10),
              Expanded(
                  child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (!(value != null && value.trim().isNotEmpty)) {
                    errorPage = page;
                    return "Required!";
                  } else {
                    return null;
                  }
                },
                controller: facultyNameController,
                onChanged: (a) {
                  labInfo.facultyName = a;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_rounded,
                        color: Theme.of(context).textTheme.titleLarge?.color),
                    label: const Text("Faculty",
                        style: TextStyle(letterSpacing: 1))),
                style: Theme.of(context).textTheme.headlineMedium,
              )),
            ],
          ),
        ],
      ),
    );
  }
}
