import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:student_dudes/Data/Model/Hive/timetables.dart';
import 'package:student_dudes/Data/Repositories/time_tables_repository.dart';
import 'package:student_dudes/UI/Widgets/Drawer/DrawerWidget.dart';
import 'package:student_dudes/UI/Widgets/ListTiles/session_tile.dart';
import 'package:student_dudes/Util/Cubits/AnimationHelper/animationHelperCubit.dart';
import 'package:student_dudes/Util/Notification/notification.dart';
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
    super.initState();
  }

  initMethod() {
    list = _repository.getAllTimeTables();
    timeTableHive = list.singleWhere((element) => element.isSelected);
    list = list.reversed.toList();
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

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SliderDrawer(
          slider: SlidingDrawer(
            drawerButtonKey: _drawerButtonKey,
            list: list,
            onTap: (index) {
              List<TimeTableHive> newList = [];
              newList = list.reversed.toList();
              for (int i = 0; i < newList.length; i++) {
                newList[i].isSelected = false;
                _repository.updateTimeTable(i, newList[i]);
              }
              newList[index].isSelected = true;
              _repository.updateTimeTable(index, newList[index]).then((value) {
                initMethod();
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
                          child: Text(
                            "Reminder",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        );
                      },
                    )),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [BoxShadow(spreadRadius: 1, color: Theme.of(context).scaffoldBackgroundColor)]),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification && controller.page == 0) {
                          // Scroll to the last page
                          controller.jumpToPage(timeTableHive.days.length - 1);
                        } else if (notification is ScrollEndNotification && controller.page == timeTableHive.days.length - 1) {
                          // Scroll to the first page
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
                                          color: Theme.of(context).textTheme.titleMedium?.color,
                                          borderRadius: BorderRadius.circular(12)),
                                      child: Text("${date.day}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(color: Theme.of(context).colorScheme.background)),
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
                                        timeTableHive.days[indexPage].session[indexList].alert = value;
                                        //TODO: update on Hive
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
