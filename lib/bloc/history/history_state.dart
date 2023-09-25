part of 'history_bloc.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class GetHistoryDataState extends HistoryState {
  final HistoryModel? historyModel;

  GetHistoryDataState({
    required this.historyModel,
  });
}

class GetHistoryLoadingState extends HistoryState {}
