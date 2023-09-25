import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

import 'constants.dart';
import 'date_time_utils.dart';

///this function used to compare three strings and create a common value.
///(Same result will return same, whether the both strings are interchanged)
String generateHash(String s1, String s2, String s3) =>
    generate256BitHashCode((<String>[s1, s2, s3]..sort()).join());

String generate256BitHashCode(String inputString) {
  final hashBytes = sha256.convert(inputString.codeUnits).toString();
  return hashBytes;
}

///convert dateTime to particular format
String convertDateTimeToDayFormat(DateTime dateTime) {
  DateTime now = getCurrentDateTime();
  int result = DateTime(dateTime.year, dateTime.month, dateTime.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
  if (result == -1) {
    return "Yesterday";
  } else if (result == 0) {
    return "Today";
  } else {
    //May 23, 2023
    DateFormat format = DateFormat("MMMM dd, yyyy");
    return customDateFormat(dateTime, dateFormat: format);
  }
}

String getUniqueId() {
  return getCurrentDateTime().microsecondsSinceEpoch.toString();
}

String getTimeFromData(DateTime dateTime) {
  DateFormat format = DateFormat("HH:mm");
  return customDateFormat(dateTime, dateFormat: format);
}

//mask chat string
String maskChat(String chat) {
  try {
    //checking consecutive 3 digit occurrence
    RegExp digits = RegExp(r'\d{3}');
    String replacedText = chat.replaceAllMapped(digits, (Match m) => '***');

    //email checking
    for (int i = 0; i < replacedText.length; i++) {
      if (replacedText[i] == '@') {
        replacedText = i <= 5
            ? replacedText.replaceRange(0, i, '****')
            : replacedText.replaceRange(i - 5, i, '****');
      }
    }
    //digits in words checking
    for (String item in numberInWords) {
      if (chat.contains(item)) {
        int index = chat.indexOf(item);
        replacedText = replacedText.replaceRange(
            index, index + item.length, "*" * item.length);
      }
    }
    log(replacedText);
    return replacedText;
  } on Exception catch (_) {
    return '';
  }
}

//sort Chats
List<DocumentSnapshot> sortChatList(List<DocumentSnapshot> chatList) {
  List<DocumentSnapshot> sortedlist = [];
  for (final chat in chatList) {
    int index = 0;
    for (final sortItem in sortedlist) {
      int comparison = (chat['createdAt'] as Timestamp)
          .compareTo((sortItem['createdAt'] as Timestamp));
      if (comparison < 0) {
        break;
      }
      index++;
    }
    sortedlist.insert(index, chat);
  }
  return sortedlist;
}
