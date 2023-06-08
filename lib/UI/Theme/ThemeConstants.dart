import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

const Color transparent = Colors.transparent;
final HexColor deadColor = HexColor("#999999");

final HexColor lightTextPrimary = HexColor("#000000");
final HexColor lightTextSecondary = HexColor("#aaaaaa");
final HexColor lightBackgroundPrimary = HexColor("#f4f4f4");
final HexColor lightBackgroundSecondary = HexColor("#ffffff");
final HexColor lightBackgroundDip = HexColor("#e4e4e4");

final HexColor darkTextPrimary = HexColor("#ffffff");
final HexColor darkTextSecondary = HexColor("#333333");
final HexColor darkBackgroundPrimary = HexColor("#000000");
final HexColor darkBackgroundSecondary = HexColor("#171717");
final HexColor darkBackgroundDip = HexColor("#2e2e2e");

class ThemeConstants {
  static final lightTheme = ThemeData(
      useMaterial3: true,
      androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
      scaffoldBackgroundColor: lightBackgroundPrimary,
      colorScheme: ColorScheme.light(
        brightness: Brightness.light,
        background: lightBackgroundSecondary
      ),
      canvasColor: lightBackgroundDip,
      iconTheme: IconThemeData(
        color: lightTextPrimary,
      ),
      brightness: Brightness.light,
      textTheme: TextTheme(
        titleLarge: TextStyle(
            letterSpacing: 5,
            fontSize: 32,
            color: lightTextPrimary,
            fontWeight: FontWeight.w400),
        titleMedium: TextStyle(
            letterSpacing: 2,
            fontSize: 26,
            color: lightTextPrimary,
            fontWeight: FontWeight.w400),
        titleSmall: TextStyle(
            letterSpacing: 1,
            fontSize: 20,
            color: lightTextPrimary,
            fontWeight: FontWeight.w400),
        headlineLarge: TextStyle(
            letterSpacing: 0,
            fontSize: 32,
            color: lightTextPrimary,
            fontWeight: FontWeight.w400),
        headlineMedium: TextStyle(
            letterSpacing: 0,
            fontSize: 20,
            color: lightTextPrimary.withOpacity(0.8),
            fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(
            letterSpacing: 0,
            fontSize: 16,
            color: lightTextPrimary.withOpacity(0.6),
            fontWeight: FontWeight.w400),
        bodyLarge: TextStyle(
            letterSpacing: 5,
            fontSize: 32,
            color: lightTextSecondary,
            fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(
            letterSpacing: 2,
            fontSize: 24,
            color: lightTextSecondary,
            fontWeight: FontWeight.w400),
        bodySmall: TextStyle(
            letterSpacing: 1,
            fontSize: 20,
            color: lightTextSecondary,
            fontWeight: FontWeight.w400),
        labelLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: lightTextSecondary),
        labelMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: lightTextSecondary),
        labelSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: lightTextSecondary),
      ),
      switchTheme: SwitchThemeData(
        splashRadius: 2,
        trackOutlineColor: MaterialStateProperty.all<Color>(lightTextPrimary),
        thumbColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
        trackColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
      dividerColor: deadColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(lightBackgroundSecondary),
          surfaceTintColor: MaterialStateProperty.all(lightBackgroundPrimary),
          iconColor: MaterialStateProperty.all(lightTextPrimary),
          overlayColor: MaterialStateProperty.all(deadColor.withOpacity(0.2)),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
          cursorColor: lightTextPrimary,
          selectionColor: lightTextPrimary.withOpacity(0.1),
          selectionHandleColor: lightTextPrimary
      ),
      dialogBackgroundColor: lightBackgroundSecondary,
      dialogTheme: DialogTheme(
          surfaceTintColor: lightBackgroundSecondary.withOpacity(0.8),
          backgroundColor: lightBackgroundSecondary.withOpacity(0.8)
      ),
      inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: lightTextSecondary,
            ),
          ),
          labelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: lightTextPrimary),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: lightTextSecondary,
            ),
          ))
  );

  static final darkTheme = ThemeData(
      useMaterial3: true,
      androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
      scaffoldBackgroundColor: darkBackgroundPrimary,
      colorScheme: ColorScheme.light(
        brightness: Brightness.dark,
          background: darkBackgroundSecondary
      ),
      canvasColor: darkBackgroundDip,
      iconTheme: IconThemeData(color: darkTextPrimary),
      brightness: Brightness.dark,
      textTheme: TextTheme(
        titleLarge: TextStyle(
            letterSpacing: 5,
            fontSize: 32,
            color: darkTextPrimary,
            fontWeight: FontWeight.w400),
        titleMedium: TextStyle(
            letterSpacing: 2,
            fontSize: 26,
            color: darkTextPrimary,
            fontWeight: FontWeight.w400),
        titleSmall: TextStyle(
            letterSpacing: 1,
            fontSize: 20,
            color: darkTextPrimary,
            fontWeight: FontWeight.w400),
        headlineLarge: TextStyle(
            fontSize: 32, color: darkTextPrimary, fontWeight: FontWeight.w400),
        headlineMedium: TextStyle(
            fontSize: 20,
            color: darkTextPrimary.withOpacity(0.8),
            fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(
            fontSize: 16,
            color: darkTextPrimary.withOpacity(0.6),
            fontWeight: FontWeight.w400),
        bodyLarge: TextStyle(
            letterSpacing: 5,
            fontSize: 32,
            color: darkTextSecondary,
            fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(
            letterSpacing: 2,
            fontSize: 26,
            color: darkTextSecondary,
            fontWeight: FontWeight.w400),
        bodySmall: TextStyle(
            letterSpacing: 1,
            fontSize: 20,
            color: darkTextSecondary,
            fontWeight: FontWeight.w400),
        labelLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: darkTextSecondary),
        labelMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: darkTextSecondary),
        labelSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: darkTextSecondary),
      ),
      switchTheme: SwitchThemeData(
        splashRadius: 2,
        trackOutlineColor:
            MaterialStateProperty.all<Color>(lightBackgroundSecondary),
        thumbColor: MaterialStateProperty.all<Color>(Colors.lightGreenAccent),
        trackColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
      dividerColor: deadColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(darkBackgroundSecondary),
          surfaceTintColor: MaterialStateProperty.all(darkBackgroundPrimary),
          iconColor: MaterialStateProperty.all(darkTextPrimary),
          overlayColor: MaterialStateProperty.all(deadColor.withOpacity(0.2)),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
          cursorColor: darkTextPrimary,
          selectionColor: darkTextPrimary.withOpacity(0.1),
          selectionHandleColor: darkTextPrimary
      ),
      dialogBackgroundColor: darkBackgroundSecondary,
      dialogTheme: DialogTheme(
        surfaceTintColor: darkBackgroundSecondary.withOpacity(0.9),
        backgroundColor: darkBackgroundSecondary.withOpacity(0.9)
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: darkTextSecondary,
            width: 3
          ),
        ),
          labelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: darkTextPrimary),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: darkTextSecondary,
            ),
          ))
  );
}
