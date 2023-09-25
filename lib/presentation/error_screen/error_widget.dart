import 'package:wsac/core/configurations.dart';

class ErrorWithButtonWidget extends StatelessWidget {
  const ErrorWithButtonWidget({
    super.key,
    required this.message,
    required this.buttonLabel,
    this.onTap,
  });
  final String message;
  final String buttonLabel;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomImageView(svgPath: Assets.errorScreenImg),
        SizedBox(height: 22.h),
        Text(
          message,
          style: AppTextStyle.txtPTSansBold12LightgreenA700.copyWith(
            color: ColorConstant.black900,
          ),
        ),
        SizedBox(height: 10.h),
        CustomElevatedButton(
          width: size.width / 2,
          title: buttonLabel,
          onTap: onTap,
        ),
      ],
    );
  }
}
