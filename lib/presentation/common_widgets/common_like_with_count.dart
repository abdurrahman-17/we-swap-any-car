import '../../core/configurations.dart';

class LikeWithCount extends StatelessWidget {
  const LikeWithCount({
    Key? key,
    this.likeCount = 0,
    this.isSliderOption = true,
  }) : super(key: key);

  final num? likeCount;
  final bool isSliderOption;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomImageView(
          height: getSize(18),
          width: getSize(18),
          svgPath: Assets.bottomLike,
          margin: getMargin(right: 8),
        ),
        Text(
          likeCount.toString(),
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.smallTextStyle.copyWith(
            color: isSliderOption
                ? ColorConstant.kColorWhite
                : ColorConstant.kColorBlack,
            fontWeight: isSliderOption ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
