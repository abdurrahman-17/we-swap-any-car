import '../../core/configurations.dart';

class CustomCheckboxWithLabel extends StatelessWidget {
  const CustomCheckboxWithLabel({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.isRemove = false,
    this.isIconFirst = false,
    this.isLocation = false,
    this.hasBorder = false,
    this.isGradientCheckBox = false,
    this.isGradientColor = false,
  }) : super(key: key);
  final ValueChanged<bool?>? onChanged;
  final bool value;
  final String label;
  final bool? isRemove;
  final bool isIconFirst;
  final bool? isLocation;
  final bool hasBorder;
  final bool isGradientCheckBox;
  final bool? isGradientColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: UniqueKey(),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          if (isIconFirst)
            Padding(
              padding: EdgeInsets.only(left: 2.w, right: 8.w),
              child: isGradientCheckBox
                  ? GradientCheckbox(
                      onChanged: onChanged,
                      value: value,
                    )
                  : CommonCheckbox(
                      onChanged: onChanged,
                      value: value,
                      hasBorder: hasBorder,
                      isRemove: isRemove ?? false,
                      isLocation: isLocation ?? false,
                      isGradientColor: isGradientColor ?? false,
                    ),
            ),
          Expanded(
            child: Text(
              label,
              style: AppTextStyle.regularTextStyle
                  .copyWith(color: ColorConstant.kColor535353),
            ),
          ),
          if (!isIconFirst)
            isGradientCheckBox
                ? GradientCheckbox(
                    onChanged: onChanged,
                    value: value,
                  )
                : CommonCheckbox(
                    onChanged: onChanged,
                    value: value,
                    isRemove: isRemove ?? false,
                    isLocation: isLocation ?? false,
                    isGradientColor: isGradientColor ?? false,
                  ),
          if (!isIconFirst) const SizedBox(width: 2),
        ],
      ),
    );
  }
}

class CommonCheckbox extends StatefulWidget {
  const CommonCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.unSelectedColor,
    this.isRemove = false,
    this.isLocation = false,
    this.hasBorder = false,
    this.isGradientColor = false,
  }) : super(key: key);
  final ValueChanged<bool?>? onChanged;
  final bool value;
  final Color? unSelectedColor;
  final bool isRemove;
  final bool isLocation;
  final bool hasBorder;
  final bool isGradientColor;

  @override
  State<CommonCheckbox> createState() => _CommonCheckboxState();
}

class _CommonCheckboxState extends State<CommonCheckbox> {
  late bool _isSelected = false;

  @override
  void initState() {
    _isSelected = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          widget.onChanged!(_isSelected);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInCubic,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isSelected
              ? widget.isGradientColor
                  ? null
                  : ColorConstant.kColorBlack
              : widget.unSelectedColor ?? ColorConstant.kColorE4E4E4,
          border: widget.hasBorder
              ? _isSelected
                  ? null
                  : Border.all(color: ColorConstant.kColor969696)
              : null,
          gradient: widget.isGradientColor
              ? LinearGradient(colors: kPrimaryGradientColor)
              : null,
        ),
        width: getSize(19),
        height: getSize(19),
        alignment: Alignment.center,
        child: _isSelected
            ? widget.isRemove
                ? CustomImageView(
                    height: getSize(19),
                    width: getSize(19),
                    svgPath: Assets.minus,
                  )
                : Icon(
                    widget.isLocation
                        ? Icons.my_location_rounded
                        : Icons.check_rounded,
                    color: ColorConstant.kColorWhite,
                    size: getSize(10),
                  )
            : null,
      ),
    );
  }
}

class GradientCheckbox extends StatefulWidget {
  const GradientCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.unSelectedColor,
    this.checkBoxRadius,
    this.size,
  }) : super(key: key);
  final ValueChanged<bool?>? onChanged;
  final bool value;
  final Color? unSelectedColor;
  final double? checkBoxRadius;
  final double? size;

  @override
  State<GradientCheckbox> createState() => _GradientCheckboxState();
}

class _GradientCheckboxState extends State<GradientCheckbox> {
  late bool _isSelected = false;

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
          _isSelected = !_isSelected;
          widget.onChanged!(_isSelected);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInCubic,
        decoration: BoxDecoration(
          gradient: _isSelected
              ? LinearGradient(colors: kPrimaryGradientColor)
              : null,
          color: _isSelected ? null : ColorConstant.kColorEAEAEA,
          border: _isSelected
              ? null
              : Border.all(width: 1.w, color: ColorConstant.kColorADADAD),
          borderRadius: BorderRadius.circular(widget.checkBoxRadius ?? 100.r),
        ),
        width: widget.size ?? getSize(19),
        height: widget.size ?? getSize(19),
        child: _isSelected
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
