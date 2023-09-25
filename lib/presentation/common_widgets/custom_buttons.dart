import '../../core/configurations.dart';

class CustomElevatedButton extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Color? buttonBgColor;
  final VoidCallback? onTap;
  final double? fontSize;
  final bool isLoading;
  final BorderRadius? customBorderRadius;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const CustomElevatedButton({
    Key? key,
    required this.title,
    this.height,
    required this.onTap,
    this.width,
    this.textStyle,
    this.fontSize,
    this.buttonBgColor,
    this.isLoading = false,
    this.customBorderRadius,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? getVerticalSize(42.h),
      child: ElevatedButton(
        onPressed: isLoading ? () {} : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBgColor ?? ColorConstant.kColorBlack,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: customBorderRadius ?? BorderRadius.circular(100.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null) prefixIcon!,
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                style: textStyle ?? AppTextStyle.darkBgButtonTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isLoading) SizedBox(width: 9.w),
            if (isLoading)
              SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  color: ColorConstant.kColorWhite,
                ),
              ),
            if (suffixIcon != null) suffixIcon!,
          ],
        ),
      ),
    );
  }
}

class GradientElevatedButton extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Gradient? buttonGradient;
  final GestureTapCallback? onTap;
  final double? fontSize;
  final Widget? prefixWidget;
  final Widget? suffixWidget;

  const GradientElevatedButton({
    super.key,
    required this.title,
    this.width,
    this.height,
    this.textStyle,
    this.buttonGradient,
    this.onTap,
    this.fontSize,
    this.prefixWidget,
    this.suffixWidget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? getVerticalSize(42.h),
        padding: getPadding(left: 14.w, right: 14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: onTap == null ? ColorConstant.grey : null,
          gradient: onTap != null
              ? buttonGradient ?? LinearGradient(colors: kPrimaryGradientColor)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixWidget != null)
              Padding(
                padding: getPadding(right: 8.w),
                child: prefixWidget!,
              ),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: textStyle ?? AppTextStyle.gradientBgButtonTextStyle,
            ),
            if (suffixWidget != null)
              Padding(
                padding: getPadding(left: 8.w),
                child: suffixWidget!,
              ),
          ],
        ),
      ),
    );
  }
}
