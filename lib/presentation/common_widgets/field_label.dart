import '../../core/configurations.dart';

class FieldLabelWidget extends StatelessWidget {
  const FieldLabelWidget({
    Key? key,
    required this.label,
    this.isMandatory = false,
    this.style,
  }) : super(key: key);
  final String label;
  final bool isMandatory;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: style ?? AppTextStyle.txtPTSansRegular12Gray600,
        children: [
          if (isMandatory)
            TextSpan(
              text: mandatoryField,
              style: AppTextStyle.txtPTSansRegular14WhiteA700.copyWith(
                color: ColorConstant.kColorRed,
              ),
            )
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
