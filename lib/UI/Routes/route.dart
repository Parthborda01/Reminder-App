import 'package:flutter/material.dart';
import 'package:student_dudes/UI/Pages/HomePage/HomePage.dart';
import 'package:student_dudes/UI/Pages/NewCreatePage/ConstructorPage.dart';
import 'package:student_dudes/Util/ImageHelper/PickHelper.dart';
import '../Pages/NewCreatePage/PDFChooser.dart';
import '../Pages/SettingPage/SettingPage.dart';

class RouteNames {
  RouteNames._();

  static const String home = '/home_page';
  static const String setting = '/setting_page';
  static const String pdfSelect = '/pdf_select';
  static const String logIn = '/login_page';
  static const String tableBuild = '/tableBuild';
}

class RouteGenerator {
  RouteGenerator._();
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    var args = settings.arguments;
    switch(settings.name){
      case RouteNames.home:
        return _createRoute(HomePage());
      case RouteNames.setting:
        return _createRoute(SettingPage());
      case RouteNames.pdfSelect:
        return _createRoute(PDFChooser());
      // case RouteNames.logIn:
      //   return _createRoute();
      case RouteNames.tableBuild:
        return _createRoute(ConstructorPage(fileData: args as FileData));
      default:
        return null;
    }
  }
}

Route _createRoute(page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: Duration(milliseconds: 100),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween(
        begin: Offset(0,0.2),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutQuad));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
