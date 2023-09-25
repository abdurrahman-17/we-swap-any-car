import '../../core/configurations.dart';

class GradientLabel extends StatelessWidget {
  const GradientLabel({
    Key? key,
    required this.text,
    this.height,
    this.width,
    this.textStyle,
    this.padding,
  }) : super(key: key);
  final String text;
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getVerticalSize(height ?? 20),
      width: getHorizontalSize(width ?? 70),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: kPrimaryGradientColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          text,
          style: textStyle ??
              AppTextStyle.regularTextStyle.copyWith(
                color: ColorConstant.kColorWhite,
              ),
        ),
      ),
    );
  }
}
