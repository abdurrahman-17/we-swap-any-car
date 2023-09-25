part of 'car_details_bloc.dart';

abstract class CarDetailsState extends Equatable {
  const CarDetailsState();

  @override
  List<Object> get props => [];
}

class CarDetailsInitial extends CarDetailsState {}

class CreateCarState extends CarDetailsState {
  final CarModel? car;
  final ProviderStatus carCreateStatus;

  final String? errorMessage;
  const CreateCarState({
    this.car,
    required this.carCreateStatus,
    this.errorMessage,
  });
  @override
  List<Object> get props => [carCreateStatus];
}

class ConfirmCarDetailsState extends CarDetailsState {
  final CarModel? car;
  final ProviderStatus confirmCarStatus;

  const ConfirmCarDetailsState({
    this.car,
    required this.confirmCarStatus,
  });
  @override
  List<Object> get props => [confirmCarStatus];
}

class GetCarDetailsState extends CarDetailsState {
  final ProviderStatus carDetailsStatus;

  const GetCarDetailsState({required this.carDetailsStatus});
  @override
  List<Object> get props => [carDetailsStatus];
}

class UpdateCarInfoState extends CarDetailsState {
  final CarModel? car;
  final ProviderStatus updateCarStatus;
  final CarCreateStatus carCreateStatus;
  final String? errorMessage;

  const UpdateCarInfoState({
    this.car,
    required this.updateCarStatus,
    required this.carCreateStatus,
    this.errorMessage,
  });
  @override
  List<Object> get props => [updateCarStatus];
}

class GetCarAccessoriesState extends CarDetailsState {
  final ProviderStatus accessoriesStatus;
  final List<ListedItem> accessoryList;

  const GetCarAccessoriesState({
    required this.accessoriesStatus,
    this.accessoryList = const [],
  });
  @override
  List<Object> get props => [accessoriesStatus];
}

class GetCarHPIHistoryState extends CarDetailsState {
  final ProviderStatus hpiDetailsStatus;
  final HPIResponseParameter? hpiResponseParameter;

  const GetCarHPIHistoryState({
    required this.hpiDetailsStatus,
    this.hpiResponseParameter,
  });
  @override
  List<Object> get props => [hpiDetailsStatus];
}
