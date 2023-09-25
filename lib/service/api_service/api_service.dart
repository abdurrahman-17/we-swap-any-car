// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../core/configurations.dart';
import '../../model/avatar/upload_profile_response_model.dart';
import '../../model/car_detail_model/hpi_response_model.dart';
import '../../model/car_model/my_cars_response.dart';
import '../../model/error_model.dart';
import '../../model/one_auto_response_model.dart';
import '../../model/payment/payment_checkout_response.dart';
import '../../model/post_code/address_detail_model.dart';
import '../../model/post_code/address_model.dart';
import '../../model/response_model.dart';
import '../../model/send_email_response_model.dart';
import '../../utility/urls.dart';
import 'api_manager.dart';

class ApiService {
  Future<Either<ErrorModel, GetCarsResponseModel>> getGuestCarListApi(
      {required Map<String, dynamic> listingParams}) async {
    try {
      var result = await ApiManager.makeApiCall(
        guestCarList,
        body: listingParams,
        apiCallType: ApiCallType.POST,
      );

      return result.fold((error) => Left(error), (response) {
        final json = response as Map<String, dynamic>;
        if (json.containsKey('data') && json['data'] != null) {
          return Right(GetCarsResponseModel.fromJson(
              json['data'] as Map<String, dynamic>));
        } else {
          return Right(GetCarsResponseModel(cars: []));
        }
      });
    } catch (e) {
      log('getGuestCarListApi:$e');
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  Future<Either<ErrorModel, ResponseModel>> sentVerificationOtpApi(
      {required String emailOrPhone, required bool isEmail}) async {
    try {
      final Map<String, dynamic> body = isEmail
          ? {'email': emailOrPhone, 'isEmail': true}
          : {'phoneNumber': emailOrPhone, 'isPhoneNumber': true};
      var result = await ApiManager.makeApiCall(
        authSendVerify,
        body: body,
        apiCallType: ApiCallType.POST,
      );

      log(result.toString());
      return result.fold(
        (error) => Left(error),
        (response) =>
            Right(ResponseModel.fromJson(response as Map<String, dynamic>)),
      );
    } catch (e) {
      log('sentVerificationOtpApi:$e');
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  Future<Either<ErrorModel, ResponseModel>> confirmVerificationOtpApi(
      {required String emailOrPhone,
      required bool isEmail,
      required String verificationCode}) async {
    try {
      final Map<String, dynamic> body = isEmail
          ? {
              'isEmail': true,
              'email': emailOrPhone,
              'emailVerificationCode': verificationCode
            }
          : {
              'isPhoneNumber': true,
              'phoneNumber': emailOrPhone.replaceAllWhiteSpace(),
              'mobileVerificationCode': verificationCode
            };

      final result = await ApiManager.makeApiCall(
        authConfirmVerify,
        body: body,
        apiCallType: ApiCallType.POST,
      );
      log(result.toString());
      return result.fold(
        (error) => Left(error),
        (response) =>
            Right(ResponseModel.fromJson(response as Map<String, dynamic>)),
      );
    } catch (e) {
      log('confirmVerificationOtpApi:$e');
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  //Send update phone number OTP
  Future<Either<ErrorModel, ResponseModel>> sendUpdatePhoneVerificationOtp({
    required String phoneNumber,
    required String newPhoneNumber,
    required bool continueWithReq,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'phoneNumber': phoneNumber,
        'newPhoneNumber': newPhoneNumber,
        'isPhoneNumber': true,
        "continueWithReq": continueWithReq
      };
      var result = await ApiManager.makeApiCall(
        changePhoneNumber,
        body: body,
        apiCallType: ApiCallType.POST,
      );

      log('sendUpdatePhoneVerificationOtp->Api Service-> ${result.toString()}');
      return result.fold(
        (error) => Left(error),
        (response) =>
            Right(ResponseModel.fromJson(response as Map<String, dynamic>)),
      );
    } catch (e) {
      log('sendUpdatePhoneVerificationOtp:$e');
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  //Verify update phone number OTP
  Future<Either<ErrorModel, ResponseModel>>
      confirmUpdatePhoneVerificationOtpApi({
    required String phoneNumber,
    required String newPhoneNumber,
    required String verificationCode,
    required bool continueWithReq,
  }) async {
    try {
      log(continueWithReq.toString());
      final Map<String, dynamic> body = {
        'newPhoneNumber': newPhoneNumber.replaceAllWhiteSpace(),
        'phoneNumber': phoneNumber.replaceAllWhiteSpace(),
        'mobileVerificationCode': verificationCode,
        "continueWithReq": continueWithReq,
      };
      final result = await ApiManager.makeApiCall(
        changePhoneNumber,
        body: body,
        apiCallType: ApiCallType.POST,
      );
      return result.fold(
        (error) => Left(error),
        (response) =>
            Right(ResponseModel.fromJson(response as Map<String, dynamic>)),
      );
    } catch (e) {
      log('confirmUpdatePhoneVerificationOtpApi:$e');
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  Future<Either<ErrorModel, OneAutoResponseModel>> valuationDataApi({
    required String registration,
    required String mileage,
    required int exterior,
  }) async {
    try {
      final result = await ApiManager.makeApiCall(
        "$valuationData?vehicle_registration_mark=$registration&"
        "current_mileage=$mileage&exterior_grade=$exterior",
        headerNeeded: true,
      );
      return result.fold(
        (error) => Left(error),
        (response) {
          log(response.toString());
          if (response['message'] == apiError) {
            return Right(OneAutoResponseModel(
                status: '', message: apiError, timestamp: 0, statusCode: 200));
          } else {
            return Right(OneAutoResponseModel.fromJson(
                response as Map<String, dynamic>));
          }
        },
      );
    } catch (e) {
      log('valuationDataApi:$e');
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  Future<Either<ErrorModel, HpiResponseModel>> hpiDataApi(
      {required String registrationMark}) async {
    try {
      final result = await ApiManager.makeApiCall(
        hpiData + registrationMark,
        headerNeeded: true,
      );
      return result.fold(
        (error) => Left(error),
        (response) =>
            Right(HpiResponseModel.fromJson(response as Map<String, dynamic>)),
      );
    } catch (e) {
      log('hpiDataApi:$e');
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  //checking whether the email exist or not
  Future<bool> checkUserExistsOrNot(String email, dynamic body) async {
    try {
      final result = await ApiManager.makeApiCall(
        checkUser,
        apiCallType: ApiCallType.POST,
        body: body,
      );

      final data = result.fold((l) => false, (r) => true);
      return data;
    } catch (_) {
      return false;
    }
  }

  ///get avatars
  Future<Either<ErrorModel, List<AvatarResponse>>> getProfileAvatars() async {
    final result = await ApiManager.makeApiCall(
      getAvatars,
    );
    try {
      return result.fold(
        (error) => Left(error),
        (response) {
          List<AvatarResponse> avatars = [];

          for (final item in response['data']['responseParameter'] as List) {
            avatars.add(AvatarResponse.fromJson(item as Map<String, dynamic>));
          }
          return Right(avatars);
        },
      );
    } catch (e) {
      log('getProfileAvatars:$e');
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///get search related postcodes
  Future<List<String>> getPostCodes(String searchPattern) async {
    try {
      final result = await ApiManager.makeApiCall(
        getAddress,
        queryParameters: {'postCode': searchPattern, 'search': true},
      );
      return result.fold(
        (error) => [],
        (response) {
          List<String> postCodes = [];
          for (final item
              in response['data']['responseParameter']['results'] as List) {
            postCodes.add('$item');
          }
          return postCodes;
        },
      );
    } catch (e) {
      log('getPostCodesException:$e');
      return [];
    }
  }

  ///get search related postcodes
  Future<List<AddressModel>> getAddressLines(String postCode) async {
    try {
      final result = await ApiManager.makeApiCall(
        getAddress,
        queryParameters: {'postCode': postCode},
      );
      return result.fold(
        (error) => [],
        (response) {
          List<AddressModel> addressList = [];
          for (final item
              in response['data']['responseParameter']['suggestions'] as List) {
            addressList
                .add(AddressModel.fromJson(item as Map<String, dynamic>));
          }
          return addressList;
        },
      );
    } catch (e) {
      log('getAddressLinesException:$e');
      return [];
    }
  }

  ///get search related postcodes
  Future<Either<ErrorModel, AddressDetailModel>> getAddressDetail(
      String postCodeId) async {
    try {
      final result = await ApiManager.makeApiCall(
        getAddressDetails,
        queryParameters: {'postCodeID': postCodeId},
      );
      return result.fold(
        (error) => Left(ErrorModel(message: error.message)),
        (response) {
          Map<String, dynamic> resultData =
              response['data']['responseParameter'] as Map<String, dynamic>;
          if (resultData['isSuccess'] == true) {
            AddressDetailModel addressDetailModel = AddressDetailModel.fromJson(
                resultData['address'] as Map<String, dynamic>);
            return Right(addressDetailModel);
          }
          return Left(ErrorModel(message: resultData['message'].toString()));
        },
      );
    } catch (e) {
      log('getAddressDetailException:$e');
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///get payment checkout url
  Future<Either<ErrorModel, PaymentCheckoutResponse>>
      getPaymentCheckoutResponse(Map<String, dynamic> checkoutBody) async {
    try {
      final result = await ApiManager.makeApiCall(
        checkout,
        body: checkoutBody,
        apiCallType: ApiCallType.POST,
      );
      return result.fold(
        (error) => Left(ErrorModel(message: error.message)),
        (response) {
          Map<String, dynamic> resultData = response as Map<String, dynamic>;
          if (resultData['code'] == '200') {
            PaymentCheckoutResponse paymentCheckoutResponse =
                PaymentCheckoutResponse.fromJson(
                    resultData['data'] as Map<String, dynamic>);
            return Right(paymentCheckoutResponse);
          }
          return Left(ErrorModel(message: resultData['message'].toString()));
        },
      );
    } catch (e) {
      log('getPaymentCheckoutResponse:$e');
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///send Email Contact Us
  Future<Either<ErrorModel, SendEmailResponseModel>> sendEmailContactUs(
      Map<String, dynamic> contactUsEmailBody) async {
    try {
      final result = await ApiManager.makeApiCall(
        contactUsEmail,
        body: contactUsEmailBody,
        apiCallType: ApiCallType.POST,
      );
      return result.fold(
        (error) => Left(ErrorModel(message: error.message)),
        (response) {
          Map<String, dynamic> resultData = response as Map<String, dynamic>;
          if (resultData['code'] == '200') {
            SendEmailResponseModel sendEmailResponse =
                SendEmailResponseModel.fromJson(
                    resultData['data']['\$metadata'] as Map<String, dynamic>);

            return Right(sendEmailResponse);
          }
          return Left(ErrorModel(message: resultData['message'].toString()));
        },
      );
    } catch (e) {
      log('sendEmailContactUsResponse:$e');
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  Future<Either<ErrorModel, bool>> updateCognito({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
  }) async {
    try {
      final result = await ApiManager.makeApiCall(
        updateCognitoURL,
        body: {
          "email": email,
          "firstName": firstName,
          "lastName": lastName,
          "phoneNumber": phoneNumber.replaceAllWhiteSpace(),
          "profile": "user"
        },
        apiCallType: ApiCallType.POST,
      );
      return result.fold(
        (error) => Left(ErrorModel(message: error.message)),
        (response) {
          return const Right(true);
        },
      );
    } catch (e) {
      log("updateCognitoException:$e");
      return Left(ErrorModel(message: errorOccurred));
    }
  }

//twitter login api
  Future<Either<ErrorModel, Map<String, String>>> twitterLoginApi(
      {required String token, required String secret}) async {
    try {
      final result = await ApiManager.makeApiCall(
        twitterLoginURL,
        queryParameters: {"secret": secret, "token": token},
      );
      return result.fold(
        (error) => Left(ErrorModel(message: error.message)),
        (response) {
          log(response.toString());
          if (response['code'] != null && response['code'] == "200") {
            return Right({
              "socialMediaID": "${response['data']['socialMediaID']}",
              "email": "${response['data']['email']}",
            });
          }
          return Left(ErrorModel(message: errorOccurred));
        },
      );
    } catch (_) {
      return Left(ErrorModel(message: errorOccurred));
    }
  }

//tiktok login api
  Future<Either<ErrorModel, Map<String, String>>> tiktokLoginApi({
    required String code,
    required String state,
    required String scopes,
  }) async {
    try {
      final result = await ApiManager.makeApiCall(
        tiktokTokenURL,
        queryParameters: {"code": code, "state": state, "scopes": scopes},
      );
      return result.fold(
        (error) => Left(ErrorModel(message: error.message)),
        (response) {
          if (response['code'] != null && response['code'] == "200") {
            return Right({
              "socialMediaID": "${response['data']['socialMediaID']}",
              "email": "${response['data']['email']}",
            });
          }
          return Left(ErrorModel(message: errorOccurred));
        },
      );
    } catch (e) {
      log("tiktokLoginApiException:$e");
      return Left(ErrorModel(message: errorOccurred));
    }
  }
}
