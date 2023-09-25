import 'package:equatable/equatable.dart';

import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/one_auto_response_model.dart';
import '../../repository/car_repo.dart';

part 'valuation_check_event.dart';
part 'valuation_check_state.dart';

class ValuationCheckBloc
    extends Bloc<ValuationCheckEvent, ValuationCheckState> {
  ValuationCheckBloc() : super(ValuationCheckInitialState()) {
    on<GetCarValuationDetails>((event, emit) async {
      emit(ValuationCheckLoadingState());
      final result =
          await Locator.instance.get<CarRepo>().checkCarValuationRepo(
                registration: event.registration,
                mileage: event.mileage,
                exterior: event.exterior,
              );

      final ValuationCheckState state = result.fold((fail) {
        return ValuationCheckErrorState(errorMessage: fail.message);
      }, (success) {
        return ValuationCheckSuccessState(oneAutoResponse: success);
      });
      emit(state);
    });
  }
}
