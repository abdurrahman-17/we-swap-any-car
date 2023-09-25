part of 'application_config_bloc.dart';

class ApplicationConfigState extends Equatable {
  const ApplicationConfigState();

  @override
  List<Object> get props => [];
}

class ApplicationConfigInitialState extends ApplicationConfigState {}

class ApplicationUpdateState extends ApplicationConfigState {
  final AppUpdateModel appUpdateModel;
  const ApplicationUpdateState({
    required this.appUpdateModel,
  });
}

class ApplicationConfigErrorState extends ApplicationConfigState {
  final String message;
  const ApplicationConfigErrorState({
    required this.message,
  });
}
