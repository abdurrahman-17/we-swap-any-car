import '../../../../core/configurations.dart';
import '../../../../model/user/subscription.dart';

class DealerAccountSubscriptionTile extends StatelessWidget {
  const DealerAccountSubscriptionTile({
    Key? key,
    required this.isSelectedIndex,
    required this.initialIndex,
    required this.plan,
    this.currentPlanName,
    this.currentPlanType,
    required this.onTapPayNow,
    required this.onTapContactUs,
    required this.onTapUpgrade,
    this.currentPlanCarLimit,
    this.subscriptionUpgradeStatus,
    this.cancelSubscriptionStatus,
  }) : super(key: key);

  final int isSelectedIndex;
  final int initialIndex;
  final SubscriptionModel plan;
  final String? currentPlanName;
  final String? currentPlanType;
  final int? currentPlanCarLimit;
  final VoidCallback onTapPayNow;
  final VoidCallback onTapContactUs;
  final VoidCallback onTapUpgrade;
  final String? subscriptionUpgradeStatus;
  final String? cancelSubscriptionStatus;

  @override
  Widget build(BuildContext context) {
    return ((currentPlanName == null &&
                plan.type !=
                    convertEnumToString(SubscriptionsType.freeTrial)) ||
            (plan.type != convertEnumToString(SubscriptionsType.freeTrial) &&
                currentPlanName != plan.name &&
                (currentPlanCarLimit! < plan.carLimit! ||
                    plan.type ==
                        convertEnumToString(SubscriptionsType.unlimited) ||
                    plan.type ==
                        convertEnumToString(SubscriptionsType.payAsYouGo))))
        ? Container(
            padding: EdgeInsets.symmetric(
              vertical: plan.type! !=
                      convertEnumToString(SubscriptionsType.payAsYouGo)
                  ? 19.h
                  : 0,
              horizontal: 19.w,
            ),
            margin: EdgeInsets.symmetric(vertical: 12.h),
            decoration: isSelectedIndex == initialIndex
                ? AppDecoration.outlineBlack9000c2.copyWith(
                    borderRadius: BorderRadius.circular(15.r),
                  )
                : BoxDecoration(
                    color: ColorConstant.kColorWhite,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (plan.type! ==
                    convertEnumToString(SubscriptionsType.payAsYouGo))
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: getPadding(top: 20.h, bottom: 7.h),
                        child: Center(
                          child: Text(
                            plan.name ?? '',
                            style: AppTextStyle.regularTextStyle.copyWith(
                                fontSize: 16,
                                color: isSelectedIndex == initialIndex
                                    ? ColorConstant.kColorWhite
                                    : ColorConstant.kColor686868),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '$euro ${plan.amount}/${plan.carLimit! > 1 ? '${plan.carLimit} Advert' : "Advert"}',
                                  style: AppTextStyle.regularTextStyle.copyWith(
                                    fontSize: getFontSize(24),
                                    color: isSelectedIndex == initialIndex
                                        ? ColorConstant.kColorWhite
                                        : ColorConstant.kColor5C5C5C,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: Assets.magistralFontStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                          plan.cycleType?.toLowerCase() == "month"
                              ? plan.validity == 1
                                  ? 'Valid for ${plan.validity} month'
                                  : 'Valid for ${plan.validity} months'
                              : plan.validity == 1
                                  ? 'Valid for ${plan.validity} day'
                                  : 'Valid for ${plan.validity} days',
                          style: AppTextStyle.regularTextStyle.copyWith(
                              color: isSelectedIndex == initialIndex
                                  ? ColorConstant.kColorWhite
                                  : ColorConstant.kColor686868)),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: CustomElevatedButton(
                          width: size.width / 3,
                          height: 33.h,
                          title: 'PAY NOW',
                          onTap: onTapPayNow,
                        ),
                      )
                    ],
                  ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (plan.type !=
                          convertEnumToString(SubscriptionsType.payAsYouGo))
                        Text(
                          plan.type ==
                                      convertEnumToString(
                                          SubscriptionsType.subscription) ||
                                  plan.type ==
                                      convertEnumToString(
                                          SubscriptionsType.freeTrial)
                              ? 'Upto'
                              : 'More than',
                          style: AppTextStyle.regularTextStyle.copyWith(
                              color: isSelectedIndex == initialIndex
                                  ? ColorConstant.kColorWhite
                                  : ColorConstant.kColor686868),
                        ),
                      if (plan.sortOrder! > 1 &&
                          plan.type !=
                              convertEnumToString(
                                  SubscriptionsType.freeTrial) &&
                          plan.type !=
                              convertEnumToString(SubscriptionsType.payAsYouGo))
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 3.h, horizontal: 11.w),
                          decoration: BoxDecoration(
                            color: isSelectedIndex == initialIndex
                                ? ColorConstant.kColorBlack.withOpacity(0.21)
                                : null,
                            borderRadius: BorderRadius.circular(25.r),
                            gradient:
                                LinearGradient(colors: kPrimaryGradientColor),
                          ),
                          child: Text(
                            plan.name!,
                            style: AppTextStyle.regularTextStyle
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                    ]),
                if (plan.type! !=
                    convertEnumToString(SubscriptionsType.payAsYouGo))
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(children: [
                      TextSpan(
                        text: plan.carLimit.toString(),
                        style: AppTextStyle.regularTextStyle.copyWith(
                          fontSize: getFontSize(42),
                          color: isSelectedIndex == initialIndex
                              ? ColorConstant.kColorE2E2E2
                              : ColorConstant.kColorBlack,
                          fontWeight: FontWeight.w700,
                          fontFamily: Assets.magistralFontStyle,
                        ),
                      ),
                      TextSpan(
                        text: ' Cars',
                        style: AppTextStyle.regularTextStyle.copyWith(
                          color: isSelectedIndex == initialIndex
                              ? ColorConstant.kColorE2E2E2
                              : ColorConstant.kColor686868,
                        ),
                      ),
                    ]),
                  ),
                if (plan.type! !=
                    convertEnumToString(SubscriptionsType.payAsYouGo))
                  Container(
                    color: ColorConstant.kColorE2E2E2,
                    width: size.width,
                    height: 1,
                  ),
                Padding(
                  padding: getPadding(top: 10.h, bottom: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: getPadding(left: 9.h),
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              if (plan.type ==
                                  convertEnumToString(
                                      SubscriptionsType.freeTrial))
                                TextSpan(
                                  text: plan.validity == 1
                                      ? '${plan.validity} day'
                                      : '${plan.validity} days',
                                  style: AppTextStyle.regularTextStyle.copyWith(
                                    fontSize: getFontSize(15),
                                    color: isSelectedIndex == initialIndex
                                        ? ColorConstant.kColorE2E2E2
                                        : ColorConstant.kColor5C5C5C,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: Assets.magistralFontStyle,
                                  ),
                                ),
                              if (plan.cycleType != "custom" &&
                                  plan.type !=
                                      convertEnumToString(
                                          SubscriptionsType.payAsYouGo) &&
                                  plan.type !=
                                      convertEnumToString(
                                          SubscriptionsType.unlimited))
                                TextSpan(
                                  text: '$euro ${plan.amount}',
                                  style: AppTextStyle.regularTextStyle.copyWith(
                                    fontSize: getFontSize(18),
                                    color: isSelectedIndex == initialIndex
                                        ? ColorConstant.kColorE2E2E2
                                        : ColorConstant.kColor5C5C5C,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: Assets.magistralFontStyle,
                                  ),
                                ),
                              if (plan.cycleType != "custom" &&
                                  plan.type !=
                                      convertEnumToString(
                                          SubscriptionsType.payAsYouGo) &&
                                  plan.type !=
                                      convertEnumToString(
                                          SubscriptionsType.unlimited))
                                TextSpan(
                                  text: plan.cycleType?.toLowerCase() == "month"
                                      ? "/Month"
                                      : plan.cycleType?.toLowerCase() == "year"
                                          ? "/Year"
                                          : plan.cycleType?.toLowerCase() ==
                                                  "day"
                                              ? "/Day"
                                              : "",
                                  style: AppTextStyle.regularTextStyle.copyWith(
                                    color: isSelectedIndex == initialIndex
                                        ? ColorConstant.kColorE2E2E2
                                        : ColorConstant.kColor5C5C5C,
                                    fontSize: getFontSize(14),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (plan.type ==
                              convertEnumToString(
                                  SubscriptionsType.freeTrial) ||
                          plan.type ==
                              convertEnumToString(
                                  SubscriptionsType.subscription) ||
                          plan.type ==
                              convertEnumToString(SubscriptionsType.unlimited))
                        CustomElevatedButton(
                          width: size.width / 3,
                          height: 33.h,
                          buttonBgColor: (subscriptionUpgradeStatus ==
                                      convertEnumToString(
                                          UpgradeSubscriptionStatus.pending) ||
                                  cancelSubscriptionStatus ==
                                      convertEnumToString(
                                          UpgradeSubscriptionStatus.pending) ||
                                  currentPlanType ==
                                      convertEnumToString(
                                          SubscriptionsType.freeTrial))
                              ? ColorConstant.gray50001
                              : null,
                          title: plan.type ==
                                  convertEnumToString(
                                      SubscriptionsType.unlimited)
                              ? "CONTACT US"
                              : plan.type ==
                                      convertEnumToString(
                                          SubscriptionsType.subscription)
                                  ? 'UPGRADE'
                                  : '',
                          onTap: (subscriptionUpgradeStatus !=
                                      convertEnumToString(
                                          UpgradeSubscriptionStatus.pending) &&
                                  cancelSubscriptionStatus !=
                                      convertEnumToString(
                                          UpgradeSubscriptionStatus.pending) &&
                                  currentPlanType !=
                                      convertEnumToString(
                                          SubscriptionsType.freeTrial))
                              ? plan.type ==
                                      convertEnumToString(
                                          SubscriptionsType.unlimited)
                                  ? onTapContactUs
                                  : plan.type ==
                                          convertEnumToString(
                                              SubscriptionsType.subscription)
                                      ? onTapUpgrade
                                      : () {}
                              : () {},
                        ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
