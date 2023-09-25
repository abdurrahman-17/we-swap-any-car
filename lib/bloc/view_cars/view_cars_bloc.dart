import 'package:equatable/equatable.dart';

import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/car_model/my_cars_response.dart';
import '../../repository/car_repo.dart';

part 'view_cars_event.dart';
part 'view_cars_state.dart';

class ViewCarsBloc extends Bloc<ViewCarsEvent, ViewCarsState> {
  ViewCarsBloc() : super(GetCarsInitial()) {
    on<ViewCarsEvent>((event, emit) => emit(GetCarsInitial()));

    ///get view match cars
    on<GetCarsEvent>((event, emit) async {
      emit(const GetCarsState(getCarsStatus: ProviderStatus.loading));

      final result = event.isGuest
          ? await Locator.instance
              .get<CarRepo>()
              .getGuestCarlistRepo(listingParams: event.listingParams)
          : await Locator.instance
              .get<CarRepo>()
              .getCars(listingParams: event.listingParams);

      final GetCarsState state = result.fold((fail) {
        return const GetCarsState(getCarsStatus: ProviderStatus.error);
      }, (response) {
        return GetCarsState(
          getCarsStatus: ProviderStatus.success,
          getCarsResponseModel: response,
        );
      });
      emit(state);
    });

    ///get view match more cars
    on<GetMoreCarsEvent>((event, emit) async {
      emit(const GetMoreCarsState(getMoreCarsStatus: ProviderStatus.loading));

      final result = event.isGuest
          ? await Locator.instance
              .get<CarRepo>()
              .getGuestCarlistRepo(listingParams: event.listingParams)
          : await Locator.instance
              .get<CarRepo>()
              .getCars(listingParams: event.listingParams);

      final GetMoreCarsState state = result.fold((fail) {
        return const GetMoreCarsState(getMoreCarsStatus: ProviderStatus.error);
      }, (response) {
        return GetMoreCarsState(
          getMoreCarsStatus: ProviderStatus.success,
          getMoreCarsResponseModel: response,
        );
      });
      emit(state);
    });
  }
}
