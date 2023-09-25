import '../../../core/configurations.dart';

class CommonOutlineButton extends StatelessWidget {
  const CommonOutlineButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.buttonTextColor = Colors.black,
    this.isArrowNeeded = false,
    this.buttonBgColor,
    this.width,
    this.height,
  }) : super(key: key);

  final String label;
  final VoidCallback onTap;
  final bool isArrowNeeded;
  final Color buttonTextColor;
  final Color? buttonBgColor;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: width ?? double.infinity,
        height: height ?? getVerticalSize(30),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: buttonBgColor ?? ColorConstant.kColorWhite,
            borderRadius: BorderRadius.all(
              Radius.circular(20.r),
            ),
            border: Border.all(
              color: const Color(0xffE4E4E4),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: Assets.primaryFontPTSans,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: buttonTextColor,
                ),
              ),
              if (isArrowNeeded)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 2,
                    right: 10,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 15,
                    color: buttonTextColor,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
