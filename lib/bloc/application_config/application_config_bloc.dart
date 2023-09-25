import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/locator.dart';
import '../../model/app_update_model.dart';
import '../../repository/application_repo.dart';

part 'application_config_event.dart';
part 'application_config_state.dart';

class ApplicationConfigBloc
    extends Bloc<ApplicationConfigEvent, ApplicationConfigState> {
  ApplicationConfigBloc() : super(ApplicationConfigInitialState()) {
    on<ApplicationConfigEventInitial>((event, emit) {
      emit(ApplicationConfigInitialState());
    });
    on<GetApplicationUpdateCheckEvent>((event, emit) async {
      final result =
          await Locator.instance.get<ApplicationRepo>().getAppUpdate();
      final state = result.fold((l) {
        return ApplicationConfigErrorState(message: l.message);
      }, (r) {
        return ApplicationUpdateState(appUpdateModel: r);
      });
      emit(state);
    });
  }
}
