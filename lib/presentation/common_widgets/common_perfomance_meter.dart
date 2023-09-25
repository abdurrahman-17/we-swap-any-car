import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../core/configurations.dart';

class PerformanceMeterWithDetails extends StatelessWidget {
  const PerformanceMeterWithDetails({
    super.key,
    required this.totalCount,
    required this.achivedCount,
    this.fillGradientColor,
    this.bottomMsg,
  });
  final List<Color>? fillGradientColor;
  final String? bottomMsg;
  final num totalCount;
  final num achivedCount;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: getVerticalSize(125),
              child: SfRadialGauge(
                enableLoadingAnimation: true,
                axes: [
                  RadialAxis(
                    showLabels: false,
                    majorTickStyle: const MajorTickStyle(thickness: 0),
                    minorTickStyle: const MinorTickStyle(thickness: 0),
                    maximum: totalCount.toDouble(),
                    ranges: <GaugeRange>[
                      GaugeRange(
                        startValue: 0,
                        endValue: achivedCount.toDouble(),
                        gradient: SweepGradient(
                          colors: fillGradientColor ?? kPrimaryGradientColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: (achivedCount / totalCount * 100).round().toString(),
                    style: AppTextStyle.regularTextStyle.copyWith(
                      color: ColorConstant.kColor353333,
                      fontSize: getFontSize(40),
                      fontFamily: Assets.magistralFontStyle,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: percentage,
                    style: AppTextStyle.regularTextStyle.copyWith(
                      color: ColorConstant.kColor353333,
                      fontSize: getFontSize(25),
                      fontFamily: Assets.magistralFontStyle,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 12.w),
              decoration: AppDecoration.fillBlack900
                  .copyWith(borderRadius: BorderRadiusStyle.roundedBorder5),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: achivedCount.toString(),
                      style: AppTextStyle.txtMagistralBold18,
                    ),
                    TextSpan(
                      text: ' / ',
                      style: AppTextStyle.txtMagistralBold10,
                    ),
                    TextSpan(
                      text: totalCount.toString(),
                      style: AppTextStyle.txtMagistralBold10,
                    ),
                  ],
                ),
              ),
            ),
            if (bottomMsg != null)
              Padding(
                padding: getPadding(top: 9.h, bottom: 9.h),
                child: Text(
                  bottomMsg!,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppTextStyle.txtPTSansRegular10Gray600,
                ),
              )
          ],
        ),
      ],
    );
  }
}
