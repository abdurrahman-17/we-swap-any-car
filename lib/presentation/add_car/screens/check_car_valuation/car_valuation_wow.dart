import 'package:wsac/bloc/user/user_bloc.dart';
import 'package:wsac/core/locator.dart';
import 'package:wsac/presentation/common_widgets/common_loader.dart';
import 'package:wsac/service/shared_preference_service.dart';

import '../../../../bloc/car_details/car_details_bloc.dart';
import '../../../../core/configurations.dart';
import '../../../../model/car_model/car_added_accessories.dart';
import '../../../../model/car_model/car_model.dart';
import '../../../../model/user/user_model.dart';
import '../../../common_popup_widget/add_edit_car_valuation_popup.dart';
import '../../../common_popup_widget/add_extra_popup.dart';
import '../../../common_widgets/common_admin_support_button.dart';
import '../../../common_widgets/common_chip_with_remove_button.dart';
import '../../../common_widgets/common_divider.dart';
import '../../../common_widgets/common_popups.dart';
import '../../../common_widgets/common_switch.dart';
import '../../../common_widgets/custom_icon_button.dart';
import '../confirm_your_car/confirm_your_car_screen.dart';

class CarValuationWowScreen extends StatefulWidget {
  static const String routeName = 'car_valuation_wow_screen';

  const CarValuationWowScreen({
    Key? key,
    this.carModel,
    this.fromEdit = false,
  }) : super(key: key);
  final CarModel? carModel;
  final bool? fromEdit;
  @override
  State<CarValuationWowScreen> createState() => _CarValuationWowScreenState();
}

class _CarValuationWowScreenState extends State<CarValuationWowScreen> {
  bool quickSaleStatus = false;
  bool isOneAutoResponse = false;
  bool isWoowDisabled = false;
  UserModel? currentUser;

  @override
  void initState() {
    currentUser = BlocProvider.of<UserBloc>(context).currentUser;
    if (widget.carModel?.tradeValue != null &&
        widget.carModel!.tradeValue! != 0) {
      setState(() => isOneAutoResponse = true);
    }
    if (widget.fromEdit ?? false) {
      quickSaleStatus = widget.carModel?.quickSale ?? false;
    }
    if (currentUser?.userType != convertEnumToString(UserType.private)) {
      isWoowDisabled = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarDetailsBloc, CarDetailsState>(
      listener: (context, state) {
        if (state is ConfirmCarDetailsState) {
          if (state.confirmCarStatus == ProviderStatus.success) {
            Navigator.pop(context);
            widget.carModel!.manufacturer = state.car!.manufacturer;
            widget.carModel!.model = state.car!.model;
            widget.carModel!.yearOfManufacture = state.car!.yearOfManufacture;
            widget.carModel!.colour = state.car!.colour;
            widget.carModel!.transmissionType = state.car!.transmissionType;
            widget.carModel!.engineSize = state.car!.engineSize;
            widget.carModel!.fuelType = state.car!.fuelType;
            widget.carModel!.hpiAndMot = state.car!.hpiAndMot;
            if (Locator.instance
                .get<SharedPrefServices>()
                .getCarDoor()
                .isNotEmpty) {
              widget.carModel?.noOfDoors = int.parse(
                  Locator.instance.get<SharedPrefServices>().getCarDoor());
            }
            if (Locator.instance
                    .get<SharedPrefServices>()
                    .getCarBodyType()
                    .name !=
                null) {
              widget.carModel?.bodyType =
                  Locator.instance.get<SharedPrefServices>().getCarBodyType();
            }
            Navigator.pushNamed(
              context,
              ConfirmYourCarScreen.routeName,
              arguments: {
                'carModel': widget.carModel,
                'fromEdit': widget.fromEdit,
              },
            );
          } else if (state.confirmCarStatus == ProviderStatus.error) {
            Navigator.pop(context);
            confirmationPopup(
              successBtnText: emailusButton,
              closeBtnText: closeButton,
              title: informationLabel,
              message: contactSupportWSACMessage,
              onTapClose: () {
                Navigator.pop(context);
              },
              onTapSuccess: () async {
                Navigator.pop(context);
                await emailUs(subject: 'Vehicle not found');
              },
            );
          } else {
            progressDialogue();
          }
        }
      },
      child: CustomScaffold(
        title: carValuationAppBar,
        actions: const [
          AdminSupportButton(),
        ],
        body: Stack(
          children: [
            CustomImageView(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              svgPath: Assets.homeBackground,
              fit: BoxFit.fitWidth,
            ),
            Column(
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          carValuationWithAddExtra(),
                          tradeValuationAndQuicksale(),
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: getPadding(
                      top: 12.h,
                      bottom: 15.h,
                      left: 25.w,
                      right: 25.w,
                    ),
                    child: CustomElevatedButton(
                      title: uploadYourVehicleButton,
                      onTap: onUploadVehicle,
                      buttonBgColor: ColorConstant.kColor102027,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget carValuationWithAddExtra() {
    // final String valuationMsgOnGrade =
    //     (widget.carModel?.exteriorGrade?.grade ?? 'good').toLowerCase();
    return Padding(
      padding: getPadding(left: 25.w, right: 25.w, top: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isWoowDisabled && !quickSaleStatus)
            Text(
              wowLabel,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppTextStyle.txtPTSansBold39Black,
            ),
          Container(
            margin: getMargin(top: 3.h),
            child: Text(
              quickSaleStatus
                  ? heresYourQuickOfferStartingValuation
                  : (widget.carModel!.userExpectedValue! >
                              widget.carModel!.wsacValue!) &&
                          (currentUser?.userType !=
                              convertEnumToString(UserType.private))
                      ? liveListingValue
                      : isOneAutoResponse
                          ? lookWhatYourRetailvaluation
                          : youValuedYourCar,
              textAlign: TextAlign.center,
              style: AppTextStyle.txtPTSansRegular24
                  .copyWith(color: ColorConstant.kColor7B7B7B),
            ),
          ),
          Container(
            margin: getMargin(
              top: 25.h,
              bottom: 33.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImageView(
                  height: getSize(61),
                  width: getSize(61),
                  svgPath: Assets.whiteCheckGreenBg,
                ),
                Padding(
                  padding: getPadding(top: 6.h, bottom: 10.h),
                  child: Text(
                    euro +
                        currencyFormatter(
                            widget.carModel?.userExpectedValue ?? 0),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppTextStyle.txtOswaldRegular36Black,
                  ),
                ),
                GradientElevatedButton(
                  title: editYourCarValueButton,
                  width: getHorizontalSize(size.width / 2.5),
                  height: getVerticalSize(34.h),
                  textStyle: AppTextStyle.txtPTSansRegular14WhiteA700,
                  onTap: !quickSaleStatus ? () => onTapEditCarValue() : null,
                  prefixWidget: CustomImageView(
                    color: ColorConstant.whiteA700,
                    svgPath: Assets.editBox,
                    height: getSize(14),
                    width: getSize(14),
                  ),
                ),
                // if (isOneAutoResponse && !quickSaleStatus)
                //   Padding(
                //     padding: getPadding(top: 13.h, bottom: 20.h),
                //     child: Text(
                //       valueBasedOnConditionMsg1 +
                //           valuationMsgOnGrade +
                //           valueBasedOnConditionMsg2,
                //       overflow: TextOverflow.ellipsis,
                //       textAlign: TextAlign.left,
                //       style: AppTextStyle.smallTextStyle.copyWith(
                //         color: ColorConstant.kColor3C3C3C,
                //         fontFamily: Assets.interFontStyle,
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
          addExtraOption(),
          if ((widget.carModel?.addedAccessories?.listedItems ?? [])
                  .isNotEmpty ||
              (widget.carModel?.addedAccessories?.notListedItems ?? [])
                  .isNotEmpty)
            addedExtraItems(),
        ],
      ),
    );
  }

  Widget addExtraOption() {
    return GestureDetector(
      onTap: () => onTapAddExtra(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: doYouNeedToAddExtra,
                    style: AppTextStyle.regularTextStyle.copyWith(
                      color: ColorConstant.kColor353333,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  WidgetSpan(
                    child: SizedBox(height: getVerticalSize(20)),
                  ),
                  TextSpan(
                    text: msgThisHelpToSellYourVehicle,
                    style: AppTextStyle.smallTextStyle.copyWith(
                      color: ColorConstant.kColor7C7C7C,
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomIconButton(
            height: getSize(26),
            width: getSize(26),
            padding: IconButtonPadding.PaddingAll6,
            shape: IconButtonShape.RoundedBorder100,
            variant: IconButtonVariant.primaryGradient,
            child: CustomImageView(
              svgPath: ((widget.carModel?.addedAccessories?.listedItems ?? []))
                          .isEmpty &&
                      ((widget.carModel?.addedAccessories?.notListedItems ??
                              []))
                          .isEmpty
                  ? Assets.whitePlus
                  : Assets.sideMenuEditProfile,
            ),
          ),
        ],
      ),
    );
  }

  Widget addedExtraItems() {
    final listedItems = widget.carModel?.addedAccessories?.listedItems ?? [];
    final notListedItems =
        widget.carModel?.addedAccessories?.notListedItems ?? [];
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: getPadding(top: 23.h),
        child: Wrap(
          spacing: 9.w,
          runSpacing: 0.5,
          children: [
            for (final ListedItem item in listedItems)
              ChipWithRemoveButton(
                text: item.name ?? '',
                onTapRemove: () {
                  if (listedItems
                      .where((element) => element.name == item.name)
                      .toList()
                      .isNotEmpty) {
                    listedItems.remove(listedItems
                        .where((element) => element.name == item.name)
                        .first);
                  }
                  setState(() {});
                },
              ),
            for (final NotListedItem item in notListedItems)
              ChipWithRemoveButton(
                text: item.name ?? '',
                onTapRemove: () {
                  notListedItems.remove(item);
                  setState(() {});
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget tradeValuationAndQuicksale() {
    return Padding(
      padding: getPadding(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: 21.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonDivider(
            color: ColorConstant.kColorDBDBDB,
            thickness: 1,
          ),
          SizedBox(height: 10.h),
          if (isOneAutoResponse)
            Container(
              padding: getPadding(
                top: 5.h,
                bottom: 15.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: getPadding(top: 5.h, bottom: 6.h),
                    child: Text(
                      tradeValuation,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyle.txtPTSansRegular14Black900,
                    ),
                  ),
                  Text(
                    euro + currencyFormatter(widget.carModel!.tradeValue!),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppTextStyle.txtPTSansRegular22Black900,
                  ),
                ],
              ),
            ),
          if (isOneAutoResponse)
            CommonDivider(
              color: ColorConstant.kColorDBDBDB,
              thickness: 1,
            ),
          quickSaleOption(),
        ],
      ),
    );
  }

  Widget quickSaleOption() {
    return Padding(
      padding: getPadding(top: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: getPadding(
                  top: 5.h,
                  bottom: 6.h,
                ),
                child: Text(
                  quickSale,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppTextStyle.regularTextStyle.copyWith(
                    color: ColorConstant.kColor151515,
                  ),
                ),
              ),
              IconButton(
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
                  color: ColorConstant.kColor5A5A5A,
                  size: getSize(25),
                ),
              ),
            ],
          ),
          CustomSwitch(
            value: quickSaleStatus,
            onChanged: (_) {
              if (quickSaleStatus) {
                //TURN OFF
                quickSaleStatus = false;
                widget.carModel!.quickSale = quickSaleStatus;
                if (isOneAutoResponse) {
                  widget.carModel?.userExpectedValue =
                      widget.carModel?.wsacValue;
                }
              } else {
                //TURN ON
                quickSaleStatus = true;
                widget.carModel!.quickSale = quickSaleStatus;
                if (isOneAutoResponse) {
                  infoOrThankyouPopup(
                    subTitle: restorWsacValue,
                    onTapButton: () {
                      widget.carModel?.userExpectedValue =
                          widget.carModel?.tradeValue;
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                  );
                } else {
                  infoOrThankyouPopup(subTitle: thankYouForChoosingQS);
                }
              }
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  ///add extra items popup
  Future<void> onTapAddExtra() async {
    await customPopup(
      barrierDismissible: false,
      content: AddExtraPopup(carModel: widget.carModel),
    );
    setState(() {});
  }

  ///edit car value popup
  Future<void> onTapEditCarValue() async {
    final editedCarVal = await customPopup(
        content: AddEditCarValuationPopup(
      fromEdit: true,
      car: widget.carModel,
    ));
    if (editedCarVal != null) {
      widget.carModel?.userExpectedValue = editedCarVal as num;
      setState(() {});
    }
  }

  //On upload vehicle
  Future<void> onUploadVehicle() async {
    if (widget.fromEdit ?? false) {
      Navigator.pushNamed(
        context,
        ConfirmYourCarScreen.routeName,
        arguments: {
          'carModel': widget.carModel,
          'fromEdit': widget.fromEdit,
        },
      );
    } else {
      BlocProvider.of<CarDetailsBloc>(context).add(ConfirmCarDetailsEvent(
          registrationNumber: widget.carModel?.registration ?? ''));
    }
  }
}
