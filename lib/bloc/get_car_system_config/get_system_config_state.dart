part of 'get_system_config_bloc.dart';

abstract class CarSystemConfigState extends Equatable {
  const CarSystemConfigState();

  @override
  List<Object> get props => [];
}

class CarDetailsInitial extends CarSystemConfigState {}

class GetSystemConfigurationState extends CarSystemConfigState {
  final ProviderStatus configurationStatus;
  final SystemConfiguration? systemConfigurations;
  final String? errorMessage;

  const GetSystemConfigurationState({
    required this.configurationStatus,
    this.systemConfigurations,
    this.errorMessage,
  });
  @override
  List<Object> get props => [configurationStatus];
}
