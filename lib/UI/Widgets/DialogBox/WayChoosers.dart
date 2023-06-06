import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_dudes/UI/Routes/route.dart';
import '../../../Util/Cubits/Theme/ThemeManager.dart';

class CreateChooser extends StatefulWidget {
  const CreateChooser({Key? key}) : super(key: key);

  @override
  State<CreateChooser> createState() => _CreateChooserState();
}

class _CreateChooserState extends State<CreateChooser> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 10),
        elevation: 5,
        title: Text("Create new by"),
        content: Row(
          children: [
            Expanded(child: BlocBuilder<ThemeCubit, ThemeModes>(
              builder: (context, themeMode) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: IconButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder?>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)))),
                      icon: Image.asset(
                        themeMode == ThemeModes.system
                            ? (MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark
                                ? 'assets/images/iconImages/addPDFDark.png'
                                : 'assets/images/iconImages/addPDFLight.png')
                            : (themeMode == ThemeModes.dark
                                ? 'assets/images/iconImages/addPDFDark.png'
                                : 'assets/images/iconImages/addPDFLight.png'),
                        fit: BoxFit.fill,
                      ),
                      onPressed: () async {
                          Navigator.pushNamed(context, RouteNames.pdfSelect).then((value) => Navigator.of(context).pop());
                      }),
                );
              },
            )),
            Expanded(child: BlocBuilder<ThemeCubit, ThemeModes>(
              builder: (context, themeMode) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: IconButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder?>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)))),
                      icon: Image.asset(
                          themeMode == ThemeModes.system
                              ? (MediaQuery.of(context).platformBrightness ==
                                      Brightness.dark
                                  ? 'assets/images/iconImages/buildScheduleDark.png'
                                  : 'assets/images/iconImages/buildScheduleLight.png')
                              : (themeMode == ThemeModes.dark
                                  ? 'assets/images/iconImages/buildScheduleDark.png'
                                  : 'assets/images/iconImages/buildScheduleLight.png'),
                          fit: BoxFit.fill),
                    onPressed: (){},
                  )
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
