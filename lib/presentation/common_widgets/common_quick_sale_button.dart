import '../../core/configurations.dart';

class QuickSaleButton extends StatelessWidget {
  const QuickSaleButton({
    super.key,
    this.isEnabled = false,
    required this.text,
    this.onPressed,
  });
  final VoidCallback? onPressed;
  final String text;
  final bool isEnabled;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: getPadding(all: 11),
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorConstant.kColorWhite,
            width: getHorizontalSize(1),
          ),
          gradient: LinearGradient(
            colors: isEnabled ? kQuickSaleGradientColor : kDisableGradientColor,
          ),
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomImageView(svgPath: Assets.quickSale),
            Padding(
              padding: getPadding(right: 8, left: 12),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: AppTextStyle.regularTextStyle.copyWith(
                  color: ColorConstant.kColorWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
