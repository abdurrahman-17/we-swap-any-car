import 'dart:convert';
import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dartz/dartz.dart';

import '../../model/error_model.dart';
import '../../utility/common_utils.dart';
import '../../utility/strings.dart';

class GraphQlCallManager {
  ///query
  static Future<Either<ErrorModel, Map<String, dynamic>>> graphQlQuery({
    required String document,
    Map<String, dynamic> variables = const <String, dynamic>{},
  }) async {
    try {
      bool isConnected = await isConnectedToInternet();
      if (!isConnected) {
        return Left(ErrorModel(message: notConnectedToInternet));
      }
      var operation = Amplify.API.query(
          request: GraphQLRequest<String>(
        document: document,
        variables: variables,
      ));
      var response = await operation.response;
      log(response.toString());
      if (response.data != null) {
        return Right(jsonDecode(response.data!) as Map<String, dynamic>);
      } else {
        if (response.errors.isNotEmpty) {
          log(response.errors[0].message);
          return Left(ErrorModel(message: response.errors[0].message));
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      }
    } on ApiException catch (e) {
      log("ApiException:$e");
      return Left(ErrorModel(message: errorOccurred));
    } on Exception catch (e) {
      log(e.toString());
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///mutation
  static Future<Either<ErrorModel, Map<String, dynamic>>> graphQlMutation({
    required String document,
    Map<String, dynamic> variables = const <String, dynamic>{},
  }) async {
    try {
      bool isConnected = await isConnectedToInternet();
      if (!isConnected) {
        return Left(ErrorModel(message: notConnectedToInternet));
      }
      var operation = Amplify.API.mutate(
          request: GraphQLRequest<String>(
        document: document,
        variables: variables,
      ));
      var response = await operation.response;
      log("$response");
      if (response.data != null) {
        return Right(jsonDecode(response.data!) as Map<String, dynamic>);
      } else {
        log(response.errors.toString());
        if (response.errors.isNotEmpty) {
          return Left(ErrorModel(message: response.errors[0].message));
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      }
    } on ApiException catch (e) {
      log("ApiException:$e");
      return Left(ErrorModel(message: errorOccurred));
    } on Exception catch (e) {
      log(e.toString());
      return Left(ErrorModel(message: errorOccurred));
    }
  }
}
