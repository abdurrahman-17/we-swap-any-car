part of 'get_system_config_bloc.dart';

abstract class CarSystemConfigEvent extends Equatable {
  const CarSystemConfigEvent();

  @override
  List<Object> get props => [];
}

class GetSystemConfigurationEvent extends CarSystemConfigEvent {}
