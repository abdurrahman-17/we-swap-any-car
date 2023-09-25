import 'package:flutter/foundation.dart';

import '../../../main.dart';
import '../../core/configurations.dart';

void showDialogue({required Widget child, bool barrierDismissible = true}) {
  showDialog<String>(
    context: globalNavigatorKey.currentContext!,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: child,
      );
    },
  );
}

///used for showing dialogues and return the index
Future<int> showReturnDialogue({required Widget child}) async {
  int? data = await showDialog<int?>(
    context: globalNavigatorKey.currentContext!,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: child,
      );
    },
  );
  return data ?? -1;
}

Future<bool> confirmationPopup({
  required String title,
  String? subTitle,
  required String message,
  String? closeBtnText,
  String? successBtnText,
  TextAlign? messageTextAlign,
  bool isInfoImageRequired = true,
  bool isQuestion = false,
  bool barrierDismissible = false,
  VoidCallback? onTapSuccess,
  VoidCallback? onTapClose,
}) async {
  bool? confirmed = await showGeneralDialog(
    context: globalNavigatorKey.currentContext!,
    barrierColor: Colors.black.withOpacity(0.8),
    transitionDuration: const Duration(milliseconds: 300),
    barrierDismissible: barrierDismissible,
    pageBuilder: (_, __, ___) {
      return WillPopScope(
        onWillPop: () async => barrierDismissible,
        child: AlertDialog(
          titlePadding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
          contentPadding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
          actionsPadding: const EdgeInsets.fromLTRB(30, 0, 30, 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.r),
          ),
          title: Column(
            children: [
              if (isInfoImageRequired)
                Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: CustomImageView(
                      svgPath: isQuestion ? Assets.question : Assets.info),
                ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyle.regularTextStyle.copyWith(
                  fontSize: getFontSize(20),
                  color: ColorConstant.kColorBlack,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
              if (subTitle != null) SizedBox(height: 6.h),
              if (subTitle != null)
                Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.regularTextStyle.copyWith(
                    fontSize: getFontSize(16),
                    color: ColorConstant.kColor7C7C7C,
                  ),
                ),
            ],
          ),
          content: Text(
            message,
            textAlign: messageTextAlign ?? TextAlign.center,
            style: AppTextStyle.regularTextStyle.copyWith(
              color: ColorConstant.kColor7C7C7C,
              decoration: TextDecoration.none,
            ),
          ),
          actions: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        height: 40.h,
                        onTap: onTapClose ??
                            () async {
                              Navigator.pop(
                                  globalNavigatorKey.currentContext!, false);
                            },
                        title: closeBtnText ?? noButton,
                        textStyle: TextStyle(color: ColorConstant.kColorWhite),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: GradientElevatedButton(
                        textStyle: TextStyle(color: ColorConstant.kColorWhite),
                        height: 40.h,
                        onTap: onTapSuccess ??
                            () {
                              Navigator.pop(
                                  globalNavigatorKey.currentContext!, true);
                            },
                        title: successBtnText ?? yesButton,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h)
              ],
            ),
          ],
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
      }
      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
  return confirmed ?? false;
}

Future<void> infoOrThankyouPopup({
  String? title,
  String? subTitle,
  String? message,
  String? buttonText,
  bool isThankYou = false,
  bool barrierDismissible = false,
  VoidCallback? onTapButton,
  TextStyle? titleStyle,
  double? buttonWidth,
}) async {
  await showDialog<void>(
    barrierColor: Colors.black.withOpacity(0.8),
    context: globalNavigatorKey.currentContext!,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => barrierDismissible,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.r),
          ),
          title: Column(
            children: [
              CustomImageView(
                svgPath: isThankYou ? Assets.thankYouIcon : Assets.info,
                margin: getMargin(top: 10.h, bottom: 15.h),
              ),
              Text(
                title ?? (isThankYou ? thankYou : informationLabel),
                textAlign: TextAlign.center,
                style: titleStyle ??
                    AppTextStyle.regularTextStyle.copyWith(
                      color: ColorConstant.kColorBlack,
                      fontSize: 22.sp,
                    ),
              ),
              if (subTitle != null) SizedBox(height: 6.h),
              if (subTitle != null)
                Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.regularTextStyle.copyWith(
                    fontSize: getFontSize(16),
                    color: ColorConstant.kColor7C7C7C,
                  ),
                ),
            ],
          ),
          titlePadding: EdgeInsets.fromLTRB(
              40, 25, 40, (message != null || message == "") ? 0 : 30),
          content: message != null
              ? Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.regularTextStyle
                      .copyWith(color: ColorConstant.kColor7C7C7C),
                )
              : null,
          contentPadding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
          actions: [
            CustomElevatedButton(
              width: buttonWidth ?? size.width / 3.2,
              height: 40.h,
              title: buttonText ?? okButton,
              onTap: onTapButton ?? () => Navigator.pop(context, true),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
        ),
      );
    },
  );
}

Future<dynamic> customPopup({
  String? title,
  Widget? content,
  String? successBtnLabel,
  Color? titleColor,
  List<Widget>? actions,
  bool hasContentPadding = true,
  bool barrierDismissible = true,
  Color? barrierColor,
}) async {
  return await showDialog(
    barrierDismissible: barrierDismissible,
    context: globalNavigatorKey.currentContext!,
    barrierColor: barrierColor ?? Colors.black.withOpacity(0.8),
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        backgroundColor: ColorConstant.kBackgroundColor,
        contentPadding: hasContentPadding
            ? const EdgeInsets.symmetric(vertical: 30, horizontal: 30)
            : const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.r),
        ),
        title: title != null
            ? Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: titleColor ?? Colors.black),
                ),
              )
            : null,
        content: content,
        actions: actions,
        actionsAlignment: MainAxisAlignment.center,
      );
    },
  );
}

//confirm popup with also return null user click back button
Future<bool?> confirmationPopup2({
  required String title,
  required String message,
  String? cancelBtnLabel,
  String? successBtnLabel,
  bool isInfoImageRequired = true,
  bool isQuestion = false,
}) async {
  bool? confirmed = await showGeneralDialog(
    context: globalNavigatorKey.currentContext!,
    barrierColor: Colors.black.withOpacity(0.8),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
        contentPadding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        actionsPadding: const EdgeInsets.fromLTRB(30, 0, 30, 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.r),
        ),
        title: Column(
          children: [
            if (isInfoImageRequired)
              Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: CustomImageView(
                    svgPath: isQuestion ? Assets.question : Assets.info),
              ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyle.regularTextStyle.copyWith(
                fontSize: getFontSize(20),
                color: ColorConstant.kColorBlack,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyle.regularTextStyle.copyWith(
            fontSize: getFontSize(16),
            color: ColorConstant.kColor7C7C7C,
            decoration: TextDecoration.none,
          ),
        ),
        actions: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      height: 40.h,
                      onTap: () async {
                        Navigator.pop(
                            globalNavigatorKey.currentContext!, false);
                      },
                      title: cancelBtnLabel ?? cancelButton,
                      textStyle: TextStyle(color: ColorConstant.kColorWhite),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: GradientElevatedButton(
                      textStyle: TextStyle(color: ColorConstant.kColorWhite),
                      height: 40.h,
                      onTap: () {
                        Navigator.pop(globalNavigatorKey.currentContext!, true);
                      },
                      title: successBtnLabel ?? confirmButton,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h)
            ],
          ),
        ],
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
      }
      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
  return confirmed;
}

//upload progress dialogue
Future<void> showUploadProgress(
    {required int total, required ValueListenable<double> progress}) async {
  return showDialog<void>(
    context: globalNavigatorKey.currentContext!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: ValueListenableBuilder<double>(
          valueListenable: progress,
          builder: (BuildContext context, double value, Widget? child) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              title: const Text('Uploading..'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("${value.toInt()} of $total completed"),
                    const SizedBox(
                      height: 10,
                    ),
                    LinearProgressIndicator(
                      value: (value / total),
                      minHeight: 10,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
