part of 'my_matches_bloc.dart';

sealed class MyMatchesState extends Equatable {
  const MyMatchesState();

  @override
  List<Object> get props => [];
}

class MyMatchesInitial extends MyMatchesState {}

class GetMyMatchesState extends MyMatchesInitial {
  final MyMatchesResponseModel? myMatchesResponse;
  final ProviderStatus myMatchesStatus;
  GetMyMatchesState({
    this.myMatchesResponse,
    required this.myMatchesStatus,
  });
  @override
  List<Object> get props => [myMatchesStatus];
}

class GetMoreMyMatchesState extends MyMatchesInitial {
  final MyMatchesResponseModel? myMoreMatchesResponse;
  final ProviderStatus myMoreMatchesStatus;
  GetMoreMyMatchesState({
    this.myMoreMatchesResponse,
    required this.myMoreMatchesStatus,
  });
  @override
  List<Object> get props => [myMoreMatchesStatus];
}
