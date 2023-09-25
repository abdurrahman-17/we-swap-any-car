// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../core/configurations.dart';
import '../core/locator.dart';
import '../repository/application_repo.dart';

Future<void> oneSignalInitialize() async {
  OneSignal.shared.setAppId(dotenv.env['ONE_SIGNAL_APP_ID']!);

  /* For handling notification click action additional data should be passed
   along with content . additional data like this {notificationType=chat} */

  ///asking for push notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    log("Accepted permission: $accepted");
  });

  OneSignal.shared.setNotificationOpenedHandler((openedResult) {
    log("notification opened");
    if (openedResult.notification.additionalData != null &&
        openedResult.notification.additionalData!['notificationType'] ==
            'chat') {
      // Navigator.push(
      //   globalNavigatorKey.currentContext!,
      //   MaterialPageRoute<void>(builder: (context) => const ChatWidget()),
      // );
    }
  });
  getOneSignalFcmToken();
  OneSignal.shared.setNotificationWillShowInForegroundHandler((event) async {
    log("Notification Foreground");
    try {
      if (event.notification.additionalData != null) {
        if (event.notification.additionalData!['notificationType'] ==
            'update') {
          event.complete(null);
          final result =
              await Locator.instance.get<ApplicationRepo>().getAppUpdate();
          result.fold((l) {}, (appUpdate) {
            launchForceUpdate(appUpdate);
          });
        }
      }
    } catch (e) {
      log("foreGroundNotificationError:$e");
    }
  });
}

///push notification device playerId get function
Future<String> getOneSignalFcmToken() async {
  var deviceState = await OneSignal.shared.getDeviceState();
  log("Device playerId : ${deviceState?.userId}");
  return deviceState!.userId.toString();
}
