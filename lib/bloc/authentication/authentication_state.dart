part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class SignInInitialState extends AuthenticationState {}

class SignInState extends AuthenticationState {
  final ProviderStatus signInStatus;
  final SocialLogin? socialLogin;
  final String? emailOrPhone;
  final String? errorMessage;
  const SignInState({
    required this.signInStatus,
    this.emailOrPhone,
    this.errorMessage,
    this.socialLogin = SocialLogin.none,
  });
  @override
  List<Object> get props => [signInStatus];
}

class OtpLoadingState extends AuthenticationState {}

class OtpVerifiedState extends AuthenticationState {}

class OtpVerifyFailedState extends AuthenticationState {
  final String errorMessage;
  const OtpVerifyFailedState({required this.errorMessage});
}

class OtpSendSuccessState extends AuthenticationState {
  const OtpSendSuccessState({
    required this.emailOrPhone,
    this.isLogin = true,
  });
  final bool isLogin;
  final String emailOrPhone;
}

class OtpSendErrorState extends AuthenticationState {
  final String errorMessage;
  const OtpSendErrorState({required this.errorMessage});
}

class OtpResendSuccessState extends AuthenticationState {
  const OtpResendSuccessState({required this.emailOrPhone});
  final String emailOrPhone;
}

class OtpResendFailedState extends AuthenticationState {}

class OtpResendLoadingState extends AuthenticationState {}

class UpdateOtpSendSuccessState extends AuthenticationState {
  const UpdateOtpSendSuccessState({
    required this.phoneNumber,
    required this.newPhoneNumber,
    this.isLogin = true,
  });
  final bool isLogin;
  final String phoneNumber;
  final String newPhoneNumber;
}

class UpdateOtpSendErrorState extends AuthenticationState {
  final String errorMessage;
  final Map<String, dynamic>? data;
  const UpdateOtpSendErrorState({
    required this.errorMessage,
    this.data,
  });
}

class UpdateOtpResendSuccessState extends AuthenticationState {
  const UpdateOtpResendSuccessState({
    required this.phoneNumber,
    required this.newPhoneNumber,
  });
  final String phoneNumber;
  final String newPhoneNumber;
}

class UpdateOtpResendFailedState extends AuthenticationState {}

class SignOutState extends AuthenticationState {
  final ProviderStatus signOutStatus;
  const SignOutState({required this.signOutStatus});
  @override
  List<Object> get props => [signOutStatus];
}

class EmailOrPhoneVerifyingState extends AuthenticationState {
  final bool isEmail;

  const EmailOrPhoneVerifyingState({required this.isEmail});
}

class SignUpState extends AuthenticationState {
  final ProviderStatus signUpStatus;
  final String? emailOrPhone;
  final String? errorMessage;
  const SignUpState({
    required this.signUpStatus,
    this.emailOrPhone,
    this.errorMessage,
  });
  @override
  List<Object> get props => [signUpStatus];
}
