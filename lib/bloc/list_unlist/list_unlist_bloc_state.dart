part of 'list_unlist_bloc_bloc.dart';

abstract class ListUnlistBlocState extends Equatable {
  const ListUnlistBlocState();

  @override
  List<Object> get props => [];
}

class ListUnlistBlocInitial extends ListUnlistBlocState {}

class ListOrUnListMyCarState extends ListUnlistBlocState {
  final ProviderStatus listStatus;
  final CarModel? car;
  final String? errorMessage;
  const ListOrUnListMyCarState({
    required this.listStatus,
    this.car,
    this.errorMessage,
  });
  @override
  List<Object> get props => [listStatus];
}

class DeleteMyCarState extends ListUnlistBlocState {
  final ProviderStatus deleteStatus;
  final String? errorMessage;
  final String routeName;
  const DeleteMyCarState({
    required this.deleteStatus,
    required this.routeName,
    this.errorMessage,
  });
  @override
  List<Object> get props => [deleteStatus];
}
