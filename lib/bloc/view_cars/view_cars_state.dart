part of 'view_cars_bloc.dart';

abstract class ViewCarsState extends Equatable {
  const ViewCarsState();

  @override
  List<Object> get props => [];
}

class GetCarsInitial extends ViewCarsState {}

class GetCarsState extends ViewCarsState {
  final ProviderStatus getCarsStatus;
  final GetCarsResponseModel? getCarsResponseModel;
  const GetCarsState({
    required this.getCarsStatus,
    this.getCarsResponseModel,
  });
  @override
  List<Object> get props => [getCarsStatus];
}

class GetMoreCarsState extends ViewCarsState {
  final ProviderStatus getMoreCarsStatus;
  final GetCarsResponseModel? getMoreCarsResponseModel;
  const GetMoreCarsState({
    required this.getMoreCarsStatus,
    this.getMoreCarsResponseModel,
  });
  @override
  List<Object> get props => [getMoreCarsStatus];
}
