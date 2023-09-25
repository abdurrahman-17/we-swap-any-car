import 'dart:developer';

import 'package:equatable/equatable.dart';

import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/response_model.dart';
import '../../model/user/user_model.dart';
import '../../repository/authentication_repo.dart';
import '../../repository/user_repo.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  ///global userModel
  UserModel? currentUser;
  UserBloc() : super(UserInitialState()) {
    /*Check authenticated or not*/
    on<CheckUserLoginEvent>((event, emit) async {
      final isSignedIn =
          await Locator.instance.get<AuthenticationRepo>().checkAuthenticated();
      emit(UserLoginState(isSignedIn: isSignedIn));
    });

    /*Fetch user data*/
    on<GetCurrentUserDataEvent>((event, emit) async {
      emit(const GetUserDataState(userDataFetchStatus: ProviderStatus.loading));
      final result = await Locator.instance
          .get<UserRepo>()
          .getCurrentUserData(key: event.key, value: event.value);
      final UserState state = result.fold((fail) {
        return GetUserDataState(
            userDataFetchStatus: ProviderStatus.error,
            errorMessage: fail.message);
      }, (userData) {
        log("user type : ${userData.userType.toString()}");

        ///assigning to current user
        currentUser = userData;
        return GetUserDataState(
            userDataFetchStatus: ProviderStatus.success, user: userData);
      });
      emit(state);
    });

    /*create user data*/
    on<CreateUserEvent>((event, emit) async {
      emit(const CreateUserState(userDataSaveStatus: ProviderStatus.loading));
      final result = await Locator.instance
          .get<UserRepo>()
          .createUserRepo(userData: event.userData);
      final UserState state = result.fold((fail) {
        return CreateUserState(
          userDataSaveStatus: ProviderStatus.error,
          errorMessage: fail.message,
        );
      }, (userData) {
        ///assigning to current user
        currentUser = userData;
        return CreateUserState(
            userDataSaveStatus: ProviderStatus.success, user: userData);
      });
      emit(state);
    });

    /*update user data*/
    on<UpdateUserEvent>((event, emit) async {
      emit(const UpdateUserState(userDataUpdateStatus: ProviderStatus.loading));
      final result = await Locator.instance
          .get<UserRepo>()
          .updateUserRepo(userData: event.userData);
      final UserState state = result.fold((fail) {
        return UpdateUserState(
          userDataUpdateStatus: ProviderStatus.error,
          errorMessage: fail.message,
        );
      }, (userData) {
        ///assigning to current user
        currentUser = userData;
        return UpdateUserState(
          userDataUpdateStatus: ProviderStatus.success,
          user: userData,
        );
      });
      emit(state);
    });

    /*Upgrade to dealer*/
    on<UpgradeToDealerEvent>((event, emit) async {
      emit(const UpgradeToDealerState(
          upgradeToDealerStatus: ProviderStatus.loading));
      final result = await Locator.instance.get<UserRepo>().upgradeToDealerRepo(
            userData: event.userData,
            planId: event.planId,
            planName: event.planName,
            planType: event.planType,
            userId: event.userId,
          );
      final UpgradeToDealerState state = result.fold((fail) {
        return UpgradeToDealerState(
          upgradeToDealerStatus: ProviderStatus.error,
          errorMessage: fail.message,
        );
      }, (userData) {
        ///assigning to current user
        currentUser = userData;
        return UpgradeToDealerState(
            upgradeToDealerStatus: ProviderStatus.success, user: userData);
      });
      emit(state);
    });

    /*delete user data*/
    on<DeleteUserEvent>((event, emit) async {
      emit(const DeleteUserState(userDataDeleteStatus: ProviderStatus.loading));
      final result = await Locator.instance
          .get<UserRepo>()
          .deleteUserRepo(userData: event.userData);
      final UserState state = result.fold((fail) {
        return DeleteUserState(
          userDataDeleteStatus: ProviderStatus.error,
          errorMessage: fail.message,
        );
      }, (userData) {
        return DeleteUserState(
          userDataDeleteStatus: ProviderStatus.success,
          user: userData,
        );
      });
      emit(state);
    });

    /*Update user notification settings*/
    on<UpdateUserNotificationSettingsEvent>((event, emit) async {
      emit(const UpdateUserNotificationSettingsState(
          updateNotificationSettingsStatus: ProviderStatus.loading));
      final result =
          await Locator.instance.get<UserRepo>().updateNotificationSettingsRepo(
                status: event.status,
                userId: event.userId,
              );
      final UpdateUserNotificationSettingsState state = result.fold((fail) {
        return UpdateUserNotificationSettingsState(
          updateNotificationSettingsStatus: ProviderStatus.error,
          errorMessage: fail.message,
        );
      }, (userData) {
        ///assigning to current user
        currentUser = userData;
        return UpdateUserNotificationSettingsState(
            updateNotificationSettingsStatus: ProviderStatus.success,
            user: userData);
      });
      emit(state);
    });
  }
}
