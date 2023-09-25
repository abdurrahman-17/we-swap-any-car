import 'package:equatable/equatable.dart';

import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/car_model/car_model.dart';
import '../../repository/car_repo.dart';

part 'other_cars_event.dart';
part 'other_cars_state.dart';

class OtherCarsBloc extends Bloc<OtherCarsEvent, OtherCarsState> {
  OtherCarsBloc() : super(OtherCarsInitial()) {
    on<OtherCarsEvent>((event, emit) => emit(OtherCarsInitial()));

    ///get other cars
    on<GetOtherCarsEvent>((event, emit) async {
      emit(const GetOtherCarsState(otherCarsStatus: ProviderStatus.loading));

      final result = await Locator.instance
          .get<CarRepo>()
          .getOtherCarsByUser(event.fetchOtherCarjson);

      final GetOtherCarsState state = result.fold((fail) {
        return const GetOtherCarsState(otherCarsStatus: ProviderStatus.error);
      }, (otherCarsResponse) {
        return GetOtherCarsState(
          otherCarsStatus: ProviderStatus.success,
          otherCars: otherCarsResponse.cars ?? [],
        );
      });
      emit(state);
    });

    ///get more other cars
    on<GetMoreOtherCarsEvent>((event, emit) async {
      emit(const GetMoreOtherCarsState(
          moreOtherCarsStatus: ProviderStatus.loading));

      final result = await Locator.instance
          .get<CarRepo>()
          .getOtherCarsByUser(event.fetchMoreOtherCarjson);

      final GetMoreOtherCarsState state = result.fold((fail) {
        return const GetMoreOtherCarsState(
            moreOtherCarsStatus: ProviderStatus.error);
      }, (otherCarsResponse) {
        return GetMoreOtherCarsState(
          moreOtherCarsStatus: ProviderStatus.success,
          moreotherCars: otherCarsResponse.cars ?? [],
        );
      });
      emit(state);
    });
  }
}
