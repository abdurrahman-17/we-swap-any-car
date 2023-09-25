import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../core/locator.dart';
import '../../model/need_finance/need_finance_response_model.dart';
import '../../repository/car_repo.dart';
import '../../utility/enums.dart';

part 'need_finance_event.dart';
part 'need_finance_state.dart';

class NeedFinanceBloc extends Bloc<NeedFinanceEvent, NeedFinanceState> {
  NeedFinanceBloc() : super(NeedFinanceInitialState()) {
    on<NeedFinanceEvent>((event, emit) {
      emit(NeedFinanceInitialState());
    });

    // post report issue
    on<AddFinanceRequestEvent>((event, emit) async {
      emit(const AddFinanceRequestState(
        needFinanceStatus: ProviderStatus.loading,
      ));

      final result = await Locator.instance
          .get<CarRepo>()
          .addFinanceRequest(event.needFinanceData);

      final AddFinanceRequestState state = result.fold((fail) {
        return const AddFinanceRequestState(
          needFinanceStatus: ProviderStatus.error,
        );
      }, (reportIssueResponse) {
        return AddFinanceRequestState(
          needFinanceStatus: ProviderStatus.success,
          needFinanceData: reportIssueResponse,
        );
      });
      emit(state);
    });
  }
}
