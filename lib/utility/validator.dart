import 'strings.dart';

class Validation {
  //regular expressions
  static const String emailValidationPattern =
      "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$";

  static const String phoneNumberValidationPattern = r'^-?[0-9]+$';

  //email validator
  static String? emailValidation(String? email) {
    RegExp regExp = RegExp(emailValidationPattern);
    if (email == null || email.isEmpty) {
      return emailEmpty;
    }
    if (!regExp.hasMatch(email)) {
      return invalidEmail;
    }
    return null;
  }

  //mobile number validator
  static String? mobileNumberValidation(String? number) {
    RegExp regExp = RegExp(phoneNumberValidationPattern);
    if (number == null || number.isEmpty) {
      return filedEmpty;
    }
    if (number.length < 5 || number.length > 15) {
      return invalidNumber;
    }
    if (!regExp.hasMatch(number)) {
      return invalidNumber;
    }
    return null;
  }

  //WSAC flutter flow validations
  static bool isValidEmail(String? inputString, {bool isRequired = false}) {
    bool isInputStringValid = false;

    if ((inputString == null ? true : inputString.isEmpty) && !isRequired) {
      isInputStringValid = true;
    }

    if (inputString != null && inputString.isNotEmpty) {
      const pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      final regExp = RegExp(pattern);

      isInputStringValid = regExp.hasMatch(inputString);
    }

    return isInputStringValid;
  }

  /// Checks if string is phone number
  static bool isValidPhone(String? inputString,
      {bool isRequired = false, bool? isSignIn = false}) {
    bool isInputStringValid = false;

    if ((inputString == null ? true : inputString.isEmpty) && !isRequired) {
      isInputStringValid = true;
    }

    if (inputString != null && inputString.isNotEmpty) {
      if (inputString.startsWith('0')) {
        if (isSignIn != null && isSignIn) {
          if (inputString.length != 11) return false;
        } else {
          if (inputString.length != 12) return false;
        }
      } else {
        if (isSignIn != null && isSignIn) {
          if (inputString.length != 10) return false;
        } else {
          if (inputString.length != 11) return false;
        }
      }

      const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';

      final regExp = RegExp(pattern);

      isInputStringValid = regExp.hasMatch(inputString);
    }

    return isInputStringValid;
  }

  /// Checks if string consist only numeric.
  static bool isNumeric(String? inputString, {bool isRequired = false}) {
    bool isInputStringValid = false;

    if ((inputString == null ? true : inputString.isEmpty) && !isRequired) {
      isInputStringValid = true;
    }

    if (inputString != null && inputString.isNotEmpty) {
      const pattern = r'^\d+$';

      final regExp = RegExp(pattern);

      isInputStringValid = regExp.hasMatch(inputString);
    }

    return isInputStringValid;
  }

  /// Password should have,
  /// at least a upper case letter
  ///  at least a lower case letter
  ///  at least a digit
  ///  at least a special character [@#$%^&+=]
  ///  length of at least 4
  /// no white space allowed
  static bool isValidPassword(String? inputString, {bool isRequired = false}) {
    bool isInputStringValid = false;

    if ((inputString == null ? true : inputString.isEmpty) && !isRequired) {
      isInputStringValid = true;
    }

    if (inputString != null && inputString.isNotEmpty) {
      const pattern =
          r'^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,}$';

      final regExp = RegExp(pattern);

      isInputStringValid = regExp.hasMatch(inputString);
    }

    return isInputStringValid;
  }

  /// Checks if string consist only Alphabet. (No Whitespace)
  static bool isText(String? inputString, {bool isRequired = false}) {
    bool isInputStringValid = false;

    if ((inputString == null ? true : inputString.isEmpty) && !isRequired) {
      isInputStringValid = true;
    }

    if (inputString != null && inputString.isNotEmpty) {
      const pattern = r'^[a-zA-Z]+$';

      final regExp = RegExp(pattern);

      isInputStringValid = regExp.hasMatch(inputString);
    }

    return isInputStringValid;
  }

  static bool isValidPostcode(String? inputString, {bool isRequired = false}) {
    bool isInputStringValid = false;

    if ((inputString == null ? true : inputString.isEmpty) && !isRequired) {
      isInputStringValid = true;
    }

    if (inputString != null && inputString.isNotEmpty) {
      const pattern = r'^[a-zA-Z0-9 ]+$';

      final regExp = RegExp(pattern);

      isInputStringValid = regExp.hasMatch(inputString);
    }

    return isInputStringValid;
  }

  static bool isValidUrl(String? inputString, {bool isRequired = false}) {
    bool isInputStringValid = false;

    if ((inputString == null ? true : inputString.isEmpty) && !isRequired) {
      isInputStringValid = true;
    }

    if (inputString != null && inputString.isNotEmpty) {
      var urlPatternHttp =
          r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
      var urlPattern =
          r"(www).([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";

      if (inputString.startsWith("http")) {
        final match = RegExp(urlPatternHttp, caseSensitive: false)
            .firstMatch(inputString);

        isInputStringValid = match != null ? true : false;
      } else {
        final match =
            RegExp(urlPattern, caseSensitive: false).firstMatch(inputString);

        isInputStringValid = match != null ? true : false;
      }
    }

    return isInputStringValid;
  }

  static bool isValidRegistrationNumber(String? inputString,
      {bool isRequired = false}) {
    bool isInputStringValid = false;

    if (inputString != null &&
        inputString.isNotEmpty &&
        inputString.length > 1 &&
        inputString.length < 9) {
      const pattern = r'^[A-Z0-9 ]+$';

      final regExp = RegExp(pattern);

      isInputStringValid = regExp.hasMatch(inputString);
    }

    return isInputStringValid;
  }
}
