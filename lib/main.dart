import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_dudes/UI/Theme/ThemeConstants.dart';
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
        )
      ],
      child: MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: ThemeConstants.lightTheme,
        darkTheme: ThemeConstants.darkTheme,
      ),
    ));
  });
}
