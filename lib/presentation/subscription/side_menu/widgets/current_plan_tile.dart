import '../../../../core/configurations.dart';

class CurrentPlanTile extends StatelessWidget {
  const CurrentPlanTile({
    Key? key,
    this.onTapCancel,
    required this.totalCarLimit,
    required this.carListed,
    this.amount,
    required this.planName,
    this.planType,
    this.cycle,
  }) : super(key: key);

  final VoidCallback? onTapCancel;
  final int totalCarLimit;
  final int carListed;
  final num? amount;
  final String planName;
  final String? planType;
  final int? cycle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 17.h,
              horizontal: 19.w,
            ),
            margin: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              gradient: LinearGradient(colors: kPrimaryGradientColor),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (planType ==
                        convertEnumToString(SubscriptionsType.freeTrial))
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: cycle?.toString(),
                              style: AppTextStyle.regularTextStyle.copyWith(
                                fontSize: getFontSize(21),
                                color: ColorConstant.kColorWhite,
                                fontWeight: FontWeight.w700,
                                fontFamily: Assets.magistralFontStyle,
                              ),
                            ),
                            TextSpan(
                              text: cycle != null && cycle == 1
                                  ? currentPlanDay
                                  : currentPlanDays,
                              style: AppTextStyle.regularTextStyle.copyWith(
                                color: ColorConstant.kColorWhite,
                                fontSize: getFontSize(15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (amount != null &&
                        planType !=
                            convertEnumToString(SubscriptionsType.freeTrial) &&
                        planType !=
                            convertEnumToString(SubscriptionsType.unlimited) &&
                        planType !=
                            convertEnumToString(SubscriptionsType.payAsYouGo))
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$euro $amount',
                              style: AppTextStyle.regularTextStyle.copyWith(
                                fontSize: getFontSize(21),
                                color: ColorConstant.kColorWhite,
                                fontWeight: FontWeight.w700,
                                fontFamily: Assets.magistralFontStyle,
                              ),
                            ),
                            TextSpan(
                              text: slashMonth,
                              style: AppTextStyle.regularTextStyle.copyWith(
                                color: ColorConstant.kColorWhite,
                                fontSize: getFontSize(15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 3.h, horizontal: 11.w),
                      decoration: BoxDecoration(
                        color: ColorConstant.kColorBlack,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Text(
                        planName.toUpperCase(),
                        style: AppTextStyle.regularTextStyle
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: carListed <= 9 && carListed > 0
                                ? zeroPrefix + carListed.toString()
                                : carListed.toString(),
                            style: AppTextStyle.regularTextStyle.copyWith(
                              fontSize: getFontSize(42),
                              color: ColorConstant.kColorWhite,
                              fontWeight: FontWeight.w700,
                              fontFamily: Assets.magistralFontStyle,
                            ),
                          ),
                          if (planType !=
                              convertEnumToString(SubscriptionsType.unlimited))
                            TextSpan(
                              text: totalCarLimit <= 9
                                  ? slash +
                                      zeroPrefix +
                                      totalCarLimit.toString()
                                  : slash + totalCarLimit.toString(),
                              style: AppTextStyle.regularTextStyle.copyWith(
                                fontSize: getFontSize(42),
                                color: ColorConstant.kColorWhite,
                                fontWeight: FontWeight.w700,
                                fontFamily: Assets.magistralFontStyle,
                              ),
                            ),
                          if (planType ==
                              convertEnumToString(SubscriptionsType.unlimited))
                            TextSpan(
                              text: slash + unlimited,
                              style: AppTextStyle.regularTextStyle.copyWith(
                                fontSize: getFontSize(26),
                                color: ColorConstant.kColorWhite,
                                fontWeight: FontWeight.w700,
                                fontFamily: Assets.magistralFontStyle,
                              ),
                            ),
                          TextSpan(
                            text: planType !=
                                    convertEnumToString(
                                        SubscriptionsType.unlimited)
                                ? currentPlanCars
                                : totalCarLimit == 1
                                    ? currentPlanCar
                                    : currentPlanCars,
                            style: AppTextStyle.regularTextStyle.copyWith(
                              color: ColorConstant.whiteA700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (planType !=
                            convertEnumToString(SubscriptionsType.payAsYouGo) &&
                        planType != null)
                      GestureDetector(
                        onTap: onTapCancel,
                        child: Text(
                          cancelPlan,
                          style: AppTextStyle.regularTextStyle.copyWith(
                            color: ColorConstant.kColorCD9393,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
