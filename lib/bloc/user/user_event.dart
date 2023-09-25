part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class CheckUserLoginEvent extends UserEvent {}

class GetCurrentUserDataEvent extends UserEvent {
  final String key;
  final String value;
  const GetCurrentUserDataEvent({
    required this.key,
    required this.value,
  });
}

class CreateUserEvent extends UserEvent {
  final Map<String, dynamic> userData;
  const CreateUserEvent({required this.userData});
}

class UpdateUserEvent extends UserEvent {
  final Map<String, dynamic> userData;
  const UpdateUserEvent({required this.userData});
}

class DeleteUserEvent extends UserEvent {
  final Map<String, dynamic> userData;
  const DeleteUserEvent({required this.userData});
}

class UpdateUserNotificationSettingsEvent extends UserEvent {
  final String status;
  final String userId;
  const UpdateUserNotificationSettingsEvent({
    required this.status,
    required this.userId,
  });
}

class UpgradeToDealerEvent extends UserEvent {
  final Map<String, dynamic> userData;
  final String planId;
  final String planName;
  final String planType;
  final String userId;
  const UpgradeToDealerEvent({
    required this.userData,
    required this.planId,
    required this.planName,
    required this.planType,
    required this.userId,
  });
}
