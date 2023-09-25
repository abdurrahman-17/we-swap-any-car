import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:dartz/dartz.dart';

import '../core/configurations.dart';
import '../core/locator.dart';
import '../model/error_model.dart';
import '../model/avatar/upload_profile_response_model.dart';
import '../model/post_code/address_detail_model.dart';
import '../model/post_code/address_model.dart';
import '../model/response_model.dart';
import '../model/user/user_model.dart';
import '../service/amplify_service/amplify_service.dart';
import '../service/api_service/api_service.dart';
import '../service/graphQl_service/gq_service.dart';

class UserRepo {
  Future<Either<ErrorModel, List<AvatarResponse>>> getUserAvatars() async =>
      await Locator.instance.get<ApiService>().getProfileAvatars();

  Future<Either<ErrorModel, UserModel>> getCurrentUserData({
    required String key,
    required String value,
  }) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .getCurrentUserData(key: key, value: value);

  //create user
  Future<Either<ErrorModel, UserModel>> createUserRepo(
          {required Map<String, dynamic> userData}) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .createUser(userData: userData);

  //update user
  Future<Either<ErrorModel, UserModel>> updateUserRepo(
          {required Map<String, dynamic> userData}) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .updateUser(userData: userData);

  //delete user
  Future<Either<ErrorModel, ResponseModel>> deleteUserRepo(
          {required Map<String, dynamic> userData}) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .deleteUser(userData: userData);

  Future<AuthUser?> getCognitoUserData() async {
    return await Locator.instance.get<AmplifyService>().getCognitoUserData();
  }

  Future<String?> uploadFile({
    required String filePath,
    required String fileName,
    void Function(double)? progressFunction,
  }) async {
    final key =
        await Locator.instance.get<AmplifyService>().uploadFileToS3Bucket(
              filePath: filePath,
              fileName: fileName,
              progressFunction: progressFunction,
            );
    if (key != null) {
      return "$s3BaseUrl/$key";
    }
    return null;
  }

  ///fetching related postcodes
  Future<List<String>> getPostCodes(String searchPattern) async =>
      await Locator.instance.get<ApiService>().getPostCodes(searchPattern);

  ///fetching related address lines
  Future<List<AddressModel>> getRelatedAddress(String postCode) async =>
      await Locator.instance.get<ApiService>().getAddressLines(postCode);

  ///fetching related address lines
  Future<Either<ErrorModel, AddressDetailModel>> getAddressDetails(
          String addressId) async =>
      await Locator.instance.get<ApiService>().getAddressDetail(addressId);

  //update user notification settings
  Future<Either<ErrorModel, UserModel>> updateNotificationSettingsRepo({
    required String status,
    required String userId,
  }) async =>
      await Locator.instance.get<GraphQlServices>().updateNotificationSettings(
            status: status,
            userId: userId,
          );

  //upgrade to dealer
  Future<Either<ErrorModel, UserModel>> upgradeToDealerRepo({
    required String planId,
    required String planName,
    required String planType,
    required String userId,
    required Map<String, dynamic> userData,
  }) async =>
      await Locator.instance.get<GraphQlServices>().upgradeToDealer(
          userData: userData,
          planId: planId,
          planName: planName,
          planType: planType,
          userId: userId);

  ///fetching related postcodes
  Future<Either<ErrorModel, num>> getActiveUsersRepo() async =>
      await Locator.instance.get<GraphQlServices>().getActiveUsers();
}
