import 'package:equatable/equatable.dart';

import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/car_detail_model/hpi_response_model.dart';
import '../../model/car_model/car_added_accessories.dart';
import '../../model/car_model/car_model.dart';
import '../../repository/car_repo.dart';

part 'car_details_event.dart';
part 'car_details_state.dart';

class CarDetailsBloc extends Bloc<CarDetailsEvent, CarDetailsState> {
  CarModel? car;
  CarDetailsBloc() : super(CarDetailsInitial()) {
    on<CarDetailsEvent>((event, emit) {
      emit(CarDetailsInitial());
    });

    ///save new car details
    on<CreateCarEvent>((event, emit) async {
      emit(const CreateCarState(carCreateStatus: ProviderStatus.loading));

      final result =
          await Locator.instance.get<CarRepo>().createCar(event.carInfoData);
      final CarDetailsState state = result.fold((fail) {
        return const CreateCarState(
          carCreateStatus: ProviderStatus.error,
        );
      }, (carModel) {
        return CreateCarState(
          carCreateStatus: ProviderStatus.success,
          car: carModel,
        );
      });
      emit(state);
    });

    ///fetch car details using api
    on<ConfirmCarDetailsEvent>((event, emit) async {
      emit(const ConfirmCarDetailsState(
          confirmCarStatus: ProviderStatus.loading));

      final result = await Locator.instance
          .get<CarRepo>()
          .confirmCarDetails(event.registrationNumber);
      final CarDetailsState state = result.fold((fail) {
        return const ConfirmCarDetailsState(
          confirmCarStatus: ProviderStatus.error,
        );
      }, (carModel) {
        return ConfirmCarDetailsState(
            confirmCarStatus: ProviderStatus.success, car: carModel);
      });
      emit(state);
    });

    ///update car additional info
    on<UpdateCarInfoEvent>((event, emit) async {
      emit(UpdateCarInfoState(
        updateCarStatus: ProviderStatus.loading,
        carCreateStatus: event.carCreateStatus,
      ));

      final result = await Locator.instance
          .get<CarRepo>()
          .updateCarDetails(event.carInfoData);
      final UpdateCarInfoState state = result.fold((fail) {
        return UpdateCarInfoState(
          updateCarStatus: ProviderStatus.error,
          carCreateStatus: event.carCreateStatus,
          errorMessage: fail.message,
        );
      }, (carModel) {
        return UpdateCarInfoState(
          updateCarStatus: ProviderStatus.success,
          car: carModel,
          carCreateStatus: event.carCreateStatus,
        );
      });
      emit(state);
    });

    ///get car details
    on<GetCarDetailsEvent>((event, emit) async {
      car = null;
      emit(const GetCarDetailsState(carDetailsStatus: ProviderStatus.loading));

      final result = await Locator.instance
          .get<CarRepo>()
          .getCarDetails(key: event.key, value: event.value);

      final GetCarDetailsState state = result.fold((fail) {
        car = null;
        return const GetCarDetailsState(carDetailsStatus: ProviderStatus.error);
      }, (carModel) {
        car = carModel;
        return const GetCarDetailsState(
          carDetailsStatus: ProviderStatus.success,
        );
      });
      emit(state);
    });

    ///fetch car accessories
    on<GetCarAccessoriesEvent>((event, emit) async {
      emit(const GetCarAccessoriesState(
          accessoriesStatus: ProviderStatus.loading));

      final result =
          await Locator.instance.get<CarRepo>().fetchCarAccessories();
      final GetCarAccessoriesState state = result.fold((fail) {
        return const GetCarAccessoriesState(
          accessoriesStatus: ProviderStatus.error,
        );
      }, (accessoryListData) {
        return GetCarAccessoriesState(
          accessoriesStatus: ProviderStatus.success,
          accessoryList: accessoryListData,
        );
      });
      emit(state);
    });

    ///fetch car HPI details
    on<GetCarHPIDetailsEvent>((event, emit) async {
      emit(const GetCarHPIHistoryState(
          hpiDetailsStatus: ProviderStatus.loading));

      final result = await Locator.instance
          .get<CarRepo>()
          .getCarHPIDetailsRepo(registrationMark: event.registrationNumber);
      final GetCarHPIHistoryState state = result.fold((fail) {
        return const GetCarHPIHistoryState(
          hpiDetailsStatus: ProviderStatus.error,
        );
      }, (hpiResponse) {
        return GetCarHPIHistoryState(
          hpiDetailsStatus: ProviderStatus.success,
          hpiResponseParameter: hpiResponse.data!.responseParameter,
        );
      });
      emit(state);
    });
  }
}
