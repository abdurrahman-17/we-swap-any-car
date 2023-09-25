import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wsac/model/error_model.dart';

import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/car_model/my_cars_response.dart';
import '../../repository/car_repo.dart';

part 'my_cars_event.dart';
part 'my_cars_state.dart';

class MyCarsBloc extends Bloc<MyCarsEvent, MyCarsState> {
  MyCarsBloc() : super(MyCarsInitial()) {
    on<MyCarsEvent>((event, emit) {
      emit(MyCarsInitial());
    });

    ///get my cars
    on<GetMyCarsEvent>((event, emit) async {
      emit(const GetMyCarsState(myCarsStatus: ProviderStatus.loading));
      late Either<ErrorModel, GetCarsResponseModel> result;
      if (event.isExpiredPremiumCars) {
        result = await Locator.instance
            .get<CarRepo>()
            .getExpiredPremiumCarsRepo(fetchMyCarJson: event.fetchMyCarjson);
      } else {
        result = await Locator.instance
            .get<CarRepo>()
            .getMyCarsWithFilterRepo(fetchMyCarjson: event.fetchMyCarjson);
      }

      final GetMyCarsState state = result.fold((fail) {
        return const GetMyCarsState(myCarsStatus: ProviderStatus.error);
      }, (myCars) {
        return GetMyCarsState(
          myCarsStatus: ProviderStatus.success,
          myCars: myCars,
        );
      });
      emit(state);
    });

    ///get more my cars
    on<GetMoreMyCarsEvent>((event, emit) async {
      emit(const GetMoreMyCarsState(moreMyCarsStatus: ProviderStatus.loading));
      late Either<ErrorModel, GetCarsResponseModel> result;
      if (event.isExpiredPremiumCars!) {
        result = await Locator.instance
            .get<CarRepo>()
            .getExpiredPremiumCarsRepo(
                fetchMyCarJson: event.fetchMoreMyCarJson);
      } else {
        result = await Locator.instance
            .get<CarRepo>()
            .getMyCarsWithFilterRepo(fetchMyCarjson: event.fetchMoreMyCarJson);
      }
      final GetMoreMyCarsState state = result.fold((fail) {
        return const GetMoreMyCarsState(moreMyCarsStatus: ProviderStatus.error);
      }, (myCars) {
        return GetMoreMyCarsState(
          moreMyCarsStatus: ProviderStatus.success,
          moreMyCars: myCars,
        );
      });
      emit(state);
    });
  }
}
