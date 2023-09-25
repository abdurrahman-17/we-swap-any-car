part of 'application_config_bloc.dart';

class ApplicationConfigEvent extends Equatable {
  const ApplicationConfigEvent();

  @override
  List<Object> get props => [];
}

class ApplicationConfigEventInitial extends ApplicationConfigEvent {}

class GetApplicationUpdateCheckEvent extends ApplicationConfigEvent {}
