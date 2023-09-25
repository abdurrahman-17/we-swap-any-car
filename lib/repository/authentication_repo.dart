import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:dartz/dartz.dart';
import 'package:enum_to_string/enum_to_string.dart';

import '../core/configurations.dart';
import '../core/locator.dart';
import '../model/error_model.dart';
import '../model/response_model.dart';
import '../model/user/user_model.dart';
import '../service/amplify_service/amplify_service.dart';
import '../service/api_service/api_service.dart';
import '../service/shared_preference_service.dart';

class AuthenticationRepo {
  Future<Either<ErrorModel, SignInResult>> signInWithEmailOrPhone(
      {required String emailOrPhone, bool isSignUp = false}) async {
    return await Locator.instance.get<AmplifyService>().signInUser(
        emailOrPhone: emailOrPhone.replaceAllWhiteSpace(), isSignUp: isSignUp);
  }

  Future<Either<ErrorModel, UserModel>> verifyOtp(String otp) async {
    return await Locator.instance.get<AmplifyService>().confirmSignIn(otp);
  }

  Future<Either<ErrorModel, SignOutResult>> signOutUser() async {
    return await Locator.instance.get<AmplifyService>().signOut();
  }

  Future<CognitoUserPoolTokens?> getRefreshToken() async {
    return await Locator.instance.get<AmplifyService>().getToken();
  }

  Future<Either<ErrorModel, UserModel>> socialLogin(
      SocialLogin socialLogin) async {
    return await Locator.instance
        .get<AmplifyService>()
        .signInWithSocialLogin(socialLogin);
  }

  Future<bool> checkAuthenticated() async {
    return await Locator.instance.get<AmplifyService>().checkAuthenticated();
  }

  void saveEmailOrPhone(String emailOrPhone) => Locator.instance
      .get<SharedPrefServices>()
      .setRememberSignIn(emailOrPhone);

  String getEmailOrPhone() =>
      Locator.instance.get<SharedPrefServices>().getRememberSignIn();

  void clearEmailOrPhone() =>
      Locator.instance.get<SharedPrefServices>().clearRememberSignIn();

  Future<Either<ErrorModel, ResponseModel>> sentVerificationOtpRepo({
    required String emailOrPhone,
    required bool isEmail,
  }) async {
    emailOrPhone = emailOrPhone.replaceAllWhiteSpace();
    log("emailOrPhone:$emailOrPhone");
    bool exist = await Locator.instance.get<ApiService>().checkUserExistsOrNot(
        emailOrPhone,
        isEmail ? {"email": emailOrPhone} : {"phoneNumber": emailOrPhone});
    if (exist) {
      return Left(ErrorModel(
          message:
              "This ${isEmail ? "email" : "phone number"} already exists"));
    } else {
      return Locator.instance
          .get<ApiService>()
          .sentVerificationOtpApi(emailOrPhone: emailOrPhone, isEmail: isEmail);
    }
  }

  Future<Either<ErrorModel, ResponseModel>> confirmVerificationOtpRepo(
          {required String emailOrPhone,
          required bool isEmail,
          required String verificationCode}) async =>
      await Locator.instance.get<ApiService>().confirmVerificationOtpApi(
            emailOrPhone: emailOrPhone,
            isEmail: isEmail,
            verificationCode: verificationCode,
          );

  //Send update phone number OTP
  Future<Either<ErrorModel, ResponseModel>> sendUpdatePhoneVerificationOtpRepo({
    required String phoneNumber,
    required String newPhoneNumber,
    required bool continueWithReq,
  }) async {
    phoneNumber = phoneNumber.replaceAllWhiteSpace();
    newPhoneNumber = newPhoneNumber.replaceAllWhiteSpace();
    log("phoneNumber: $phoneNumber");
    log("newPhoneNumber: $newPhoneNumber");

    return Locator.instance.get<ApiService>().sendUpdatePhoneVerificationOtp(
          phoneNumber: phoneNumber,
          newPhoneNumber: newPhoneNumber,
          continueWithReq: continueWithReq,
        );
  }

  //Verify update phone number OTP
  Future<Either<ErrorModel, ResponseModel>>
      confirmUpdatePhoneVerificationOtpRepo({
    required String phoneNumber,
    required String newPhoneNumber,
    required String verificationCode,
    required bool continueWithReq,
  }) async =>
          await Locator.instance
              .get<ApiService>()
              .confirmUpdatePhoneVerificationOtpApi(
                phoneNumber: phoneNumber,
                newPhoneNumber: newPhoneNumber,
                verificationCode: verificationCode,
                continueWithReq: continueWithReq,
              );

  Future<Either<ErrorModel, SignUpResult>> signUpWithEmailOrPhone({
    required String emailOrPhone,
    required Map<String, String> userAttributes,
  }) async {
    return await Locator.instance
        .get<AmplifyService>()
        .signUpUser(emailOrPhone, userAttributes: userAttributes);
  }

  void setLoginType(Enum loginType) {
    Locator.instance
        .get<SharedPrefServices>()
        .setLoginType(convertEnumToString(loginType));
  }

  SocialLogin getLoginType() {
    final String loginType =
        Locator.instance.get<SharedPrefServices>().getLoginType();
    return EnumToString.fromString(SocialLogin.values, loginType)!;
  }

//fetching email and phone number from token
  Future<
      ({
        String email,
        bool isEmailVerified,
        String phone,
        bool isPhoneVerified,
        String firstName,
        String lastName,
      })> populateUserData() async {
    final result = await getRefreshToken();
    var phone = result?.idToken.phoneNumber ?? '';
    if (phone.startsWith(countryCode)) {
      phone = phone.replaceAll(countryCode, '');
    }
    final data = (
      email: result?.idToken.email ?? '',
      isEmailVerified: result?.idToken.emailVerified ?? false,
      phone: phone,
      isPhoneVerified: result?.idToken.phoneNumberVerified ?? false,
      firstName: result?.idToken.givenName ?? '',
      lastName: result?.idToken.familyName ?? ''
    );
    log(data.toString());
    return data;
  }

  Future<Either<ErrorModel, bool>> updateCognito({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
  }) async {
    return Locator.instance.get<ApiService>().updateCognito(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber);
  }

//twitter login
  Future<Either<ErrorModel, Map<String, String>>> twitterLoginApi({
    required String secret,
    required String token,
  }) async =>
      Locator.instance.get<ApiService>().twitterLoginApi(
            secret: secret,
            token: token,
          );

  //tiktok login
  Future<Either<ErrorModel, Map<String, String>>> tiktokLoginApi({
    required String code,
    required String state,
    required String scopes,
  }) async =>
      Locator.instance.get<ApiService>().tiktokLoginApi(
            code: code,
            state: state,
            scopes: scopes,
          );

  //token login
  Future<Either<ErrorModel, UserModel>> tokenLogin(
          {required String email,
          required String socialMediaId,
          required String socialType}) async =>
      Locator.instance.get<AmplifyService>().tokenLogin(
            email: email,
            socialMediaId: socialMediaId,
            socialType: socialType,
          );
}
