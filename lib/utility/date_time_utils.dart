// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

import '../core/configurations.dart';
import '../main.dart';

///date picker common widget
Future<DateTime?> showCommonDatePicker(
    {DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
  try {
    DateTime? dateTime = await showDatePicker(
      context: globalNavigatorKey.currentContext!,
      initialDate: initialDate ?? getCurrentDateTime(),
      firstDate: firstDate ?? DateTime(1920),
      lastDate: lastDate ?? getCurrentDateTime(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: ColorConstant.kPrimaryDarkRed,
            colorScheme:
                ColorScheme.light(primary: ColorConstant.kPrimaryDarkRed)
                    .copyWith(secondary: ColorConstant.kPrimaryDarkRed),
          ),
          child: child!,
        );
      },
    );
    return dateTime;
  } catch (e) {
    log("datePickerException:$e");
    return null;
  }
}

//custom dateFormate
String customDateFormat(
  DateTime dateTime, {
  DateFormat? dateFormat,
  bool isUtc = false,
  bool isAWSDateFormat = false,
}) {
  try {
    if (isAWSDateFormat) {
      DateFormat format = DateFormat("yyyy-MM-dd");
      return format.format(dateTime);
    } else if (isUtc) {
      DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      return format.format(dateTime);
    } else {
      DateFormat format = dateFormat ?? DateFormat("dd-MM-yyyy");
      return format.format(dateTime);
    }
  } catch (e) {
    return e.toString();
  }
}

DateTime? convertStringToDateTime(
  String dateTime, {
  DateFormat? dateFormat,
  bool isAWSDateFormat = false,
  bool isUtc = false,
  bool isStandard = false,
}) {
  try {
    if (isAWSDateFormat) {
      DateFormat format = DateFormat("yyyy-MM-dd");
      return format.parse(dateTime);
    } else if (isUtc) {
      DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      return format.parse(dateTime);
    } else if (isStandard) {
      DateFormat format = DateFormat("dd-MM-yyyy");
      return format.parse(dateTime);
    }

    return DateTime.parse(dateTime);
  } catch (e) {
    log("convertStringToDateTime:$e");
  }
  return null;
}

//get current network time
Future<DateTime> networkDateTime() async {
  DateTime networkDateTime = await NTP.now();
  return networkDateTime;
}

//dateTime
// String getParsedOrDate(String value, {bool? isAWSDateFormat, bool? isUTC}) {
//   try {
//     final date = DateTime.parse(value);
//     return customDateFormat(date,
//         isAWSDateFormat: isAWSDateFormat!, isUtc: isUTC!);
//   } catch (_) {
//     return value;
//   }
// }

//get current dateTime in timestamp format
Timestamp getCurrentTimeStamp() {
  final DateTime dateTime = getCurrentDateTime();
  return Timestamp.fromDate(dateTime);
}

//get current dateTime
DateTime getCurrentDateTime() {
  final DateTime dateTime = DateTime.now();
  return dateTime;
}

//date only
DateTime getDateOnly(DateTime dateTime) {
  return dateTime.copyWith(
    hour: 0,
    minute: 0,
    second: 0,
    millisecond: 0,
    microsecond: 0,
  );
}
