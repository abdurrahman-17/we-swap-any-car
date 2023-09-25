part of 'my_matches_bloc.dart';

sealed class MyMatchesEvent extends Equatable {
  const MyMatchesEvent();

  @override
  List<Object> get props => [];
}

class GetMyMatchesEvent extends MyMatchesEvent {
  final int? pageNo;
  final String userId;
  const GetMyMatchesEvent({this.pageNo, required this.userId});
}

class GetMoreMyMatchesEvent extends MyMatchesEvent {
  final int? pageNo;
  final String userId;
  const GetMoreMyMatchesEvent({this.pageNo, required this.userId});
}
