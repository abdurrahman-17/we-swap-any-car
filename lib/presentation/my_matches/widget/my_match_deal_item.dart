import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wsac/model/my_matches/my_matches_model.dart';

import '../../../core/configurations.dart';
import '../../common_widgets/common_divider.dart';

class MyMatchDealItem extends StatelessWidget {
  const MyMatchDealItem({Key? key, this.myMatch}) : super(key: key);

  final MyMatchModel? myMatch;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: ColorConstant.kColorWhite,
            borderRadius: BorderRadius.all(
              Radius.circular(20.r),
            ),
            border: Border.all(color: ColorConstant.kColorD9D9D9),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Car One
              Padding(
                padding: getPadding(left: 17, top: 20, right: 17, bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CustomImageView(
                          border: Border.all(color: ColorConstant.gray200),
                          url: myMatch!.carOne!.image,
                          fit: BoxFit.contain,
                          radius: BorderRadius.circular(2.r),
                          height: getVerticalSize(40),
                          width: getHorizontalSize(56),
                        ),
                        Expanded(
                          child: Padding(
                            padding: getPadding(left: 9, top: 2, bottom: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  myMatch?.carOne?.carName ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppTextStyle.txtPTSansRegular14Black900
                                      .copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                Padding(
                                  padding: getPadding(top: 6.h),
                                  child: Text(
                                    myMatch?.carOne?.registration ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style:
                                        AppTextStyle.txtPTSansRegular14Gray550,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          currencyFormatter(
                                  (myMatch?.carOne?.mileage ?? 0).round()) +
                              milesOfVehicle.toProperCase(),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppTextStyle.txtPTSansRegular14Gray550,
                        ),
                        const Spacer(),
                        Text(
                          euro +
                              currencyFormatter(
                                  (myMatch?.carOne?.userExpectedValue ?? 0)),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppTextStyle.txtPTSansBold22,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: getPadding(left: 25, top: 20, right: 17, bottom: 10),
                decoration: BoxDecoration(
                  color: ColorConstant.gray100,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: getSize(36),
                          width: getSize(36),
                          decoration:
                              AppDecoration.kGradientBoxDecoration.copyWith(
                            border: Border.all(
                                color: ColorConstant.kPrimaryLightRed),
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: myMatch?.carTwo?.avatarImage != null
                              ? CustomImageView(
                                  url: myMatch?.carTwo?.avatarImage,
                                  radius: BorderRadius.circular(100.r),
                                  height: getSize(36),
                                  width: getSize(36),
                                  fit: BoxFit.fill,
                                )
                              : CustomImageView(
                                  svgPath: myMatch?.carTwo?.userType ==
                                          convertEnumToString(UserType.private)
                                      ? Assets.privatePlaceholder
                                      : Assets.dealerPlaceholder,
                                  margin: getMargin(all: 7),
                                  color: ColorConstant.kColorWhite,
                                ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: getPadding(left: 9),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: getPadding(right: 7, bottom: 3),
                                  child: Text(
                                    (myMatch?.carTwo?.userName ?? '')
                                        .toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppTextStyle.txtPTSansBold12Gray700,
                                  ),
                                ),
                                RatingBar.builder(
                                  initialRating:
                                      (myMatch?.carTwo?.rating ?? 0).toDouble(),
                                  minRating: 1,
                                  allowHalfRating: true,
                                  itemSize: 15,
                                  unratedColor: Colors.grey,
                                  ignoreGestures: true,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (double value) {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: getPadding(top: 20, bottom: 5),
                child: Column(
                  children: [
                    Padding(
                      padding: getPadding(left: 25, right: 17),
                      child: Row(
                        children: [
                          CustomImageView(
                            border: Border.all(color: ColorConstant.gray200),
                            url: myMatch!.carTwo!.image,
                            radius: BorderRadius.circular(2.r),
                            fit: BoxFit.contain,
                            height: getVerticalSize(40),
                            width: getHorizontalSize(56),
                          ),
                          Expanded(
                            child: Padding(
                              padding: getPadding(left: 9, top: 2, bottom: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    myMatch?.carTwo?.carName ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppTextStyle
                                        .txtPTSansRegular14Black900
                                        .copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(top: 6.h),
                                    child: Text(
                                      myMatch?.carTwo?.registration ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppTextStyle
                                          .txtPTSansRegular14Gray550,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: getPadding(
                        left: 25,
                        right: 17,
                        bottom: 5,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            currencyFormatter(
                                    (myMatch?.carTwo?.mileage ?? 0).round()) +
                                milesOfVehicle.toProperCase(),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppTextStyle.txtPTSansRegular14Gray550,
                          ),
                          const Spacer(),
                          Text(
                            euro +
                                currencyFormatter(
                                    (myMatch?.carTwo?.userExpectedValue ?? 0)),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppTextStyle.txtPTSansBold22,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              CommonDivider(color: ColorConstant.kColorE3E3E3),
              Padding(
                padding: getPadding(top: 15.h, bottom: 15.h),
                child: GestureDetector(
                  onTap: () async {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImageView(
                        color: ColorConstant.kColor898989,
                        svgPath: Assets.bottomChat,
                        margin: getMargin(right: 6.w),
                      ),
                      Text(
                        chatNowButton,
                        style: AppTextStyle.txtPTSansBold14Gray900,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: getVerticalSize(102),
          left: getHorizontalSize(size.width / 2.75),
          child: Container(
            padding: getPadding(all: 8),
            width: getSize(30),
            height: getSize(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorConstant.kColorWhite,
              border: Border.all(color: ColorConstant.kColorE3E3E3),
            ),
            child: const CustomImageView(
              svgPath: Assets.bottomLike,
            ),
          ),
        ),
      ],
    );
  }
}
