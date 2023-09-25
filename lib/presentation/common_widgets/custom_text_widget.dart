import '../../core/configurations.dart';

class CenterText extends StatelessWidget {
  const CenterText({super.key, required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: style ??
            AppTextStyle.regularTextStyle.copyWith(
              color: ColorConstant.kColor7C7C7C,
              fontSize: getFontSize(16),
              letterSpacing: 0.8,
              fontFamily: Assets.magistralFontStyle,
            ),
      ),
    );
  }
}

RichText mandatoryText(String label) {
  return RichText(
    text: TextSpan(
      text: label,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12.sp,
        fontFamily: Assets.primaryFontPTSans,
        color: const Color.fromRGBO(48, 48, 48, 0.45),
      ),
      children: const [
        TextSpan(
          text: '*',
          style: TextStyle(color: Colors.red, fontSize: 20),
        ),
      ],
    ),
    maxLines: 1,
  );
}
