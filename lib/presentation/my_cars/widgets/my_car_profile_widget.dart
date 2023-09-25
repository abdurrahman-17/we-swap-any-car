import '../../../core/configurations.dart';
import '../../../model/car_model/car_model.dart';
import '../../common_widgets/common_gradient_label.dart';
import '../my_car_profile_screen.dart';
import 'my_car_profile_content_slider.dart';

class MyCarProfileWidget extends StatefulWidget {
  const MyCarProfileWidget({
    super.key,
    required this.car,
    this.onTapRemove,
    this.onTapResume,
  });
  final CarModel car;
  final VoidCallback? onTapRemove;
  final VoidCallback? onTapResume;
  @override
  State<MyCarProfileWidget> createState() => _MyCarProfileWidgetState();
}

class _MyCarProfileWidgetState extends State<MyCarProfileWidget> {
  bool isContinueAddCar = false;

  @override
  void initState() {
    isContinueAddCar = !widget.car.createStatus!
            .contains(convertEnumToString(CarCreateStatus.completed))
        ? true
        : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isContinueAddCar) {
          Navigator.pushNamed(
            context,
            MyCarProfileScreen.routeName,
            arguments: {'carId': widget.car.id},
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(21.r),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(21.r),
                              topRight: Radius.circular(21.r),
                            ),
                            child: MyCarProfileContentSlider(
                              isContinueAddCar: isContinueAddCar,
                              aspectRatio: 1.8,
                              widgetWidth: constraints.maxWidth,
                              car: widget.car,
                              onTapSlider: () => Navigator.pushNamed(
                                context,
                                MyCarProfileScreen.routeName,
                                arguments: {'carId': widget.car.id},
                              ),
                            ),
                          );
                        },
                      ),
                      if (isContinueAddCar)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: CustomElevatedButton(
                                  title: removeButton,
                                  onTap: widget.onTapRemove,
                                  buttonBgColor: ColorConstant.kColorWhite,
                                  textStyle:
                                      AppTextStyle.regularTextStyle.copyWith(
                                    color: ColorConstant.kColorBlack,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: GradientElevatedButton(
                                  title: resumeButton,
                                  onTap: widget.onTapResume,
                                ),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: getPadding(
                      top: 16.h,
                      left: 19.w,
                      right: 19.w,
                      bottom: 24.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.car.manufacturer?.name
                                            ?.toUpperCase() ??
                                        '',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: isContinueAddCar
                                        ? AppTextStyle.smallTextStyle.copyWith(
                                            color: ColorConstant.kColor9D9D9D)
                                        : AppTextStyle.labelTextStyle,
                                  ),
                                  Text(
                                    widget.car.model ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.left,
                                    style:
                                        AppTextStyle.txtPTSansBold14Bluegray900,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: getPadding(left: 5.w),
                              child: Text(
                                euro +
                                    currencyFormatter(
                                        widget.car.userExpectedValue?.toInt() ??
                                            0),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppTextStyle.regularTextStyle.copyWith(
                                  fontSize: getFontSize(20),
                                  fontWeight: FontWeight.w700,
                                  color: ColorConstant.kColor353333,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        if (widget.car.additionalInformation?.attentionGraber !=
                                null &&
                            widget.car.additionalInformation!.attentionGraber!
                                .isNotEmpty)
                          Text(
                            widget.car.additionalInformation?.attentionGraber ??
                                notApplicable,
                            style: AppTextStyle.regularTextStyle.copyWith(
                              color: ColorConstant.gray600,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        mileageInfoBox(),
                        if (!isContinueAddCar)
                          Padding(
                            padding: getPadding(top: 13.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomImageView(
                                  svgPath: Assets.likeSmall,
                                  margin: getMargin(right: 8.w),
                                ),
                                Text(
                                  widget.car.analytics?.likes?.toString() ??
                                      '0',
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style:
                                      AppTextStyle.txtPTSansBold14Bluegray900,
                                ),
                                CustomImageView(
                                  svgPath: Assets.eyeVisible,
                                  margin: getMargin(left: 23.w, right: 8.w),
                                ),
                                Text(
                                  widget.car.analytics?.views?.toString() ??
                                      '0',
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style:
                                      AppTextStyle.txtPTSansBold14Bluegray900,
                                ),
                                const Spacer(),
                                const GradientLabel(text: offersLabel),
                                Padding(
                                  padding: getPadding(left: 8.w),
                                  child: Text(
                                    widget.car.analytics?.offersReceived
                                            ?.toString() ??
                                        '0',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style:
                                        AppTextStyle.txtPTSansBold14Bluegray900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.car.status == CarStatus.sold.name)
                Positioned(
                  bottom: 0,
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(21.r)),
                      color: ColorConstant.kColorBlack.withOpacity(0.8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GradientLabel(
                          height: 30,
                          width: 90,
                          text: soldLabel,
                          textStyle: AppTextStyle.regularTextStyle.copyWith(
                            fontWeight: FontWeight.w500,
                            fontFamily: Assets.secondaryFontOswald,
                            fontSize: getFontSize(16),
                            color: ColorConstant.kColorWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mileageInfoBox() {
    return Container(
      width: width,
      margin: getMargin(top: 10.h),
      padding: getPadding(
        left: 8.w,
        top: 5.h,
        right: 8.w,
        bottom: 5.h,
      ),
      decoration: isContinueAddCar
          ? BoxDecoration(
              color: ColorConstant.kColor565656,
              borderRadius: BorderRadius.circular(5.r),
            )
          : AppDecoration.gradientDeeporangeA200Yellow900.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder5,
            ),
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          children: [
            TextSpan(
              text: (widget.car.fuelType?.name ?? notApplicable).toUpperCase() +
                  mileageOfVehicle,
              style: AppTextStyle.smallTextStyle.copyWith(
                color: ColorConstant.kColorWhite,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: '${currencyFormatter(widget.car.mileage ?? 0)} '
                  '${milesLabel.toUpperCase()}',
              style: AppTextStyle.smallTextStyle.copyWith(
                color: ColorConstant.kColorWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
