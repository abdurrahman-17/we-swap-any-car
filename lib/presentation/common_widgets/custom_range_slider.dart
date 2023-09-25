import 'dart:async';

import '../../core/configurations.dart';

class CustomRangeSlider extends StatefulWidget {
  const CustomRangeSlider({
    Key? key,
    required this.selectedStartValue,
    required this.selectedEndValue,
    required this.onChanged,
    required this.startValueLabel,
    required this.endValueLabel,
    this.isPrice = false,
    required this.min,
    required this.max,
    this.isSliderAtBottom = false,
    this.isButtonsNeeded = false,
    this.division,
    this.trackHeight,
    this.activeTrackColor,
    this.label,
  }) : super(key: key);

  final double selectedStartValue, selectedEndValue;
  final double? trackHeight;
  final double min, max;
  final String startValueLabel, endValueLabel;
  final bool isPrice;
  final bool isSliderAtBottom;
  final int? division;
  final String? label;
  final Color? activeTrackColor;
  final void Function(RangeValues) onChanged;
  final bool isButtonsNeeded;

  @override
  State<CustomRangeSlider> createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  double selectedStartValue = 0;
  double selectedEndValue = 0;
  Timer? timer;

  @override
  void initState() {
    selectedStartValue = widget.selectedStartValue;
    selectedEndValue = widget.selectedEndValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: getPadding(bottom: widget.isSliderAtBottom ? 20 : 0),
          child: Row(
            mainAxisAlignment: widget.isSliderAtBottom
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.end,
            children: [
              if (widget.isSliderAtBottom)
                Text(
                  widget.label ?? '',
                  style: AppTextStyle.regularTextStyle.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              Text(
                widget.isPrice
                    ? euro +
                        currencyFormatter(selectedStartValue.round()) +
                        dashSeperator +
                        euro +
                        currencyFormatter(selectedEndValue.round())
                    : selectedStartValue.round().toString() +
                        dashSeperator +
                        selectedEndValue.round().toString(),
                style: AppTextStyle.regularTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.kColor353333,
                ),
              ),
            ],
          ),
        ),
        if (widget.isSliderAtBottom)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.startValueLabel,
                style: AppTextStyle.regularTextStyle.copyWith(
                  color: ColorConstant.kColor7C7C7C,
                ),
              ),
              Text(
                widget.endValueLabel,
                style: AppTextStyle.regularTextStyle.copyWith(
                  color: ColorConstant.kColor7C7C7C,
                ),
              ),
            ],
          ),
        Padding(
          padding: getPadding(top: 5.h, bottom: 5.h),
          child: Row(
            children: [
              if (widget.isButtonsNeeded)
                Padding(
                  padding: getPadding(right: 10.w),
                  child: GestureDetector(
                    onTap: () => decreaseStartValue(),
                    onLongPressStart: (details) {
                      timer = Timer.periodic(const Duration(milliseconds: 50),
                          (timer) => decreaseStartValue());
                    },
                    onLongPressEnd: (details) => timer?.cancel(),
                    child: Icon(
                      Icons.remove_circle_outline,
                      color: ColorConstant.kPrimaryDarkRed,
                    ),
                  ),
                ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    overlayShape: SliderComponentShape.noOverlay,
                    trackHeight: widget.trackHeight ?? 4,
                  ),
                  child: RangeSlider(
                    values: RangeValues(selectedStartValue, selectedEndValue),
                    onChanged: (value) {
                      setState(() {
                        selectedStartValue = value.start;
                        selectedEndValue = value.end;
                      });
                      widget.onChanged(value);
                    },
                    min: widget.min,
                    max: widget.max,
                    divisions: widget.division != null && widget.division! > 0
                        ? widget.division
                        : null,
                    activeColor:
                        widget.activeTrackColor ?? ColorConstant.kColor40B9B9,
                    inactiveColor: ColorConstant.kGreyColor,
                  ),
                ),
              ),
              if (widget.isButtonsNeeded)
                Padding(
                  padding: getPadding(left: 10.w),
                  child: GestureDetector(
                    onTap: () => increaseEndValue(),
                    onLongPressStart: (details) {
                      timer = Timer.periodic(const Duration(milliseconds: 50),
                          (timer) => increaseEndValue());
                    },
                    onLongPressEnd: (details) => timer?.cancel(),
                    child: Icon(
                      Icons.add_circle_outline,
                      color: ColorConstant.kPrimaryDarkRed,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (!widget.isSliderAtBottom)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.startValueLabel,
                style: AppTextStyle.regularTextStyle.copyWith(
                  color: ColorConstant.kColor7C7C7C,
                ),
              ),
              Text(
                widget.endValueLabel,
                style: AppTextStyle.regularTextStyle.copyWith(
                  color: ColorConstant.kColor7C7C7C,
                ),
              ),
            ],
          ),
      ],
    );
  }

  void decreaseStartValue() {
    if (selectedStartValue >= widget.min) {
      setState(() => --selectedStartValue);
      widget.onChanged(RangeValues(selectedStartValue, selectedEndValue));
    }
  }

  void increaseEndValue() {
    if (selectedEndValue <= widget.max) {
      setState(() => ++selectedEndValue);
      widget.onChanged(RangeValues(selectedStartValue, selectedEndValue));
    }
  }
}
