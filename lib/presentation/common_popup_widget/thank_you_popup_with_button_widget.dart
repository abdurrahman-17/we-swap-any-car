import '../../core/configurations.dart';

class ThankYouPopUpWithButton extends StatefulWidget {
  const ThankYouPopUpWithButton({
    super.key,
    required this.subTitle,
    required this.buttonTitle,
    this.onTapButton,
    this.bottomWidget,
    this.subTitleAlign,
    this.titleLabel,
  });
  final String? titleLabel;
  final String subTitle;
  final String buttonTitle;
  final VoidCallback? onTapButton;
  final Widget? bottomWidget;
  final TextAlign? subTitleAlign;

  @override
  State<ThankYouPopUpWithButton> createState() =>
      _ThankYouPopUpWithButtonState();
}

class _ThankYouPopUpWithButtonState extends State<ThankYouPopUpWithButton> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: IntrinsicHeight(
        child: Stack(
          children: [
            CustomImageView(
              svgPath: Assets.thankYouPopupGreenBg,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
              radius: BorderRadius.only(
                bottomLeft: Radius.circular(40.r),
                bottomRight: Radius.circular(40.r),
              ),
              margin: getMargin(top: 30.h),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ColorConstant.whiteA700,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: const CustomImageView(
                      svgPath: Assets.thankYouThumbBlack,
                    ),
                  ),
                  Padding(
                    padding: getPadding(top: 10.h, bottom: 6.h),
                    child: Text(
                      widget.titleLabel ?? thankYou,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyle.txtPTSansBold22WhiteA700,
                    ),
                  ),
                  Text(
                    widget.subTitle,
                    overflow: TextOverflow.ellipsis,
                    textAlign: widget.subTitleAlign ?? TextAlign.left,
                    style: AppTextStyle.txtPTSansRegular14WhiteA700,
                  ),
                  Padding(
                    padding: getPadding(
                        top: 18.h,
                        bottom: widget.bottomWidget != null ? 0 : 18.h),
                    child: CustomElevatedButton(
                      title: widget.buttonTitle,
                      onTap: widget.onTapButton,
                    ),
                  ),
                  if (widget.bottomWidget != null) widget.bottomWidget!
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
