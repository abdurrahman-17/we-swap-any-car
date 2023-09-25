import 'package:dotted_line/dotted_line.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:intl/intl.dart';

import '../../../../bloc/my_cars/my_cars_bloc.dart';
import '../../../../bloc/subscription/subscription_bloc.dart';
import '../../../../bloc/user/user_bloc.dart';
import '../../../../core/configurations.dart';
import '../../../../main.dart';
import '../../../../model/car_model/car_model.dart';
import '../../../../model/payment/payment_response_model.dart';
import '../../../../model/user/user_model.dart';
import '../../../../utility/date_time_utils.dart';
import '../../../common_widgets/common_loader.dart';
import '../../../common_widgets/common_popups.dart';
import '../../../common_widgets/custom_text_widget.dart';
import '../../../common_widgets/switch_item.dart';
import '../../../error_screen/error_widget.dart';
import '../../../my_cars/my_car_profile_screen.dart';
import '../../../payment/payment_screen.dart';
import '../my_subscription_screen.dart';
import '../payment_history.dart';

class SubscriptionPremiumPostTab extends StatefulWidget {
  const SubscriptionPremiumPostTab({super.key});

  @override
  State<SubscriptionPremiumPostTab> createState() =>
      _SubscriptionPremiumPostTabState();
}

class _SubscriptionPremiumPostTabState
    extends State<SubscriptionPremiumPostTab> {
  int perPage = 10;
  int pageNo = 0;
  UserModel? user;
  String? userType;
  String? carId;
  bool isPremiumCars = true;
  String? premiumPostId;
  List<CarModel> filteredCarList = [];
  Map<String, dynamic> filterJson = {"postType": "premium"};
  late MyCarsBloc _myCarsBloc;
  final EasyRefreshController _easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    _myCarsBloc = BlocProvider.of<MyCarsBloc>(context);
    user = context.read<UserBloc>().currentUser;
    userType = user!.userType != convertEnumToString(UserType.private)
        ? convertEnumToString(FilterUserTypes.dealer)
        : user!.userType!;
    fetchPremiumPostData();
    getMyCarsPremiumData(isPremiumCars: isPremiumCars);
    super.initState();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  void fetchPremiumPostData() {
    BlocProvider.of<SubscriptionBloc>(context)
        .add(GetpremiumPostEvent(userType: userType!));
  }

  void getMyCarsPremiumData({required bool isPremiumCars}) {
    pageNo = 0;
    if (isPremiumCars) {
      final premiumCarsJson = {
        'pageNo': pageNo,
        'perPage': perPage,
        'filters': const {'postType': 'premium'},
      };
      _myCarsBloc.add(GetMyCarsEvent(fetchMyCarjson: premiumCarsJson));
    } else {
      final expiredPremiumCarsJson = {
        'pageNo': pageNo,
        'perPage': perPage,
        'sortBy': -1,
      };
      _myCarsBloc.add(GetMyCarsEvent(
          fetchMyCarjson: expiredPremiumCarsJson, isExpiredPremiumCars: true));
    }
  }

  void getLoadMorePremiumCars({required bool isPremiumCars}) async {
    if (isPremiumCars) {
      final morePremiumCarsJson = {
        'pageNo': ++pageNo,
        'perPage': perPage,
        'filters': const {'postType': 'premium'},
      };
      _myCarsBloc
          .add(GetMoreMyCarsEvent(fetchMoreMyCarJson: morePremiumCarsJson));
    } else {
      final moreExpiredPremiumCarsJson = {
        'pageNo': ++pageNo,
        'perPage': perPage,
        'sortBy': -1,
      };
      _myCarsBloc.add(GetMoreMyCarsEvent(
          fetchMoreMyCarJson: moreExpiredPremiumCarsJson,
          isExpiredPremiumCars: true));
    }

    final morePremiumCarsJson = {
      'pageNo': ++pageNo,
      'perPage': perPage,
      'filters': const {'postType': 'premium'},
    };
    _myCarsBloc
        .add(GetMoreMyCarsEvent(fetchMoreMyCarJson: morePremiumCarsJson));
  }

  void renewPremiumPaymentAction() async {
    final PaymentResponseModel? paymentResponse = await Navigator.pushNamed(
      context,
      PaymentScreen.routeName,
      arguments: {
        "user": user,
        "premiumPostId": premiumPostId,
        "carId": carId,
      },
    );

    if (paymentResponse != null) {
      //success
      if (paymentResponse.isSuccess!) {
        Navigator.pushReplacementNamed(
          globalNavigatorKey.currentContext!,
          MySubscriptionPage.routeName,
          arguments: {
            'initialIndex': 1,
          },
        );
        showSnackBar(message: renewalSuccessSnackbarMsg);
      }
      //fail
      else {
        showSnackBar(message: paymentResponse.message ?? '');
        //payment failed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: getPadding(left: 25.w, right: 25.w, top: 10.h),
          child: SwitchItemWidget(
            switchLeftLabel: '',
            switchRightLabel: '',
            textStyle: AppTextStyle.txtPTSansBold14Bluegray900,
            label: isPremiumCars ? premiumCars : premiumExpiredCars,
            switchValue: isPremiumCars,
            onChanged: (value) {
              setState(() {
                isPremiumCars = value;
              });
              if (value) {
                filterJson = {"postType": "premium"};
                getMyCarsPremiumData(isPremiumCars: isPremiumCars);
              } else {
                filterJson = {"postType": "normal"};
                getMyCarsPremiumData(isPremiumCars: isPremiumCars);
              }
            },
          ),
        ),
        Expanded(
          child: BlocConsumer<SubscriptionBloc, SubscriptionState>(
              listener: (context, state) {
            if (state is GetPremiumPostState) {
              if (state.premiumPostDataStatus == ProviderStatus.success) {
                setState(() {
                  premiumPostId = state.premiumPostData?.id;
                });
              }
            }
          }, builder: (context, state) {
            if (state is GetPremiumPostState) {
              if (state.premiumPostDataStatus == ProviderStatus.success) {
                return BlocBuilder<MyCarsBloc, MyCarsState>(
                    builder: (context, state) {
                  if (state is GetMyCarsState) {
                    if (state.myCarsStatus == ProviderStatus.success) {
                      filteredCarList = state.myCars?.cars ?? [];
                      return body();
                    } else if (state.myCarsStatus == ProviderStatus.error) {
                      return Container(
                        alignment: Alignment.topCenter,
                        margin: getMargin(top: size.height * 0.15),
                        height: size.height,
                        child: ErrorWithButtonWidget(
                            message: getPremiumPostsApiFailErrorMsg,
                            buttonLabel: retryButton,
                            onTap: () {
                              fetchPremiumPostData();
                              getMyCarsPremiumData(
                                  isPremiumCars: isPremiumCars);
                            }),
                      );
                    }
                  } else if (state is GetMoreMyCarsState) {
                    if (state.moreMyCarsStatus == ProviderStatus.success) {
                      if ((state.moreMyCars?.cars ?? []).isNotEmpty) {
                        filteredCarList.addAll(state.moreMyCars!.cars!);
                        _easyRefreshController.finishLoad(
                            IndicatorResult.success, true);
                      } else {
                        _easyRefreshController.finishLoad(
                            IndicatorResult.noMore, true);
                      }
                    }
                    return body();
                  }
                  return shimmerLoaderEffect();
                });
              } else if (state.premiumPostDataStatus == ProviderStatus.error) {
                return Container(
                  alignment: Alignment.topCenter,
                  margin: getMargin(top: size.height * 0.15),
                  height: size.height,
                  child: ErrorWithButtonWidget(
                      message: getPremiumPostsApiFailErrorMsg,
                      buttonLabel: retryButton,
                      onTap: () {
                        fetchPremiumPostData();
                        getMyCarsPremiumData(isPremiumCars: isPremiumCars);
                      }),
                );
              }
            }
            return shimmerLoaderEffect();
          }),
        ),
      ],
    );
  }

  Widget body() {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: EasyRefresh(
        triggerAxis: Axis.vertical,
        clipBehavior: Clip.none,
        controller: _easyRefreshController,
        footer: ClassicFooter(
          textStyle: AppTextStyle.regularTextStyle.copyWith(
            color: ColorConstant.kColor7C7C7C,
            fontWeight: FontWeight.w700,
          ),
          hapticFeedback: true,
          noMoreIcon: Icon(
            Icons.low_priority_sharp,
            color: ColorConstant.kColor7C7C7C,
          ),
          dragText: 'Load More',
          failedText: 'No More',
          processingText: 'Loading..',
          readyText: 'No More',
          noMoreText: 'No More',
        ),
        onLoad: () => getLoadMorePremiumCars(isPremiumCars: isPremiumCars),
        child: filteredCarList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                padding: getPadding(left: 25.w, right: 25.w),
                itemBuilder: (ctx, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MyCarProfileScreen.routeName,
                        arguments: {'carId': filteredCarList[index].id},
                      );
                    },
                    child: buildContainer(filteredCarList[index]),
                  );
                },
                itemCount: filteredCarList.length,
              )
            : Column(
                children: [
                  SizedBox(
                    height: size.height / 3,
                  ),
                  CenterText(
                    text: isPremiumCars
                        ? noPremiumPostMessage
                        : noPremiumEXpiredCars,
                  ),
                ],
              ),
      ),
    );
  }

  Container buildContainer(CarModel myCars) {
    final RegExp regexToRemoveDecimalIfZero = RegExp(r'([.]*0)(?!.*\d)');
    final amount = myCars.additionalProps?.amount
        ?.toString()
        .replaceAll(regexToRemoveDecimalIfZero, '');

    return Container(
      height: getVerticalSize(495),
      width: getHorizontalSize(size.width),
      margin: getMargin(top: 19),
      decoration: AppDecoration.outlineBlack90021.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: getVerticalSize(185),
            width: getHorizontalSize(size.width),
            child: Stack(
              children: [
                CustomImageView(
                  fit: BoxFit.cover,
                  url: myCars.uploadPhotos != null &&
                          myCars.uploadPhotos!.frontImages!.isNotEmpty
                      ? myCars.uploadPhotos?.frontImages![0]
                      : "",
                  height: getVerticalSize(184.00),
                  width: getHorizontalSize(size.width),
                  radius: BorderRadius.only(
                    topLeft: Radius.circular(21.r),
                    topRight: Radius.circular(21.r),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: getPadding(left: 20, top: 16, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      myCars.manufacturer?.name ?? "",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyle.txtPTSansRegular12Red300,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: getPadding(left: 20, top: 5, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      myCars.model ?? "",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyle.txtPTSansBold14Bluegray900,
                    ),
                    Text(
                      '£${currencyFormatter(myCars.tradeValue!)}',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyle.txtPTSansBold14Bluegray900,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: getPadding(left: 20, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Container(
                        width: size.width / 1.42,
                        padding: getPadding(
                          left: 8,
                          top: 7,
                          bottom: 7,
                        ),
                        decoration: AppDecoration
                            .gradientDeeporangeA200Yellow900
                            .copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder5,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        (myCars.fuelType?.name ?? notApplicable)
                                                .toUpperCase() +
                                            mileageOfVehicle,
                                    style: AppTextStyle.smallTextStyle.copyWith(
                                      color: ColorConstant.kColorWhite,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${currencyFormatter(myCars.mileage!)} '
                                        '${milesLabel.toUpperCase()}',
                                    style: AppTextStyle.smallTextStyle.copyWith(
                                      color: ColorConstant.kColorWhite,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: getVerticalSize(1),
            width: size.width,
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: DottedLine(
              dashColor: ColorConstant.gray500,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10),
                child: Text(
                  premiumPostItemTitle,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.txtPTSansRegular14Black900,
                ),
              ),
              Padding(
                padding: getPadding(
                  left: 20,
                  top: 3,
                  right: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      standardPlanItemTitle,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyle.txtSansRegular12Bluegray900,
                    ),
                    Text(
                      euro + amount.toString(),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyle.txtPTSansBold12,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: getPadding(
                  left: 20,
                  top: 10,
                  right: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateTime.parse(myCars.additionalProps!.expiry!)
                              .isBefore(getCurrentDateTime())
                          ? expiredOnItemTitle
                          : expiresOnItemTitle,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyle.txtSansRegular12Bluegray900,
                    ),
                    Text(
                      DateFormat.yMMMMd()
                          .format(
                              DateTime.parse(myCars.additionalProps!.expiry!))
                          .toString(),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyle.txtPTSansBold12,
                    ),
                  ],
                ),
              ),
              Container(
                height: getVerticalSize(1.00),
                width: size.width,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 19),
                child: DottedLine(
                  dashColor: ColorConstant.gray500,
                ),
              ),
              Padding(
                padding: getPadding(top: 10, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment:
                      myCars.additionalProps?.isPremium != null &&
                              !myCars.additionalProps!.isPremium!
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                  children: [
                    if (myCars.additionalProps?.isPremium != null &&
                        !myCars.additionalProps!.isPremium!)
                      CustomElevatedButton(
                        height: 36,
                        width: 130,
                        title: renewButtonTitle,
                        onTap: () async {
                          bool isOk = await confirmationPopup(
                            title: renewconfirmationPopupTitle,
                            message: "$renewconfirmationPopupMsg1"
                                "${DateFormat.yMMMMd().format(
                              DateTime.parse(myCars.additionalProps!.expiry!),
                            )}"
                                "$renewconfirmationPopupMsg2",
                          );
                          if (isOk) {
                            setState(() => carId = myCars.id);
                            renewPremiumPaymentAction();
                          }
                        },
                      ),
                    if (myCars.premiumPostLogs != null)
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, PremiumPaymentHistory.routeName,
                              arguments: {
                                "PremiumPostLogs": myCars.premiumPostLogs
                              });
                        },
                        child: Text(
                          viewHistoryButton,
                          style: AppTextStyle.regularTextStyle.copyWith(
                            color: ColorConstant.black900,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget shimmerLoaderEffect() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,
      padding: getPadding(left: 25.w, right: 25.w, top: 15.h),
      itemBuilder: (ctx, index) {
        return shimmerLoader(
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              margin: getMargin(top: 5.h, bottom: 5.h),
              decoration: BoxDecoration(
                color: ColorConstant.kColorWhite,
                borderRadius: BorderRadius.circular(21.r),
              ),
            ),
          ),
        );
      },
    );
  }

  void progressLoad(bool value) {
    if (value) {
      progressDialogue(isCircularProgress: true);
    } else {
      Navigator.pop(context);
    }
  }
}
