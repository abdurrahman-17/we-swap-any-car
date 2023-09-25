import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/configurations.dart';
import '../../model/error_model.dart';
import '../../repository/authentication_repo.dart';

class ApiManager {
  static Dio dio = Dio();
  static Future<Either<ErrorModel, dynamic>> makeApiCall(String apiUrl,
      {ApiCallType? apiCallType = ApiCallType.GET,
      Map<String, String>? headerData,
      Map<String, dynamic>? queryParameters,
      dynamic body,
      bool headerNeeded = false}) async {
    try {
      bool isConnected = await isConnectedToInternet();
      if (!isConnected) {
        return Left(ErrorModel(message: notConnectedToInternet));
      }
      Map<String, String> headers = {};
      if (headerData != null) {
        headers = headerData;
      } else if (headerNeeded) {
        final value = await AuthenticationRepo().getRefreshToken();
        if (value != null) {
          headers = {'Authorization': 'Bearer ${value.accessToken.signature}'};
        }
      }
      Response<dynamic> response;
      switch (apiCallType) {
        case ApiCallType.GET:
          {
            response = await dio.get(
              apiUrl,
              queryParameters: queryParameters,
              options: Options(headers: headers),
            );
          }
          break;
        case ApiCallType.PUT:
          {
            response = await dio.put(
              apiUrl,
              options: Options(headers: headers),
              data: body,
              queryParameters: queryParameters,
            );
          }
          break;
        case ApiCallType.POST:
          {
            response = await dio.post(
              apiUrl,
              options: Options(headers: headers),
              data: body,
              queryParameters: queryParameters,
            );
          }
          break;
        case ApiCallType.PATCH:
          {
            response = await dio.patch(
              apiUrl,
              options: Options(headers: headers),
              data: body,
              queryParameters: queryParameters,
            );
          }
          break;
        case ApiCallType.DELETE:
          {
            response = await dio.patch(
              apiUrl,
              options: Options(headers: headers),
              data: body,
              queryParameters: queryParameters,
            );
          }
          break;
        default:
          {
            return Left(ErrorModel(message: "API method is not defined"));
          }
      }
      log(response.toString());
      if (response.statusCode == successStatusCode) {
        return Right(response.data);
      } else {
        return Left(
            ErrorModel(message: response.statusMessage ?? 'Request not found'));
      }
    } on SocketException {
      showSnackBar(message: noInternetConnection);
      return Left(ErrorModel(message: noInternetConnection));
    } on DioError catch (e) {
      log("DioError:::$e");
      log("${e.response?.data}");
      if (e.response?.statusCode == validationErrorStatusCode) {
        return Left(ErrorModel(
          message: e.response?.data['details'][0] as String? ?? "Bad response",
        ));
      }
      if (e.response?.statusCode == errorStatusCode400) {
        log("error data: ${e.response?.data['data']}");
        return Left(ErrorModel(
            data: e.response?.data['data'] as Map<String, dynamic>,
            message:
                e.response?.data['message']?.toString() ?? "Bad response"));
      }
      return Left(ErrorModel(
          message: (e.response?.data['message']?.toString() != null &&
                  e.response?.data['message']?.toString() ==
                      payAsyouGoLimitExceededMsg)
              ? payAsyouGoLimitExceededMsg
              : "Bad response"));
    } on Exception {
      showSnackBar(message: "Bad response");
      return Left(ErrorModel(message: "Bad response"));
    }
  }
}
