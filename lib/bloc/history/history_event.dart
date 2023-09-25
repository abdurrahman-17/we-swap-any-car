part of 'history_bloc.dart';

abstract class HistoryEvent {}

class GetHistoryDataEvent extends HistoryEvent {
  final HistoryModel? historyModel;
  GetHistoryDataEvent({required this.historyModel});
}
