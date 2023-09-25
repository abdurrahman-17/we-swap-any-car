part of 'other_cars_bloc.dart';

abstract class OtherCarsEvent extends Equatable {
  const OtherCarsEvent();

  @override
  List<Object> get props => [];
}

class GetOtherCarsEvent extends OtherCarsEvent {
  final Map<String, dynamic> fetchOtherCarjson;

  const GetOtherCarsEvent({required this.fetchOtherCarjson});
}

class GetMoreOtherCarsEvent extends OtherCarsEvent {
  final Map<String, dynamic> fetchMoreOtherCarjson;

  const GetMoreOtherCarsEvent({required this.fetchMoreOtherCarjson});
}
