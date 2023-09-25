part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitialState extends UserState {}

class UserLoginState extends UserState {
  final bool isSignedIn;
  const UserLoginState({required this.isSignedIn});
}

class GetUserDataState extends UserState {
  final ProviderStatus userDataFetchStatus;
  final String? errorMessage;
  final UserModel? user;
  const GetUserDataState({
    required this.userDataFetchStatus,
    this.user,
    this.errorMessage,
  });
  @override
  List<Object> get props => [userDataFetchStatus];
}

class CreateUserState extends UserState {
  final ProviderStatus userDataSaveStatus;
  final String? errorMessage;
  final UserModel? user;
  const CreateUserState({
    required this.userDataSaveStatus,
    this.user,
    this.errorMessage,
  });
  @override
  List<Object> get props => [userDataSaveStatus];
}

class UpdateUserState extends UserState {
  final ProviderStatus userDataUpdateStatus;
  final String? errorMessage;
  final UserModel? user;
  const UpdateUserState({
    required this.userDataUpdateStatus,
    this.user,
    this.errorMessage,
  });

  @override
  List<Object> get props => [userDataUpdateStatus];
}

class DeleteUserState extends UserState {
  final ProviderStatus userDataDeleteStatus;
  final String? errorMessage;
  final ResponseModel? user;
  const DeleteUserState({
    required this.userDataDeleteStatus,
    this.user,
    this.errorMessage,
  });

  @override
  List<Object> get props => [userDataDeleteStatus];
}

class UpdateUserNotificationSettingsState extends UserState {
  final ProviderStatus updateNotificationSettingsStatus;
  final String? errorMessage;
  final UserModel? user;
  const UpdateUserNotificationSettingsState({
    required this.updateNotificationSettingsStatus,
    this.user,
    this.errorMessage,
  });
  @override
  List<Object> get props => [updateNotificationSettingsStatus];
}

class UpgradeToDealerState extends UserState {
  final ProviderStatus upgradeToDealerStatus;
  final String? errorMessage;
  final UserModel? user;
  const UpgradeToDealerState({
    required this.upgradeToDealerStatus,
    this.user,
    this.errorMessage,
  });
  @override
  List<Object> get props => [upgradeToDealerStatus];
}
