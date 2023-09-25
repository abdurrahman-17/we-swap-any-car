import '../../core/configurations.dart';
import '../common_widgets/common_divider.dart';

class AboutUsScreen extends StatelessWidget {
  static const String routeName = 'about_us_screen';
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: aboutUsAppBar,
      body: Stack(
        children: [
          CustomImageView(
            svgPath: Assets.homeBackground,
            fit: BoxFit.fill,
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
          ),
          SafeArea(
            child: Padding(
              padding: getPadding(left: 35, right: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: getPadding(top: 35.h),
                    child: CustomImageView(
                      alignment: Alignment.topCenter,
                      svgPath: Assets.logoFrame,
                      width: getHorizontalSize(size.width / 2.8),
                    ),
                  ),
                  Container(
                    width: getHorizontalSize(
                      130.00,
                    ),
                    margin: getMargin(top: 75, bottom: 45),
                    child: Text(
                      "ABOUT \nWE SWAP ANY CAR",
                      textAlign: TextAlign.left,
                      style: AppTextStyle.txtPTSansBold16Bluegray900,
                    ),
                  ),
                  const GradientDivider(),
                  Padding(
                    padding: getPadding(top: 37),
                    child: Text(
                      aboutUsDescrition,
                      textAlign: TextAlign.left,
                      softWrap: true,
                      style: AppTextStyle.regularTextStyle.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        height: 1.3,
                        wordSpacing: 1.2,
                        color: ColorConstant.kColorBlack,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
