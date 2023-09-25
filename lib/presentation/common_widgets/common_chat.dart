import '../../core/configurations.dart';

class ChatWithIcon extends StatelessWidget {
  const ChatWithIcon({
    Key? key,
    this.isSliderOption = true,
    this.onTapChatNow,
  }) : super(key: key);
  final bool isSliderOption;
  final GestureTapCallback? onTapChatNow;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapChatNow,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Chat Now',
            style: AppTextStyle.smallTextStyle.copyWith(
              color: isSliderOption
                  ? ColorConstant.kColorWhite
                  : ColorConstant.kColorBlack,
              fontWeight: isSliderOption ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          CustomImageView(
            height: getSize(18),
            width: getSize(18),
            svgPath: Assets.bottomChat,
            margin: getMargin(left: 6),
          ),
        ],
      ),
    );
  }
}
