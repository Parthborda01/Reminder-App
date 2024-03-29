import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:student_dudes/Data/Model/Hive/timetables.dart';
import 'package:student_dudes/Data/Model/time_table_model.dart';
import 'package:student_dudes/Data/Repositories/model_converter.dart';
import 'package:student_dudes/Data/Repositories/time_tables_repository.dart';
import 'package:student_dudes/Firebase/service.dart';
import 'package:student_dudes/UI/Routes/route.dart';
import 'package:student_dudes/UI/Theme/theme_constants.dart';
import 'package:student_dudes/UI/Widgets/DialogBox/constructor_choosers.dart';
import 'package:student_dudes/UI/Widgets/DialogBox/dialog_box.dart';
import 'package:student_dudes/Util/Cubits/AnimationHelper/animationHelperCubit.dart';
import 'package:student_dudes/Util/Cubits/Theme/ThemeManager.dart';
import 'package:student_dudes/Util/Notification/notification.dart';
import 'package:student_dudes/Util/lab_session_util.dart';
import 'package:student_dudes/Util/string_util.dart';
import 'package:student_dudes/Util/time_util.dart';


class ResourcePage extends StatefulWidget {
  const ResourcePage({super.key});
  @override
  State<ResourcePage> createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage> {
  final TimeTablesRepository _repository = TimeTablesRepository();

  List<String> allShuffles(List<String> inputList) {
    List<List<String>> permutations = [];

    // Recursive function to generate all possible permutations
    void generatePermutations(List<String> prefix, List<String> remaining) {
      if (remaining.isEmpty) {
        permutations.add(prefix);
      } else {
        for (int i = 0; i < remaining.length; i++) {
          List<String> nextPrefix = List.from(prefix)..add(remaining[i]);
          List<String> nextRemaining = List.from(remaining)..removeAt(i);
          generatePermutations(nextPrefix, nextRemaining);
        }
      }
    }

    // Start the recursive permutation generation
    generatePermutations([], inputList);

    List<String> a = [];

    // Print all generated permutations
    for (List<String> permutation in permutations) {
      a.add(permutation.join(''));
    }
    return a;
  }

  String search = "";

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    ScrollController sliverScrollController = ScrollController();
    sliverScrollController.addListener(() {
      if (sliverScrollController.offset >= 100 && !sliverScrollController.position.outOfRange) {
        BlocProvider.of<SliverScrolled>(context).Add();
      } else {
        BlocProvider.of<SliverScrolled>(context).clear();
      }
    });

    ScrollPhysics physics = const NeverScrollableScrollPhysics();
    sliverScrollController.addListener(() {
      if (sliverScrollController.offset >= 160 && !sliverScrollController.position.outOfRange) {
        BlocProvider.of<SliverScrolled>(context).Add();
        physics = const ScrollPhysics();
      } else {
        BlocProvider.of<SliverScrolled>(context).clear();
        physics = const NeverScrollableScrollPhysics();
      }
    });

    return PieCanvas(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: StreamBuilder<List<TimeTable>>(
          stream: FirebaseServices.getFirebaseData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<TimeTable> data = [];
              List<TimeTable> find = [];
              if (search.isNotEmpty) {
                for (TimeTable t in snapshot.data ?? []) {
                  List<String> permutations = allShuffles([t.className ?? "", t.department ?? "", t.semester?.toString() ?? ""]);
                  bool found = false;
                  for (String s in permutations) {
                    if (s.toLowerCase().contains(search.toLowerCase().replaceAll(" ", ""))) {
                      found = true;
                    }
                  }
                  if (found) {
                    find.add(t);
                  }
                }
                data = find;
              } else {
                data = snapshot.data ?? [];
              }
              return Container(
                decoration:
                    BoxDecoration(boxShadow: [BoxShadow(spreadRadius: 1, color: Theme.of(context).scaffoldBackgroundColor)]),
                child: CustomScrollView(
                  controller: sliverScrollController,
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
                      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
                      elevation: 0,
                      expandedHeight: 300,
                      leading: Navigator.canPop(context)
                          ? IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Theme.of(context).iconTheme.color,
                              icon: const Icon(Icons.arrow_back_ios_new_rounded))
                          : null,
                      actions: [
                        IconButton(
                          onPressed: () {
                            showDialog(context: context, builder: (context) => const CreateChooser());
                          },
                          color: Theme.of(context).iconTheme.color,
                          icon: const Icon(Icons.add),
                        ),
                        BlocBuilder<ThemeCubit, ThemeModes>(
                          builder: (context, themeMode) {
                            final themeCubit = BlocProvider.of<ThemeCubit>(context);
                            if (themeMode == ThemeModes.system) {
                              if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
                                return IconButton(
                                  icon: const Icon(Icons.dark_mode),
                                  color: Theme.of(context).iconTheme.color,
                                  onPressed: () {
                                    themeCubit.setThemeMode(ThemeModes.light);
                                  },
                                );
                              } else {
                                return IconButton(
                                  icon: const Icon(Icons.light_mode),
                                  color: Theme.of(context).iconTheme.color,
                                  onPressed: () {
                                    themeCubit.setThemeMode(ThemeModes.dark);
                                  },
                                );
                              }
                            } else if (themeMode == ThemeModes.dark) {
                              return IconButton(
                                icon: const Icon(Icons.dark_mode),
                                color: Theme.of(context).iconTheme.color,
                                onPressed: () {
                                  themeCubit.setThemeMode(ThemeModes.light);
                                },
                              );
                            } else if (themeMode == ThemeModes.light) {
                              return IconButton(
                                icon: const Icon(Icons.light_mode),
                                color: Theme.of(context).iconTheme.color,
                                onPressed: () {
                                  themeCubit.setThemeMode(ThemeModes.dark);
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ],
                      bottom: PreferredSize(
                        preferredSize: Size(deviceWidth, 24),
                        child: BlocBuilder<SliverScrolled, bool>(
                          builder: (context, state) {
                            return Container(
                              decoration: BoxDecoration(boxShadow: [
                                state
                                    ? const BoxShadow(
                                        blurRadius: 20, offset: Offset(0, -20), color: Colors.black12, spreadRadius: 20)
                                    : const BoxShadow(blurRadius: 10, color: Colors.transparent)
                              ]),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: TextField(
                                  style: Theme.of(context).textTheme.titleMedium,
                                  onChanged: (value) {
                                    search = value;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Search",
                                      hintStyle: Theme.of(context).textTheme.titleMedium,
                                      contentPadding: const EdgeInsets.only(left: 30, bottom: 10, top: 10),
                                      prefixIconConstraints: const BoxConstraints(minWidth: 60),
                                      suffixIconConstraints: const BoxConstraints(minWidth: 60),
                                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Theme.of(context).colorScheme.background,
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.search, size: 30, color: Theme.of(context).iconTheme.color),
                                        onPressed: () {},
                                      )),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: Center(child: BlocBuilder<SliverScrolled, bool>(
                          builder: (context, state) {
                            return AnimatedOpacity(
                              opacity: state ? 0.0 : 1.0,
                              duration: const Duration(milliseconds: 100),
                              child: Text(
                                "Select your\nClass and Batch",
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        )),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        constraints: BoxConstraints(minHeight: deviceHeight),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            boxShadow: [BoxShadow(spreadRadius: 1, color: Theme.of(context).scaffoldBackgroundColor)]),
                        child: data.isEmpty
                            ? Container(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                alignment: Alignment.topCenter,
                                child: const Text("No Data Found!"))
                            : ListView.builder(
                                itemCount: data.length,
                                physics: physics,
                                shrinkWrap: true,
                                itemBuilder: (context, indexList) {
                                  final TimeTable timeTable = data[indexList];
                                  List<String> batches = [];

                                  for (DayOfWeek i in timeTable.weekDays!) {
                                    for (Session j in i.sessions!) {
                                      if (j.isLab!) {
                                        List<Session> labData = LabUtils.labToSessions(j);
                                        for (Session k in labData) {
                                          if (!batches.contains(k.time!.trim())) {
                                            batches.add(k.time!.trim());
                                          }
                                        }
                                      }
                                    }
                                  }
                                  return GestureDetector(
                                    onLongPress: () {},
                                    child: PieMenu(
                                      theme: PieTheme(
                                        brightness: Theme.of(context).brightness,
                                        iconSize: 32,
                                        pointerColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                                        buttonTheme: PieButtonTheme(
                                            backgroundColor: Theme.of(context).canvasColor,
                                            iconColor: Theme.of(context).iconTheme.color),
                                      ),
                                      actions: [
                                        PieAction(
                                          buttonThemeHovered: PieButtonTheme(
                                            backgroundColor: Colors.red,
                                            iconColor: Theme.of(context).scaffoldBackgroundColor,
                                          ),
                                          tooltip: 'Delete',
                                          onSelect: () async {
                                            showDialog(
                                                context: context,
                                                builder: (context) => DialogBox.deleteConform(context,
                                                    onConform: () async {
                                                      FirebaseServices.removeTimeTable(
                                                          "${timeTable.semester} ${timeTable.department} ${timeTable.className}");
                                                      await FirebaseServices.sendFCMMessage(
                                                          "${timeTable.semester ?? ""} ${timeTable.department ?? ""} ${timeTable.className ?? ""}",
                                                          "${timeTable.semester ?? ""} ${timeTable.department ?? ""} ${timeTable.className ?? ""} was Deleted by admin.",
                                                          "Please! Reschedule as per your updated classroom.").then((value) => Navigator.of(context).pop());
                                                    },
                                                    timeTableName:
                                                        "${timeTable.semester} ${timeTable.department} ${timeTable.className}",
                                                    batch: "Forever"));


                                          },
                                          child: const Icon(Icons.delete_rounded),
                                        ),
                                        PieAction(
                                          buttonThemeHovered: PieButtonTheme(
                                            backgroundColor: Colors.lightBlueAccent,
                                            iconColor: Theme.of(context).scaffoldBackgroundColor,
                                          ),
                                          tooltip: 'Edit',
                                          onSelect: () {
                                            Navigator.pushNamed(context, RouteNames.pdfConstructor,
                                                arguments: {"table": timeTable});
                                          },
                                          child: const Icon(Icons.edit),
                                        )
                                      ],
                                      child: Card(
                                        color: Theme.of(context).colorScheme.background,
                                        surfaceTintColor: Theme.of(context).colorScheme.background,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                        margin: const EdgeInsets.only(bottom: 20),
                                        child: ExpansionTile(
                                            iconColor: Theme.of(context).iconTheme.color,
                                            collapsedIconColor: Theme.of(context).iconTheme.color,
                                            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                            childrenPadding: const EdgeInsets.symmetric(vertical: 10),
                                            tilePadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                            backgroundColor: Theme.of(context).colorScheme.background,
                                            shape:
                                                const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                                            title: Text(
                                              "${StringUtils.getOrdinal(timeTable.semester ?? 0)} ${timeTable.department} ${timeTable.className}",
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 2),
                                            ),
                                            children: List.generate(
                                              batches.length,
                                              (index) => GestureDetector(
                                                onTap: () async {
                                                  TimeTable selected = TimeTable.fromJson(timeTable.toJson());
                                                  final box = await Hive.openBox<TimeTableHive>('time_tables');
                                                  bool success = false;
                                                  for (TimeTableHive i in box.values.toList()) {
                                                    if (i.id == "${selected.id} ${batches[index]}") {
                                                      success = true;
                                                    }
                                                  }
                                                  if (!mounted) return;
                                                  if (success) {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        behavior: SnackBarBehavior.floating,
                                                        backgroundColor:
                                                            Theme.of(context).textTheme.labelMedium?.color?.withOpacity(0.9),
                                                        content: Text(
                                                          '''${StringUtils.getOrdinal(selected.semester ?? 0)} ${selected.department} ${selected.className} Exist in your Device''',
                                                          style: Theme.of(context).textTheme.headlineMedium,
                                                        )));
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => DialogBox.installConform(
                                                        context,
                                                        timeTableName:
                                                            "${StringUtils.getOrdinal(selected.semester ?? 0)} ${selected.department} ${selected.className}",
                                                        batch: batches[index],
                                                        onConform: () async {
                                                          LocalNotification.clearAllNotifications();
                                                          selected = LabUtils.getFinalTimeTable(selected, batches[index]);

                                                          for (var i = 0; i < box.values.length; i++) {
                                                            box.values.toList()[i].isSelected = false;
                                                            _repository.updateTimeTable(i, box.values.toList()[i]);
                                                          }

                                                          await _repository.storeTimeTable(
                                                            ModelConverter.convertToHive(timetable: selected, isSelected: true),
                                                          );

                                                          DateTime now = TimeUtil.getLastMonday();
                                                          for (DayOfWeek i in selected.weekDays!) {
                                                            for (Session j in i.sessions!) {
                                                              LocalNotification.scheduleNotification(j, now);
                                                            }
                                                            now = now.add(const Duration(days: 1));
                                                          }

                                                          if (!mounted) return;
                                                          Navigator.pop(context);
                                                          Navigator.pushNamedAndRemoveUntil(
                                                            context,
                                                            RouteNames.home,
                                                            (route) => false,
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                  width: deviceWidth,
                                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                                  decoration: BoxDecoration(
                                                      color: deadColor.withOpacity(0.2),
                                                      borderRadius: const BorderRadius.horizontal(
                                                          left: Radius.circular(20), right: Radius.circular(20))),
                                                  child: Text(batches[index], style: Theme.of(context).textTheme.headlineMedium),
                                                ),
                                              ),
                                            )),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error"));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
