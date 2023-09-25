part of 'avatar_bloc.dart';

abstract class AvatarEvent extends Equatable {
  const AvatarEvent();

  @override
  List<Object> get props => [];
}

class AvatarInitialEvent extends AvatarEvent {}

class GetProfileAvatars extends AvatarEvent {}
