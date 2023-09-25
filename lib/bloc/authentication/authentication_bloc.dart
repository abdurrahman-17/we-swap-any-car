import 'dart:developer';

import 'package:equatable/equatable.dart';

import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../repository/authentication_repo.dart';
import '../../repository/user_repo.dart';
import '../../service/shared_preference_service.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(SignInInitialState()) {
    on<SignInitialEvent>((event, emit) {
      emit(SignInInitialState());
    });

    /* signIn with email or phone*/
    on<SignInWithEmailOrPhoneEvent>((event, emit) async {
      emit(const SignInState(signInStatus: ProviderStatus.loading));
      final result = await Locator.instance
          .get<AuthenticationRepo>()
          .signInWithEmailOrPhone(
            emailOrPhone: event.emailOrPhone,
            isSignUp: event.isSignUp,
          );
      final AuthenticationState state = result.fold((fail) {
        return SignInState(
            signInStatus: ProviderStatus.error, errorMessage: fail.message);
      }, (success) {
        return SignInState(
          signInStatus: ProviderStatus.success,
          emailOrPhone: event.emailOrPhone,
        );
      });
      if (event.isSignUp) {
        final userData =
            await Locator.instance.get<UserRepo>().getCognitoUserData();
        Locator.instance
            .get<SharedPrefServices>()
            .setCognitoId(userData?.userId ?? '');
      }
      emit(state);
    });

    /*VerifyOTPEvent*/
    on<VerifyOTPEvent>((event, emit) async {
      // emit(SignInLoadingState());
      emit(OtpLoadingState());
      final result =
          await Locator.instance.get<AuthenticationRepo>().verifyOtp(event.otp);

      final AuthenticationState state = result.fold((fail) {
        return OtpVerifyFailedState(errorMessage: fail.message);
      }, (user) {
        ///setting user id to shared pref for future usage
        Locator.instance
            .get<SharedPrefServices>()
            .setCognitoId(user.cognitoId ?? '');
        log(user.userId.toString());
        return OtpVerifiedState();
      });
      emit(state);
    });

    /*Otp Resend */
    on<ResendOtpEvent>((event, emit) async {
      emit(OtpResendLoadingState());
      final result = await Locator.instance
          .get<AuthenticationRepo>()
          .signInWithEmailOrPhone(emailOrPhone: event.emailOrPhone);
      final AuthenticationState state = result.fold((fail) {
        return OtpResendFailedState();
      }, (success) {
        return OtpResendSuccessState(emailOrPhone: event.emailOrPhone);
      });
      emit(state);
    });

    /*Otp Resend for verification */
    on<EmailOrPhoneVerificationOtpResend>((event, emit) async {
      emit(OtpResendLoadingState());
      final result = await Locator.instance
          .get<AuthenticationRepo>()
          .sentVerificationOtpRepo(
            emailOrPhone: event.emailOrPhone,
            isEmail: event.isEmail,
          );
      final AuthenticationState state = result.fold((fail) {
        return OtpResendFailedState();
      }, (success) {
        return OtpResendSuccessState(emailOrPhone: event.emailOrPhone);
      });
      emit(state);
    });

    /*SignOut*/
    on<SignOutEvent>((event, emit) async {
      emit(const SignOutState(signOutStatus: ProviderStatus.loading));
      final result =
          await Locator.instance.get<AuthenticationRepo>().signOutUser();
      final state = result.fold((fail) {
        return const SignOutState(
          signOutStatus: ProviderStatus.error,
        );
      }, (s) {
        return const SignOutState(signOutStatus: ProviderStatus.success);
      });
      emit(state);
    });

    /*Send Email or phone verification mail*/
    on<EmailOrPhoneVerificationEvent>((event, emit) async {
      emit(EmailOrPhoneVerifyingState(isEmail: event.isEmail));
      final result = await Locator.instance
          .get<AuthenticationRepo>()
          .sentVerificationOtpRepo(
            emailOrPhone: event.emailOrPhone,
            isEmail: event.isEmail,
          );
      final state = result.fold((fail) {
        return OtpSendErrorState(errorMessage: fail.message);
      }, (s) {
        return OtpSendSuccessState(
          emailOrPhone: event.emailOrPhone,
          isLogin: false,
        );
      });
      emit(state);
    });

    /*Confirm Email or phone verification code*/
    on<EmailOrPhoneVerificationConfirmEvent>((event, emit) async {
      emit(OtpLoadingState());
      final result = await Locator.instance
          .get<AuthenticationRepo>()
          .confirmVerificationOtpRepo(
            emailOrPhone: event.emailOrPhone,
            isEmail: event.isEmail,
            verificationCode: event.verificationCode,
          );
      final state = result.fold((fail) {
        return OtpVerifyFailedState(errorMessage: fail.message);
      }, (s) {
        return OtpVerifiedState();
      });
      emit(state);
    });

    /*Send update phone OTP verification code*/
    on<UpdatePhoneVerificationEvent>((event, emit) async {
      emit(const EmailOrPhoneVerifyingState(isEmail: false));
      final result = await Locator.instance
          .get<AuthenticationRepo>()
          .sendUpdatePhoneVerificationOtpRepo(
            phoneNumber: event.phoneNumber,
            newPhoneNumber: event.newphoneNumber,
            continueWithReq: event.continueWithReq,
          );
      final state = result.fold((fail) {
        return UpdateOtpSendErrorState(
          errorMessage: fail.message,
          data: fail.data,
        );
      }, (s) {
        return UpdateOtpSendSuccessState(
          phoneNumber: event.phoneNumber,
          newPhoneNumber: event.newphoneNumber,
          isLogin: false,
        );
      });
      emit(state);
    });

    /*Confirm Email or phone verification code*/
    on<UpdatePhoneVerificationConfirmEvent>((event, emit) async {
      emit(OtpLoadingState());
      final result = await Locator.instance
          .get<AuthenticationRepo>()
          .confirmUpdatePhoneVerificationOtpRepo(
            phoneNumber: event.phoneNumber,
            newPhoneNumber: event.newphoneNumber,
            verificationCode: event.verificationCode,
            continueWithReq: event.continueWithReq,
          );
      final state = result.fold((fail) {
        return OtpVerifyFailedState(errorMessage: fail.message);
      }, (s) {
        return OtpVerifiedState();
      });
      emit(state);
    });

    /*Otp Resend for Update phone number verification */
    on<UpdatePhoneVerificationOtpResend>((event, emit) async {
      emit(OtpResendLoadingState());
      final result = await Locator.instance
          .get<AuthenticationRepo>()
          .sendUpdatePhoneVerificationOtpRepo(
            phoneNumber: event.phoneNumber,
            newPhoneNumber: event.newphoneNumber,
            continueWithReq: event.continueWithReq,
          );
      final AuthenticationState state = result.fold((fail) {
        return UpdateOtpResendFailedState();
      }, (success) {
        return UpdateOtpResendSuccessState(
          phoneNumber: event.phoneNumber,
          newPhoneNumber: event.newphoneNumber,
        );
      });
      emit(state);
    });

    /* signUp with email or phone*/
    on<SignUpWithEmailOrPhoneEvent>((event, emit) async {
      emit(const SignUpState(signUpStatus: ProviderStatus.loading));
      final result = await Locator.instance
          .get<AuthenticationRepo>()
          .signUpWithEmailOrPhone(
              emailOrPhone: event.emailOrPhone,
              userAttributes: event.userAttributes);
      final AuthenticationState state = result.fold((fail) {
        //signUp failed
        return SignUpState(
          signUpStatus: ProviderStatus.error,
          errorMessage: fail.message,
        );
      }, (success) {
        return SignUpState(
            signUpStatus: ProviderStatus.success,
            emailOrPhone: event.emailOrPhone);
      });
      emit(state);
    });

    //google signIn
    on<SignInWithGoogleEvent>((event, emit) async {
      emit(const SignInState(
        signInStatus: ProviderStatus.loading,
        socialLogin: SocialLogin.google,
      ));

      final result = await Locator.instance
          .get<AuthenticationRepo>()
          .socialLogin(SocialLogin.google);
      final AuthenticationState state = result.fold((fail) {
        return SignInState(
            signInStatus: ProviderStatus.error,
            errorMessage: fail.message,
            socialLogin: SocialLogin.google);
      }, (user) {
        ///setting user id to shared pref for future usage
        Locator.instance
            .get<SharedPrefServices>()
            .setCognitoId(user.cognitoId ?? '');
        Locator.instance
            .get<AuthenticationRepo>()
            .setLoginType(SocialLogin.google);
        return const SignInState(
            signInStatus: ProviderStatus.success,
            socialLogin: SocialLogin.google);
      });
      emit(state);
    });

    //facebook signIn
    on<SignInWithFacebookEvent>((event, emit) async {
      emit(const SignInState(
        signInStatus: ProviderStatus.loading,
        socialLogin: SocialLogin.facebook,
      ));

      final result = await Locator.instance
          .get<AuthenticationRepo>()
          .socialLogin(SocialLogin.facebook);
      final AuthenticationState state = result.fold((fail) {
        return SignInState(
            signInStatus: ProviderStatus.error,
            errorMessage: fail.message,
            socialLogin: SocialLogin.facebook);
      }, (user) {
        ///setting user id to shared pref for future usage
        Locator.instance
            .get<SharedPrefServices>()
            .setCognitoId(user.cognitoId ?? '');
        Locator.instance
            .get<AuthenticationRepo>()
            .setLoginType(SocialLogin.facebook);
        return const SignInState(
            signInStatus: ProviderStatus.success,
            socialLogin: SocialLogin.facebook);
      });
      emit(state);
    });

    //apple signIn
    on<SignInWithAppleEvent>((event, emit) async {
      emit(const SignInState(
        signInStatus: ProviderStatus.loading,
        socialLogin: SocialLogin.apple,
      ));

      final result = await Locator.instance
          .get<AuthenticationRepo>()
          .socialLogin(SocialLogin.apple);
      final AuthenticationState state = result.fold((fail) {
        return SignInState(
            signInStatus: ProviderStatus.error,
            errorMessage: fail.message,
            socialLogin: SocialLogin.apple);
      }, (user) {
        ///setting user id to shared pref for future usage
        Locator.instance
            .get<SharedPrefServices>()
            .setCognitoId(user.cognitoId ?? '');
        Locator.instance
            .get<AuthenticationRepo>()
            .setLoginType(SocialLogin.apple);
        return const SignInState(
            signInStatus: ProviderStatus.success,
            socialLogin: SocialLogin.apple);
      });
      emit(state);
    });

    //twitter signIn
    on<SignInWithTwitterEvent>((event, emit) async {
      emit(const SignInState(
        signInStatus: ProviderStatus.loading,
        socialLogin: SocialLogin.twitter,
      ));

      final result = await Locator.instance
          .get<AuthenticationRepo>()
          .twitterLoginApi(
              secret: event.authTokenSecret, token: event.authToken);
      late AuthenticationState state;
      state = await result.fold((fail) {
        return SignInState(
            signInStatus: ProviderStatus.error,
            errorMessage: fail.message,
            socialLogin: SocialLogin.twitter);
      }, (data) async {
        log("$data");
        final response = await Locator.instance
            .get<AuthenticationRepo>()
            .tokenLogin(
                email: data['email'] as String,
                socialMediaId: data['socialMediaID'] as String,
                socialType: "TWITTER");
        return state = response.fold(
            (fail) => SignInState(
                signInStatus: ProviderStatus.error,
                errorMessage: fail.message,
                socialLogin: SocialLogin.twitter), (user) {
          Locator.instance
              .get<SharedPrefServices>()
              .setCognitoId(user.cognitoId ?? '');
          Locator.instance
              .get<AuthenticationRepo>()
              .setLoginType(SocialLogin.twitter);
          return const SignInState(
              signInStatus: ProviderStatus.success,
              socialLogin: SocialLogin.twitter);
        });
      });
      emit(state);
    });

    //tiktok signIn
    on<SignInWithTikTokEvent>((event, emit) async {
      emit(const SignInState(
        signInStatus: ProviderStatus.loading,
        socialLogin: SocialLogin.tiktok,
      ));
      final result = await Locator.instance
          .get<AuthenticationRepo>()
          .tiktokLoginApi(
              code: "${event.loginResult['code']}",
              state: "${event.loginResult['state']}",
              scopes: "${event.loginResult['scopes']}");
      late AuthenticationState state;
      state = await result.fold((fail) {
        return SignInState(
            signInStatus: ProviderStatus.error,
            errorMessage: fail.message,
            socialLogin: SocialLogin.tiktok);
      }, (data) async {
        log("$data");
        final response =
            await Locator.instance.get<AuthenticationRepo>().tokenLogin(
                  email: data['email'] as String,
                  socialMediaId: data['socialMediaID'] as String,
                  socialType: "TIKTOK",
                );
        return state = response.fold(
            (fail) => SignInState(
                signInStatus: ProviderStatus.error,
                errorMessage: fail.message,
                socialLogin: SocialLogin.tiktok), (user) {
          Locator.instance
              .get<SharedPrefServices>()
              .setCognitoId(user.cognitoId ?? '');
          Locator.instance
              .get<AuthenticationRepo>()
              .setLoginType(SocialLogin.tiktok);
          return const SignInState(
              signInStatus: ProviderStatus.success,
              socialLogin: SocialLogin.tiktok);
        });
      });
      emit(state);
    });
  }
}
