import 'package:flutter/material.dart';
import 'package:student_dudes/Data/Model/time_table_model.dart';
import 'package:student_dudes/UI/Pages/HomePage/home_page.dart';
import 'package:student_dudes/UI/Pages/NewCreatePage/constructor_page.dart';
import 'package:student_dudes/UI/Pages/ResourcePage/resorce_page.dart';
import 'package:student_dudes/Util/ImageHelper/PickHelper.dart';
import '../Pages/NewCreatePage/PDF_chooser.dart';
import '../Pages/SettingPage/setting_page.dart';

class RouteNames {
  RouteNames._();

  static const String home = '/home_page';
  static const String setting = '/setting_page';
  static const String pdfSelect = '/pdf_select';
  static const String logIn = '/login_page';
  static const String pdfConstructor = '/tableBuild';
  static const String resource = '/resource_Page';
}

class RouteGenerator {
  RouteGenerator._();
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    var args = settings.arguments;
    switch(settings.name){
      case RouteNames.home:
        return _createRoute(HomePage());
      case RouteNames.setting:
        return _createRoute(const SettingPage());
      case RouteNames.pdfSelect:
        return _createRoute(PDFChooser(args as bool));
      case RouteNames.resource:
        return _createRoute(const ResourcePage());
      case RouteNames.pdfConstructor:
        return _createRoute(ConstructorPage(fileData:(args as Map)["fileData"] as FileData?,table:args["table"] as TimeTable?));
      default:
        return null;
    }
  }
}

Route _createRoute(page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween(
        begin: const Offset(0,0.2),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutQuad));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
