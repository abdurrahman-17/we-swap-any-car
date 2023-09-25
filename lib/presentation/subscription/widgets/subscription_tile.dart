import '../../../core/configurations.dart';
import '../../../model/user/subscription.dart';

class SubscriptionTile extends StatelessWidget {
  const SubscriptionTile({
    Key? key,
    required this.isSelectedIndex,
    required this.initialIndex,
    this.onTap,
    required this.plan,
    required this.payAsYouGoExpired,
    required this.onTapFreeTrial,
    required this.onTapPayNow,
    required this.onTapContactUs,
    required this.onTapSubscribe,
  }) : super(key: key);

  final int isSelectedIndex;
  final int initialIndex;
  final bool payAsYouGoExpired;
  final GestureTapCallback? onTap;
  final SubscriptionModel plan;
  final VoidCallback onTapFreeTrial;
  final VoidCallback onTapPayNow;
  final VoidCallback onTapContactUs;
  final VoidCallback onTapSubscribe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: plan.type! !=
                      convertEnumToString(SubscriptionsType.payAsYouGo)
                  ? 19.h
                  : 0,
              horizontal: 19.w,
            ),
            margin: EdgeInsets.symmetric(vertical: 12.h),
            decoration:
                plan.type! == convertEnumToString(SubscriptionsType.payAsYouGo)
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
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          plan.name!,
                          style: AppTextStyle.regularTextStyle.copyWith(
                              fontSize: 16,
                              color: plan.type! ==
                                      convertEnumToString(
                                          SubscriptionsType.payAsYouGo)
                                  ? ColorConstant.kColorWhite
                                  : ColorConstant.kColor686868),
                        ),
                      ),
                      const SizedBox(
                        height: 7,
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
                                    color: plan.type! ==
                                            convertEnumToString(
                                                SubscriptionsType.payAsYouGo)
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
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          plan.cycleType?.toLowerCase() == "month"
                              ? plan.validity == 1
                                  ? 'Valid for ${plan.validity} month'
                                  : 'Valid for ${plan.validity} months'
                              : plan.validity == 1
                                  ? 'Valid for ${plan.validity} day'
                                  : 'Valid for ${plan.validity} days',
                          style: AppTextStyle.regularTextStyle.copyWith(
                              color: plan.type! ==
                                      convertEnumToString(
                                          SubscriptionsType.payAsYouGo)
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
                    if (plan.type! !=
                        convertEnumToString(SubscriptionsType.payAsYouGo))
                      Text(
                        plan.type == "subscription" || plan.type == "freeTrial"
                            ? 'Upto'
                            : 'More than',
                        style: AppTextStyle.regularTextStyle.copyWith(
                            color: plan.type! ==
                                    convertEnumToString(
                                        SubscriptionsType.payAsYouGo)
                                ? ColorConstant.kColorWhite
                                : ColorConstant.kColor686868),
                      ),
                    if (plan.sortOrder! > 1 &&
                        plan.type !=
                            convertEnumToString(SubscriptionsType.freeTrial) &&
                        plan.type !=
                            convertEnumToString(SubscriptionsType.payAsYouGo))
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 3.h, horizontal: 11.w),
                        decoration: BoxDecoration(
                          color: plan.type! ==
                                  convertEnumToString(
                                      SubscriptionsType.payAsYouGo)
                              ? ColorConstant.kColorBlack.withOpacity(0.21)
                              : ColorConstant.kPrimaryDarkRed,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Text(
                          plan.name!,
                          style: AppTextStyle.regularTextStyle
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                  ],
                ),
                if (plan.type! !=
                    convertEnumToString(SubscriptionsType.payAsYouGo))
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: plan.carLimit.toString(),
                          style: AppTextStyle.regularTextStyle.copyWith(
                            fontSize: getFontSize(42),
                            color: plan.type! ==
                                    convertEnumToString(
                                        SubscriptionsType.payAsYouGo)
                                ? ColorConstant.kColorE2E2E2
                                : ColorConstant.kColorBlack,
                            fontWeight: FontWeight.w700,
                            fontFamily: Assets.magistralFontStyle,
                          ),
                        ),
                        TextSpan(
                          text: ' Cars',
                          style: AppTextStyle.regularTextStyle.copyWith(
                            color: plan.type! ==
                                    convertEnumToString(
                                        SubscriptionsType.payAsYouGo)
                                ? ColorConstant.kColorE2E2E2
                                : ColorConstant.kColor686868,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (plan.type! !=
                    convertEnumToString(SubscriptionsType.payAsYouGo))
                  Container(
                    color: ColorConstant.kColorE2E2E2,
                    width: size.width,
                    height: 1,
                  ),
                Padding(
                  padding: getPadding(top: 10, bottom: 15),
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
                                    color: plan.type! ==
                                            convertEnumToString(
                                                SubscriptionsType.payAsYouGo)
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
                                    color: plan.type! ==
                                            convertEnumToString(
                                                SubscriptionsType.payAsYouGo)
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
                                    color: plan.type! ==
                                            convertEnumToString(
                                                SubscriptionsType.payAsYouGo)
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
                          title: plan.type ==
                                  convertEnumToString(
                                      SubscriptionsType.freeTrial)
                              ? 'FREE TRIAL'
                              : payAsYouGoExpired &&
                                      plan.type !=
                                          convertEnumToString(
                                              SubscriptionsType.unlimited)
                                  ? "UPGRADE"
                                  : plan.type ==
                                          convertEnumToString(
                                              SubscriptionsType.unlimited)
                                      ? "CONTACT US"
                                      : plan.type ==
                                              convertEnumToString(
                                                  SubscriptionsType
                                                      .subscription)
                                          ? 'SUBSCRIBE'
                                          : '',
                          onTap: plan.type ==
                                  convertEnumToString(
                                      SubscriptionsType.freeTrial)
                              ? onTapFreeTrial
                              : plan.type ==
                                      convertEnumToString(
                                          SubscriptionsType.unlimited)
                                  ? onTapContactUs
                                  : plan.type ==
                                          convertEnumToString(
                                              SubscriptionsType.subscription)
                                      ? onTapSubscribe
                                      : () {},
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (plan.type == convertEnumToString(SubscriptionsType.freeTrial))
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width,
                  child: Text(
                    'Lorem ipsum doler sit umetLorem ipsum doler sit umetLorem',
                    style: AppTextStyle.regularTextStyle.copyWith(
                      color: ColorConstant.kColor6C6C6C,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
