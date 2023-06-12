
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:student_dudes/UI/Widgets/DialogBox/constructor_choosers.dart';
import 'package:student_dudes/UI/Routes/route.dart';
import 'package:student_dudes/Util/Cubits/Theme/ThemeManager.dart';

class SlidingDrawer extends StatefulWidget {
  final GlobalKey<SliderDrawerState> drawerButtonKey;

  const SlidingDrawer({Key? key, required this.drawerButtonKey})
      : super(key: key);

  @override
  State<SlidingDrawer> createState() => _SlidingDrawerState();
}

class _SlidingDrawerState extends State<SlidingDrawer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if(details.velocity.pixelsPerSecond.dx < -100){
          widget.drawerButtonKey.currentState?.toggle();
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 10, top: 10),
          child: ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(20)),
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
                            if (MediaQuery.of(context).platformBrightness ==
                                Brightness.dark) {
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



                  const Spacer(),
                  Material(
                    color: Theme.of(context).colorScheme.background,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text('Add Time Table', style: Theme.of(context).textTheme.titleSmall,textAlign: TextAlign.center),
                      tileColor: Theme.of(context).scaffoldBackgroundColor,
                      onTap: (){

                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Material(
                    color: Theme.of(context).colorScheme.background,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text('Create Time Table',
                          style: Theme.of(context).textTheme.titleSmall,textAlign: TextAlign.center),
                      tileColor: Theme.of(context).scaffoldBackgroundColor,
                      onTap: () async {
                        widget.drawerButtonKey.currentState?.toggle();
                        Future.delayed(const Duration(milliseconds: 300),() => showDialog(context: context, builder: (context) => const CreateChooser()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
