import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_dudes/UI/Theme/ThemeConstants.dart';
import 'package:student_dudes/Util/Cubits/Theme/ThemeManager.dart';
import 'package:student_dudes/Util/Cubits/HomePage/animationHelperCubit.dart';
import 'UI/Pages/HomePage/HomePage.dart';

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemStatusBarContrastEnforced: false,
    statusBarBrightness: Brightness.light,
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]).then((_) {
    runApp(MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SliverScrolled(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        )
      ],
      child: BlocBuilder<ThemeCubit, ThemeModes>(
        builder: (context, themeMode) {
          return MaterialApp(
            home: HomePage(),
            debugShowCheckedModeBanner: false,
            themeMode: getThemeMode(themeMode),
            theme: ThemeConstants.lightTheme,
            darkTheme: ThemeConstants.darkTheme,
          );
        },
      ),
    ));
  });
}
getThemeMode(ThemeModes themeMode) {
  switch(themeMode){
    case ThemeModes.system:
      return ThemeMode.system;
    case ThemeModes.light:
      return ThemeMode.light;
    case ThemeModes.dark:
      return ThemeMode.dark;
  }
}
