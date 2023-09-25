import '../../core/configurations.dart';

class BulletPoint extends StatelessWidget {
  const BulletPoint({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: getSize(9),
            width: getSize(9),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: kPrimaryGradientColor),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: AppTextStyle.smallTextStyle
                .copyWith(color: ColorConstant.kColor4E4545),
          )
        ],
      ),
    );
  }
}
