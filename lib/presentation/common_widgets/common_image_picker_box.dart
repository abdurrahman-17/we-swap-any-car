import '../../core/configurations.dart';

class ImagePickerGradientBox extends StatefulWidget {
  const ImagePickerGradientBox({Key? key, this.onTap}) : super(key: key);
  final GestureTapCallback? onTap;
  @override
  State<ImagePickerGradientBox> createState() => _ImagePickerGradientBoxState();
}

class _ImagePickerGradientBoxState extends State<ImagePickerGradientBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        margin: getMargin(top: 9.h),
        padding: EdgeInsets.symmetric(vertical: 42.h),
        decoration: AppDecoration.kGradientBoxDecoration.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder5.r,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomImageView(svgPath: Assets.camerawhite),
            Padding(
              padding: getPadding(top: 10.h),
              child: Text(
                clickHeretoAddImage,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppTextStyle.txtPTSansRegular12WhiteA700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
