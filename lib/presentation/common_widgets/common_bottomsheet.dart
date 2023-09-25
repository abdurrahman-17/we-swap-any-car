import '../../core/configurations.dart';
import '../../main.dart';

void commonBottomSheetWithBg({required Widget content}) async {
  return showModalBottomSheet(
    isDismissible: true,
    isScrollControlled: true,
    barrierColor: Colors.grey.withOpacity(0.3),
    backgroundColor: ColorConstant.kBackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40.r),
        topRight: Radius.circular(40.r),
      ),
    ),
    context: globalNavigatorKey.currentContext!,
    builder: (context) => Wrap(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomImageView(
              width: MediaQuery.of(context).size.width,
              svgPath: Assets.homeBackground,
              fit: BoxFit.fill,
              alignment: Alignment.bottomCenter,
            ),
            content,
          ],
        ),
      ],
    ),
  );
}

void commonBottomSheet({required Widget content}) async {
  return showModalBottomSheet(
    isDismissible: true,
    isScrollControlled: true,
    barrierColor: Colors.grey.withOpacity(0.3),
    backgroundColor: ColorConstant.kBackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40.r),
        topRight: Radius.circular(40.r),
      ),
    ),
    context: globalNavigatorKey.currentContext!,
    builder: (context) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      child: SafeArea(child: content),
    ),
  );
}
