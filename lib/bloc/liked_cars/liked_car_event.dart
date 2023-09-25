part of 'liked_car_bloc.dart';

abstract class LikedCarsEvent extends Equatable {
  const LikedCarsEvent();

  @override
  List<Object> get props => [];
}

class GetLikedCarsEvent extends LikedCarsEvent {
  final Map<String, dynamic> likedCarJson;

  const GetLikedCarsEvent({required this.likedCarJson});
}

class GetMoreLikedCarsEvent extends LikedCarsEvent {
  final Map<String, dynamic> likedCarJson;

  const GetMoreLikedCarsEvent({required this.likedCarJson});
}

class UnLikeACarEvent extends LikedCarsEvent {
  final Map<String, dynamic> unlikeSelectedCars;
  const UnLikeACarEvent({required this.unlikeSelectedCars});
}
