import '../../core/configurations.dart';

class ChipWithRemoveButton extends StatelessWidget {
  const ChipWithRemoveButton({
    super.key,
    required this.text,
    this.onTapRemove,
  });
  final String text;
  final GestureTapCallback? onTapRemove;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: ColorConstant.kColorE6E9EA,
      ),
      padding: getPadding(
        top: 5.h,
        bottom: 5.h,
        left: 8.w,
        right: 8.w,
      ),
      margin: getMargin(bottom: 9.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: AppTextStyle.regularTextStyle
                .copyWith(color: ColorConstant.kColor535353),
          ),
          SizedBox(width: 6.w),
          GestureDetector(
            onTap: onTapRemove,
            child: Icon(
              Icons.clear_rounded,
              size: getSize(14),
              color: ColorConstant.kColorADADAD,
            ),
          ),
        ],
      ),
    );
  }
}
