part of 'file_data_fetch_cubit.dart';

@immutable
abstract class FileDataFetchState {}

class FileDataFetchInitial extends FileDataFetchState {}

class FileDataFetchLoading extends FileDataFetchState {}

class FileDataFetchLoaded extends FileDataFetchState {
  final TimeTable timeTable;
  FileDataFetchLoaded(this.timeTable);
}


class FileDataFetchError extends FileDataFetchState{
  final String errorMessage;

  FileDataFetchError(this.errorMessage);
}

