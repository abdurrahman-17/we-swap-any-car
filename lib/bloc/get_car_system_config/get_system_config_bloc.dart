import 'package:equatable/equatable.dart';

import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/car_model/car_model.dart';
import '../../model/get_system_configuration_model.dart';
import '../../repository/car_repo.dart';

part 'get_system_config_event.dart';
part 'get_system_config_state.dart';

class CarSystemConfigBloc
    extends Bloc<CarSystemConfigEvent, CarSystemConfigState> {
  CarModel? car;

  CarSystemConfigBloc() : super(CarDetailsInitial()) {
    on<CarSystemConfigEvent>((event, emit) {
      emit(CarDetailsInitial());
    });

    ///fetch system configuration
    on<GetSystemConfigurationEvent>((event, emit) async {
      emit(const GetSystemConfigurationState(
          configurationStatus: ProviderStatus.loading));
      final result =
          await Locator.instance.get<CarRepo>().getSystemConfigurations();
      final GetSystemConfigurationState state = result.fold((fail) {
        return GetSystemConfigurationState(
          configurationStatus: ProviderStatus.error,
          errorMessage: fail.message,
        );
      }, (systemConfigurationResponse) {
        return GetSystemConfigurationState(
          configurationStatus: ProviderStatus.success,
          systemConfigurations:
              systemConfigurationResponse.systemConfigurations,
        );
      });
      emit(state);
    });
  }
}
