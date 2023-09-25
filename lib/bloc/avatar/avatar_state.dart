part of 'avatar_bloc.dart';

abstract class AvatarState extends Equatable {
  const AvatarState();

  @override
  List<Object> get props => [];
}

class AvatarInitialState extends AvatarState {}

class AvatarLoadingState extends AvatarState {}

class AvatarErrorState extends AvatarState {
  final String errorMessage;
  const AvatarErrorState({required this.errorMessage});
}

class UserAvatarSuccessState extends AvatarState {
  final List<AvatarResponse> avatarVariationResponse;
  const UserAvatarSuccessState({
    this.avatarVariationResponse = const [],
  });
}
