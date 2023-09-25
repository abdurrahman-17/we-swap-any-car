import 'package:wsac/core/configurations.dart';
import 'package:super_banners/super_banners.dart';

class QuickOfferBanner extends StatelessWidget {
  const QuickOfferBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: CornerBanner(
        bannerColor: ColorConstant.kPrimaryDarkRed,
        shadowColor: Colors.black.withOpacity(0.8),
        elevation: 5,
        bannerPosition: CornerBannerPosition.topRight,
        child: Padding(
          padding: getPadding(top: 3.h, bottom: 3.h),
          child: Text(
            quickSale,
            style: AppTextStyle.regularTextStyle.copyWith(
              color: ColorConstant.kColorWhite,
              fontWeight: FontWeight.w700,
              fontSize: getFontSize(10),
            ),
          ),
        ),
      ),
    );
  }
}
