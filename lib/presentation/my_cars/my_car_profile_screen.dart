import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

import '../../bloc/car_details/car_details_bloc.dart';
import '../../bloc/list_unlist/list_unlist_bloc_bloc.dart';
import '../../bloc/my_cars/my_cars_bloc.dart';
import '../../bloc/subscription/subscription_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../main.dart';
import '../../model/car_detail_model/hpi_history_result_model.dart';
import '../../model/car_model/car_hpi_history_check.dart';
import '../../model/car_model/car_model.dart';
import '../../model/payment/payment_response_model.dart';
import '../../model/user/user_model.dart';
import '../../repository/user_repo.dart';
import '../../utility/common_keys.dart';
import '../../utility/date_time_utils.dart';
import '../common_popup_widget/add_edit_car_valuation_popup.dart';
import '../common_popup_widget/edit_delete_popup.dart';
import '../common_popup_widget/thank_you_popup_with_button_widget.dart';
import '../common_widgets/common_condition_damage_info_card.dart';
import '../common_widgets/common_divider.dart';
import '../common_widgets/common_expansion_tile.dart';
import '../common_widgets/common_gradient_label.dart';
import '../common_widgets/common_loader.dart';
import '../common_widgets/common_perfomance_meter.dart';
import '../common_widgets/common_popups.dart';
import '../common_widgets/custom_icon_button.dart';
import '../common_widgets/full_screen_image_viewer.dart';
import '../common_widgets/label_and_value_card_widget.dart';
import '../error_screen/error_widget.dart';
import '../landing_screen/landing_screen.dart';
import '../payment/payment_screen.dart';
import '../slot_purchase/slot_purchase_screen.dart';
import 'widgets/my_car_profile_content_slider.dart';

class MyCarProfileScreen extends StatefulWidget {
  static const String routeName = 'my_car_profile_screen';
  const MyCarProfileScreen({Key? key, required this.carId}) : super(key: key);

  final String carId;
  @override
  State<MyCarProfileScreen> createState() => _MyCarProfileScreenState();
}

class _MyCarProfileScreenState extends State<MyCarProfileScreen> {
  late ValueNotifier<bool>? quickSaleVisible;
  late int selectedIndex = -1;
  final TextEditingController _attentionGrabberController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _companyDescriptionController =
      TextEditingController();
  final TextEditingController _additionalController = TextEditingController();
  late CarDetailsBloc carDetailsBloc;
  int carListed = 0;
  int totalCarLimit = 0;
  String? planNameIfSubscription;
  String? planNameIfPayAsYouGo;
  UserModel? currentUser;
  CarModel? carModel;
  late ListUnlistBlocBloc unlistBlocBloc;
  bool premiumPaymentSuccess = false;
  String? userType;
  num? premiumPostAmount;
  String? premiumPostId;

  ///collapse or expand - expansion tile
  void collapseOrExpand({required bool newState, required int index}) {
    setState(() {
      if (newState) {
        selectedIndex = index;
      } else {
        selectedIndex = -1;
      }
    });
  }

  @override
  void initState() {
    carDetailsBloc = context.read<CarDetailsBloc>();
    unlistBlocBloc = context.read<ListUnlistBlocBloc>();
    currentUser = context.read<UserBloc>().currentUser;
    userType = currentUser!.userType != convertEnumToString(UserType.private)
        ? "dealer"
        : currentUser!.userType!;
    carListed = currentUser?.trader?.carsListed ?? 0;
    totalCarLimit = currentUser?.trader?.totalCarLimit ?? 0;
    planNameIfSubscription = currentUser?.trader?.subscription?.name ?? '';
    planNameIfPayAsYouGo =
        currentUser?.trader?.traderSubscriptionChangeReq?.planName ?? '';
    fetchPremiumPostData();
    fetchCarDetails();
    super.initState();
  }

  void fetchPremiumPostData() {
    BlocProvider.of<SubscriptionBloc>(context)
        .add(GetpremiumPostEvent(userType: userType!));
  }

  void fetchCarDetails() {
    BlocProvider.of<CarDetailsBloc>(context).add(GetCarDetailsEvent(
      key: '_id',
      value: widget.carId,
    ));
  }

  Future<void> fetchMyCars() async {
    Map<String, dynamic> filterJsonData = {};
    final Map<String, dynamic> myCarJson = {
      'pageNo': 0,
      'perPage': 10,
      'filters': filterJsonData,
    };
    BlocProvider.of<MyCarsBloc>(context)
        .add(GetMyCarsEvent(fetchMyCarjson: myCarJson));
  }

  void premiumPaymentAction() async {
    final PaymentResponseModel? paymentResponse = await Navigator.pushNamed(
      context,
      PaymentScreen.routeName,
      arguments: {
        "user": currentUser,
        "premiumPostId": premiumPostId,
        "carId": widget.carId,
      },
    );
    if (paymentResponse != null) {
      //success
      if (paymentResponse.isSuccess!) {
        premiumPaymentSuccess = true;
        setLoader(true);
        delayedStart(() {
          setLoader(false);
          fetchPremiumPostData();
          fetchCarDetails();
          fetchMyCars();
        }, duration: const Duration(seconds: 3));
      }
      //fail
      else {
        setLoader(false);
        showSnackBar(message: paymentResponse.message ?? '');
        //payment failed
      }
    }
  }

  List<HPIHistoryResultModel> get fetchInitialHpiHistoryCheck =>
      hpiCheckContents
          .map((entry) => HPIHistoryResultModel(message: entry))
          .toList();

  String setHistoryCheck({required HPIHistoryCheck hpiHistoryCheck}) {
    final List<HPIHistoryResultModel> tempHpiHistoryCheck =
        fetchInitialHpiHistoryCheck;
    tempHpiHistoryCheck[0].result = hpiHistoryCheck.cherishedDataQty;
    tempHpiHistoryCheck[1].result = hpiHistoryCheck.colourChangesQty;
    tempHpiHistoryCheck[2].result = hpiHistoryCheck.conditionDataQty;
    tempHpiHistoryCheck[3].result = hpiHistoryCheck.financeDataQty;
    tempHpiHistoryCheck[4].result = hpiHistoryCheck.highRiskDataQty;
    tempHpiHistoryCheck[5].result =
        ((hpiHistoryCheck.keeperChangesQty ?? 0) > 0) ? true : false;
    tempHpiHistoryCheck[6].result = hpiHistoryCheck.stolenVehicleDataQty;
    tempHpiHistoryCheck[7].result = hpiHistoryCheck.isScrapped;

    //Warning counts
    final warningList =
        tempHpiHistoryCheck.where((e) => (e.result ?? false)).toList();
    if (warningList.isNotEmpty &&
        warningList.length <= tempHpiHistoryCheck.length) {
      return (warningList.length == 1)
          ? carModel!.userType == convertEnumToString(UserType.private)
              ? carHpiHistoryAIssue
              : carHpiHistoryAMarker
          : carModel!.userType == convertEnumToString(UserType.private)
              ? carHpiHistoryAreIssues
              : carHpiHistoryAreMarkers;
    } else {
      return carHpiHistoryAllClear;
    }
  }

  Future<num> activeUsers() async {
    final result = await Locator.instance.get<UserRepo>().getActiveUsersRepo();
    return result.fold((l) {
      showSnackBar(message: l.message);
      return 0;
    }, (r) => r);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ListUnlistBlocBloc, ListUnlistBlocState>(
            listener: (context, state) async {
          if (state is ListOrUnListMyCarState) {
            if (state.listStatus == ProviderStatus.success) {
              setLoader(false);
              carDetailsBloc.car = state.car;
              if (state.car?.status ==
                  convertEnumToString(CarStatus.disabled)) {
                showSnackBar(message: "Successfully car unlisted");
              } else {
                successPopup();
              }
              BlocProvider.of<UserBloc>(context).add(GetCurrentUserDataEvent(
                  key: emailKey, value: currentUser?.email ?? ''));
              setState(() {});
            } else if (state.listStatus == ProviderStatus.error) {
              setLoader(false);
              if (state.errorMessage == slotUnavailable) {
                bool? result = await confirmationPopup2(
                  title: "ALERT",
                  message: slotPurchaseContent,
                  successBtnLabel: "ADD SLOT",
                  cancelBtnLabel: "UNLIST CAR",
                );
                if (result != null) {
                  if (result) {
                    await Navigator.pushNamed(
                      globalNavigatorKey.currentContext!,
                      SlotPurchase.routeName,
                      arguments: {
                        "subscriptionPageName": SubscriptionPageName.myCar,
                      },
                    );
                  } else {
                    Navigator.pushNamed(
                      globalNavigatorKey.currentContext!,
                      LandingScreen.routeName,
                      arguments: {'selectedIndex': 0},
                    );
                  }
                }
              } else {
                showSnackBar(message: state.errorMessage ?? errorOccurred);
              }
            } else {
              setLoader(true);
            }
          }
        }),
        BlocListener<SubscriptionBloc, SubscriptionState>(
          listener: (context, state) async {
            if (state is AddSubscriptionPlanState &&
                state.subscriptionPageName == SubscriptionPageName.carSummary) {
              if (state.subscriptionAddStatus == ProviderStatus.success) {
                setLoader(false);
                if (state.subscriptionsData?.status ==
                    convertEnumToString(SubscriptionChangeStatus.approved)) {
                  unlistBlocBloc.add(ListOrUnListMyCarEvent(
                    userId: currentUser?.userId ?? '',
                    userType: currentUser?.userType ?? ' ',
                    carId: widget.carId,
                    status: convertEnumToString(CarStatus.active),
                  ));
                } else {
                  infoOrThankyouPopup(
                    subTitle: forCHoosingWSACMsg,
                    message: subscriptionThanks,
                    buttonText: closeButton,
                    isThankYou: true,
                    onTapButton: () {
                      setLoader(true);
                      logoutAction();
                    },
                  );
                }
              } else if (state.subscriptionAddStatus == ProviderStatus.error) {
                //error
                setLoader(false);
                showSnackBar(message: paymentApiFailed);
              } else if (state.subscriptionAddStatus ==
                  ProviderStatus.loading) {
                //loading
                setLoader(true);
              }
            }
          },
        )
      ],
      child: CustomScaffold(
        title: myCarProfileAppBar,
        actions: [
          GestureDetector(
            onTap: () => customPopup(content: EditDeletePopup(car: carModel)),
            child: Padding(
              padding: getPadding(all: 15),
              child: Icon(
                Icons.more_vert,
                size: getSize(22),
                color: ColorConstant.kColor7C7C7C,
              ),
            ),
          ),
        ],
        body: Stack(
          children: [
            CustomImageView(
              svgPath: Assets.homeBackground,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              fit: BoxFit.fill,
            ),
            BlocConsumer<SubscriptionBloc, SubscriptionState>(
                listener: (context, state) {
              if (state is GetPremiumPostState &&
                  state.premiumPostDataStatus == ProviderStatus.success) {
                setState(() {
                  premiumPostAmount = state.premiumPostData?.amount;
                  premiumPostId = state.premiumPostData?.id;
                });
              }
            }, builder: (context, state) {
              if (state is GetPremiumPostState) {
                if (state.premiumPostDataStatus == ProviderStatus.success) {
                  return BlocConsumer<CarDetailsBloc, CarDetailsState>(
                    listener: (context, state) {
                      if (state is GetCarDetailsState) {
                        if (state.carDetailsStatus == ProviderStatus.success) {
                          if (premiumPaymentSuccess) {
                            showSnackBar(message: paymentDoneSuccess);
                          }
                        } else if (state.carDetailsStatus ==
                            ProviderStatus.error) {
                          if (premiumPaymentSuccess) {
                            showSnackBar(message: paymentDoneSuccess);
                          }
                        }
                      }
                    },
                    builder: (context, state) {
                      final carDetailsBloc = context.read<CarDetailsBloc>();
                      if (state is GetCarDetailsState ||
                          state is UpdateCarInfoState) {
                        if (state is GetCarDetailsState) {
                          if (state.carDetailsStatus ==
                              ProviderStatus.success) {
                            carModel = carDetailsBloc.car;
                            quickSaleVisible = ValueNotifier<bool>(
                                carDetailsBloc.car?.quickSale ?? false);

                            return carDetails(carModel);
                          } else if (state.carDetailsStatus ==
                              ProviderStatus.error) {
                            return errorBuild(
                                errorMessage: errorOccurredWhileFetch,
                                buttonLabel: retryButton,
                                onTap: () {
                                  fetchPremiumPostData();
                                  fetchCarDetails();
                                });
                          }
                        } else if (state is UpdateCarInfoState &&
                            state.updateCarStatus == ProviderStatus.success) {
                          quickSaleVisible = ValueNotifier<bool>(
                              state.car?.quickSale ?? false);
                          carModel = state.car;
                          return carDetails(state.car!);
                        }
                      }
                      return shimmerEffect();
                    },
                  );
                } else if (state.premiumPostDataStatus ==
                    ProviderStatus.error) {
                  return errorBuild(
                      errorMessage: errorOccurredWhileFetch,
                      buttonLabel: retryButton,
                      onTap: () {
                        fetchPremiumPostData();
                        fetchCarDetails();
                      });
                }
              }
              return shimmerEffect();
            })
          ],
        ),
      ),
    );
  }

  Widget shimmerEffect() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shimmerLoader(
            AspectRatio(
              aspectRatio: 1.8,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorConstant.kColorWhite,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
          Padding(
            padding: getPadding(
              top: 16.h,
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
                        margin: getMargin(bottom: 5.h),
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
                    height: getVerticalSize(30.h),
                    width: getHorizontalSize(80.w),
                    decoration: BoxDecoration(
                      color: ColorConstant.kColorWhite,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
          shimmerLoader(
            Container(
              height: getVerticalSize(24.h),
              width: size.width / 1.5,
              margin: getMargin(left: 20.w, right: 20.w, bottom: 10.h),
              decoration: BoxDecoration(
                color: ColorConstant.kColorWhite,
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
          ),
          shimmerLoader(
            Container(
              height: getVerticalSize(24.h),
              width: double.infinity,
              margin: getMargin(left: 20.w, right: 20.w),
              decoration: BoxDecoration(
                color: ColorConstant.kColorWhite,
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
          ),
          ListView.separated(
            itemCount: 7,
            shrinkWrap: true,
            padding: getPadding(
              top: 30.h,
              bottom: 15.h,
              right: 20.w,
              left: 20.w,
            ),
            itemBuilder: (context, index) => shimmerLoader(
              Container(
                height: getVerticalSize(40.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorConstant.kColorWhite,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
            separatorBuilder: (context, index) => const CommonDivider(),
          ),
        ],
      ),
    );
  }

  Widget carDetails(CarModel? car) {
    return SafeArea(
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyCarProfileContentSlider(aspectRatio: 1.8, car: car),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: getPadding(top: 16.h, bottom: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  car?.manufacturer?.name ?? notApplicable,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppTextStyle.txtPTSansRegular12Red300,
                                ),
                                Text(
                                  car?.model ?? notApplicable,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
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
                                      car?.userExpectedValue?.toInt() ?? 0),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppTextStyle.regularTextStyle.copyWith(
                                fontSize: getFontSize(22),
                                color: ColorConstant.kColor353333,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      car?.additionalInformation?.attentionGraber ??
                          notApplicable,
                      style: AppTextStyle.regularTextStyle.copyWith(
                        color: ColorConstant.gray600,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      width: size.width,
                      margin: getMargin(top: 10.h),
                      padding: getPadding(
                        left: 8.w,
                        top: 5.h,
                        right: 8.w,
                        bottom: 5.h,
                      ),
                      decoration: AppDecoration.gradientDeeporangeA200Yellow900
                          .copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder5,
                      ),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: (car?.fuelType?.name ?? notApplicable)
                                      .toUpperCase() +
                                  mileageOfVehicle,
                              style: AppTextStyle.smallTextStyle.copyWith(
                                color: ColorConstant.kColorWhite,
                              ),
                            ),
                            TextSpan(
                              text: '${currencyFormatter(car?.mileage ?? 0)} '
                                  '${milesLabel.toUpperCase()}',
                              style: AppTextStyle.smallTextStyle.copyWith(
                                color: ColorConstant.kColorWhite,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: getPadding(top: 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomImageView(
                            svgPath: Assets.gradientLike,
                            height: getSize(15),
                            width: getSize(15),
                            margin: getMargin(right: 8.w),
                          ),
                          Text(
                            car?.analytics?.likes?.toString() ?? '0',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppTextStyle.txtPTSansBold14Bluegray900,
                          ),
                          CustomImageView(
                            svgPath: Assets.gradientEye,
                            height: getVerticalSize(18),
                            width: getHorizontalSize(18),
                            margin: getMargin(left: 23.w, right: 8.w),
                          ),
                          Text(
                            car?.analytics?.views?.toString() ?? '0',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppTextStyle.txtPTSansBold14Bluegray900,
                          ),
                          const Spacer(),
                          const GradientLabel(text: offersLabel),
                          Padding(
                            padding: getPadding(left: 8.w),
                            child: Text(
                              car?.analytics?.offersReceived?.toString() ?? '0',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppTextStyle.txtPTSansBold14Bluegray900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: getPadding(top: 20.w, bottom: 20.w),
                      child: summaryList(car),
                    ),
                    subscriptionAndPremiumPostCard(),
                    editCarValue(car),
                    SizedBox(height: 5.h),
                    quickSaleButtonWithInfo(car),
                    SizedBox(height: 26.h),
                    unlistAndPremiumButton(car),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget summaryList(CarModel? car) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          const GradientDivider(),
          vehicleAdditionalInfoTile(car),
          const GradientDivider(),
          performanceMeter(car),
          const GradientDivider(),
          vehicleDetails(car),
          const GradientDivider(),
          pricingTile(car),
          const GradientDivider(),
          hpiHistory(car),
          const GradientDivider(),
          motHistory(car),
          const GradientDivider(),
          extraFitting(car),
          const GradientDivider(),
          serviceHistory(car),
          const GradientDivider(),
          conditionAndDamage(car),
          const GradientDivider(),
        ],
      ),
    );
  }

  Widget vehicleAdditionalInfoTile(CarModel? car) {
    _companyDescriptionController.text =
        car?.additionalInformation?.companyDescription ?? notApplicable;
    _descriptionController.text =
        car?.additionalInformation?.description ?? notApplicable;
    _attentionGrabberController.text =
        car?.additionalInformation?.attentionGraber ?? notApplicable;
    return CommonExpansionTile(
      title: additionalInfoLabel,
      initiallyExpanded: selectedIndex == 0,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 0);
      },
      childrens: [
        Padding(
          padding: getPadding(bottom: 9.h),
          child: Text(
            attentionGrabberLabel,
            style: AppTextStyle.smallTextStyle.copyWith(
              fontWeight: FontWeight.w700,
              color: ColorConstant.kColor263238,
            ),
          ),
        ),
        CommonTextFormField(
          controller: _attentionGrabberController,
          readOnly: true,
        ),
        Padding(
          padding: getPadding(top: 18.h, bottom: 9.h),
          child: Text(
            discriptionLabel,
            style: AppTextStyle.smallTextStyle.copyWith(
              fontWeight: FontWeight.w700,
              color: ColorConstant.kColor263238,
            ),
          ),
        ),
        Padding(
          padding: getPadding(bottom: 18.h),
          child: CommonTextFormField(
            readOnly: true,
            maxLines: 12,
            controller: _descriptionController,
          ),
        ),
        if (car?.userType != convertEnumToString(UserType.private))
          Padding(
            padding: getPadding(bottom: 9.h),
            child: Text(
              companyDiscriptionLabel,
              style: AppTextStyle.smallTextStyle.copyWith(
                fontWeight: FontWeight.w700,
                color: ColorConstant.kColor263238,
              ),
            ),
          ),
        if (car?.userType != convertEnumToString(UserType.private))
          Padding(
            padding: getPadding(bottom: 16.h),
            child: CommonTextFormField(
              readOnly: true,
              maxLines: 12,
              minLines: 4,
              controller: _companyDescriptionController,
            ),
          ),
      ],
    );
  }

  Widget performanceMeter(CarModel? car) {
    return CommonExpansionTile(
      title: carDetailsPerformanceMeterTitle,
      initiallyExpanded: selectedIndex == 1,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 1);
      },
      childrens: [
        FutureBuilder<num>(
          future: activeUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Row(
                children: [
                  Expanded(
                    child: PerformanceMeterWithDetails(
                      achivedCount: car?.analytics?.likes ?? 0,
                      totalCount: snapshot.data ?? 0,
                      fillGradientColor: gaugesGradientRed,
                      bottomMsg: userHaveLikedYourPostMsg,
                    ),
                  ),
                  Expanded(
                    child: PerformanceMeterWithDetails(
                      achivedCount: car?.analytics?.views ?? 0,
                      totalCount: snapshot.data ?? 0,
                      fillGradientColor: gaugesGradientGreen,
                      bottomMsg: userHaveViewedYourPostMsg,
                    ),
                  ),
                ],
              );
            }
            return shimmerLoader(Container(
              height: getVerticalSize(200),
              margin: getMargin(bottom: 10.h),
              decoration: BoxDecoration(
                color: ColorConstant.kColorWhite,
                borderRadius: BorderRadius.circular(25.r),
              ),
            ));
          },
        ),
      ],
    );
  }

  Widget vehicleDetails(CarModel? car) {
    final List<LabelAndValueCardWidget> vehicleDetailsList = [
      LabelAndValueCardWidget(
        label: brandNameLabel,
        value: car?.manufacturer?.name ?? notApplicable,
      ),
      LabelAndValueCardWidget(
        label: modelLabel,
        value: car?.model ?? notApplicable,
        valueOverflow: TextOverflow.visible,
      ),
      LabelAndValueCardWidget(
        label: yearDropDownLabel,
        value: car?.yearOfManufacture?.toString() ?? notApplicable,
      ),
      LabelAndValueCardWidget(
        label: colourLabel,
        value: car?.colour?.name ?? notApplicable,
      ),
      LabelAndValueCardWidget(
        label: transmissionLabel,
        value: car?.transmissionType?.name ?? notApplicable,
      ),
      LabelAndValueCardWidget(
        label: engineSizeLabel,
        value: car?.engineSize?.toInt().toString() ?? notApplicable,
      ),
      LabelAndValueCardWidget(
        label: fuelTypeLabel,
        value: car?.fuelType?.name?.toProperCase() ?? notApplicable,
      ),
      LabelAndValueCardWidget(
        label: registrationLabel,
        value: car?.registration != null
            ? getFormattedRegistrationNumber(car!.registration!)
            : notApplicable,
      ),
      LabelAndValueCardWidget(
        label: mileageLabel,
        value: currencyFormatter(car?.mileage ?? 0),
      ),
      LabelAndValueCardWidget(
        label: exteriorgradeLabel,
        value: car?.exteriorGrade?.grade ?? notApplicable,
      ),
      LabelAndValueCardWidget(
        label: noOfDoorsDropDownLabel,
        value: car?.noOfDoors?.toString() ?? notApplicable,
      ),
      LabelAndValueCardWidget(
        label: bodyTypeLabel,
        value: car?.bodyType?.name ?? notApplicable,
      ),
    ];
    return CommonExpansionTile(
      title: vehicleDetailsTitle,
      initiallyExpanded: selectedIndex == 2,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 2);
      },
      childrens: [
        AlignedGridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          padding: getPadding(bottom: 16.h),
          mainAxisSpacing: getHorizontalSize(11),
          crossAxisSpacing: getHorizontalSize(11),
          itemCount: vehicleDetailsList.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => vehicleDetailsList
              .firstWhere((element) => element == vehicleDetailsList[index]),
        ),
      ],
    );
  }

  Widget pricingTile(CarModel? car) {
    return CommonExpansionTile(
      title: carDetailsPricingTitle,
      initiallyExpanded: selectedIndex == 3,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 3);
      },
      childrens: [
        Container(
          margin: getMargin(bottom: 23.h),
          padding: getPadding(
            left: 29.w,
            top: 25.h,
            right: 29.w,
            bottom: 25.h,
          ),
          decoration: AppDecoration.outlineBlack9003f2.copyWith(
            borderRadius: BorderRadiusStyle.circleBorder25,
          ),
          child: Row(
            children: [
              Column(
                children: [
                  const CustomImageView(svgPath: Assets.userPriceCheck),
                  SizedBox(height: 10.h),
                  Text(
                    euro +
                        currencyFormatter(car?.userExpectedValue?.round() ?? 0),
                    style: AppTextStyle.regularTextStyle.copyWith(
                      fontSize: getFontSize(25),
                      fontWeight: FontWeight.w700,
                      fontFamily: Assets.magistralFontStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 18.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      yourListingPrice,
                      style: AppTextStyle.regularTextStyle.copyWith(
                        fontSize: getFontSize(16),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // Padding(
                    //   padding: getPadding(top: 4.h),
                    //   child: Text(
                    //     (car.tradeValue != null && car.tradeValue != 0)
                    //         ? ((car.userExpectedValue ?? 0) >
                    //                 (car.tradeValue ?? 0))
                    //             ? slightlyAboveTradeValMsg
                    //             : slightlyBelowTradeValMsg
                    //         : thisCanHelpToSellMsg,
                    //     style: AppTextStyle.smallTextStyle
                    //         .copyWith(color: ColorConstant.kColorWhite),
                    //   ),
                    // ),
                    Padding(
                      padding: getPadding(top: 11.h),
                      child: CustomElevatedButton(
                        height: 34.h,
                        width: getHorizontalSize(105.w),
                        title: editPriceButton,
                        onTap: () async {
                          await onTapEditCarValue(car);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (car?.tradeValue != null && car!.tradeValue != 0)
          Container(
            padding: getPadding(
              left: 29.w,
              top: 25.h,
              right: 29.w,
              bottom: 25.h,
            ),
            margin: getMargin(bottom: 16.h),
            decoration: BoxDecoration(
              color: ColorConstant.kColor3F3244,
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    const CustomImageView(svgPath: Assets.tradeValuationCheck),
                    SizedBox(height: 10.h),
                    Text(
                      euro + currencyFormatter(car.tradeValue!.round()),
                      style: AppTextStyle.regularTextStyle.copyWith(
                        fontSize: getFontSize(25),
                        fontWeight: FontWeight.w700,
                        fontFamily: Assets.magistralFontStyle,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 18.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tradeValuationLabel,
                        style: AppTextStyle.regularTextStyle.copyWith(
                          fontSize: getFontSize(16),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // Padding(
                      //   padding: getMargin(top: 6.h),
                      //   child: Text(
                      //     valueBasedOnConditionMsg1 +
                      //         (car.exteriorGrade?.grade ?? 'good')
                      //             .toLowerCase() +
                      //         valueBasedOnConditionMsg2,
                      //     style: AppTextStyle.smallTextStyle
                      //         .copyWith(color: ColorConstant.kColorWhite),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  ///edit car value popup
  Future<dynamic> onTapEditCarValue(CarModel? car) async {
    final editedCarVal = await customPopup(
        content: AddEditCarValuationPopup(
      fromEdit: true,
      car: car,
    ));
    if (editedCarVal != null) {
      final String editedCarValue =
          '$editedCarVal'.replaceAll(',', '').toString();
      car?.userExpectedValue = int.parse(editedCarValue);
      if (!mounted) return;
      BlocProvider.of<CarDetailsBloc>(context).add(
        UpdateCarInfoEvent(
          carInfoData: {
            '_id': car?.id,
            'userExpectedValue': car?.userExpectedValue,
          },
          carCreateStatus: CarCreateStatus.completed,
        ),
      );
    }
  }

  Widget hpiHistory(CarModel? car) {
    final List<Widget> hpiHistoryList = [
      if (car?.tradeValue != null && car!.tradeValue! != 0)
        LabelAndValueCardWidget(
          label: hpiHistoryCheck,
          value: car.hpiAndMot?.historyCheck != null
              ? setHistoryCheck(hpiHistoryCheck: car.hpiAndMot!.historyCheck!)
              : noText,
        ),
      LabelAndValueCardWidget(
        label: hpiKeeperStart,
        value: car?.hpiAndMot?.keeperStartDate != null &&
                car!.hpiAndMot!.keeperStartDate!.isNotEmpty
            ? customDateFormat(
                convertStringToDateTime(car.hpiAndMot!.keeperStartDate!)!)
            : notApplicable,
      ),
      LabelAndValueCardWidget(
        label: hpiVin,
        value: car?.hpiAndMot?.vin ?? notApplicable,
      ),
      LabelAndValueCardWidget(
        label: hpiFirstRegistered,
        value: car?.hpiAndMot?.firstRegisted != null &&
                car!.hpiAndMot!.firstRegisted!.isNotEmpty
            ? customDateFormat(
                convertStringToDateTime(car.hpiAndMot!.firstRegisted!)!)
            : notApplicable,
      ),
    ];
    return CommonExpansionTile(
      title: hpiHistoryTitle,
      initiallyExpanded: selectedIndex == 4,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 4);
      },
      childrens: [
        AlignedGridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          padding: getPadding(bottom: 16.h),
          mainAxisSpacing: getHorizontalSize(11),
          crossAxisSpacing: getHorizontalSize(11),
          itemCount: hpiHistoryList.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => hpiHistoryList
              .firstWhere((element) => element == hpiHistoryList[index]),
        ),
      ],
    );
  }

  Widget motHistory(CarModel? car) {
    final List<Widget> motHistoryList = [
      LabelAndValueCardWidget(
        label: lastMotDateLabel,
        value: car?.hpiAndMot?.lastMotDate != null &&
                car!.hpiAndMot!.lastMotDate!.isNotEmpty
            ? customDateFormat(
                convertStringToDateTime(car.hpiAndMot!.lastMotDate!)!)
            : notApplicable,
      ),
      LabelAndValueCardWidget(
        label: previousOwnerLabel,
        value: car?.hpiAndMot?.previousOwner?.toString() ?? notApplicable,
      ),
      LabelAndValueCardWidget(
        label: noOfKeysLabel,
        value: car?.hpiAndMot?.numberOfKeys.toString() ?? notApplicable,
      ),
      LabelAndValueCardWidget(
        label: onFinanaceLabel,
        value: car?.hpiAndMot?.onFinance ?? notApplicable,
      ),
      LabelAndValueCardWidget(
        label: privatePlateLabel,
        value: car?.hpiAndMot?.privatePlate != null
            ? car!.hpiAndMot!.privatePlate!
                ? yesText
                : noText
            : notApplicable,
      ),
      LabelAndValueCardWidget(
        label: sellerKeepingPlateLabel,
        value: car?.hpiAndMot?.sellerKeepingPlate != null
            ? car!.hpiAndMot!.sellerKeepingPlate!
                ? yesText
                : noText
            : notApplicable,
      ),
    ];
    return CommonExpansionTile(
      title: motHistoryTitle,
      initiallyExpanded: selectedIndex == 5,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 5);
      },
      childrens: [
        AlignedGridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          padding: getPadding(bottom: 16.h),
          mainAxisSpacing: getHorizontalSize(11),
          crossAxisSpacing: getHorizontalSize(11),
          itemCount: motHistoryList.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => motHistoryList
              .firstWhere((element) => element == motHistoryList[index]),
        ),
      ],
    );
  }

  Widget extraFitting(CarModel? car) {
    List<String?> extraItems = [];
    extraItems = (car?.addedAccessories?.notListedItems ?? [])
        .map((e) => e.name)
        .toList();
    final List<String?> addedExtraItems =
        (car?.addedAccessories?.listedItems ?? []).map((e) => e.name).toList();

    extraItems.addAll(addedExtraItems);

    return CommonExpansionTile(
      title: extraFittingTitle,
      initiallyExpanded: selectedIndex == 6,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 6);
      },
      childrens: [
        extraItems.isNotEmpty
            ? ListView.separated(
                shrinkWrap: true,
                padding: getPadding(bottom: 10.h),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: extraItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: getPadding(top: 10.h, bottom: 10.h),
                    child: Text(
                      extraItems[index]!,
                      style: AppTextStyle.regularTextStyle.copyWith(
                        color: ColorConstant.kColor535353,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    CommonDivider(color: ColorConstant.kColorDBDBDB),
              )
            : Padding(
                padding: getPadding(bottom: 15.h),
                child: Text(
                  'No extra fittings added',
                  style: AppTextStyle.regularTextStyle
                      .copyWith(color: ColorConstant.kColor7C7C7C),
                ),
              ),
      ],
    );
  }

  Widget serviceHistory(CarModel? car) {
    return CommonExpansionTile(
      title: serviceHistoryTitle,
      initiallyExpanded: selectedIndex == 7,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 7);
      },
      childrens: [
        Row(
          children: [
            Expanded(
              child: LabelAndValueCardWidget(
                label: serviceRecordLabel,
                value: car?.serviceHistory?.record ?? notApplicable,
              ),
            ),
            SizedBox(width: 11.w),
            Expanded(
              child: LabelAndValueCardWidget(
                label: mainDealerServices,
                value: car?.serviceHistory?.mainDealer?.toString() ??
                    notApplicable,
              ),
            ),
          ],
        ),
        Padding(
          padding: getPadding(top: 10.h, bottom: 15.h),
          child: LabelAndValueCardWidget(
            label: independentGarageServices,
            value:
                car?.serviceHistory?.independent?.toString() ?? notApplicable,
          ),
        ),
        car?.serviceHistory?.images != null &&
                car!.serviceHistory!.images!.isNotEmpty
            ? GridView.builder(
                shrinkWrap: true,
                padding: getPadding(bottom: 15.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: getVerticalSize(106),
                  crossAxisCount: 2,
                  mainAxisSpacing: getHorizontalSize(11),
                  crossAxisSpacing: getHorizontalSize(11),
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: car.serviceHistory!.images!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        FullScreenImageViewer.routeName,
                        arguments: {
                          'imageList': car.serviceHistory!.images,
                          'isMultiImage': true,
                          'initialIndex': index,
                        },
                      );
                    },
                    child: CustomImageView(
                      fit: BoxFit.fill,
                      url: car.serviceHistory!.images![index],
                      height: getVerticalSize(106.h),
                      width: double.infinity,
                      radius: BorderRadius.circular(
                        getHorizontalSize(5.r),
                      ),
                    ),
                  );
                },
              )
            : Container(
                alignment: Alignment.center,
                padding: getPadding(bottom: 15.h),
                child: Text(
                  'No service photos available',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.regularTextStyle
                      .copyWith(color: ColorConstant.kColor7C7C7C),
                ),
              ),
      ],
    );
  }

  Widget conditionAndDamage(CarModel? car) {
    return CommonExpansionTile(
      title: conditionAndDamageTitle,
      initiallyExpanded: selectedIndex == 8,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 8);
      },
      childrens: [
        ConditionDamageCarInfoCardWidget(
          value: car?.conditionAndDamage?.scratches?.scratches ?? false,
          label: scratchesAndScuffsLabel,
          images: car?.conditionAndDamage?.scratches?.images ?? [],
        ),
        ConditionDamageCarInfoCardWidget(
          value: car?.conditionAndDamage?.dents?.dents ?? false,
          label: dentsLabel,
          images: car?.conditionAndDamage?.dents?.images ?? [],
        ),
        ConditionDamageCarInfoCardWidget(
          value: car?.conditionAndDamage?.paintProblem?.paintProblem ?? false,
          label: paintWorkProblemLabel,
          images: car?.conditionAndDamage?.paintProblem?.images ?? [],
        ),
        ConditionDamageCarInfoCardWidget(
          value: car?.conditionAndDamage?.smokingInVehicle?.smokingInVehicle ??
              false,
          label: smokingInVehicleLabel,
        ),
        ConditionDamageCarInfoCardWidget(
          value:
              car?.conditionAndDamage?.brokenMissingItems?.brokenMissingItems ??
                  false,
          label: brokenMinorProblemLabel,
          images: car?.conditionAndDamage?.brokenMissingItems?.images ?? [],
        ),
        ConditionDamageCarInfoCardWidget(
          value: car?.conditionAndDamage?.warningLightsDashboard
                  ?.warningLightsDashboard ??
              false,
          label: warningLightOnDashboardLabel,
          images: car?.conditionAndDamage?.warningLightsDashboard?.images ?? [],
        ),
        SizedBox(height: 6.h),
        Text(
          wheelsAndTyresTitle,
          style: AppTextStyle.regularTextStyle.copyWith(
            color: ColorConstant.kColorBlack,
            fontWeight: FontWeight.w700,
          ),
        ),
        ConditionDamageCarInfoCardWidget(
          value: car?.conditionAndDamage?.tyreProblem?.tyreProblem ?? false,
          label: tyreProblemsLabel,
          images: car?.conditionAndDamage?.tyreProblem?.images ?? [],
        ),
        ConditionDamageCarInfoCardWidget(
          value: car?.conditionAndDamage?.scuffedAlloy?.scuffedAlloy ?? false,
          label: scuffedAlloysLabel,
          images: car?.conditionAndDamage?.scuffedAlloy?.images ?? [],
        ),
        ConditionDamageCarInfoCardWidget(
          value: car?.conditionAndDamage?.toolPack?.toolPack ?? false,
          label: toolPackLabel,
        ),
        ConditionDamageCarInfoCardWidget(
          value: car?.conditionAndDamage?.lockWheelNut?.lockWheelNut ?? false,
          label: lockingNutsLabel,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            additionalInfoLabel,
            style: AppTextStyle.labelTextStyle.copyWith(
              color: ColorConstant.kColor7C7C7C,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        CommonTextFormField(
          controller: _additionalController,
          minLines: 4,
          maxLines: 4,
          readOnly: true,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget subscriptionAndPremiumPostCard() {
    return Column(
      children: [
        if (currentUser?.userType != convertEnumToString(UserType.private))
          Container(
            margin: getMargin(bottom: 23),
            padding: getPadding(left: 23, top: 25, right: 23, bottom: 25),
            decoration: BoxDecoration(
              color: ColorConstant.kColor303030,
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  subscriptionDetailsTitle,
                  style: AppTextStyle.regularTextStyle.copyWith(
                    fontSize: getFontSize(16),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: getMargin(top: 8, bottom: 22),
                  child: Text(
                    planNameIfPayAsYouGo == ""
                        ? '$planNameIfPayAsYouGo'
                        : '$planNameIfPayAsYouGo'
                            '  - $carListed/$totalCarLimit Cars',
                    style: AppTextStyle.smallTextStyle
                        .copyWith(color: ColorConstant.kColorDBDBDB),
                  ),
                ),
                GradientElevatedButton(
                  title: upgradeNowButton,
                  buttonGradient:
                      const LinearGradient(colors: kOrangeGradientColor),
                  onTap: () async {
                    await Navigator.pushNamed(
                      globalNavigatorKey.currentContext!,
                      SlotPurchase.routeName,
                      arguments: {
                        "subscriptionPageName": SubscriptionPageName.myCar,
                      },
                    );
                  },
                )
              ],
            ),
          ),
        Container(
          padding: getPadding(left: 23, top: 25, right: 23, bottom: 25),
          decoration: AppDecoration.outlineBlack9003f
              .copyWith(borderRadius: BorderRadius.circular(25.r)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  CustomImageView(
                    svgPath: Assets.premiumWhite,
                    height: getVerticalSize(15),
                    width: getHorizontalSize(20),
                    margin: getMargin(bottom: 3),
                  ),
                  Padding(
                    padding: getPadding(left: 9),
                    child: Text(
                      premiumTitle,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyle.txtPTSansBold14WhiteA700,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: getMargin(left: 3, top: 8, bottom: 12),
                child: Text(
                  carModel?.postType != null && !planIsExpired
                      ? yourPremiumPlanEndInMsg +
                          DateFormat.yMMMMd()
                              .format(DateTime.parse(
                                  carModel!.additionalProps!.expiry!))
                              .toString()
                      : "$premiumPostAmountDescMsg$euro$premiumPostAmount",
                  style: AppTextStyle.smallTextStyle
                      .copyWith(color: ColorConstant.kColorWhite),
                ),
              ),
              if (carModel?.postType == null || planIsExpired)
                Padding(
                  padding: getPadding(top: 8),
                  child: CustomElevatedButton(
                      title: upgradeNowButton,
                      onTap: () async {
                        bool isOk = await confirmationPopup(
                          title: confirmTitle,
                          message: makePostPremiumPopupMsg,
                          isQuestion: true,
                        );
                        if (isOk) premiumPaymentAction();
                      }),
                )
            ],
          ),
        ),
      ],
    );
  }

  bool get planIsExpired => carModel?.additionalProps?.expiry != null
      ? DateTime.parse(carModel!.additionalProps!.expiry!)
          .isBefore(DateTime.now())
      : true;

  Widget editCarValue(CarModel? car) {
    return GestureDetector(
      onTap: () => onTapEditCarValue(car),
      child: Padding(
        padding: getPadding(top: 31, bottom: 31),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: doYouNeedYourCarValueMsg,
                    style: AppTextStyle.regularTextStyle.copyWith(
                      color: ColorConstant.kColor353333,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: thisCanHelpToSellMsg,
                    style: AppTextStyle.smallTextStyle.copyWith(
                      color: ColorConstant.kColor7C7C7C,
                    ),
                  )
                ],
              ),
            ),
            CustomIconButton(
              height: getSize(26),
              width: getSize(26),
              margin: getMargin(left: 10.w),
              padding: IconButtonPadding.PaddingAll8,
              shape: IconButtonShape.CircleBorder21,
              child: CustomImageView(
                svgPath: Assets.editBox,
                color: ColorConstant.kColorWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget quickSaleButtonWithInfo(CarModel? car) {
    return Container(
      padding: getPadding(right: 18.w),
      decoration: BoxDecoration(
        color: quickSaleVisible!.value
            ? ColorConstant.gray700
            : ColorConstant.violetShade,
        borderRadius: BorderRadiusStyle.roundedBorder39,
      ),
      child: Row(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Padding(
                  padding: getPadding(left: 5.w),
                  child: IconButton(
                    onPressed: () {
                      infoOrThankyouPopup(
                        title: quickSalePopupTitle,
                        message: quickSalePopupMsg,
                        titleStyle: AppTextStyle.regularTextStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: getFontSize(20),
                          color: ColorConstant.kColor707070,
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.info_outline_rounded,
                      color: ColorConstant.kColorWhite,
                      size: getSize(25),
                    ),
                  ),
                ),
                VerticalDivider(
                  color: quickSaleVisible!.value
                      ? ColorConstant.gray500
                      : ColorConstant.violetShadeFaded,
                  thickness: 1,
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async => await onTapQuickOffer(car),
              child: ValueListenableBuilder<bool>(
                valueListenable: quickSaleVisible!,
                builder: (context, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const CustomImageView(svgPath: Assets.quickSale),
                      SizedBox(width: 4.w),
                      Text(
                        quickSaleButton,
                        style: AppTextStyle.regularTextStyle.copyWith(
                          color: ColorConstant.kColorWhite,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onTapQuickOffer(CarModel? car) async {
    if (quickSaleVisible!.value) {
      //Disable Quick Offer
      confirmationPopup(
        isQuestion: true,
        title: confirmTitle,
        subTitle: subTitleAreSureToRemoveQuickOffer,
        message: msgAreSureToRemoveQuickOffer,
        onTapSuccess: () {
          if (car?.userExpectedValue != null && car!.userExpectedValue != 0.0) {
            car.userExpectedValue = car.wsacValue;
          }
          quickSaleVisible!.value = false;
          Navigator.pop(context);
          BlocProvider.of<CarDetailsBloc>(context).add(
            UpdateCarInfoEvent(
              carInfoData: {
                '_id': car!.id,
                'quickSale': quickSaleVisible!.value,
                if (car.userExpectedValue != null &&
                    car.userExpectedValue != 0.0)
                  'userExpectedValue': car.userExpectedValue,
              },
              carCreateStatus: CarCreateStatus.completed,
            ),
          );
        },
      );
    } else {
      //Enable Quick Offer
      quickSaleVisible!.value = true;
      if (car?.userExpectedValue != null && car!.userExpectedValue != 0.0) {
        if (car.userExpectedValue! > car.wsacValue! &&
            quickSaleVisible!.value) {
          car.userExpectedValue = car.tradeValue;
          infoOrThankyouPopup(subTitle: restorWsacValue);
        } else {
          car.userExpectedValue = car.wsacValue;
          infoOrThankyouPopup(subTitle: thankYouForChoosingQS);
        }
      } else {
        infoOrThankyouPopup(subTitle: thankYouForChoosingQS);
      }
      BlocProvider.of<CarDetailsBloc>(context).add(
        UpdateCarInfoEvent(
          carInfoData: {
            '_id': car!.id,
            'quickSale': quickSaleVisible!.value,
            if (car.userExpectedValue != null && car.userExpectedValue != 0.0)
              'userExpectedValue': car.userExpectedValue,
          },
          carCreateStatus: CarCreateStatus.completed,
        ),
      );
    }
  }

  Widget unlistAndPremiumButton(CarModel? car) {
    final unListStatus = unListCarStatus.map((e) => e.name).toList();
    return Padding(
      padding: getPadding(top: 20.h, bottom: 20.h),
      child: Row(
        children: [
          if (car?.status != convertEnumToString(CarStatus.sold))
            Expanded(
              child: CustomElevatedButton(
                title: unListStatus.contains(car!.status)
                    ? listButton
                    : unListButton,
                buttonBgColor: ColorConstant.kColor303030,
                onTap: () => listOrUnlist(unListStatus),
              ),
            ),
        ],
      ),
    );
  }

  void listOrUnlist(List<String> unListStatus) async {
    final listUnlistBloc = context.read<ListUnlistBlocBloc>();

    //LIST
    if (unListStatus.contains(carModel!.status!)) {
      bool isYes = await confirmationPopup(
        title: listTitle,
        message: listCarPopupMessage,
        isQuestion: true,
      );
      if (isYes) {
        listUnlistBloc.add(ListOrUnListMyCarEvent(
          userId: currentUser?.userId ?? '',
          userType: currentUser?.userType ?? '',
          carId: widget.carId,
          status: convertEnumToString(CarStatus.active),
        ));
      }
    } else {
      //UNLIST
      bool isYes = await confirmationPopup(
        title: unlistTitle,
        message: unListCarPopupMessage,
        isQuestion: true,
      );
      if (isYes) {
        listUnlistBloc.add(ListOrUnListMyCarEvent(
          userId: currentUser?.userId ?? '',
          userType: currentUser?.userType ?? ' ',
          carId: widget.carId,
          status: convertEnumToString(CarStatus.disabled),
        ));
      }
    }
  }

  //loader
  void setLoader(bool isLoader) {
    if (isLoader) {
      progressDialogue();
    } else {
      Navigator.pop(globalNavigatorKey.currentContext!);
    }
  }

  Widget errorBuild({
    required String errorMessage,
    required String buttonLabel,
    required void Function() onTap,
  }) {
    return Container(
      alignment: Alignment.topCenter,
      margin: getMargin(top: size.height * 0.15),
      height: size.height,
      child: ErrorWithButtonWidget(
        message: errorMessage,
        buttonLabel: buttonLabel,
        onTap: onTap,
      ),
    );
  }

  //sucess popup
  void successPopup() {
    customPopup(
      hasContentPadding: false,
      content: ThankYouPopUpWithButton(
        titleLabel: congrats.toUpperCase(),
        subTitle: forListingYourCar,
        buttonTitle: okButton,
        subTitleAlign: TextAlign.center,
        onTapButton: () => Navigator.pop(context),
      ),
    );
  }
}
