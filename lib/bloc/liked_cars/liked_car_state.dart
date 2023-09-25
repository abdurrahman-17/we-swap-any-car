part of 'liked_car_bloc.dart';

abstract class LikedCarsState extends Equatable {
  const LikedCarsState();

  @override
  List<Object> get props => [];
}

class CarDetailsInitial extends LikedCarsState {}

class GetLikedCarsState extends LikedCarsState {
  final ProviderStatus likedCarsStatus;
  final GetLikedCarsResponseModel? likedCarsList;
  const GetLikedCarsState({required this.likedCarsStatus, this.likedCarsList});
  @override
  List<Object> get props => [likedCarsStatus];
}

class GetMoreLikedCarsState extends LikedCarsState {
  final ProviderStatus moreLikedCarStatus;
  final GetLikedCarsResponseModel? moreLikedCarsList;
  const GetMoreLikedCarsState({
    required this.moreLikedCarStatus,
    this.moreLikedCarsList,
  });
  @override
  List<Object> get props => [moreLikedCarStatus];
}

class UnLikeACarState extends LikedCarsState {
  final ProviderStatus likedCarDataDeleteStatus;
  final String? errorMessage;
  final ResponseModel? likedCar;
  const UnLikeACarState({
    required this.likedCarDataDeleteStatus,
    this.likedCar,
    this.errorMessage,
  });

  @override
  List<Object> get props => [likedCarDataDeleteStatus];
}
