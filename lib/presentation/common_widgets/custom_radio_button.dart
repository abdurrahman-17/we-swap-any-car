import '../../core/configurations.dart';

class CustomRadioWithLabel extends StatelessWidget {
  const CustomRadioWithLabel({
    super.key,
    this.onChanged,
    this.value,
    this.groupValue,
    this.text,
    this.isRadioCheckBox = false,
    this.disabledColor,
    this.onTapLabel,
  });
  final bool isRadioCheckBox;
  final ValueChanged<String?>? onChanged;
  final String? value;
  final String? groupValue;
  final String? text;
  final Color? disabledColor;
  final VoidCallback? onTapLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isRadioCheckBox
            ? GradientCheckBoxRadio(
                onChanged: onChanged,
                value: value!,
                groupValue: groupValue,
              )
            : GradientRadio(
                value: value!,
                onChanged: onChanged,
                groupValue: groupValue,
                disabledColor: disabledColor,
              ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: onTapLabel ?? () {},
            child: Text(
              text ?? '',
              style: AppTextStyle.regularTextStyle
                  .copyWith(color: ColorConstant.kColor7C7C7C),
            ),
          ),
        ),
      ],
    );
  }
}

class GradientRadio extends StatefulWidget {
  const GradientRadio({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.disabledColor,
    this.size,
  }) : super(key: key);
  final ValueChanged<String?>? onChanged;
  final String value;
  final Color? disabledColor;
  final String? groupValue;
  final double? size;

  @override
  State<GradientRadio> createState() => _GradientRadioState();
}

class _GradientRadioState extends State<GradientRadio> {
  late String _isSelected = '';

  @override
  void initState() {
    _isSelected = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => widget.onChanged!(_isSelected));
      },
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          border: Border.all(width: 1.w, color: ColorConstant.kColorD9D9D9),
          color: widget.disabledColor ?? ColorConstant.kColorWhite,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInCubic,
          decoration: BoxDecoration(
            gradient: _isSelected == widget.groupValue
                ? widget.disabledColor != null
                    ? LinearGradient(colors: kDisableGradientColor)
                    : LinearGradient(colors: kPrimaryGradientColor)
                : null,
            borderRadius: BorderRadius.circular(100.r),
          ),
          width: widget.size ?? getSize(12),
          height: widget.size ?? getSize(12),
        ),
      ),
    );
  }
}

class GradientCheckBoxRadio extends StatefulWidget {
  const GradientCheckBoxRadio({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.groupValue,
  }) : super(key: key);
  final ValueChanged<String?>? onChanged;
  final String value;
  final String? groupValue;

  @override
  State<GradientCheckBoxRadio> createState() => _GradientCheckBoxRadioState();
}

class _GradientCheckBoxRadioState extends State<GradientCheckBoxRadio> {
  late String _isSelected = '';

  @override
  void initState() {
    _isSelected = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onChanged!(_isSelected);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInCubic,
        decoration: BoxDecoration(
          gradient: _isSelected == widget.groupValue
              ? LinearGradient(colors: kPrimaryGradientColor)
              : null,
          color: _isSelected == widget.groupValue
              ? null
              : ColorConstant.kColorWhite,
          border: _isSelected == widget.groupValue
              ? null
              : Border.all(width: 1.w, color: ColorConstant.kColorADADAD),
          borderRadius: BorderRadius.circular(5.r),
        ),
        width: getSize(19),
        height: getSize(19),
        child: _isSelected == widget.groupValue
            ? Icon(
                Icons.check_rounded,
                color: ColorConstant.kColorWhite,
                size: 8,
              )
            : null,
      ),
    );
  }
}
