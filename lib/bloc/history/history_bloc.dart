import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/history/history_model.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    on<HistoryEvent>((event, emit) {});
    on<GetHistoryDataEvent>((event, emit) {
      emit(GetHistoryLoadingState());
      emit(GetHistoryDataState(historyModel: event.historyModel));
    });
  }
}
