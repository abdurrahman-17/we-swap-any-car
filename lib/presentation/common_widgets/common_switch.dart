import '../../core/configurations.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation<Alignment>? _circleAnimation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _circleAnimation = AlignmentTween(
      begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
      end: widget.value ? Alignment.centerLeft : Alignment.centerRight,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Stack(
            children: [
              Container(
                width: getHorizontalSize(26.w),
                height: getVerticalSize(15.h),
                margin: getMargin(all: 3),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorConstant.kColorBlack.withOpacity(0.1),
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  color: ColorConstant.kColorWhite,
                ),
              ),
              Container(
                width: getHorizontalSize(32.w),
                height: getVerticalSize(15.h),
                margin: getMargin(top: 3.h, bottom: 3.h),
                alignment: _circleAnimation!.value,
                child: Container(
                  width: getSize(22),
                  height: getSize(22),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _circleAnimation!.value == Alignment.centerLeft
                        ? ColorConstant.kColor434343
                        : ColorConstant.kColor7C7C7C,
                    gradient: _circleAnimation!.value == Alignment.centerRight
                        ? LinearGradient(colors: kPrimaryGradientColor)
                        : null,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
