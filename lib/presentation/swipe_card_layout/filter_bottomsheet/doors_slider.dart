import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../core/configurations.dart';

class DoorsSlider extends StatefulWidget {
  const DoorsSlider({
    Key? key,
    required this.onChangedCallBack,
  }) : super(key: key);
  final void Function(dynamic value) onChangedCallBack;
  @override
  State<DoorsSlider> createState() => _DoorsSliderState();
}

class _DoorsSliderState extends State<DoorsSlider> {
  double _value = 4;
  @override
  Widget build(BuildContext context) {
    return SfSlider(
      activeColor: ColorConstant.kColor40B9B9,
      inactiveColor: ColorConstant.kGreyColor,
      thumbIcon: Container(
        decoration: BoxDecoration(
          color: ColorConstant.kColorWhite,
          shape: BoxShape.circle,
        ),
      ),
      min: 2,
      max: 8,
      value: _value,
      stepSize: 1,
      interval: 1,
      showLabels: true,
      onChanged: (dynamic value) {
        setState(() {
          _value = value as double;
        });
      },
    );
  }
}
