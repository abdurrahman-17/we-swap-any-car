import '../../core/configurations.dart';

class ShareButtonWithIcon extends StatelessWidget {
  const ShareButtonWithIcon({
    Key? key,
    this.isSliderOption = true,
    this.onTapShare,
  }) : super(key: key);
  final bool isSliderOption;
  final GestureTapCallback? onTapShare;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapShare,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Share',
            style: AppTextStyle.regularTextStyle.copyWith(
              color: isSliderOption
                  ? ColorConstant.kColorWhite
                  : ColorConstant.kColorBlack,
              fontWeight: isSliderOption ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          CustomImageView(
            height: getSize(18),
            width: getSize(18),
            svgPath: Assets.share,
            margin: getMargin(left: 6.w),
          ),
        ],
      ),
    );
  }
}
