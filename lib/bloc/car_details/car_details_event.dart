part of 'car_details_bloc.dart';

abstract class CarDetailsEvent extends Equatable {
  const CarDetailsEvent();

  @override
  List<Object> get props => [];
}

class CreateCarEvent extends CarDetailsEvent {
  final Map<String, dynamic> carInfoData;

  const CreateCarEvent({required this.carInfoData});
}

class ConfirmCarDetailsEvent extends CarDetailsEvent {
  final String registrationNumber;

  const ConfirmCarDetailsEvent({required this.registrationNumber});
}

class UpdateCarInfoEvent extends CarDetailsEvent {
  final Map<String, dynamic> carInfoData;
  final CarCreateStatus carCreateStatus;

  const UpdateCarInfoEvent({
    required this.carInfoData,
    required this.carCreateStatus,
  });
}

class GetCarDetailsEvent extends CarDetailsEvent {
  final String key;
  final String value;

  const GetCarDetailsEvent({
    required this.key,
    required this.value,
  });
}

class GetCarAccessoriesEvent extends CarDetailsEvent {}

class GetCarHPIDetailsEvent extends CarDetailsEvent {
  final String registrationNumber;

  const GetCarHPIDetailsEvent({required this.registrationNumber});
}
