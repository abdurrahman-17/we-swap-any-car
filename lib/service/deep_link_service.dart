import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wsac/presentation/landing_screen/landing_screen.dart';
import 'package:wsac/service/shared_preference_service.dart';

import '../core/locator.dart';
import '../main.dart';
import '../presentation/view_match_car/view_profile.dart';

/// example deep link
//  https://emvigo.page.link/?link=https://emvigo.page.link/restPassword?code=1234554321&apn=com.emvigo.flutterstarter&amv=0&ibi=com.emvigo.flutterstarter&imv=0afl=https://www.emvigotech.com/

///firebase dynamic link handling
Future<bool> deepLinkHandling() async {
  bool isNotEmpty = false;
  //navigation
  navigation(QueryParams queryParams) {
    try {
      log(queryParams.paramTitle);
      if (queryParams.paramTitle == "carId") {
        Locator.instance.get<SharedPrefServices>().setHelpInfo(false);
        Navigator.pushNamedAndRemoveUntil(
          globalNavigatorKey.currentContext!,
          LandingScreen.routeName,
          (route) => false,
        );
        Navigator.pushNamed(
          globalNavigatorKey.currentContext!,
          ViewProfileScreen.routeName,
          arguments: {'carId': queryParams.paramData},
        );
      }
    } on Exception catch (e) {
      log("navigation_exception:$e");
    }
  }

  late AppLinks appLinks;
  appLinks = AppLinks();
  String signInRedirectURI = dotenv.env['SIGN_IN_REDIRECT_URI']!;
  final appLink = await appLinks.getInitialAppLink();
  if (appLink != null) {
    isNotEmpty = true;
    log('getInitialAppLink: $appLink');
    if ("$appLink".startsWith(signInRedirectURI)) {
      return false;
    }
    var params = appLink.queryParameters;
    var oobCode = getCode(params);
    navigation(oobCode);
  }
  // Handle link when app is in warm state (front or background)
  appLinks.uriLinkStream.listen((uri) {
    log('onAppLink: $uri');
    if ("$appLink".startsWith(signInRedirectURI)) {
      isNotEmpty = false;
    }
    var params = uri.queryParameters;
    var oobCode = getCode(params);
    navigation(oobCode);
  });
  return isNotEmpty;
}

String generateDeepLink(String queryParams) {
  return "https://uat-weswapanycar.emvigotech.co.uk/?$queryParams";
}

///extracting reset code from link based on the OS
QueryParams getCode(Map<String, String> queryParams) {
  if (queryParams.containsKey('code')) {
    return QueryParams(paramTitle: 'code', paramData: queryParams['code']!);
  } else if (queryParams.containsKey('carId')) {
    return QueryParams(paramTitle: 'carId', paramData: queryParams['carId']!);
  } else {
    String link = queryParams['link']!;
    var oobCode = link.split("=")[1];
    return QueryParams(paramTitle: 'link', paramData: oobCode);
  }
}

class QueryParams {
  String paramTitle;
  String paramData;
  QueryParams({required this.paramTitle, required this.paramData});
}
