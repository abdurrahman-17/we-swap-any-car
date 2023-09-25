part of 'my_cars_bloc.dart';

abstract class MyCarsState extends Equatable {
  const MyCarsState();

  @override
  List<Object> get props => [];
}

class MyCarsInitial extends MyCarsState {}

class GetMyCarsState extends MyCarsState {
  final ProviderStatus myCarsStatus;
  final GetCarsResponseModel? myCars;
  const GetMyCarsState({required this.myCarsStatus, this.myCars});
  @override
  List<Object> get props => [myCarsStatus];
}

class GetMoreMyCarsState extends MyCarsState {
  final ProviderStatus moreMyCarsStatus;
  final GetCarsResponseModel? moreMyCars;
  const GetMoreMyCarsState({
    required this.moreMyCarsStatus,
    this.moreMyCars,
  });
  @override
  List<Object> get props => [moreMyCarsStatus];
}

