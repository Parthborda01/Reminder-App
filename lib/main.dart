import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'UI/Pages/HomePage/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]).then((_) {
    runApp(MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
        )));
  });
}
