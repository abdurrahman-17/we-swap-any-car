// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:aws_common/vm.dart';
import 'package:dartz/dartz.dart';
import 'package:wsac/utility/file_utils.dart';

import '../../core/configurations.dart';
import '../../model/error_model.dart';
import '../../model/user/user_model.dart';
import '../../utility/date_time_utils.dart';
import 'amplify_configuration.dart';

class AmplifyService {
  //configuring amplify plugin
  Future<void> configureAmplify() async {
    try {
      final AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
      final AmplifyAPI amplifyAPI = AmplifyAPI();
      final AmplifyStorageS3 amplifyStorageS3 = AmplifyStorageS3();
      await Amplify.addPlugins([
        authPlugin,
        amplifyAPI,
        amplifyStorageS3,
      ]);
      await Amplify.configure(json.encode(amplifyConfigString));
      log("amplify configured successfully");
    } on AmplifyAlreadyConfiguredException catch (e) {
      log("AmplifyAlreadyConfiguredException:$e");
    } catch (e) {
      log("configureAmplifyException:$e");
    }
  }

  ///fetch user attributes
  Future<Map<String, dynamic>?> getUserAttributes() async {
    try {
      List<AuthUserAttribute> userAttributes =
          await Amplify.Auth.fetchUserAttributes();
      Map<String, dynamic> tempAttributes = {};
      log(userAttributes.toString());
      for (var element in userAttributes) {
        switch (element.userAttributeKey.key) {
          case "sub":
            tempAttributes["cognitoId"] = element.value;
            break;
          case "name":
            tempAttributes["firstName"] = element.value;
            break;
          case "nickname":
            tempAttributes["lastName"] = element.value;
            break;
          case "email":
            tempAttributes["email"] = element.value;
            break;
          case "email_verified":
            tempAttributes["emailVerified"] = element.value;
            break;

          case "phone_number":
            tempAttributes["phone"] = element.value;
            break;
          case "phone_number_verified":
            tempAttributes["phoneVerified"] = element.value;
            break;
        }
      }
      return tempAttributes;
    } catch (e) {
      log('getUserData:$e');
      return null;
    }
  }

  //get user data
  Future<AuthUser?> getCognitoUserData() async {
    try {
      AuthUser user = await Amplify.Auth.getCurrentUser();
      log(user.userId);
      log(user.username);
      log(user.signInDetails.toString());
      return user;
    } catch (e) {
      log('getUserDataException:$e');
      return null;
    }
  }

  //functions helps to check whether the user is already signed or not
  Future<bool> checkAuthenticated() async {
    try {
      var session = await Amplify.Auth.fetchAuthSession();
      final authenticated = session.isSignedIn;
      log("session:$authenticated");
      return authenticated;
    } on AuthException catch (error) {
      log("error ${error.message}");
    } catch (error) {
      log("error $error");
    }
    return false;
  }

  //this function helps regenerate new token
  Future<CognitoUserPoolTokens?> getToken() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession(
        options: const FetchAuthSessionOptions(),
      );
      final tokens = (session as CognitoAuthSession).userPoolTokensResult.value;
      log("accessToken: ${tokens.accessToken}");
      return tokens;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  //passwordless signUp
  Future<Either<ErrorModel, SignUpResult>> signUpUser(String emailOrPhone,
      {required Map<String, String> userAttributes}) async {
    try {
      log("SignUp:$emailOrPhone");
      final options = SignUpOptions(
        userAttributes: {
          CognitoUserAttributeKey.profile: "user",
          CognitoUserAttributeKey.phoneNumber: userAttributes['phoneNumber']!,
          CognitoUserAttributeKey.email: userAttributes['email']!,
          CognitoUserAttributeKey.givenName: userAttributes['firstName']!,
          CognitoUserAttributeKey.familyName: userAttributes['lastName']!
        },
      );

      final result = await Amplify.Auth.signUp(
        // username: emailOrPhone,
        username: "${getCurrentDateTime().microsecondsSinceEpoch}",
        password: signUpPassword,
        options: options,
      );
      return Right(result);
    } on UsernameExistsException catch (e) {
      return Left(ErrorModel(message: e.message));
    } on AuthException catch (e) {
      log("error $e");
      String errorMessage = loginFailed;
      if (e.underlyingException.toString().contains(incorrectUsername)) {
        errorMessage = incorrectEmail;
      }
      safePrint("error ${e.underlyingException}");
      return Left(ErrorModel(message: errorMessage));
    } catch (e) {
      log("error:$e");
      return Left(ErrorModel(message: noInternetConnection));
    }
  }

  //passwordless signIn
  Future<Either<ErrorModel, SignInResult>> signInUser(
      {required String emailOrPhone, bool isSignUp = false}) async {
    try {
      log("SignIn:$emailOrPhone");
      String type = emailType;
      final options = SignInOptions(
          pluginOptions: CognitoSignInPluginOptions(
        authFlowType: isSignUp
            ? AuthenticationFlowType.userSrpAuth
            : AuthenticationFlowType.customAuthWithoutSrp,
      ));
      //PHONE login
      if (isStringNumeric(emailOrPhone)) {
        emailOrPhone = countryCode + emailOrPhone;
        type = phoneType;
      }
      final result = await Amplify.Auth.signIn(
        username: emailOrPhone,
        options: options,
        password: isSignUp ? signUpPassword : null,
      );
      if (isSignUp) {
        return Right(result);
      }
      final confirmResult = await confirmSignIn(
        loginWithEmailOrPhone,
        emailOrPhoneType: type,
      );
      return confirmResult.fold((l) => Left(l), (r) => Right(result));
    } on LambdaException catch (e) {
      String errorMessage = loginFailed;
      if (e.underlyingException.toString().contains("no phone found")) {
        errorMessage = incorrectEmail;
      } else if (e.underlyingException.toString().contains("no email found")) {
        errorMessage = incorrectEmail;
      } else if (e.underlyingException.toString().contains("USER_NOT_ACTIVE")) {
        errorMessage = incorrectEmail;
      }
      return Left(ErrorModel(message: errorMessage));
    } on AuthException catch (e) {
      log("AuthException: $e");
      String errorMessage = loginFailed;
      if (e.underlyingException.toString().contains(incorrectUsername)) {
        errorMessage = incorrectEmail;
      } else if (e.message.contains(alreadySignedIn)) {
        errorMessage = e.message;
      }

      log("error ${e.underlyingException}");
      return Left(ErrorModel(message: errorMessage));
    } catch (e) {
      safePrint("error");
      log(e.toString());
      return Left(ErrorModel(message: noInternetConnection));
    }
  }

  //confirm signIn
  Future<Either<ErrorModel, UserModel>> confirmSignIn(String generatedNumber,
      {String? emailOrPhoneType}) async {
    try {
      log("confirmSignIn:$generatedNumber");
      ConfirmSignInOptions? options;
      if (emailOrPhoneType != null) {
        options = ConfirmSignInOptions(
          pluginOptions: CognitoConfirmSignInPluginOptions(
            clientMetadata: {loginWithEmailOrPhone: emailOrPhoneType},
          ),
        );
      }
      final result = await Amplify.Auth.confirmSignIn(
        confirmationValue: generatedNumber,
        options: options,
      );
      if (generatedNumber == loginWithEmailOrPhone) {
        return Right(UserModel());
      } else if (result.isSignedIn) {
        AuthUser? authUser = await getCognitoUserData();
        UserModel user = UserModel(userId: authUser?.userId);
        return Right(user);
      } else {
        return Left(ErrorModel(message: invalidOtp));
      }
    } on LambdaException catch (e) {
      String errorMessage = loginFailed;
      if (e.underlyingException.toString().contains("no phone found")) {
        errorMessage = incorrectEmail;
      } else if (e.underlyingException.toString().contains("no email found")) {
        errorMessage = incorrectEmail;
      } else if (e.underlyingException.toString().contains("USER_NOT_ACTIVE")) {
        errorMessage = incorrectEmail;
      }
      return Left(ErrorModel(message: errorMessage));
    } on AuthException catch (e) {
      log("confirmSignInException: $e");
      String errorMessage = loginFailed;
      if (e.underlyingException.toString().contains(incorrectUsername)) {
        errorMessage = deactivateMessage;
      }
      return Left(ErrorModel(message: errorMessage));
    } catch (e) {
      log("confirmSignInException:$e");
      return Left(ErrorModel(message: noInternetConnection));
    }
  }

//user signOut
  Future<Either<ErrorModel, SignOutResult>> signOut() async {
    try {
      log("signOut");
      final result = await Amplify.Auth.signOut();
      log(result.toString());
      return Right(result);
    } on AuthException catch (e) {
      log("error $e");
      safePrint("error ${e.underlyingException}");
      return Left(ErrorModel(message: e.message));
    } catch (e) {
      safePrint("error");
      log(e.toString());
      return Left(ErrorModel(message: "SignOut failed"));
    }
  }

  //social login
  Future<Either<ErrorModel, UserModel>> signInWithSocialLogin(
      SocialLogin loginType) async {
    try {
      SignInResult? result;
      switch (loginType) {
        case SocialLogin.google:
          result = await Amplify.Auth.signInWithWebUI(
            provider: AuthProvider.google,
            options: const SignInWithWebUIOptions(
              pluginOptions: CognitoSignInWithWebUIPluginOptions(
                isPreferPrivateSession: true,
              ),
            ),
          );
          break;
        case SocialLogin.facebook:
          result = await Amplify.Auth.signInWithWebUI(
            provider: AuthProvider.facebook,
            options: const SignInWithWebUIOptions(
              pluginOptions: CognitoSignInWithWebUIPluginOptions(
                isPreferPrivateSession: true,
              ),
            ),
          );
          break;
        case SocialLogin.apple:
          result = await Amplify.Auth.signInWithWebUI(
            provider: AuthProvider.apple,
            options: const SignInWithWebUIOptions(
              pluginOptions: CognitoSignInWithWebUIPluginOptions(
                isPreferPrivateSession: true,
              ),
            ),
          );
          break;
        default:
          result = null;
          break;
      }

      if (result != null) {
        log("socialAuth:${result.isSignedIn}");
        AuthUser? authUser = await getCognitoUserData();
        UserModel user = UserModel(cognitoId: authUser?.userId);
        return Right(user);
      } else {
        return Left(ErrorModel(message: "$loginType is not implemented"));
      }
    } on UrlLauncherException catch (e) {
      log("UrlLauncherException:$e");
      return Left(ErrorModel(message: ''));
    } on UserCancelledException catch (e) {
      log("UserCancelledException:$e");
      return Left(ErrorModel(message: ''));
    } on AmplifyException catch (e) {
      log("AmplifyException:$e");
      return Left(ErrorModel(message: e.message));
    } catch (e) {
      log("catch:$e");
      return Left(ErrorModel(message: noInternetConnection));
    }
  }

  //s3 bucket upload file
  Future<String?> uploadFileToS3Bucket({
    required String filePath,
    String? fileName,
    void Function(double)? progressFunction,
  }) async {
    try {
      final file = AWSFilePlatform.fromFile(File(filePath));
      fileName ??= File(filePath).name;
      final fileNameTemp = fileName.replaceAllWhiteSpace();
      final result = await Amplify.Storage.uploadFile(
        localFile: file,
        key: fileNameTemp,
        onProgress: (progress) {
          safePrint('Fraction completed: ${progress.fractionCompleted}');
          if (progressFunction != null) {
            progressFunction(progress.fractionCompleted);
          }
        },
      ).result;
      log('Successfully uploaded file: ${result.uploadedItem.key}');
      return result.uploadedItem.key;
    } on StorageException catch (e) {
      log('Upload file failed: $e');
    }
    return null;
  }

  Future<String?> getS3ImageUrl(String key) async {
    try {
      final urlResult = await Amplify.Storage.getUrl(key: key).result;
      log("getS3Image:${urlResult.url}");
      return urlResult.url.toString();
    } catch (e) {
      log("getS3Image:$e");
    }
    return null;
  }

  //twitter
  Future<Either<ErrorModel, UserModel>> tokenLogin({
    required String email,
    required String socialMediaId,
    required String socialType,
  }) async {
    try {
      const options = SignInOptions(
          pluginOptions: CognitoSignInPluginOptions(
        authFlowType: AuthenticationFlowType.customAuthWithoutSrp,
      ));
      final result = await Amplify.Auth.signIn(
        username: email,
        options: options,
      );
      if (!result.isSignedIn) {
        final confirmOption = ConfirmSignInOptions(
          pluginOptions: CognitoConfirmSignInPluginOptions(
            clientMetadata: {loginWithEmailOrPhone: 'TOKEN'},
          ),
        );
        final result2 = await Amplify.Auth.confirmSignIn(
          confirmationValue: loginWithEmailOrPhone,
          options: confirmOption,
        );

        if (!result2.isSignedIn) {
          final result3 = await Amplify.Auth.confirmSignIn(
            confirmationValue: "$socialType===$socialMediaId",
          );

          if (result3.isSignedIn) {
            AuthUser? authUser = await getCognitoUserData();
            UserModel user = UserModel(cognitoId: authUser?.userId);
            return Right(user);
          }
        }
      }
      return Left(ErrorModel(message: "Login failed"));
    } catch (e) {
      log("$e");
      return Left(ErrorModel(message: errorOccurred));
    }
  }
}
