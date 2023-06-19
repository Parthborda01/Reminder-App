import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:student_dudes/Data/Repositories/time_tables_repository.dart';
import 'package:student_dudes/UI/Routes/route.dart';
import 'package:student_dudes/UI/Theme/theme_constants.dart';
import 'package:student_dudes/Util/Cubits/Theme/ThemeManager.dart';
import 'package:student_dudes/Util/Cubits/fileDataFetch/file_data_fetch_cubit.dart';
import 'package:student_dudes/Util/Notification/notification.dart';
import 'package:student_dudes/firebase_options.dart';
import 'Data/Model/Hive/timetables.dart';
import 'Util/Cubits/AnimationHelper/animationHelperCubit.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  LocalNotification.initialization();
  bool isBoxEmpty = false;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();

  await Hive.initFlutter();
    Hive.registerAdapter(TimeTableHiveAdapter());
    Hive.registerAdapter(DayOfWeekHiveAdapter());
    Hive.registerAdapter(SessionHiveAdapter());
  await Hive.openBox<TimeTableHive>('time_tables');
  final TimeTablesRepository repository = TimeTablesRepository();
   for (var element in repository.getAllTimeTables()) {
     if(element.isSelected){
       isBoxEmpty = true;
     }
   }
  await Alarm.init();

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
        ),
        BlocProvider(
          create: (context) => FileDataFetchCubit(),
        )
      ],
      child: BlocBuilder<ThemeCubit, ThemeModes>(
        builder: (context, themeMode) {
          return MaterialApp(
            initialRoute: isBoxEmpty? RouteNames.home : RouteNames.resource,
            onGenerateRoute: RouteGenerator.generateRoute,
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
