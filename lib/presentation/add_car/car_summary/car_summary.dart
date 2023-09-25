import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wsac/core/configurations.dart';

import '../../../bloc/car_details/car_details_bloc.dart';
import '../../../bloc/list_unlist/list_unlist_bloc_bloc.dart';
import '../../../bloc/subscription/subscription_bloc.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../main.dart';
import '../../../model/car_detail_model/hpi_history_result_model.dart';
import '../../../model/car_model/car_hpi_history_check.dart';
import '../../../model/car_model/car_model.dart';
import '../../../model/user/user_model.dart';
import '../../../service/deep_link_service.dart';
import '../../../utility/common_keys.dart';
import '../../../utility/date_time_utils.dart';
import '../../common_popup_widget/add_edit_car_valuation_popup.dart';
import '../../common_popup_widget/thank_you_popup_with_button_widget.dart';
import '../../common_widgets/common_admin_support_button.dart';
import '../../common_widgets/common_condition_damage_info_card.dart';
import '../../common_widgets/common_divider.dart';
import '../../common_widgets/common_expansion_tile.dart';
import '../../common_widgets/common_loader.dart';
import '../../common_widgets/common_popups.dart';
import '../../common_widgets/full_screen_image_viewer.dart';
import '../../common_widgets/label_and_value_card_widget.dart';
import '../../landing_screen/landing_screen.dart';
import '../../slot_purchase/slot_purchase_screen.dart';
import 'widgets/car_summary_image_slider.dart';

class CarSummaryScreen extends StatefulWidget {
  static const String routeName = 'car_summary_screen';

  const CarSummaryScreen({Key? key, required this.carId}) : super(key: key);
  final String carId;
  @override
  State<CarSummaryScreen> createState() => _CarSummaryScreenState();
}

class _CarSummaryScreenState extends State<CarSummaryScreen> {
  late int selectedIndex = -1;
  final TextEditingController _attentionGrabberController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _companyDescriptionController =
      TextEditingController();
  final TextEditingController _additionalController = TextEditingController();

  CarModel? carModel;
  UserModel? currentUser;
  late ListUnlistBlocBloc unlistBlocBloc;

  @override
  void initState() {
    unlistBlocBloc = context.read<ListUnlistBlocBloc>();
    currentUser = context.read<UserBloc>().currentUser;
    BlocProvider.of<CarDetailsBloc>(context).add(GetCarDetailsEvent(
      key: '_id',
      value: widget.carId,
    ));
    super.initState();
  }

  ///collapse or expand- expansion tile
  void collapseOrExpand({required bool newState, required int index}) {
    if (newState) {
      selectedIndex = index;
    } else {
      selectedIndex = -1;
    }
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: carSummaryAppBar,
      actions: const [
        AdminSupportButton(),
      ],
      body: MultiBlocListener(
        listeners: [
          BlocListener<ListUnlistBlocBloc, ListUnlistBlocState>(
            listener: (context, state) async {
              if (state is ListOrUnListMyCarState) {
                if (state.listStatus == ProviderStatus.success) {
                  setLoader(false);
                  successPopup();
                  BlocProvider.of<UserBloc>(context).add(
                      GetCurrentUserDataEvent(
                          key: emailKey, value: currentUser?.email ?? ''));
                } else if (state.listStatus == ProviderStatus.error) {
                  setLoader(false);
                  if (state.errorMessage == slotUnavailable) {
                    bool? result = await confirmationPopup2(
                      title: alert.toUpperCase(),
                      message: slotPurchaseContent,
                      successBtnLabel: "ADD SLOT",
                      cancelBtnLabel: "UNLIST CAR",
                    );
                    if (result != null) {
                      if (result) {
                        Navigator.pushNamed(
                          globalNavigatorKey.currentContext!,
                          SlotPurchase.routeName,
                          arguments: {
                            "subscriptionPageName":
                                SubscriptionPageName.carSummary,
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
            },
          ),
          BlocListener<SubscriptionBloc, SubscriptionState>(
            listener: (context, state) {
              if (state is AddSubscriptionPlanState &&
                  state.subscriptionPageName ==
                      SubscriptionPageName.carSummary) {
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
                      isThankYou: true,
                      subTitle: forCHoosingWSACMsg,
                      message: subscriptionThanks,
                      buttonText: closeButton,
                      onTapButton: () {
                        setLoader(true);
                        logoutAction();
                      },
                    );
                  }
                } else if (state.subscriptionAddStatus ==
                    ProviderStatus.error) {
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
          ),
        ],
        child: BlocBuilder<CarDetailsBloc, CarDetailsState>(
          builder: (context, state) {
            final carDetailsBloc = context.read<CarDetailsBloc>();
            if (state is GetCarDetailsState || state is UpdateCarInfoState) {
              if (state is GetCarDetailsState &&
                  state.carDetailsStatus == ProviderStatus.success) {
                carModel = carDetailsBloc.car;
                return body(carModel);
              } else if (state is UpdateCarInfoState &&
                  state.carCreateStatus == CarCreateStatus.summaryScreen &&
                  state.updateCarStatus == ProviderStatus.success) {
                carModel = state.car;
                return body(carModel);
              } else if (state is UpdateCarInfoState &&
                  state.carCreateStatus == CarCreateStatus.carWorth &&
                  state.updateCarStatus == ProviderStatus.success) {
                carModel = state.car;
                return body(carModel);
              }
            }
            return shimmerEffect();
          },
        ),
      ),
    );
  }

  Widget shimmerEffect() {
    return SingleChildScrollView(
      child: Padding(
        padding: getPadding(
          left: 25.w,
          right: 25.w,
          top: 15.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vehicleInformation,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppTextStyle.txtPTSansRegular16,
            ),
            SizedBox(height: 19.h),
            shimmerLoader(
              AspectRatio(
                aspectRatio: 1.6,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorConstant.kColorWhite,
                    borderRadius: BorderRadius.circular(21.r),
                  ),
                ),
              ),
            ),
            ListView.separated(
              itemCount: 7,
              shrinkWrap: true,
              padding: getPadding(top: 30.h, bottom: 15.h),
              itemBuilder: (context, index) => shimmerLoader(
                Container(
                  height: getVerticalSize(41.h),
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
      ),
    );
  }

  Widget body(CarModel? car) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: CustomImageView(
            width: MediaQuery.of(context).size.width,
            svgPath: Assets.homeBackground,
            fit: BoxFit.fill,
          ),
        ),
        SafeArea(
          child: Padding(
            padding: getPadding(
              left: 25.w,
              right: 25.w,
              top: 15.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: summaryList(car)),
                Padding(
                  padding: getPadding(top: 13.h, bottom: 10.h),
                  child: CustomElevatedButton(
                    title: confirmButton,
                    onTap: () async {
                      bool isYes = await confirmationPopup(
                        title: "LIST",
                        message: "Are you sure want to list the vehicle?",
                        messageTextAlign: TextAlign.center,
                      );
                      if (isYes) {
                        unlistBlocBloc.add(ListOrUnListMyCarEvent(
                          userId: currentUser?.userId ?? '',
                          userType: currentUser?.userType ?? ' ',
                          carId: widget.carId,
                          status: convertEnumToString(CarStatus.active),
                        ));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget summaryList(CarModel? car) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          Text(
            vehicleInformation,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppTextStyle.txtPTSansRegular16,
          ),
          SizedBox(height: 19.h),
          CarSummaryImageSlider(car: car),
          vehicleAdditionalInfoTile(car),
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
          SizedBox(height: 20.h),
          GradientElevatedButton(
            title: editInfoButton,
            onTap: () {
              Navigator.of(context).pop({'carModel': car});
            },
          ),
          SizedBox(height: 26.h),
          Text(
            ifAllInfoCorrectSaveYourDetails,
            style: AppTextStyle.regularTextStyle.copyWith(
              color: ColorConstant.kColor353333,
            ),
          ),
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
      title: additionalInfo,
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
        value: car?.mileage != null
            ? currencyFormatter(car!.mileage!)
            : notApplicable,
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
      initiallyExpanded: selectedIndex == 1,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 1);
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
      initiallyExpanded: selectedIndex == 2,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 2);
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
                    //     (car?.tradeValue != null && car!.tradeValue != 0)
                    //         ? ((car?.userExpectedValue ?? 0) >
                    //                 (car?.tradeValue ?? 0))
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
        if (car?.tradeValue != null && car!.tradeValue! != 0)
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
  Future<void> onTapEditCarValue(CarModel? car) async {
    final editedCarVal = await customPopup(
        content: AddEditCarValuationPopup(
      fromEdit: true,
      car: car,
    ));
    if (editedCarVal != null) {
      final String editedCarValue =
          '$editedCarVal'.replaceAll(',', '').toString();
      car?.userExpectedValue = int.parse(editedCarValue);
      List<String> createStatus = car?.createStatus ?? [];
      createStatus.add(convertEnumToString(CarCreateStatus.carWorth));
      if (!mounted) return;
      BlocProvider.of<CarDetailsBloc>(context).add(
        UpdateCarInfoEvent(
          carInfoData: {
            '_id': car!.id,
            'userExpectedValue': car.userExpectedValue,
            'createStatus': createStatus.toSet().toList(),
          },
          carCreateStatus: CarCreateStatus.carWorth,
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
      initiallyExpanded: selectedIndex == 3,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 3);
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
        value: car?.hpiAndMot?.numberOfKeys?.toString() ?? notApplicable,
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
      initiallyExpanded: selectedIndex == 5,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 5);
      },
      childrens: [
        extraItems.isNotEmpty
            ? ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: getPadding(bottom: 10.h),
                itemCount: extraItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: getPadding(top: 10.h, bottom: 10.h),
                    child: Text(
                      extraItems[index] ?? '',
                      style: AppTextStyle.regularTextStyle.copyWith(
                        color: ColorConstant.kColor535353,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => CommonDivider(
                  color: ColorConstant.kColorDBDBDB,
                  thickness: 1,
                ),
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
      initiallyExpanded: selectedIndex == 6,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 6);
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
            ? Padding(
                padding: getPadding(bottom: 16),
                child: GridView.builder(
                  shrinkWrap: true,
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
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'No receipts added',
                  textAlign: TextAlign.start,
                  style: AppTextStyle.regularTextStyle
                      .copyWith(color: ColorConstant.kColor7C7C7C),
                ),
              ),
      ],
    );
  }

  Widget conditionAndDamage(CarModel? car) {
    _additionalController.text = car?.conditionAndDamage?.additionalInfo ?? '';
    return CommonExpansionTile(
      title: conditionAndDamageTitle,
      initiallyExpanded: selectedIndex == 7,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 7);
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
          style: AppTextStyle.hintTextStyle,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  void successPopup() {
    customPopup(
      hasContentPadding: false,
      content: ThankYouPopUpWithButton(
        titleLabel: congrats.toUpperCase(),
        subTitle: forListingYourCar,
        buttonTitle: goToHomeButton,
        subTitleAlign: TextAlign.center,
        onTapButton: () => Navigator.pushNamedAndRemoveUntil(
            context, LandingScreen.routeName, (route) => false),
        bottomWidget: Padding(
          padding: getPadding(bottom: 5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                wouldYouLikeToShareMsg,
                style: AppTextStyle.labelTextStyle.copyWith(
                  color: ColorConstant.kBackgroundColor,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  final make = carModel?.manufacturer?.name?.toUpperCase() ??
                      shortAppName;
                  final model = carModel?.model ?? appName;
                  shareFeature(
                    content: make +
                        nextLine +
                        model +
                        nextLine +
                        generateDeepLink('carId=${carModel?.id ?? ''}'),
                    imgUrl: carModel?.uploadPhotos?.rightImages?.first ?? '',
                  );
                },
                icon: const CustomImageView(
                    svgPath: Assets.shareBlackWithWhiteBg),
                label: Text(
                  shareTitle,
                  style: AppTextStyle.labelTextStyle.copyWith(
                    color: ColorConstant.kBackgroundColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void setLoader(bool value) {
    if (value) {
      progressDialogue();
    } else {
      Navigator.pop(context);
    }
  }
}
