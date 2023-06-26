import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:student_dudes/Data/Model/Hive/timetables.dart';
import 'package:student_dudes/UI/Widgets/DialogBox/constructor_choosers.dart';
import 'package:student_dudes/UI/Routes/route.dart';
import 'package:student_dudes/Util/Cubits/Theme/ThemeManager.dart';
import 'package:student_dudes/Util/string_util.dart';

class SlidingDrawer extends StatefulWidget {
  final GlobalKey<SliderDrawerState> drawerButtonKey;
  final List<TimeTableHive> list;
  final Function(int) onTap;
  final Function(int) onLongPress;

  const SlidingDrawer(
      {Key? key, required this.drawerButtonKey, required this.list, required this.onTap, required this.onLongPress})
      : super(key: key);

  @override
  State<SlidingDrawer> createState() => _SlidingDrawerState();
}

class _SlidingDrawerState extends State<SlidingDrawer> {
  int getIndex(int index) {
    List<int> a = [];
    for (int i = widget.list.length - 1; i >= 0; i--) {
      a.add(i);
    }
    return a[index];
  }

  var menuActive = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx < -100) {
          widget.drawerButtonKey.currentState?.toggle();
        }
      },
      child: PieCanvas(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 10, top: 10),
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BlocBuilder<ThemeCubit, ThemeModes>(
                          builder: (context, themeMode) {
                            final themeCubit = BlocProvider.of<ThemeCubit>(context);

                            if (themeMode == ThemeModes.system) {
                              if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
                                return IconButton(
                                  icon: const Icon(Icons.dark_mode),
                                  onPressed: () {
                                    themeCubit.setThemeMode(ThemeModes.light);
                                  },
                                );
                              } else {
                                return IconButton(
                                  icon: const Icon(Icons.light_mode),
                                  onPressed: () {
                                    themeCubit.setThemeMode(ThemeModes.dark);
                                  },
                                );
                              }
                            } else if (themeMode == ThemeModes.dark) {
                              return IconButton(
                                icon: const Icon(Icons.dark_mode),
                                onPressed: () {
                                  themeCubit.setThemeMode(ThemeModes.light);
                                },
                              );
                            } else if (themeMode == ThemeModes.light) {
                              return IconButton(
                                icon: const Icon(Icons.light_mode),
                                onPressed: () {
                                  themeCubit.setThemeMode(ThemeModes.dark);
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            widget.drawerButtonKey.currentState?.toggle();
                            Navigator.pushNamed(context, RouteNames.setting);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DottedLine(
                        dashColor: Theme.of(context).dividerColor,
                        lineThickness: 2,
                        dashRadius: 4,
                        dashGapLength: 4,
                        dashLength: 2),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        physics: menuActive ? const NeverScrollableScrollPhysics() : null,
                        itemCount: widget.list.length,
                        itemBuilder: (context, index) {
                          return PieMenu(
                            theme: PieTheme(
                              pointerSize: 15,
                              iconSize: 32,
                              brightness: Theme.of(context).brightness,
                              buttonTheme: PieButtonTheme(
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                iconColor: Theme.of(context).iconTheme.color,
                              ),
                            ),
                            onToggle: (active) {
                              setState(() {
                                menuActive = active;
                              });
                            },
                            actions: [
                              PieAction(
                                  buttonThemeHovered: PieButtonTheme(
                                    backgroundColor: Colors.red,
                                    iconColor: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                  tooltip: "Delete",
                                  onSelect: () {
                                    widget.onLongPress(getIndex(index));
                                    setState(() {});
                                  },
                                  child: const Icon(Icons.delete_rounded)),
                              if (!widget.list[index].isSelected) ...{
                                PieAction(
                                  buttonThemeHovered: PieButtonTheme(
                                    backgroundColor: Colors.lightBlueAccent,
                                    iconColor: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                  tooltip: "Select",
                                  onSelect: () {
                                    widget.onTap(getIndex(index));
                                    setState(() {});
                                  },
                                  child: const Icon(Icons.check_circle_outline_rounded),
                                )
                              }
                            ],
                            child: ListTile(
                              selected: widget.list[index].isSelected,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                "${StringUtils.getOrdinal(widget.list[index].semester)} ${widget.list[index].department} ${widget.list[index].classname} (${widget.list[index].id.substring(widget.list[index].id.length - 2)})",
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              leading: const Icon(Icons.calendar_month_rounded),
                              trailing: widget.list[index].isSelected
                                  ? const Icon(Icons.check_circle_outline_rounded)
                                  : const SizedBox(),
                            ),
                          );
                        },
                      ),
                    ),
                    Material(
                      color: Theme.of(context).colorScheme.background,
                      child: ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        titleAlignment: ListTileTitleAlignment.center,
                        title: Text('Add Time Table', style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
                        tileColor: Theme.of(context).scaffoldBackgroundColor,
                        onTap: () {
                          widget.drawerButtonKey.currentState?.toggle();
                          Navigator.pushNamed(context, RouteNames.resource);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Material(
                      color: Theme.of(context).colorScheme.background,
                      child: ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        titleAlignment: ListTileTitleAlignment.center,
                        title:
                            Text('Create Time Table', style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
                        tileColor: Theme.of(context).scaffoldBackgroundColor,
                        onTap: () async {
                          widget.drawerButtonKey.currentState?.toggle();
                          Future.delayed(const Duration(milliseconds: 300),
                              () => showDialog(context: context, builder: (context) => const CreateChooser()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
