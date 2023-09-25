// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../model/app_update_model.dart';
import '../model/error_model.dart';
import '../utility/common_keys.dart';
import '../utility/constants.dart';

class RemoteConfigService {
  final remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    try {
      /*adding minimum fetch interval to manage remote config cache.*/
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval:
            Duration(milliseconds: minimumFetchIntervalTime * 1000 * 60 * 60),
      ));

      await remoteConfig.fetch();
      await remoteConfig.activate();
    } catch (_) {}
  }

  //returning login types
  Future<Either<ErrorModel, AppUpdateModel>> getUpdateModel() async {
    try {
      await remoteConfig.fetch();
      await remoteConfig.activate();
      String appUpdateData = remoteConfig.getString(mobileUpdateVersion);
      Map<String, dynamic> json =
          jsonDecode(appUpdateData) as Map<String, dynamic>;
      //     {
      //   "android_url":
      //       "https://play.google.com/store/apps/details?id=com.app.wsac",
      //   "android_version": 5,
      //   "ios_url": "https://apps.apple.com/in/app/id6446250005",
      //   "ios_version": 1,
      //   "isForceUpdate": false,
      //   "isNormalUpdate": true
      // };

      AppUpdateModel remoteConfigModel = AppUpdateModel.fromJson(json);
      log("RemoteConfig:$json");

      return Right(remoteConfigModel);
    } on Exception {
      return Left(ErrorModel(message: "Remote config fetch error"));
    }
  }
}
