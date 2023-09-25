import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../bloc/car_details/car_details_bloc.dart';
import '../../bloc/chat/chat_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../core/configurations.dart';
import '../../model/car_detail_model/hpi_history_result_model.dart';
import '../../model/car_model/car_hpi_history_check.dart';
import '../../model/car_model/car_model.dart';
import '../../model/chat_model/chat_group/chat_car_model.dart';
import '../../model/chat_model/chat_group/chat_group_model.dart';
import '../../model/chat_model/chat_group/chat_user_model.dart';
import '../../model/user/user_model.dart';
import '../../utility/chat_utils.dart';
import '../../utility/date_time_utils.dart';
import '../chat_screen/screens/user_chat_window.dart';
import '../common_widgets/common_condition_damage_info_card.dart';
import '../common_widgets/common_divider.dart';
import '../common_widgets/common_expansion_tile.dart';
import '../common_widgets/common_loader.dart';
import '../common_widgets/full_screen_image_viewer.dart';
import '../common_widgets/label_and_value_card_widget.dart';
import 'widgets/car_profile_slider.dart';

class ViewProfileScreen extends StatefulWidget {
  static const String routeName = 'view_profile_screen';
  const ViewProfileScreen({Key? key, required this.carId}) : super(key: key);
  final String carId;
  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  late bool quickSale = false;
  late int selectedIndex = -1;
  final TextEditingController _attentionGrabberController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _companyDescriptionController =
      TextEditingController();
  final TextEditingController _additionalController = TextEditingController();
  UserModel? currentUser;
  String userIdOrAdminUserId = '';
  CarModel? carModel;

  ///collapse or expand - expansion tile
  void collapseOrExpand({required bool newState, required int index}) {
    if (newState) {
      selectedIndex = index;
    } else {
      selectedIndex = -1;
    }
    setState(() {});
  }

  @override
  void initState() {
    BlocProvider.of<CarDetailsBloc>(context).add(GetCarDetailsEvent(
      key: '_id',
      value: widget.carId,
    ));
    super.initState();
    currentUser = context.read<UserBloc>().currentUser;
  }

  void setLoading(bool value) {
    if (value) {
      progressDialogue();
    } else {
      Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatGroupCreateState &&
            state.routeName == ViewProfileScreen.routeName) {
          if (state.createChatGroupStatus == ProviderStatus.success) {
            setLoading(false);
            Navigator.pushNamed(
              context,
              UserChatScreen.routeName,
              arguments: {
                'chatGroup': state.chatGroup,
                'userIdOrAdminUserId': userIdOrAdminUserId,
                'selectedIndex': state.selectedIndex,
              },
            );
          } else if (state.createChatGroupStatus == ProviderStatus.error) {
            setLoading(false);
            showSnackBar(message: state.errorMessage ?? errorOccurred);
          } else {
            setLoading(true);
          }
        }
      },
      child: CustomScaffold(
        title: viewProfileAppBar,
        body: BlocBuilder<CarDetailsBloc, CarDetailsState>(
          builder: (context, state) {
            final carDetailsBloc = context.read<CarDetailsBloc>();
            if (state is GetCarDetailsState || state is UpdateCarInfoState) {
              if (state is GetCarDetailsState &&
                  state.carDetailsStatus == ProviderStatus.success) {
                carModel = carDetailsBloc.car;
                return carDetails(carModel);
              } else if (state is UpdateCarInfoState &&
                  state.updateCarStatus == ProviderStatus.success) {
                carModel = state.car;
                return carDetails(carModel);
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shimmerLoader(
            Container(
              height: getVerticalSize(55.h),
              margin:
                  getMargin(left: 20.w, right: 20.w, bottom: 20.h, top: 10.h),
              decoration: AppDecoration.outlineBlack9000c.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder39,
              ),
            ),
          ),
          shimmerLoader(
            AspectRatio(
              aspectRatio: 1.8,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(color: ColorConstant.kColorWhite),
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
    return Stack(
      children: [
        CustomImageView(
          svgPath: Assets.homeBackground,
          width: getHorizontalSize(size.width),
          alignment: Alignment.bottomCenter,
          fit: BoxFit.fill,
        ),
        SafeArea(
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  userInfoCard(car),
                  CarProfileContentSlider(car: car),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: getPadding(left: 20.w, top: 18.h, right: 20.w),
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
                                    style:
                                        AppTextStyle.txtPTSansRegular12Red300,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    car?.model ?? notApplicable,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.left,
                                    style:
                                        AppTextStyle.txtPTSansBold14Bluegray900,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              euro +
                                  currencyFormatter(
                                      (car?.userExpectedValue ?? 0).toInt()),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppTextStyle.regularTextStyle.copyWith(
                                color: ColorConstant.kColorBlack,
                                fontSize: getFontSize(20),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            getPadding(top: 6, left: 20, right: 20, bottom: 5),
                        child: Text(
                          car?.additionalInformation?.attentionGraber ??
                              notApplicable,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.regularTextStyle.copyWith(
                            color: ColorConstant.kColor7C7C7C,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: getPadding(
                          left: 8.w,
                          top: 5.h,
                          right: 8.w,
                          bottom: 5.h,
                        ),
                        margin: getMargin(
                          left: 20.w,
                          top: 5.h,
                          right: 20.w,
                          bottom: 20.h,
                        ),
                        width: double.infinity,
                        decoration: AppDecoration
                            .gradientDeeporangeA200Yellow900
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
                                text:
                                    '${currencyFormatter((car?.mileage ?? 0))} '
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
                        padding: getPadding(
                          left: 20.w,
                          right: 20.w,
                          bottom: 20.h,
                        ),
                        child: summaryList(car),
                      ),
                      chatAndMakeOfferButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget userInfoCard(CarModel? car) {
    return Container(
      padding: getPadding(
        left: 12.w,
        right: 15.w,
        top: 10.h,
        bottom: 10.h,
      ),
      margin: getMargin(left: 15.w, right: 15.w, bottom: 15.h, top: 8.h),
      decoration: AppDecoration.outlineBlack9000c.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder39,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  height: getSize(42),
                  width: getSize(42),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                    gradient: LinearGradient(colors: kPrimaryGradientColor),
                  ),
                  child: (car?.ownerProfileImage != null &&
                              car!.ownerProfileImage!.isNotEmpty) ||
                          (car?.companyLogo != null &&
                              car!.companyLogo!.isNotEmpty)
                      ? CustomImageView(
                          url: car.userType == UserType.private.name
                              ? car.ownerProfileImage
                              : car.companyLogo,
                          height: getSize(42),
                          width: getSize(42),
                          radius: BorderRadius.circular(100.r),
                          fit: BoxFit.cover,
                        )
                      : CustomImageView(
                          svgPath: car?.userType == UserType.private.name
                              ? Assets.privatePlaceholder
                              : Assets.dealerPlaceholder,
                          color: ColorConstant.kColorWhite,
                          margin: getMargin(all: 9),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    car?.userType == UserType.private.name
                        ? car?.ownerUserName ?? shortAppName
                        : car?.companyName ?? shortAppName,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppTextStyle.txtPTSansBold15Red300,
                  ),
                ),
              ],
            ),
          ),
          if (car?.userType != UserType.private.name)
            RatingBar.builder(
              initialRating: car?.companyRating?.toDouble() ?? 0.0,
              minRating: 1,
              allowHalfRating: true,
              itemSize: 15,
              itemPadding: getPadding(left: 3.w, right: 3.w),
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
          vehicleDetails(car),
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
            ? customDateFormat(convertStringToDateTime(
                car.hpiAndMot!.keeperStartDate!,
              )!)
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
      if (car?.hpiAndMot?.isPreOwnerNotDisclosed == false)
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
      initiallyExpanded: selectedIndex == 4,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 4);
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
      initiallyExpanded: selectedIndex == 5,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 5);
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
      initiallyExpanded: selectedIndex == 6,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 6);
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
          value:
              car?.conditionAndDamage?.brokenMissingItems?.brokenMissingItems ??
                  false,
          label: brokenMinorProblemLabel,
          images: car?.conditionAndDamage?.brokenMissingItems?.images ?? [],
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

  Widget chatAndMakeOfferButton() {
    return Padding(
      padding: getPadding(
        top: 15.h,
        right: 20.w,
        left: 20.w,
        bottom: 15.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomElevatedButton(
              title: chatButton,
              onTap: () {
                createChatGroup(
                  car: carModel!,
                  selectedIndex: 0, //chat
                );
              },
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: GradientElevatedButton(
              title: makeAnOfferButton,
              onTap: () {
                createChatGroup(
                  car: carModel!,
                  selectedIndex: 1, //make an offer
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void createChatGroup({required CarModel car, required int selectedIndex}) {
    String? userId;
    String? username;
    String? userImage;
    String? userType;
    num? rating;
    if (currentUser?.userType == convertEnumToString(UserType.private)) {
      userId = currentUser?.userId;
      username = currentUser?.userName;
      userImage = currentUser?.avatarImage;
      userType = currentUser?.userType;
    } else {
      userId = currentUser?.userId;
      username = currentUser?.trader?.companyName;
      userImage = currentUser?.trader?.logo;
      userType = convertEnumToString(UserType.dealerAdmin);
      rating = currentUser?.trader?.companyRating;
      if (currentUser?.userType ==
          convertEnumToString(UserType.dealerSubUser)) {
        userId = currentUser?.trader?.adminUserId;
      }
    }
    userIdOrAdminUserId = userId ?? '';
    //current car userId,currentUserId,carId
    final String groupId = generateHash(
      car.userId!,
      userId!,
      car.id!,
    );

    final chatGroup = ChatGroupModel()
      ..groupId = groupId
      ..groupAdminUserId = userId
      ..groupNameForSearch = (car.manufacturer?.name ?? '').toLowerCase()
      ..lastMessage = ''
      ..isChatAvailable = false
      ..groupUsers = [userId, car.userId!]
      ..createdAt = getCurrentDateTime()
      ..updatedAt = getCurrentDateTime()
      ..carDetails = ChatCarModel(
          carId: car.id,
          carName: car.manufacturer?.name,
          carModelName: car.model,
          carCash: car.userExpectedValue,
          carImage: car.uploadPhotos?.rightImages != null
              ? car.uploadPhotos?.rightImages![0]
              : null,
          userId: car.userId)
      ..receiver = ChatUserModel(
          userId: car.userId,
          userName: car.ownerUserName,
          userImage: car.ownerProfileImage,
          userType: car.userType,
          rating: car.userRating)
      ..admin = ChatUserModel(
          userId: userId,
          userImage: userImage,
          userName: username,
          userType: userType,
          rating: rating);
    context.read<ChatBloc>().add(CreateChatGroupEvent(
          chatGroup: chatGroup,
          routeName: ViewProfileScreen.routeName,
          selectedIndex: selectedIndex,
        ));
  }
}
