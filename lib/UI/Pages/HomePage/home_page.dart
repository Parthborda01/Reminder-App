import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:student_dudes/Data/Model/Hive/timetables.dart';
import 'package:student_dudes/Data/Model/time_table_model.dart';
import 'package:student_dudes/Data/Repositories/model_converter.dart';
import 'package:student_dudes/Data/Repositories/time_tables_repository.dart';
import 'package:student_dudes/Firebase/service.dart';
import 'package:student_dudes/UI/Routes/route.dart';
import 'package:student_dudes/UI/Widgets/DialogBox/dialog_box.dart';
import 'package:student_dudes/UI/Widgets/Drawer/DrawerWidget.dart';
import 'package:student_dudes/UI/Widgets/ListTiles/session_tile.dart';
import 'package:student_dudes/Util/Cubits/AnimationHelper/animationHelperCubit.dart';
import 'package:student_dudes/Util/Notification/notification.dart';
import 'package:student_dudes/Util/string_util.dart';
import 'package:student_dudes/Util/time_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<SliderDrawerState> _drawerButtonKey = GlobalKey<SliderDrawerState>();
  final TimeTablesRepository _repository = TimeTablesRepository();
  PageController controller = PageController(initialPage: 600 + ((DateTime.now().weekday - 1) % 7));
  int currentPage = 0;
  late TimeTableHive timeTableHive;
  List<TimeTableHive> list = [];
  DateTime date = DateTime.now();

  @override
  void initState() {
    currentPage = controller.initialPage;
    initMethod();
    LocalNotification.initialization();
    tokenSaveFCM();
    super.initState();
  }

  tokenSaveFCM() {
    List<String> sds = [];
    for (TimeTableHive i in list) {
      if (!sds.contains("${i.semester} ${i.department} ${i.classname}")) {
        sds.add("${i.semester} ${i.department} ${i.classname}");
      }
    }
    FirebaseServices.tokenSave(sds);
  }

  initMethod() async {
    list = _repository.getAllTimeTables();
    timeTableHive = list.singleWhere((element) => element.isSelected);
    list = list.reversed.toList();
    Permission.accessNotificationPolicy.isDenied.then((value) {
      if (value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            enableDrag: true,
            context: context,
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(25), color: Theme.of(context).colorScheme.background),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.blue, Colors.blueAccent.shade700],
                            ).createShader(bounds);
                          },
                          child: const Icon(Icons.volume_mute_rounded, size: 30)),
                    ),
                    Text('Do Not Disturb permission',
                        style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    Text('At the time of Lecture & Lab session you can mute or vibrate your phone form this App',
                        style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                    const SizedBox(height: 20.0),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await Permission.accessNotificationPolicy.request();
                      },
                      child: Text('Allow', style: Theme.of(context).textTheme.headlineMedium),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text("Don't Allow", style: Theme.of(context).textTheme.headlineMedium),
                    ),
                  ],
                ),
              );
            },
          );
        });
      }
      Permission.ignoreBatteryOptimizations.isDenied.then((v) {
        if (v) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              enableDrag: true,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(25), color: Theme.of(context).colorScheme.background),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.blue, Colors.blueAccent.shade700],
                              ).createShader(bounds);
                            },
                            child: const Icon(Icons.battery_alert_rounded, size: 30)),
                      ),
                      Text('Battery Optimization permission',
                          style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      Text(
                          'For use notification service without interruption, allow Battery Optimization to No-Restriction.\n Must required for Non-Pure Android (e.g. by Xiaomi, Huawei)',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center),
                      const SizedBox(height: 20.0),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await Permission.ignoreBatteryOptimizations.request();
                        },
                        child: Text('Allow', style: Theme.of(context).textTheme.headlineMedium),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text("Don't Allow", style: Theme.of(context).textTheme.headlineMedium),
                      ),
                    ],
                  ),
                );
              },
            );
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    ScrollController sliverScrollController = ScrollController();
    sliverScrollController.addListener(() {
      if (sliverScrollController.offset >= 120 && !sliverScrollController.position.outOfRange) {
        BlocProvider.of<SliverScrolled>(context).Add();
      } else {
        BlocProvider.of<SliverScrolled>(context).clear();
      }
    });

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

    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SliderDrawer(
          slider: SlidingDrawer(
            onLongPress: (index) {
              List<TimeTableHive> newList = [];
              newList = list.reversed.toList();
              showDialog(
                context: context,
                builder: (context) => DialogBox.deleteConform(
                  context,
                  timeTableName:
                      "${StringUtils.getOrdinal(newList[index].semester ?? 0)} ${newList[index].department} ${newList[index].classname}",
                  batch: newList[index].id.substring(newList[index].id.length - 2),
                  onConform: () {

                    if (newList[index].isSelected) {
                      LocalNotification.clearAllNotifications();
                      if (newList.length > 1) {
                        int nextIndex;
                        if (newList.length - 1 == index) {
                          nextIndex = newList.length - 2;
                        } else {
                          nextIndex = newList.length - 1;
                        }
                        //make All selected false
                        for (int i = 0; i < newList.length; i++) {
                          newList[i].isSelected = false;
                          _repository.updateTimeTable(i, newList[i]);
                        }
                        newList[nextIndex].isSelected = true;
                        _repository.updateTimeTable(nextIndex, newList[nextIndex]);
                        _repository.deleteTimeTable(index).then((value) {
                          initMethod();
                          //Notification Assign
                          DateTime now = TimeUtil.getLastMonday();

                          for (DayOfWeek i in ModelConverter.convertToPODO(timeTableHive).weekDays!) {
                            for (Session j in i.sessions!) {
                              LocalNotification.scheduleNotification(j, now);
                            }

                            now = now.add(const Duration(days: 1));
                          }
                          setState(() {});
                        });
                      } else {
                        _repository.deleteTimeTable(index).then((value) {
                          FirebaseServices.tokenSave([]);
                          Navigator.pushNamedAndRemoveUntil(context, RouteNames.resource, (route) => false);
                        });
                      }
                      Navigator.of(context).pop();
                    }
                    else {
                      _repository.deleteTimeTable(index).then((value) {
                        initMethod();
                        setState(() {});
                        Navigator.of(context).pop();
                      });
                    }
                  },
                ),
              );
            },
            drawerButtonKey: _drawerButtonKey,
            list: list,
            onTap: (index) {
              LocalNotification.clearAllNotifications();
              List<TimeTableHive> newList = [];
              newList = list.reversed.toList();
              //make All selected false
              for (int i = 0; i < newList.length; i++) {
                newList[i].isSelected = false;
                _repository.updateTimeTable(i, newList[i]);
              }
              //Make One selected true
              newList[index].isSelected = true;
              _repository.updateTimeTable(index, newList[index]).then((value) {
                initMethod();
                //Notification Assign
                DateTime now = TimeUtil.getLastMonday();
                for (DayOfWeek i in ModelConverter.convertToPODO(timeTableHive).weekDays!) {
                  for (Session j in i.sessions!) {
                    LocalNotification.scheduleNotification(j, now);
                  }
                  now = now.add(const Duration(days: 1));
                }
                setState(() {});
              });
            },
          ),
          key: _drawerButtonKey,
          appBar: Container(),
          isDraggable: true,
          isCupertino: true,
          animationDuration: 200,
          sliderOpenSize: deviceWidth - 80,
          child: Container(
            decoration: BoxDecoration(boxShadow: [BoxShadow(spreadRadius: 1, color: Theme.of(context).scaffoldBackgroundColor)]),
            child: CustomScrollView(
              controller: sliverScrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  expandedHeight: 300,
                  leading: IconButton(
                    onPressed: () {
                      _drawerButtonKey.currentState?.toggle();
                    },
                    highlightColor: Colors.transparent,
                    icon: Icon(
                      Icons.menu,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Center(
                      child: BlocBuilder<SliverScrolled, bool>(
                        builder: (context, state) {
                          return AnimatedOpacity(
                            opacity: state ? 0.0 : 1.0,
                            duration: const Duration(milliseconds: 100),
                            child: Text(
                              "Reminder",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: deviceHeight,
                    ),
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [BoxShadow(spreadRadius: 1, color: Theme.of(context).scaffoldBackgroundColor)]),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification && controller.page == 0) {
                          controller.jumpToPage(timeTableHive.days.length - 1);
                        } else if (notification is ScrollEndNotification && controller.page == timeTableHive.days.length - 1) {
                          controller.jumpToPage(0);
                        }
                        return false;
                      },
                      child: ExpandablePageView.builder(
                        controller: controller,
                        itemCount: 1000,
                        itemBuilder: (context, index) {
                          final indexPage = index % timeTableHive.days.length;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(left: 20),
                                      width: 45,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: currentPage == controller.initialPage
                                              ? Theme.of(context).textTheme.titleMedium?.color
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(12)),
                                      child: Text("${date.day}",
                                          style: currentPage == controller.initialPage
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(color: Theme.of(context).colorScheme.background)
                                              : Theme.of(context).textTheme.titleMedium),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(timeTableHive.days[indexPage].day, style: Theme.of(context).textTheme.titleMedium),
                                  ],
                                ),
                                ListView.builder(
                                  itemCount: timeTableHive.days[indexPage].session.length,
                                  physics: physics,
                                  shrinkWrap: true,
                                  itemBuilder: (context, indexList) {
                                    timeTableHive.days[indexPage].session.sort((a, b) => TimeUtil.compareTime(a.time, b.time));
                                    return SessionTile.sessionTile(
                                      context: context,
                                      session: timeTableHive.days[indexPage].session[indexList],
                                      switchValue: timeTableHive.days[indexPage].session[indexList].alert,
                                      onChange: (value) {
                                        int? index;
                                        List<TimeTableHive> newList = [];
                                        newList = list.reversed.toList();
                                        for (int i = 0; i < newList.length; i++) {
                                          if (newList[i].isSelected == true) {
                                            index = i;
                                          }
                                        }
                                        if (index != null) {
                                          timeTableHive.days[indexPage].session[indexList].alert = value;
                                          _repository.updateTimeTable(index, timeTableHive);
                                        }
                                        if (timeTableHive.days[indexPage].session[indexList].alert == false) {
                                          LocalNotification.clearNotificationByID(
                                              timeTableHive.days[indexPage].session[indexList].id);
                                        }
                                        if (timeTableHive.days[indexPage].session[indexList].alert == true) {
                                          LocalNotification.scheduleNotification(
                                              Session(
                                                id: timeTableHive.days[indexPage].session[indexList].id,
                                                location: timeTableHive.days[indexPage].session[indexList].location,
                                                facultyName: timeTableHive.days[indexPage].session[indexList].facultyName,
                                                subjectName: timeTableHive.days[indexPage].session[indexList].subjectName,
                                                time: timeTableHive.days[indexPage].session[indexList].time,
                                                duration: timeTableHive.days[indexPage].session[indexList].duration,
                                                isLab: timeTableHive.days[indexPage].session[indexList].isLab,
                                              ),
                                              TimeUtil.getNextOccurrenceOfDay(timeTableHive.days[indexPage].day) ??
                                                  DateTime.now());
                                        }
                                        setState(() {});
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        onPageChanged: (page) {
                          if (currentPage < page) {
                            date = date.add(const Duration(days: 1));
                            if (date.weekday == DateTime.sunday) {
                              date = date.add(const Duration(days: 1));
                            }
                          } else if (currentPage > page) {
                            date = date.subtract(const Duration(days: 1));
                            if (date.weekday == DateTime.sunday) {
                              date = date.subtract(const Duration(days: 1));
                            }
                          }
                          currentPage = page;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
