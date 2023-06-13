 import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_dudes/Data/Model/time_table_model.dart';
import 'package:student_dudes/Data/Repositories/data_extractor.dart';

part 'file_data_fetch_state.dart';

class FileDataFetchCubit extends Cubit<FileDataFetchState> {
  FileDataFetchCubit() : super(FileDataFetchInitial());

  TextExtractor textExtractor = TextExtractor();

  void fetchData(File image, double width, double height) async {
    emit(FileDataFetchLoading());
    try {
      TimeTable timeTable = await textExtractor.fetchTimeTable(image: image, width: width, height: height);
      emit(FileDataFetchLoaded(timeTable));
    } catch (error) {
      emit(FileDataFetchError(error.toString()));
      debugPrint(error.toString());
    }
  }

  void clearData() async {
    emit(FileDataFetchInitial());
  }
}
