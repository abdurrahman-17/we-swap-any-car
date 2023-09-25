import 'package:wsac/core/configurations.dart';

import '../../common_widgets/common_divider.dart';
import '../../common_widgets/common_loader.dart';

class CarInfoCardShimmer extends StatefulWidget {
  const CarInfoCardShimmer({Key? key}) : super(key: key);

  @override
  State<CarInfoCardShimmer> createState() => _CarInfoCardShimmerState();
}

class _CarInfoCardShimmerState extends State<CarInfoCardShimmer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstant.kBackgroundColor,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomImageView(
              svgPath: Assets.homeBackground,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shimmerLoader(
                AspectRatio(
                  aspectRatio: 1.2,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(color: ColorConstant.kColorWhite),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageView(
                    svgPath: Assets.swipeDislike,
                    color: ColorConstant.kColorE4E4E4,
                  ),
                  Padding(
                    padding: getPadding(left: 15.w, right: 15.w),
                    child: Text(
                      swipeInstructionLabel,
                      style: AppTextStyle.regularTextStyle.copyWith(
                        color: ColorConstant.kColorE4E4E4,
                        fontWeight: FontWeight.w700,
                        fontSize: getFontSize(16.sp),
                      ),
                    ),
                  ),
                  CustomImageView(
                    svgPath: Assets.swipeLike,
                    color: ColorConstant.kColorE4E4E4,
                  )
                ],
              ),
              Padding(
                padding: getPadding(
                  top: 6.h,
                  bottom: 8.h,
                  left: 20.w,
                  right: 20.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerLoader(
                          Container(
                            height: getVerticalSize(20.h),
                            width: getHorizontalSize(100.w),
                            margin: getMargin(bottom: 8.h),
                            decoration: BoxDecoration(
                              color: ColorConstant.kColorWhite,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ),
                        ),
                        shimmerLoader(
                          Container(
                            height: getVerticalSize(20.h),
                            width: getHorizontalSize(150.w),
                            decoration: BoxDecoration(
                              color: ColorConstant.kColorWhite,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                    shimmerLoader(
                      Container(
                        height: getVerticalSize(35.h),
                        width: getHorizontalSize(90.w),
                        decoration: BoxDecoration(
                          color: ColorConstant.kColorWhite,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: shimmerLoader(
                      Container(
                        height: getVerticalSize(24.h),
                        margin: getMargin(left: 20.w, bottom: 10.h),
                        decoration: BoxDecoration(
                          color: ColorConstant.kColorWhite,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: shimmerLoader(
                      Container(
                        height: getVerticalSize(24.h),
                        margin: getMargin(left: 8.w, right: 20.w, bottom: 10.h),
                        decoration: BoxDecoration(
                          color: ColorConstant.kColorWhite,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: getPadding(bottom: 4.h, left: 20.w, right: 20.w),
                child: const CommonDivider(),
              ),
              shimmerLoader(
                Container(
                  height: getVerticalSize(30.h),
                  width: double.infinity,
                  margin: getMargin(left: 20.w, right: 20.w),
                  decoration: BoxDecoration(
                    color: ColorConstant.kColorWhite,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
              ),
              Padding(
                padding: getPadding(
                  top: 4.h,
                  bottom: 8.h,
                  left: 20.w,
                  right: 20.w,
                ),
                child: const CommonDivider(),
              ),
              Padding(
                padding: getPadding(left: 20.w, right: 20.w),
                child: cardBottomOptions(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget cardBottomOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: getHorizontalSize(size.width / 4.5),
          child: shimmerLoader(
            Container(
              height: 41.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: ColorConstant.kColorWhite,
              ),
            ),
          ),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: shimmerLoader(
            Container(
              height: 41.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: ColorConstant.kColorWhite,
              ),
            ),
          ),
        ),
        SizedBox(width: 5.w),
        SizedBox(
          width: getHorizontalSize(size.width / 4.5),
          child: shimmerLoader(
            Container(
              height: 41.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: ColorConstant.kColorWhite,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
