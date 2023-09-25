part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class SignInitialEvent extends AuthenticationEvent {}

class SignInWithEmailOrPhoneEvent extends AuthenticationEvent {
  final String emailOrPhone;
  final bool isSignUp;

  const SignInWithEmailOrPhoneEvent({
    required this.emailOrPhone,
    this.isSignUp = false,
  });
}

class ResendOtpEvent extends AuthenticationEvent {
  final String emailOrPhone;

  const ResendOtpEvent({required this.emailOrPhone});
}

class VerifyOTPEvent extends AuthenticationEvent {
  final String otp;

  const VerifyOTPEvent({required this.otp});
}

class SignInWithGoogleEvent extends AuthenticationEvent {}

class SignInWithFacebookEvent extends AuthenticationEvent {}

class SignInWithAppleEvent extends AuthenticationEvent {}

class SignInWithTwitterEvent extends AuthenticationEvent {
  final String authToken;
  final String authTokenSecret;
  const SignInWithTwitterEvent(
      {required this.authToken, required this.authTokenSecret});
}

class SignInWithTikTokEvent extends AuthenticationEvent {
  final Map<String, dynamic> loginResult;
  const SignInWithTikTokEvent({required this.loginResult});
}

class SignInWithInstagramEvent extends AuthenticationEvent {}

class SignOutEvent extends AuthenticationEvent {}

class EmailOrPhoneVerificationEvent extends AuthenticationEvent {
  final String emailOrPhone;
  final bool isEmail;

  const EmailOrPhoneVerificationEvent({
    required this.emailOrPhone,
    required this.isEmail,
  });
}

class EmailOrPhoneVerificationConfirmEvent extends AuthenticationEvent {
  final String emailOrPhone;
  final bool isEmail;
  final String verificationCode;

  const EmailOrPhoneVerificationConfirmEvent({
    required this.emailOrPhone,
    required this.isEmail,
    required this.verificationCode,
  });
}

class UpdatePhoneVerificationEvent extends AuthenticationEvent {
  final String phoneNumber;
  final String newphoneNumber;
  final bool continueWithReq;

  const UpdatePhoneVerificationEvent({
    required this.phoneNumber,
    required this.newphoneNumber,
    required this.continueWithReq,
  });
}

class UpdatePhoneVerificationConfirmEvent extends AuthenticationEvent {
  final String phoneNumber;
  final String newphoneNumber;
  final String verificationCode;
  final bool continueWithReq;

  const UpdatePhoneVerificationConfirmEvent({
    required this.phoneNumber,
    required this.newphoneNumber,
    required this.verificationCode,
    required this.continueWithReq,
  });
}

class UpdatePhoneVerificationOtpResend extends AuthenticationEvent {
  final String phoneNumber;
  final String newphoneNumber;
  final bool continueWithReq;
  const UpdatePhoneVerificationOtpResend({
    required this.phoneNumber,
    required this.newphoneNumber,
    required this.continueWithReq,
  });
}

class SignUpWithEmailOrPhoneEvent extends AuthenticationEvent {
  final String emailOrPhone;
  final Map<String, String> userAttributes;

  const SignUpWithEmailOrPhoneEvent({
    required this.emailOrPhone,
    required this.userAttributes,
  });
}

class EmailOrPhoneVerificationOtpResend extends AuthenticationEvent {
  final String emailOrPhone;
  final bool isEmail;
  const EmailOrPhoneVerificationOtpResend({
    required this.emailOrPhone,
    required this.isEmail,
  });
}
