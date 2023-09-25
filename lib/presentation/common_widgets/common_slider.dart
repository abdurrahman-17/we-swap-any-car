import 'dart:async';

import '../../core/configurations.dart';

class CommonSlider extends StatefulWidget {
  const CommonSlider({
    Key? key,
    required this.sliderValue,
    required this.min,
    required this.max,
    required this.displayStartValue,
    required this.displayEndValue,
    this.displaySelectedLabel,
    this.isValuation = false,
    required this.onChanged,
    this.isButtonsNeeded = false,
  }) : super(key: key);

  final double sliderValue, min, max;
  final String displayStartValue, displayEndValue;
  final String? displaySelectedLabel;
  final bool isValuation;
  final ValueChanged<double>? onChanged;
  final bool isButtonsNeeded;

  @override
  State<CommonSlider> createState() => _CommonSliderState();
}

class _CommonSliderState extends State<CommonSlider> {
  int selectedVal = 0;
  Timer? timer;
  @override
  void initState() {
    selectedVal = widget.sliderValue.toInt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          widget.isValuation
              ? (widget.displaySelectedLabel ?? '') +
                  currencyFormatter(selectedVal)
              : '$selectedVal ${widget.displaySelectedLabel ?? ''}',
          style: AppTextStyle.regularTextStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: ColorConstant.kColor353333,
          ),
        ),
        Row(
          children: [
            if (widget.isButtonsNeeded)
              GestureDetector(
                onTap: () {
                  decrementValue();
                },
                onLongPressStart: (details) {
                  timer =
                      Timer.periodic(const Duration(milliseconds: 50), (timer) {
                    decrementValue();
                  });
                },
                onLongPressEnd: (details) {
                  timer?.cancel();
                },
                child: Icon(
                  Icons.remove_circle_outline,
                  color: ColorConstant.kPrimaryDarkRed,
                ),
              ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  overlayShape: SliderComponentShape.noOverlay,
                  trackHeight: 4,
                ),
                child: Slider(
                  value: selectedVal.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      selectedVal = value.toInt();
                    });
                    widget.onChanged!(value);
                  },
                  min: widget.min,
                  max: widget.max,
                  activeColor: ColorConstant.kColor40B9B9,
                  inactiveColor: ColorConstant.kGreyColor,
                  thumbColor: ColorConstant.kColorWhite,
                ),
              ),
            ),
            if (widget.isButtonsNeeded)
              GestureDetector(
                onTap: () {
                  incrementValue();
                },
                onLongPressStart: (details) {
                  timer =
                      Timer.periodic(const Duration(milliseconds: 50), (timer) {
                    incrementValue();
                  });
                },
                onLongPressEnd: (details) {
                  timer?.cancel();
                },
                child: Icon(
                  Icons.add_circle_outline,
                  color: ColorConstant.kPrimaryDarkRed,
                ),
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.displayStartValue,
              style: AppTextStyle.regularTextStyle.copyWith(
                color: ColorConstant.kColor7C7C7C,
              ),
            ),
            Text(
              widget.displayEndValue,
              style: AppTextStyle.regularTextStyle.copyWith(
                color: ColorConstant.kColor7C7C7C,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void decrementValue() {
    if (selectedVal != widget.min) {
      setState(() {
        --selectedVal;
        widget.onChanged!(selectedVal.toDouble());
      });
    }
  }

  void incrementValue() {
    if (selectedVal != widget.max) {
      setState(() {
        ++selectedVal;
        widget.onChanged!(selectedVal.toDouble());
      });
    }
  }
}
