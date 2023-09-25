import 'package:flutter/services.dart';

import '../core/configurations.dart';

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    var buffer = StringBuffer();
    int offset = newValue.selection.end;

    if (newValue.selection.baseOffset < 5) {
      offset = newValue.selection.end;
    } else {
      offset = newValue.selection.end + 1;
    }

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex == 4 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string, selection: TextSelection.collapsed(offset: offset));
  }
}

class UkTelephoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    var buffer = StringBuffer();
    int offset = newValue.selection.end;

    if (newValue.selection.baseOffset < 4) {
      offset = newValue.selection.end;
    } else if (newValue.selection.baseOffset > 6) {
      offset = newValue.selection.end + 2;
    } else {
      offset = newValue.selection.end + 1;
    }

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex == 3 && nonZeroIndex != text.length) {
        buffer.write(' ');
      } else if (nonZeroIndex > 3 &&
          nonZeroIndex == 6 &&
          nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string, selection: TextSelection.collapsed(offset: offset));
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    var formattedString = '';
    if (text.isNotEmpty) {
      formattedString = currencyFormatter(int.parse(text));
    }
    return newValue.copyWith(
        text: formattedString,
        selection: TextSelection.collapsed(offset: formattedString.length));
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

String postCodeFormatter(String postCode) {
  if (postCode.length < 5) {
    return postCode;
  } else if (postCode.length == 5) {
    String sub1 = postCode.substring(0, 2);
    String sub2 = postCode.substring(2, 5);
    return "$sub1 $sub2";
  } else if (postCode.length == 6) {
    String sub1 = postCode.substring(0, 3);
    String sub2 = postCode.substring(3, 6);
    return "$sub1 $sub2";
  } else {
    String sub1 = postCode.substring(0, 4);
    String sub2 = postCode.substring(4, 7);
    return "$sub1 $sub2";
  }
}

// XXXX XXXXXXX
String phoneNumberFormatter(String phoneNumber) {
  if (phoneNumber.isEmpty) {
    return phoneNumber;
  }
  String newPhoneNumberText = phoneNumber.replaceAllWhiteSpace();
  if (newPhoneNumberText.startsWith(countryCode)) {
    newPhoneNumberText = newPhoneNumberText.replaceAll(countryCode, '');
  }
  String sub1 = newPhoneNumberText.substring(0, 4);
  String sub2 = newPhoneNumberText.substring(4);
  return "$sub1 $sub2";
}

// XXX XXXX XXXX
String companyPhoneNumberFormatter(String phoneNumber) {
  if (phoneNumber.isEmpty) {
    return phoneNumber;
  }
  String newPhoneNumberText = phoneNumber.replaceAllWhiteSpace();
  if (newPhoneNumberText.startsWith(countryCode)) {
    newPhoneNumberText = newPhoneNumberText.replaceAll(countryCode, '');
  }

  if (newPhoneNumberText.length < 7) {
    return newPhoneNumberText;
  }
  String sub1 = newPhoneNumberText.substring(0, 3);
  String sub2 = newPhoneNumberText.substring(3, 7);
  String sub3 = newPhoneNumberText.substring(7);
  return "$sub1 $sub2 $sub3";
}

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }

    return newValue;
  }
}

class RegistrationTextFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  RegistrationTextFormatter({
    required this.mask,
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length < 5) {
      if (newValue.text.contains(' ')) {
        final offset = newValue.selection.end - 1;
        return newValue.copyWith(
            text: newValue.text.trimRight(),
            selection: TextSelection.collapsed(offset: offset));
      }
    } else if (newValue.text.length == 5) {
      if (newValue.text.contains(' ')) {
        final offset = newValue.selection.end - 1;
        return newValue.copyWith(
            text: newValue.text.trimRight(),
            selection: TextSelection.collapsed(offset: offset));
      }
      return TextEditingValue(
        text: '${oldValue.text}$separator'
            '${newValue.text.substring(newValue.text.length - 1)}',
        selection: TextSelection.collapsed(
          offset: newValue.selection.end + 1,
        ),
      );
    } else {
      if (newValue.text.length > mask.length) return oldValue;
      if (' '.allMatches(newValue.text).length > 1) {
        final offset = newValue.selection.end - 1;
        return newValue.copyWith(
            text: newValue.text.substring(0, newValue.text.length - 1),
            selection: TextSelection.collapsed(offset: offset));
      }
    }
    return newValue;
  }
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text: '${oldValue.text}$separator'
                '${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}
