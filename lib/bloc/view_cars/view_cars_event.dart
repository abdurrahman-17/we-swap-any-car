part of 'view_cars_bloc.dart';

abstract class ViewCarsEvent extends Equatable {
  const ViewCarsEvent();

  @override
  List<Object> get props => [];
}

class GetCarsEvent extends ViewCarsEvent {
  final Map<String, dynamic> listingParams;
  final bool isGuest;
  const GetCarsEvent({
    required this.listingParams,
    this.isGuest = false,
  });
}

class GetMoreCarsEvent extends ViewCarsEvent {
  final Map<String, dynamic> listingParams;
  final bool isGuest;
  const GetMoreCarsEvent({
    required this.listingParams,
    this.isGuest = false,
  });
}
