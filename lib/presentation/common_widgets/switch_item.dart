import '../../core/configurations.dart';
import 'common_switch.dart';

class SwitchItemWidget extends StatelessWidget {
  const SwitchItemWidget({
    Key? key,
    required this.switchValue,
    this.switchHeadValue,
    required this.onChanged,
    required this.label,
    this.switchLeftLabel,
    this.switchRightLabel,
    this.textStyle,
  }) : super(key: key);

  final bool switchValue;
  final bool? switchHeadValue;
  final void Function(bool) onChanged;
  final String label;
  final String? switchLeftLabel;
  final String? switchRightLabel;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getPadding(top: 11.h, bottom: 11.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.left,
              style: textStyle ??
                  AppTextStyle.smallTextStyle.copyWith(
                    color: ColorConstant.kColor151515,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: getPadding(right: 7.w),
                child: Text(
                    switchValue
                        ? switchLeftLabel ?? "Yes"
                        : switchRightLabel ?? "No",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppTextStyle.smallTextStyle
                        .copyWith(color: ColorConstant.kColor151515)),
              ),
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return CustomSwitch(
                    value: switchValue,
                    onChanged: onChanged,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
