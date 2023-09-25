// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dartz/dartz.dart';

import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/error_model.dart';
import '../../repository/user_repo.dart';

class AmplifyApiManager {
  static Future<Either<ErrorModel, String>> makeApiCall(
    String path, {
    ApiCallType? apiCallType = ApiCallType.GET,
    Map<String, String>? queryParameters,
    Map<String, dynamic>? body,
    bool headerNeeded = true,
  }) async {
    try {
      // Map<String, String> headers = {};
      // if (headerNeeded) {
      //   final value = await AuthenticationRepo().getRefreshToken();
      //   if (value != null) {
      //     headers = {'Authorization': 'Bearer ${value.accessToken}'};
      //   }
      // }
      HttpPayload? httpPayLoad;
      if (body != null) {
        httpPayLoad = HttpPayload.json(body);
      }
      RestOperation restOperation;
      switch (apiCallType) {
        case ApiCallType.GET:
          {
            restOperation = Amplify.API.get(
              path,
              queryParameters: queryParameters,
            );
          }
          break;
        case ApiCallType.PUT:
          {
            restOperation = Amplify.API.put(
              path,
              body: httpPayLoad,
            );
          }
          break;
        case ApiCallType.POST:
          {
            restOperation = Amplify.API.post(
              path,
              body: httpPayLoad,
            );
          }
          break;
        case ApiCallType.DELETE:
          {
            restOperation = Amplify.API.delete(
              path,
              body: httpPayLoad,
            );
          }
          break;
        case ApiCallType.PATCH:
          {
            restOperation = Amplify.API.patch(
              path,
              body: httpPayLoad,
            );
          }
          break;
        default:
          {
            return Left(ErrorModel(message: "API method is not defined"));
          }
      }
      var result = await restOperation.response;

      if (result.statusCode == successStatusCode) {
        return Right(result.decodeBody());
      } else {
        return Left(ErrorModel(message: 'Request not found'));
      }
    } catch (e) {
      showSnackBar(message: "Bad response");
      return Left(ErrorModel(message: "Bad response"));
    }
  }

  static Future<String> uploadImageToS3(
    File imageFile, {
    void Function(double)? progressFunction,
  }) async {
    final String? imgUrl = await Locator.instance.get<UserRepo>().uploadFile(
          filePath: imageFile.path,
          fileName: imageFile.path.split('/').last,
          progressFunction: progressFunction,
        );
    if (imgUrl != null) {
      return imgUrl;
    } else {
      return '';
    }
  }
}
