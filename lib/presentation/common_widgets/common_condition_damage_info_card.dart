import '../../core/configurations.dart';
import 'full_screen_image_viewer.dart';

class ConditionDamageCarInfoCardWidget extends StatelessWidget {
  const ConditionDamageCarInfoCardWidget({
    super.key,
    required this.value,
    required this.label,
    this.images,
  });

  final String label;
  final List<String>? images;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getPadding(top: 11.h, bottom: 11.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyle.labelTextStyle.copyWith(
                    color: ColorConstant.kColor7C7C7C,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                padding: getPadding(
                  left: 10.w,
                  right: 10.w,
                  top: 3.h,
                  bottom: 3.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.5.r),
                  gradient: value
                      ? LinearGradient(colors: kPrimaryGradientColor)
                      : null,
                  color: value ? null : ColorConstant.kColorBlack,
                ),
                child: Center(
                  child: Text(
                    value ? yesText : noText,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: AppTextStyle.gradientBgButtonTextStyle,
                  ),
                ),
              ),
            ],
          ),
          if (images != null && images!.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              padding: getPadding(top: 10.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: getVerticalSize(70),
                crossAxisCount: 4,
                mainAxisSpacing: getHorizontalSize(8),
                crossAxisSpacing: getHorizontalSize(8),
              ),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: images!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        FullScreenImageViewer.routeName,
                        arguments: {
                          'imageList': images,
                          "isMultiImage": true,
                          "initialIndex": index,
                        },
                      );
                    },
                    child: imageView(images![index]));
              },
            ),
        ],
      ),
    );
  }

  Widget imageView(String image) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorConstant.kColorBlack,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: CustomImageView(
        url: image,
        radius: BorderRadius.circular(8.r),
      ),
    );
  }
}
