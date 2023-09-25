part of 'other_cars_bloc.dart';

abstract class OtherCarsState extends Equatable {
  const OtherCarsState();

  @override
  List<Object> get props => [];
}

class OtherCarsInitial extends OtherCarsState {}

class GetOtherCarsState extends OtherCarsState {
  final ProviderStatus otherCarsStatus;
  final List<CarModel>? otherCars;
  const GetOtherCarsState({required this.otherCarsStatus, this.otherCars});
  @override
  List<Object> get props => [otherCarsStatus];
}

class GetMoreOtherCarsState extends OtherCarsState {
  final ProviderStatus moreOtherCarsStatus;
  final List<CarModel>? moreotherCars;
  const GetMoreOtherCarsState({
    required this.moreOtherCarsStatus,
    this.moreotherCars,
  });
  @override
  List<Object> get props => [moreOtherCarsStatus];
}
