import '../../core/configurations.dart';

class SuccessfulPopup extends StatelessWidget {
  const SuccessfulPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: getSize(55),
            width: getSize(55),
            margin: getMargin(top: 43.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                getHorizontalSize(100.r),
              ),
              gradient: LinearGradient(
                begin: const Alignment(0, 0.5),
                end: const Alignment(1, 0.5),
                colors: kPrimaryGradientColor,
              ),
            ),
            child: const CustomImageView(
              svgPath: Assets.successCheckmark,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: getPadding(top: 15.h),
            child: Text(
              successful,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppTextStyle.txtPTSansBold22,
            ),
          ),
          Padding(
            padding: getPadding(top: 6.h),
            child: Text(
              msgSuccessfullyVerified,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppTextStyle.txtPTSansRegular14Gray600,
            ),
          ),
          CustomImageView(
            svgPath: Assets.successPopupBg,
            margin: getMargin(top: 14.h),
            fit: BoxFit.fill,
            radius: BorderRadius.only(
              bottomLeft: Radius.circular(40.r),
              bottomRight: Radius.circular(40.r),
            ),
          ),
        ],
      ),
    );
  }
}
