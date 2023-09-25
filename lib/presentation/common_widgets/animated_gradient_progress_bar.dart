import '../../core/configurations.dart';

class AnimatedProgressBar extends AnimatedWidget {
  const AnimatedProgressBar({Key? key, this.height, required this.animation})
      : super(key: key, listenable: animation);
  final Animation<double> animation;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: height ?? getVerticalSize(2.h),
          width: animation.value,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: kPrimaryGradientColor),
          ),
        ),
        Expanded(
          child: Container(
            height: height ?? getVerticalSize(2.h),
            width: double.infinity,
            decoration: BoxDecoration(color: ColorConstant.kColorE4E4E4),
          ),
        )
      ],
    );
  }
}
