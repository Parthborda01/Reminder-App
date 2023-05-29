import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:student_dudes/UI/Routes/route.dart';
import 'package:student_dudes/Util/Cubits/Theme/ThemeManager.dart';

class SlidingDrawer extends StatefulWidget {
  final GlobalKey<SliderDrawerState> drwerButtonkey;

  const SlidingDrawer({Key? key, required this.drwerButtonkey}) : super(key: key);
  @override
  State<SlidingDrawer> createState() => _SlidingDrawerState();
}

class _SlidingDrawerState extends State<SlidingDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(right: 10, top: 10),
        child: ClipRRect(
          borderRadius:
              const BorderRadius.horizontal(right: Radius.circular(20)),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
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
                              icon: Icon(Icons.dark_mode),
                              onPressed: () {
                                themeCubit.setThemeMode(ThemeModes.light);
                              },
                            );
                          } else {
                            return IconButton(
                              icon: Icon(Icons.light_mode),
                              onPressed: () {
                                themeCubit.setThemeMode(ThemeModes.dark);
                              },
                            );
                          }
                        } else if (themeMode == ThemeModes.dark) {
                          return IconButton(
                            icon: Icon(Icons.dark_mode),
                            onPressed: () {
                              themeCubit.setThemeMode(ThemeModes.light);
                            },
                          );
                        } else if (themeMode == ThemeModes.light) {
                          return IconButton(
                            icon: Icon(Icons.light_mode),
                            onPressed: () {
                              themeCubit.setThemeMode(ThemeModes.dark);
                            },
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        widget.drwerButtonkey.currentState?.toggle();
                        Navigator.pushNamed(context, RouteNames.setting);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                DottedLine(
                    dashColor: Theme.of(context).dividerColor,
                    lineThickness: 2,
                    dashRadius: 4,
                    dashGapLength: 4,
                    dashLength: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
