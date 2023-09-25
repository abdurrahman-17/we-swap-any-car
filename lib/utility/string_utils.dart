//appending zero to single digit

import 'package:enum_to_string/enum_to_string.dart';
import 'package:intl/intl.dart';

String appendZeroAsPrefix(String num) => num.length > 1 ? num : "0$num";

///replace substring to ***
String maskString(String string, {int length = 3}) {
  return '*' * length + string.substring(length);
}

///extension to replace all white space with a particular char
extension ReplaceWhiteSpace on String {
  String replaceAllWhiteSpace() => replaceAll(RegExp(r'\s+'), '');
}

///function check whether the string is numeric or not
bool isStringNumeric(String s) {
  String string = s.replaceAll("+", "");
  string = s.replaceAll(",", "");
  string = string.replaceAllWhiteSpace();

  if (string.isNotEmpty && double.tryParse(string) != null) {
    return true;
  } else {
    return false;
  }
}

///Currency Formatter
String currencyFormatter(num amount) {
  if (amount.toString().length < 3) return amount.toString();
  var formatter = NumberFormat('###,###,000');
  return formatter.format(amount);
}

///converts Enum to String
String convertEnumToString(Enum enumValue) {
  return EnumToString.convertToString(enumValue);
}

extension ReplaceAllFunction on String {
  String replaceAllFunction(String charToReplace) {
    return replaceAll(charToReplace, '');
  }
}

extension StringExtension on String {
  //convert string to proper case [removes underscore also]
  String toProperCase() {
    return replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

//if it is empty return passed value
  String emptyValue(String defaultValue) {
    return isNotEmpty ? this : defaultValue;
  }
}

String getEncodedUrl(String url) => Uri.encodeFull(url);
