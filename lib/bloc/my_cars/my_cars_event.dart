part of 'my_cars_bloc.dart';

abstract class MyCarsEvent extends Equatable {
  const MyCarsEvent();

  @override
  List<Object> get props => [];
}

class GetMyCarsEvent extends MyCarsEvent {
  final Map<String, dynamic> fetchMyCarjson;
  final bool isExpiredPremiumCars;

  const GetMyCarsEvent(
      {required this.fetchMyCarjson, this.isExpiredPremiumCars = false});
}

class GetMoreMyCarsEvent extends MyCarsEvent {
  final Map<String, dynamic> fetchMoreMyCarJson;
  final bool? isExpiredPremiumCars;

  const GetMoreMyCarsEvent(
      {required this.fetchMoreMyCarJson, this.isExpiredPremiumCars});
}
