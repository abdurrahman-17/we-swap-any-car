import 'package:equatable/equatable.dart';

import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/car_model/car_model.dart';
import '../../model/car_model/get_liked_cars_response_model.dart';
import '../../model/response_model.dart';
import '../../repository/car_repo.dart';

part 'liked_car_event.dart';
part 'liked_car_state.dart';

class LikedCarsBloc extends Bloc<LikedCarsEvent, LikedCarsState> {
  CarModel? car;
  LikedCarsBloc() : super(CarDetailsInitial()) {
    // on<LikedCarsEvent>((event, emit) {
    //   emit(CarDetailsInitial());
    // });

    ///get liked cars
    on<GetLikedCarsEvent>((event, emit) async {
      emit(const GetLikedCarsState(likedCarsStatus: ProviderStatus.loading));

      final result = await Locator.instance
          .get<CarRepo>()
          .getLikedCarsWithSearch(likedCarJson: event.likedCarJson);

      final GetLikedCarsState state = result.fold((fail) {
        return const GetLikedCarsState(likedCarsStatus: ProviderStatus.error);
      }, (likedCars) {
        return GetLikedCarsState(
          likedCarsStatus: ProviderStatus.success,
          likedCarsList: likedCars,
        );
      });
      emit(state);
    });

    ///GET MORE LIKED CARS with filter
    on<GetMoreLikedCarsEvent>((event, emit) async {
      emit(const GetMoreLikedCarsState(
          moreLikedCarStatus: ProviderStatus.loading));
      final result = await Locator.instance
          .get<CarRepo>()
          .getLikedCarsWithSearch(likedCarJson: event.likedCarJson);

      final GetMoreLikedCarsState state = result.fold((fail) {
        //fail
        return const GetMoreLikedCarsState(
            moreLikedCarStatus: ProviderStatus.error);
      }, (moreLikedCars) {
        return GetMoreLikedCarsState(
            moreLikedCarStatus: ProviderStatus.success,
            moreLikedCarsList: moreLikedCars);
      });
      emit(state);
    });

    ///Unlike a car
    on<UnLikeACarEvent>((event, emit) async {
      emit(const UnLikeACarState(
          likedCarDataDeleteStatus: ProviderStatus.loading));
      final result = await Locator.instance
          .get<CarRepo>()
          .unlikeACarRepo(carInfoJson: event.unlikeSelectedCars);
      final UnLikeACarState state = result.fold((fail) {
        return UnLikeACarState(
          likedCarDataDeleteStatus: ProviderStatus.error,
          errorMessage: fail.message,
        );
      }, (deletedSelectedCars) {
        return UnLikeACarState(
          likedCarDataDeleteStatus: ProviderStatus.success,
          likedCar: deletedSelectedCars,
        );
      });
      emit(state);
    });
  }
}
