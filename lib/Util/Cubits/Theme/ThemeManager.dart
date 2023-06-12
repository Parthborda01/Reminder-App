import 'package:flutter_bloc/flutter_bloc.dart';

enum ThemeModes {
  system,
  light,
  dark,
}

class ThemeCubit extends Cubit<ThemeModes> {
  ThemeCubit() : super(ThemeModes.system);

  void setThemeMode(ThemeModes themeMode) {
    emit(themeMode);
  }
}