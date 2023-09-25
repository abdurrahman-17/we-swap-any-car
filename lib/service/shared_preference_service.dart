import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/car_model/value_section_input.dart';
import '../utility/common_keys.dart';
import '../utility/enums.dart';
import '../utility/string_utils.dart';

class SharedPrefServices {
  static late SharedPreferences _sharedPreferences;

  //making sharedPreference synchronously
  static Future<void> initializeSharedPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void clearSharedPref() {
    String temp = getRememberSignIn();
    _sharedPreferences.clear();
    setRememberSignIn(temp);
  }

  void setRememberSignIn(String emailOrPhone) =>
      _sharedPreferences.setString(rememberMe, emailOrPhone);

  String getRememberSignIn() => _sharedPreferences.getString(rememberMe) ?? '';

  void clearRememberSignIn() => _sharedPreferences.remove(rememberMe);

  void setCognitoId(String userIdValue) =>
      _sharedPreferences.setString(cognitoId, userIdValue);

  String getCognitoId() => _sharedPreferences.getString(cognitoId) ?? '';

  void setHelpInfo(bool helpInfoValue) =>
      _sharedPreferences.setBool(helpInfo, helpInfoValue);

  bool getHelpInfo() => _sharedPreferences.getBool(helpInfo) ?? false;

  void setLoginType(String value) =>
      _sharedPreferences.setString(loginType, value);

  String getLoginType() =>
      _sharedPreferences.getString(loginType) ??
      convertEnumToString(SocialLogin.none);

  void setEmail(String emailId) =>
      _sharedPreferences.setString(emailKey, emailId);

  String getEmail() => _sharedPreferences.getString(emailKey) ?? '';

  void setCarDoor(String noOfDoors) =>
      _sharedPreferences.setString(carDoor, noOfDoors);

  String getCarDoor() => _sharedPreferences.getString(carDoor) ?? '';

  void setCarBodyType(ValuesSectionInput bodyType) =>
      _sharedPreferences.setString(carBodyType, json.encode(bodyType));

  ValuesSectionInput getCarBodyType() => ValuesSectionInput.fromJson(
      json.decode(_sharedPreferences.getString(carBodyType) ??
          jsonEncode(ValuesSectionInput())) as Map<String, dynamic>);

  void clearCarData() {
    _sharedPreferences.remove(carBodyType);
    _sharedPreferences.remove(carDoor);
  }
}
