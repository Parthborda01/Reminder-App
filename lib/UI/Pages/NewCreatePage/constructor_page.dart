import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfx/pdfx.dart';
import 'package:student_dudes/Data/Model/time_table_model.dart';
import 'package:student_dudes/Data/Repositories/calc_success_rate.dart';
import 'package:student_dudes/Firebase/service.dart';
import 'package:student_dudes/UI/Routes/route.dart';
import 'package:student_dudes/UI/Theme/theme_constants.dart';
import 'package:student_dudes/UI/Widgets/DialogBox/ConstructorDialogs/constructor_dialog_lab.dart';
import 'package:student_dudes/UI/Widgets/DialogBox/ConstructorDialogs/constructor_dialog_lecture.dart';
import 'package:student_dudes/UI/Widgets/Helper/expandable_pageView.dart';
import 'package:student_dudes/UI/Widgets/ListTiles/ConstructorTileLab.dart';
import 'package:student_dudes/UI/Widgets/ListTiles/ConstructorTileLecture.dart';
import 'package:student_dudes/Util/Cubits/AnimationHelper/animationHelperCubit.dart';
import 'package:student_dudes/Util/Cubits/Theme/ThemeManager.dart';
import 'package:student_dudes/Util/Cubits/fileDataFetch/file_data_fetch_cubit.dart';
import 'package:student_dudes/Util/ImageHelper/PickHelper.dart';
import 'package:student_dudes/Util/lab_session_util.dart';
import 'package:student_dudes/Util/time_util.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ConstructorPage extends StatefulWidget {
  const ConstructorPage({Key? key, this.fileData}) : super(key: key);
  final FileData? fileData;

  @override
  State<ConstructorPage> createState() => _ConstructorPageState();
}

class _ConstructorPageState extends State<ConstructorPage> {
  int semester = 0;
  TimeTable? timeTable = TimeTable(weekDays: [
    DayOfWeek(day: "Monday", sessions: []),
    DayOfWeek(day: "Tuesday", sessions: []),
    DayOfWeek(day: "Wednesday", sessions: []),
    DayOfWeek(day: "Thursday", sessions: []),
    DayOfWeek(day: "Friday", sessions: []),
    DayOfWeek(day: "Saturday", sessions: []),
  ]);
  int currentPage = 0;
  List<Session> selectedItems = [];
  PageController controller = PageController();
  bool editingFlag = false;
  int numberOfEmpty = 0;
  ScrollController sliverScrollController = ScrollController();

  int countEmptyData() {
    int empty = 0;
    for (int i = 0; i < timeTable!.weekDays!.length; i++) {
      for (var element in timeTable!.weekDays![i].sessions!) {
        if (element.isLab ?? true) {
          List<Session> labElements = LabUtils.labToSessions(element);
          for (var element in labElements) {
            empty += RetrieveRate.countNullEmptyValues(element.toJson());
          }
        } else {
          empty += RetrieveRate.countNullEmptyValues(element.toJson());
        }
      }
    }
    return empty;
  }

  int countEmptyDataFromLab(Session? session) {
    int empty = 0;
    if (session != null) {
      List<Session> labElements = LabUtils.labToSessions(session);
      for (var element in labElements) {
        empty += RetrieveRate.countNullEmptyValues(element.toJson());
      }
    }
    return empty;
  }

  TextEditingController departmentNameController = TextEditingController();
  TextEditingController classNameController = TextEditingController();
  TextEditingController classroomController = TextEditingController();

  @override
  void initState() {
    if (widget.fileData != null) {
      initMethod(widget.fileData!);
    } else {
      BlocProvider.of<FileDataFetchCubit>(context).clearData();
    }
    super.initState();
  }

  initMethod(FileData fileData) {
    File image = fileData.imageFile;
    double width = fileData.width;
    double height = fileData.height;
    BlocProvider.of<FileDataFetchCubit>(context).fetchData(image, width, height);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: AlertDialog(
              title: const Text("Exit"),
              content: const Text("Did you want to cancel editing?"),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No', style: Theme.of(context).textTheme.bodyMedium),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Sure', style: Theme.of(context).textTheme.titleMedium),
                ),
              ],
            ),
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
          body: Container(
              decoration:
                  BoxDecoration(boxShadow: [BoxShadow(spreadRadius: 1, color: Theme.of(context).scaffoldBackgroundColor)]),
              child: CustomScrollView(controller: sliverScrollController, slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  expandedHeight: 300,
                  actions: [
                    IconButton(
                        onPressed: () async {
                          FileData? a = await Navigator.pushNamed(context, RouteNames.pdfSelect, arguments: false) as FileData?;
                          if (a != null) {
                            initMethod(a);
                            setState(() {});
                          }
                        },
                        highlightColor: Colors.transparent,
                        icon: Icon(
                          widget.fileData != null ? Icons.refresh_rounded : Icons.add_photo_alternate_rounded,
                          color: Theme.of(context).iconTheme.color,
                        ))
                  ],
                  leading: IconButton(
                      onPressed: () {
                        showExitPopup().then((f) {
                          if (f) {
                            Navigator.pop(context);
                          }
                        });
                      },
                      highlightColor: Colors.transparent,
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Theme.of(context).iconTheme.color,
                      )),
                  bottom: PreferredSize(
                    preferredSize: Size(deviceWidth, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BlocBuilder<SliverScrolled, bool>(
                            builder: (context, state) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: AnimatedOpacity(
                                      opacity: state ? 1.0 : 0.0,
                                      duration: const Duration(milliseconds: 200),
                                      child: Text("Tasks", style: Theme.of(context).textTheme.titleSmall)),
                                )),
                        const Spacer(),
                        selectedItems.isEmpty
                            ? Row(
                                children: [
                                  PopupMenuButton(
                                    onSelected: (value) {
                                      if (value == "Lecture") {
                                        showDialog(
                                            context: context,
                                            builder: (context) => ConstructorDialogLecture(
                                                  dayOfWeek: timeTable!.weekDays![currentPage].day ?? "",
                                                  fileData: widget.fileData,
                                                  lectureData:
                                                      Session(id: DateTime.now().microsecondsSinceEpoch.toString(), time: "0:00"),
                                                  onChanged: (session) {
                                                    timeTable!.weekDays![currentPage].sessions!.add(session);
                                                    editingFlag = true;
                                                    numberOfEmpty = countEmptyData();
                                                    setState(() {});
                                                  },
                                                ));
                                      } else if (value == "Lab") {
                                        showDialog(
                                          context: context,
                                          builder: (context) => ConstructorDialogLab(
                                            dayOfWeek: timeTable!.weekDays![currentPage].day ?? "",
                                            onChanged: (session) {
                                              timeTable!.weekDays![currentPage].sessions!.add(session);
                                              editingFlag = true;
                                              numberOfEmpty = countEmptyData();
                                              setState(() {});
                                            },
                                            fileData: widget.fileData,
                                          ),
                                        );
                                      }
                                    },
                                    color: Theme.of(context).colorScheme.background,
                                    surfaceTintColor: Colors.transparent,
                                    shape: ShapeBorder.lerp(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), 10),
                                    icon: Icon(Icons.add, color: Theme.of(context).iconTheme.color),
                                    tooltip: "Add sessions",
                                    itemBuilder: (BuildContext context) => [
                                      PopupMenuItem(
                                        value: "Lab",
                                        height: 40,
                                        padding: const EdgeInsets.only(top: 10, left: 20),
                                        child: Text("Lab", style: Theme.of(context).textTheme.headlineMedium),
                                      ),
                                      PopupMenuItem(
                                        value: 'Lecture',
                                        height: 40,
                                        padding: const EdgeInsets.only(bottom: 10, left: 20),
                                        child: Text("Lecture", style: Theme.of(context).textTheme.headlineMedium),
                                      )
                                    ],
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        if (numberOfEmpty > 0) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              backgroundColor: Theme.of(context).canvasColor.withOpacity(0.9),
                                              behavior: SnackBarBehavior.floating,
                                              content: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "$numberOfEmpty Field Remaining to fill",
                                                    style: Theme.of(context).textTheme.headlineMedium,
                                                  ),
                                                  const Icon(Icons.warning, color: Colors.amber),
                                                ],
                                              )));
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return BackdropFilter(
                                                  filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
                                                  child: Dialog(
                                                    insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                                          children: [
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
                                                                            imageProvider: FileImage(widget.fileData!.imageFile),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(height: 20)
                                                            },
                                                            Form(
                                                              child: Column(
                                                                children: [
                                                                  TextFormField(
                                                                    controller: departmentNameController,
                                                                    style: Theme.of(context).textTheme.headlineMedium,
                                                                    decoration: InputDecoration(
                                                                        prefixIcon: Icon(Icons.class_outlined,
                                                                            color: Theme.of(context).textTheme.titleLarge?.color),
                                                                        label: const Text(
                                                                          "Department",
                                                                          style: TextStyle(letterSpacing: 1),
                                                                        )),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: TextFormField(
                                                                          controller: classroomController,
                                                                          style: Theme.of(context).textTheme.headlineMedium,
                                                                          decoration: InputDecoration(
                                                                              prefixIcon: Icon(Icons.badge,
                                                                                  color: Theme.of(context)
                                                                                      .textTheme
                                                                                      .titleLarge
                                                                                      ?.color),
                                                                              label: const Text(
                                                                                "classroom",
                                                                                style: TextStyle(letterSpacing: 0),
                                                                              )),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 20,
                                                                      ),
                                                                      Expanded(
                                                                        child: TextFormField(
                                                                          controller: classNameController,
                                                                          style: Theme.of(context).textTheme.headlineMedium,
                                                                          decoration: InputDecoration(
                                                                              prefixIcon: Icon(Icons.people_outline_rounded,
                                                                                  color: Theme.of(context)
                                                                                      .textTheme
                                                                                      .titleLarge
                                                                                      ?.color),
                                                                              label: const Text(
                                                                                "Class",
                                                                                style: TextStyle(letterSpacing: 1),
                                                                              )),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 10),
                                                                  Column(
                                                                    children: [
                                                                      const Text("Semester"),
                                                                      ToggleSwitch(
                                                                        labels: const ["1", "2", "3", "4", "5", "6", "7", "8"],
                                                                        customWidths: [
                                                                          deviceWidth * 0.1,
                                                                          deviceWidth * 0.1,
                                                                          deviceWidth * 0.1,
                                                                          deviceWidth * 0.1,
                                                                          deviceWidth * 0.1,
                                                                          deviceWidth * 0.1,
                                                                          deviceWidth * 0.1,
                                                                          deviceWidth * 0.1
                                                                        ],
                                                                        initialLabelIndex: semester,
                                                                        totalSwitches: 8,
                                                                        activeBgColor: [deadColor],
                                                                        cornerRadius: 15,
                                                                        inactiveBgColor: Colors.transparent,
                                                                        inactiveFgColor: deadColor,
                                                                        animate: true,
                                                                        animationDuration: 200,
                                                                        onToggle: (index) {
                                                                          semester = index! + 1;
                                                                          setState(() {});
                                                                        },
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(height: 20),
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 5),
                                                              child: IntrinsicHeight(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  children: [
                                                                    Expanded(
                                                                      child: TextButton(
                                                                        style: ButtonStyle(
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
                                                                          timeTable!.className = classNameController.text;
                                                                          timeTable!.department = departmentNameController.text;
                                                                          timeTable!.semester = semester;
                                                                          timeTable!.classRoom = classroomController.text;
                                                                          timeTable!.image = null;

                                                                          print(json.encode(timeTable!.toJson()));

                                                                          FirebaseServices.addTimeTable(timeTable!);

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
                                              });
                                        }
                                      },
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                          if (states.contains(MaterialState.focused)) {
                                            return Colors.white70;
                                          }
                                          if (states.contains(MaterialState.hovered)) {
                                            return Colors.white70;
                                          }
                                          if (states.contains(MaterialState.pressed)) {
                                            return Colors.white70;
                                          }
                                          return Colors.white70; // Defer to the widget's default.
                                        }),
                                      ),
                                      child: Text("Done", style: Theme.of(context).textTheme.titleSmall)),
                                ],
                              )
                            : Row(
                                children: [
                                  IconButton(
                                      icon: const Icon(Icons.delete_forever_rounded),
                                      onPressed: () {
                                        for (Session item in selectedItems) {
                                          for (int i = 0; i < timeTable!.weekDays!.length; i++) {
                                            timeTable!.weekDays![i].sessions!.removeWhere((element) => element.id == item.id);
                                          }
                                        }
                                        selectedItems.clear();
                                        setState(() {});
                                      }),
                                  IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        selectedItems.clear();
                                        setState(() {});
                                      }),
                                ],
                              ),
                        const SizedBox(width: 10)
                      ],
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Center(child: BlocBuilder<SliverScrolled, bool>(
                      builder: (context, state) {
                        return AnimatedOpacity(
                          opacity: state ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          child: editingFlag
                              ? Text(
                                  numberOfEmpty > 0 ? "$numberOfEmpty empty\nremaining" : "Looks Good\nfor Upload",
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                )
                              : BlocBuilder<FileDataFetchCubit, FileDataFetchState>(
                                  builder: (context, state) {
                                    if (state is FileDataFetchLoading) {
                                      return Text(
                                        "Pre - possessing...",
                                        style: Theme.of(context).textTheme.titleMedium,
                                        textAlign: TextAlign.center,
                                      );
                                    } else if (state is FileDataFetchLoaded) {
                                      double successRate = 100 -
                                          ((countEmptyData() / RetrieveRate.countTotalValues(state.timeTable.toJson())) * 100);
                                      return Text(
                                        "${successRate.toStringAsFixed(2)}% Data\nRetrieved",
                                        style: Theme.of(context).textTheme.titleLarge,
                                        textAlign: TextAlign.center,
                                      );
                                    } else if (state is FileDataFetchInitial) {
                                      return Text(
                                        "Create Table",
                                        style: Theme.of(context).textTheme.titleLarge,
                                        textAlign: TextAlign.center,
                                      );
                                    } else {
                                      return Text(
                                        "Please! Retry to load!",
                                        style: Theme.of(context).textTheme.titleLarge,
                                        textAlign: TextAlign.center,
                                      );
                                    }
                                  },
                                ),
                        );
                      },
                    )),
                  ),
                ),
                SliverToBoxAdapter(
                  child: BlocBuilder<FileDataFetchCubit, FileDataFetchState>(
                    builder: (context, state) {
                      if (state is FileDataFetchLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is FileDataFetchLoaded || state is FileDataFetchInitial) {
                        if (state is FileDataFetchLoaded) {
                          timeTable = state.timeTable;
                        }
                        numberOfEmpty = countEmptyData();
                        return ExpandablePageView(
                          pageController: controller,
                          onPageChanged: (page) => currentPage = page,
                          children: List.generate(timeTable!.weekDays!.length, (indexPage) {
                            ScrollPhysics physics = const NeverScrollableScrollPhysics();
                            sliverScrollController.addListener(() {
                              if (sliverScrollController.offset >= 120 && !sliverScrollController.position.outOfRange) {
                                BlocProvider.of<SliverScrolled>(context).Add();
                                physics = const ScrollPhysics();
                              } else {
                                BlocProvider.of<SliverScrolled>(context).clear();
                                physics = const NeverScrollableScrollPhysics();
                              }
                            });
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    indexPage == 0
                                        ? const SizedBox()
                                        : IconButton(
                                            onPressed: () {
                                              controller.previousPage(
                                                  duration: const Duration(milliseconds: 200), curve: Curves.easeInOutCubic);
                                              setState(() {});
                                            },
                                            icon: const Icon(Icons.chevron_left)),
                                    Text(timeTable!.weekDays![indexPage].day!.toUpperCase(),
                                        style: Theme.of(context).textTheme.titleMedium),
                                    indexPage == timeTable!.weekDays!.length - 1
                                        ? const SizedBox()
                                        : IconButton(
                                            onPressed: () {
                                              controller.nextPage(
                                                  duration: const Duration(milliseconds: 200), curve: Curves.easeInOutCubic);
                                            },
                                            icon: const Icon(Icons.chevron_right))
                                  ],
                                ),
                                ListView.builder(
                                  itemCount: timeTable!.weekDays![indexPage].sessions?.length ?? 0,
                                  physics: physics,
                                  shrinkWrap: true,
                                  itemBuilder: (context, indexList) {
                                    timeTable!.weekDays![indexPage].sessions
                                        ?.sort((a, b) => TimeUtil.compareTime(a.time ?? "0:00", b.time ?? "0:00"));
                                    //Data to json
                                    if (!(timeTable?.weekDays?[indexPage].sessions?[indexList].isLab ?? false)) {
                                      //It's a lecture
                                      return InkWell(
                                        onLongPress: () {
                                          if (selectedItems.isEmpty) {
                                            selectedItems.add(timeTable!.weekDays![indexPage].sessions![indexList]);
                                            setState(() {});
                                          }
                                        },
                                        onTap: () {
                                          if (selectedItems.isEmpty) {
                                            showDialog(
                                                context: context,
                                                builder: (context) => ConstructorDialogLecture(
                                                      dayOfWeek: timeTable!.weekDays![indexPage].day ?? "",
                                                      fileData: widget.fileData,
                                                      lectureData: timeTable!.weekDays![indexPage].sessions![indexList],
                                                      onChanged: (session) {
                                                        timeTable!.weekDays![indexPage].sessions![indexList] = session;

                                                        numberOfEmpty = countEmptyData();
                                                        editingFlag = true;
                                                        setState(() {});
                                                      },
                                                    ));
                                          } else {
                                            if (selectedItems
                                                .where((element) =>
                                                    element.id == timeTable!.weekDays![indexPage].sessions![indexList].id)
                                                .isNotEmpty) {
                                              selectedItems.removeWhere((element) =>
                                                  element.id == timeTable!.weekDays![indexPage].sessions![indexList].id);
                                            } else {
                                              selectedItems.add(timeTable!.weekDays![indexPage].sessions![indexList]);
                                            }
                                            setState(() {});
                                          }
                                        },
                                        child: ConstructorTileLecture(
                                          numberOfEmpty: RetrieveRate.countNullEmptyValues(
                                              timeTable!.weekDays![indexPage].sessions![indexList].toJson()),
                                          isSelected: selectedItems
                                              .where((element) =>
                                                  element.id == timeTable!.weekDays![indexPage].sessions![indexList].id)
                                              .isNotEmpty,
                                          lectureData: timeTable!.weekDays![indexPage].sessions![indexList],
                                        ),
                                      );
                                    } else {
                                      //for lab
                                      return InkWell(
                                        onLongPress: () {
                                          if (selectedItems.isEmpty) {
                                            selectedItems.add(timeTable!.weekDays![indexPage].sessions![indexList]);
                                            setState(() {});
                                          }
                                        },
                                        onTap: () {
                                          if (selectedItems.isEmpty) {
                                            showDialog(
                                                context: context,
                                                builder: (context) => ConstructorDialogLab(
                                                      dayOfWeek: timeTable!.weekDays![indexPage].day ?? "",
                                                      labData: timeTable!.weekDays?[indexPage].sessions?[indexList],
                                                      onChanged: (session) {
                                                        timeTable!.weekDays?[indexPage].sessions?[indexList] = session;
                                                        numberOfEmpty = countEmptyData();
                                                        editingFlag = true;
                                                        setState(() {});
                                                      },
                                                      fileData: widget.fileData,
                                                    ));
                                          } else {
                                            if (selectedItems
                                                .where((element) =>
                                                    element.id == timeTable!.weekDays![indexPage].sessions![indexList].id)
                                                .isNotEmpty) {
                                              selectedItems.removeWhere((element) =>
                                                  element.id == timeTable!.weekDays![indexPage].sessions![indexList].id);
                                            } else {
                                              selectedItems.add(timeTable!.weekDays![indexPage].sessions![indexList]);
                                            }
                                            setState(() {});
                                          }
                                        },
                                        child: ConstructorTileLab(
                                          numberOfEmpty:
                                              countEmptyDataFromLab(timeTable!.weekDays?[indexPage].sessions![indexList]),
                                          isSelected: selectedItems
                                              .where((element) =>
                                                  element.id == timeTable!.weekDays![indexPage].sessions![indexList].id)
                                              .isNotEmpty,
                                          labData: timeTable!.weekDays?[indexPage].sessions?[indexList],
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            );
                          }),
                        );
                      } else if (state is FileDataFetchError) {
                        return const SizedBox();
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ]
              )
          )
      ),
    );
  }
}
