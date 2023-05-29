import 'package:bloc/bloc.dart';

class SliverScrolled extends Cubit<bool> {
  SliverScrolled() : super(false);
  void Add() => emit(true);
  void clear() => emit(false);
}