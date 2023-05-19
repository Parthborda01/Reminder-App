import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'UI/Pages/HomePage/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemStatusBarContrastEnforced: false,
    statusBarBrightness: Brightness.light,
  ));

  runApp(MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
      )));
}
