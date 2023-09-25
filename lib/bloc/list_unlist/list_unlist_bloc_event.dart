part of 'list_unlist_bloc_bloc.dart';

abstract class ListUnlistBlocEvent extends Equatable {
  const ListUnlistBlocEvent();

  @override
  List<Object> get props => [];
}

class ListOrUnListMyCarEvent extends ListUnlistBlocEvent {
  final String carId;
  final String userId;
  final String userType;
  final String status;

  const ListOrUnListMyCarEvent({
    required this.carId,
    required this.userId,
    required this.userType,
    required this.status,
  });
}

class DeleteMyCarEvent extends ListUnlistBlocEvent {
  final String carId;
  final String routeName;
  const DeleteMyCarEvent({
    required this.carId,
    required this.routeName,
  });
}
