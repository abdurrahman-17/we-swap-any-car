import 'package:dots_indicator/dots_indicator.dart';
import 'package:wsac/core/configurations.dart';

class CoachMarkDesc extends StatefulWidget {
  const CoachMarkDesc({
    Key? key,
    this.titleText,
    this.descText,
    required this.onTapDismiss,
    required this.onTapNext,
    required this.currentIndex,
    this.isFirstPage = false,
    this.isLastPage = false,
  }) : super(key: key);

  final String? titleText;
  final String? descText;
  final VoidCallback onTapDismiss;
  final VoidCallback onTapNext;
  final int currentIndex;
  final bool isFirstPage;
  final bool isLastPage;

  @override
  State<CoachMarkDesc> createState() => _CoachMarkDescState();
}

class _CoachMarkDescState extends State<CoachMarkDesc> {
  @override
  Widget build(BuildContext context) {
    return !widget.isFirstPage
        ? Container(
            padding: getPadding(
              top: 30.h,
              left: 25.w,
              right: 25.w,
              bottom: 15.h,
            ),
            decoration: BoxDecoration(
              color: ColorConstant.kPrimaryDarkRed,
              borderRadius: BorderRadius.circular(21.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.titleText ?? helpinfoHeading,
                  style: AppTextStyle.regularTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.kColorWhite,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    widget.descText ?? helpinfoDescription,
                    style: AppTextStyle.regularTextStyle.copyWith(
                      color: ColorConstant.kColorWhite,
                    ),
                  ),
                ),
                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DotsIndicator(
                      dotsCount: 6,
                      position: widget.currentIndex,
                      decorator: DotsDecorator(
                        activeColor: ColorConstant.kColorWhite,
                        color: ColorConstant.kColorWhite.withOpacity(0.5),
                        size: const Size(5, 5),
                        activeSize: const Size(6, 6),
                        spacing: const EdgeInsets.all(2.5),
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: widget.onTapDismiss,
                          child: Text(
                            dismissButton,
                            style: AppTextStyle.regularTextStyle.copyWith(
                              color: ColorConstant.kColorWhite,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!widget.isLastPage)
                          TextButton(
                            onPressed: widget.onTapNext,
                            child: Text(
                              nextButton,
                              style: AppTextStyle.regularTextStyle.copyWith(
                                color: ColorConstant.kColorWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        : SafeArea(
            child: Column(
              children: [
                Container(
                  padding: getPadding(all: 18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-2, 0.5),
                      end: Alignment(2, 0.1),
                      colors: [
                        Colors.transparent,
                        Colors.lightGreen,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomImageView(
                            height: getSize(20),
                            width: getSize(20),
                            svgPath: Assets.likeThumbWhite,
                            margin: getMargin(right: 15),
                          ),
                          Text(
                            slideRightToLike,
                            style: AppTextStyle.regularTextStyle.copyWith(
                              color: ColorConstant.kColorWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: getFontSize(13),
                            ),
                          ),
                        ],
                      ),
                      const CustomImageView(svgPath: Assets.forwardArrowWhite),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                Container(
                  padding: getPadding(all: 18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-2, 0.5),
                      end: Alignment(1, 0.1),
                      colors: [
                        Colors.redAccent,
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomImageView(svgPath: Assets.backwardArrowWhite),
                      Row(
                        children: [
                          Text(
                            slideLeftToDislike,
                            style: AppTextStyle.regularTextStyle.copyWith(
                              color: ColorConstant.kColorWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: getFontSize(13),
                            ),
                          ),
                          SizedBox(width: 15.w),
                          CustomImageView(
                            height: getSize(20),
                            width: getSize(20),
                            svgPath: Assets.disLikeThumbWhite,
                            margin: getMargin(right: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getVerticalSize(size.height / 4)),
                CustomElevatedButton(
                  title: nextButton,
                  onTap: widget.onTapDismiss,
                  width: getHorizontalSize(size.width / 3),
                  buttonBgColor: ColorConstant.kColor373737,
                )
              ],
            ),
          );
  }
}
