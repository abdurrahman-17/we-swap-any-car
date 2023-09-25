// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/configurations.dart';
import '../core/locator.dart';
import '../main.dart';
import '../model/app_update_model.dart';
import '../presentation/common_widgets/common_loader.dart';
import '../presentation/common_widgets/common_popups.dart';
import '../presentation/sign_in/sign_in_screen.dart';
import '../repository/authentication_repo.dart';
import '../service/shared_preference_service.dart';

///force update checking function
Future<void> launchForceUpdate(AppUpdateModel data) async {
  if (data.isForceUpdate || data.isNormalUpdate) {
    final String url = Platform.isAndroid ? data.androidUrl! : data.iosUrl!;
    final latestVersion =
        Platform.isAndroid ? data.androidVersion : data.iosVersion;
    final packageInfo = await PackageInfo.fromPlatform();
    try {
      final appVersion = int.parse(packageInfo.buildNumber);

      if (latestVersion! > appVersion) {
        if (data.isForceUpdate) {
          await infoOrThankyouPopup(
            onTapButton: () {
              launchURL(url);
            },
            title: "App Update!",
            buttonText: "UPDATE NOW",
            message: "A new version of ${packageInfo.appName} is available "
                "on the ${Platform.isAndroid ? "Play store" : "App store"}",
          );
        } else {
          bool isOk = await confirmationPopup(
            title: "App Update!",
            successBtnText: "UPDATE NOW",
            closeBtnText: "LATER",
            barrierDismissible: data.isForceUpdate,
            message: "A new version of ${packageInfo.appName} is available "
                "on the ${Platform.isAndroid ? "Play store" : "App store"}",
          );
          if (isOk) {
            launchURL(url);
          }
        }
      }
    } catch (e) {
      log("exception_forceUpdate:$e");
    }
  }
}

///url launcher
Future<void> launchURL(String url) async {
  var uri = Uri.parse(url);
  try {
    await launchUrl(uri);
  } catch (e) {
    log('Could not launch $uri: $e');
  }
}

///Call the [func] after [delay] seconds
Future<void> delayedStart(VoidCallback fun,
    {Duration duration = const Duration(seconds: 2)}) async {
  Future.delayed(duration, () => fun());
}

void shareFeature(
    {required String content, String? subject, String? imgUrl}) async {
  final box =
      globalNavigatorKey.currentContext!.findRenderObject() as RenderBox?;
  setLoader(true);
  if (imgUrl != null && imgUrl.isNotEmpty) {
    String filePath = await getTempFile(imgUrl);
    setLoader(false);
    await Share.shareXFiles(
      [XFile(filePath)],
      text: content,
      subject: subject,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  } else {
    setLoader(false);
    await Share.share(
      content,
      subject: subject,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}

Future<String> getTempFile(String url) async {
  final documentDirectory = (await getExternalStorageDirectory())!.path;
  var response = await get(Uri.parse(url));
  String fileName = url.split('/').last;
  File imgFile = File('$documentDirectory/$fileName');
  imgFile.writeAsBytesSync(response.bodyBytes);
  return '$documentDirectory/$fileName';
}

///Email
Future<void> emailUs({String? subject}) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: supportMail,
    query: 'subject=$subject',
  );
  await launchUrl(emailLaunchUri);
}

///aspect ratio
double getAspectRatio() {
  var aspectRatio =
      MediaQuery.of(globalNavigatorKey.currentContext!).size.aspectRatio;
  aspectRatio = double.parse(aspectRatio.toStringAsFixed(2));
  if (aspectRatio > 0.59) {
    return 2.0;
  } else if (aspectRatio > 0.5) {
    return 1.4;
  } else if (aspectRatio == 0.5) {
    return 1.1;
  } else if (aspectRatio > 0.46) {
    return 1.0;
  }
  return 1.2;
}

///keyboard hide
void keyBoardHide(BuildContext context) {
  FocusScope.of(context).unfocus();
}

//this function helps to check internet connectivity
Future<bool> isConnectedToInternet() async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi ||
      connectivityResult == ConnectivityResult.ethernet) {
    return true;
  } else {
    return false;
  }
}

//logout action
void logoutAction() async {
  Locator.instance.get<SharedPrefServices>().clearSharedPref();
  await Locator.instance.get<AuthenticationRepo>().signOutUser();
  Navigator.pushNamedAndRemoveUntil(globalNavigatorKey.currentContext!,
      SignInScreen.routeName, (route) => false);
}

//registration formatting
String getFormattedRegistrationNumber(String value) {
  String newValue = '';
  for (int i = 0; i < value.length; i++) {
    if (i == 4) {
      newValue += " ${value[i]}";
    } else {
      newValue += value[i];
    }
  }
  return newValue;
}

///loader
void setLoader(bool isLoader) {
  if (isLoader) {
    progressDialogue();
  } else {
    Navigator.pop(globalNavigatorKey.currentContext!);
  }
}

//check whether the app is jailbroken or not
Future<void> checkJailBrake() async {
  bool jailbreakMode;
  bool developerMode;
  try {
    jailbreakMode = await FlutterJailbreakDetection.jailbroken;
    developerMode = Platform.isAndroid
        ? await FlutterJailbreakDetection.developerMode
        : false;
  } on PlatformException {
    jailbreakMode = true;
    developerMode = true;
  }

  if (jailbreakMode || developerMode) {
    delayedStart(() {
      infoOrThankyouPopup(
        title: alert,
        message: jailBrokenMsg,
        buttonText: quitButton,
        onTapButton: () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        },
      );
    });
  }
}

///senrty exception capture
void sentryExceptionCapture({dynamic throwable, dynamic stackTrace}) {
  Sentry.captureException(throwable, stackTrace: stackTrace);
}
