import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void toggle() {
    // ensures the smooth theme toggle across the app
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}
