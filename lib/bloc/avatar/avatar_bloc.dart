import 'package:equatable/equatable.dart';

import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/avatar/upload_profile_response_model.dart';
import '../../repository/user_repo.dart';

part 'avatar_event.dart';
part 'avatar_state.dart';

class AvatarBloc extends Bloc<AvatarEvent, AvatarState> {
  AvatarBloc() : super(AvatarInitialState()) {
    on<AvatarInitialEvent>((event, emit) => emit(AvatarInitialState()));

    ///get avatars
    on<GetProfileAvatars>((event, emit) async {
      emit(AvatarLoadingState());
      final result = await Locator.instance.get<UserRepo>().getUserAvatars();

      final AvatarState state = result.fold((fail) {
        return AvatarErrorState(errorMessage: fail.message);
      }, (success) {
        return UserAvatarSuccessState(avatarVariationResponse: success);
      });
      emit(state);
    });
  }
}
