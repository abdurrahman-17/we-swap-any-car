import 'package:wsac/core/configurations.dart';

import '../../../model/car_model/car_model.dart';
import '../../common_popup_widget/decription_popup.dart';
import '../../common_widgets/common_divider.dart';
import '../../common_widgets/common_popups.dart';
import 'swipe_card_content_slider.dart';

class CarInfoCard extends StatefulWidget {
  const CarInfoCard({
    Key? key,
    this.onTapBack,
    this.onTapMakeOffer,
    this.onTapFilter,
    this.onTapViewDetails,
    required this.redoEnable,
    required this.car,
    this.quickSaleTutorialKey,
    this.makeAnOfferTutorialKey,
    this.premiumTutorialKey,
    this.backButtonTutorialKey,
    this.filterButtonTutorialKey,
    this.viewDetailsButtonTutorialKey,
    this.isTutorialVisible = false,
  }) : super(key: key);
  final CarModel car;
  final GestureTapCallback? onTapBack;
  final GestureTapCallback? onTapMakeOffer;
  final GestureTapCallback? onTapFilter;
  final GestureTapCallback? onTapViewDetails;
  final GlobalKey? makeAnOfferTutorialKey;
  final GlobalKey? premiumTutorialKey;
  final GlobalKey? backButtonTutorialKey;
  final GlobalKey? filterButtonTutorialKey;
  final GlobalKey? quickSaleTutorialKey;
  final GlobalKey? viewDetailsButtonTutorialKey;
  final ValueNotifier<bool> redoEnable;
  final bool isTutorialVisible;

  @override
  State<CarInfoCard> createState() => _CarInfoCardState();
}

class _CarInfoCardState extends State<CarInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwipeCardContentSlider(
          car: widget.car,
          premiumTutorialKey: widget.premiumTutorialKey,
          quickSaleTutorialKey: widget.quickSaleTutorialKey,
          isTutorialVisible: widget.isTutorialVisible,
        ),
        Expanded(child: carDetails()),
      ],
    );
  }

  Widget carDetails() {
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
          Container(
            padding: EdgeInsets.only(
              top: 18.h,
              left: 18.w,
              right: 18.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomImageView(svgPath: Assets.swipeDislike),
                    Padding(
                      padding: getPadding(left: 15.w, right: 15.w),
                      child: Text(
                        swipeInstructionLabel,
                        style: AppTextStyle.regularTextStyle.copyWith(
                          color: ColorConstant.kColorF27B79,
                          fontWeight: FontWeight.w700,
                          fontSize: getFontSize(16.sp),
                        ),
                      ),
                    ),
                    const CustomImageView(svgPath: Assets.swipeLike)
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (widget.car.manufacturer?.name ?? notApplicable)
                                .toUpperCase(),
                            style: AppTextStyle.labelTextStyle,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            (widget.car.model ?? notApplicable).toUpperCase(),
                            maxLines: 2,
                            style: AppTextStyle.regularTextStyle.copyWith(
                              fontWeight: FontWeight.w700,
                              color: ColorConstant.kColor353333,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 5.w),
                      child: Text(
                        euro +
                            currencyFormatter(
                                widget.car.userExpectedValue ?? 0),
                        style: AppTextStyle.regularTextStyle.copyWith(
                          fontSize: getFontSize(22),
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.kColor353333,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorConstant.kColorE4E4E4,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 3.h,
                          horizontal: 8.w,
                        ),
                        margin: getMargin(right: 7),
                        child: Row(
                          children: [
                            Text(
                              (widget.car.fuelType?.name ?? notApplicable)
                                      .toUpperCase() +
                                  mileageOfVehicle,
                              style: AppTextStyle.smallTextStyle,
                            ),
                            Text(
                              currencyFormatter(widget.car.mileage ?? 0) +
                                  milesOfVehicle,
                              style: AppTextStyle.smallTextStyle
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      key: widget.viewDetailsButtonTutorialKey,
                      height: 23.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstant.kColorBlack,
                          padding: EdgeInsets.symmetric(
                            vertical: 3.h,
                            horizontal: 7.w,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: widget.onTapViewDetails,
                        child: Text(
                          viewDetailsButton,
                          style: AppTextStyle.regularTextStyle.copyWith(
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.kColorWhite,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.car.additionalInformation?.attentionGraber != null &&
                    widget
                        .car.additionalInformation!.attentionGraber!.isNotEmpty)
                  Padding(
                    padding: getPadding(top: 8.h, bottom: 8.h),
                    child: Column(
                      children: [
                        CommonDivider(color: ColorConstant.kColorD6D6D6),
                        GestureDetector(
                          onTap: () => customPopup(
                            content: DescriptionPopupWidget(car: widget.car),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: getPadding(top: 4.h, bottom: 4.h),
                            child: Text(
                              widget.car.additionalInformation
                                      ?.attentionGraber ??
                                  notApplicable,
                              style: AppTextStyle.regularTextStyle.copyWith(
                                color: ColorConstant.kColorBlack,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        CommonDivider(color: ColorConstant.kColorD6D6D6),
                      ],
                    ),
                  ),
                if (widget.car.additionalInformation?.attentionGraber == null ||
                    widget.car.additionalInformation!.attentionGraber!.isEmpty)
                  SizedBox(height: 40.h),
                cardBottomOptions(),
              ],
            ),
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
        ValueListenableBuilder<bool>(
          valueListenable: widget.redoEnable,
          builder: (BuildContext context, bool value, Widget? child) {
            return CustomElevatedButton(
              width: size.width / 3.8,
              key: widget.backButtonTutorialKey,
              title: backButton,
              onTap: value ? widget.onTapBack : null,
              prefixIcon: CustomImageView(
                svgPath: Assets.undo,
                margin: getMargin(right: 7),
                color: value ? null : ColorConstant.kColor7C7C7C,
              ),
            );
          },
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: GradientElevatedButton(
            key: widget.makeAnOfferTutorialKey,
            title: makeAnOfferButton.toUpperCase(),
            onTap: widget.onTapMakeOffer,
          ),
        ),
        SizedBox(width: 6.w),
        CustomElevatedButton(
          width: size.width / 3.8,
          key: widget.filterButtonTutorialKey,
          title: filterButton,
          onTap: widget.onTapFilter,
          suffixIcon: CustomImageView(
            svgPath: Assets.filter,
            margin: getMargin(left: 7),
          ),
        ),
      ],
    );
  }
}
