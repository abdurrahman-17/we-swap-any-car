import 'dart:developer';

import 'package:flutter/services.dart';

import '../../../../bloc/car_valuation/valuation_check_bloc.dart';
import '../../../../bloc/user/user_bloc.dart';
import '../../../../core/configurations.dart';
import '../../../../core/locator.dart';
import '../../../../model/car_model/car_added_accessories.dart';
import '../../../../model/car_model/car_exterior_grade.dart';
import '../../../../model/car_model/car_model.dart';
import '../../../../model/one_auto_response_model.dart';
import '../../../../model/user/user_model.dart';
import '../../../../repository/car_repo.dart';
import '../../../../service/shared_preference_service.dart';
import '../../../../utility/custom_formatter.dart';
import '../../../../utility/validator.dart';
import '../../../common_popup_widget/car_valuation_check_popup.dart';
import '../../../common_popup_widget/exterior_grade_popup.dart';
import '../../../common_widgets/common_admin_support_button.dart';
import '../../../common_widgets/common_loader.dart';
import '../../../common_widgets/common_popups.dart';
import '../../../common_widgets/custom_text_widget.dart';
import '../../../common_widgets/field_label.dart';
import 'car_valuation_wow.dart';

class CheckCarWorthScreen extends StatefulWidget {
  static const String routeName = 'check_car_worth_screen';
  const CheckCarWorthScreen({super.key, this.carModel});
  final CarModel? carModel;
  @override
  State<CheckCarWorthScreen> createState() => _CheckCarWorthScreenState();
}

class _CheckCarWorthScreenState extends State<CheckCarWorthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _registerNumberController =
      TextEditingController();
  final TextEditingController _exteriorGradeController =
      TextEditingController();
  int? selectedIndex;
  String mileage = '';
  int mileageMaxLength = 9;
  UserModel? user;
  List<ExteriorGrade> exteriorItemList = [];
  bool? fromEdit = false;

  @override
  void initState() {
    user = context.read<UserBloc>().currentUser;
    autoPopulate();
    if (widget.carModel != null) {
      fromEdit = true;
    }
    super.initState();
  }

  void autoPopulate() {
    final registration = widget.carModel?.registration ?? '';
    if (registration.length == 7) {
      _registerNumberController.text = registration.replaceRange(
          registration.length - 3, registration.length - 3, ' ');
    } else {
      _registerNumberController.text = registration;
    }
    if (widget.carModel?.mileage != null) {
      _mileageController.text =
          currencyFormatter(widget.carModel!.mileage ?? 0);
    }
    _exteriorGradeController.text = widget.carModel?.exteriorGrade?.grade ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ValuationCheckBloc, ValuationCheckState>(
      listener: (context, state) {
        if (state is ValuationCheckLoadingState) {
          progressDialogue();
        } else if (state is ValuationCheckErrorState) {
          Navigator.pop(context);
          showSnackBar(message: state.errorMessage);
        } else if (state is ValuationCheckSuccessState) {
          Navigator.pop(context);
          CarModel carModel = CarModel(
            userId: user!.userId,
            registration:
                _registerNumberController.text.replaceAll(' ', '').trim(),
            mileage:
                int.parse(_mileageController.text.replaceAll(',', '').trim()),
            exteriorGrade: exteriorItemList[selectedIndex ?? 0],
            addedAccessories: AddedAccessories(
              listedItems: [],
              notListedItems: [],
            ),
          );
          final OneAutoData? oneAutoResult = state.oneAutoResponse.data;
          if (oneAutoResult != null) {
            log(oneAutoResult.toJson().toString());
            carModel.wsacValue =
                (oneAutoResult.responseParameter?.wsacValue ?? 0).round();
            carModel.userExpectedValue =
                (oneAutoResult.responseParameter?.wsacValue ?? 0).round();
            carModel.tradeValue =
                (oneAutoResult.responseParameter?.retailValuation ?? 0).round();
            Navigator.pushNamed(
              context,
              CarValuationWowScreen.routeName,
              arguments: {
                'carModel': carModel,
                'fromEdit': fromEdit,
              },
            );
          } else {
            ///MANUAL ENTRY
            customPopup(
              hasContentPadding: false,
              content: CarValuationCheckPopup(carModel: carModel),
            );
          }
        }
      },
      child: CustomScaffold(
        title: carValuationCheckAppBar,
        actions: const [
          AdminSupportButton(),
        ],
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomImageView(
              fit: BoxFit.fill,
              svgPath: Assets.carValuationBg,
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: getPadding(left: 25.w, right: 25.w),
              child: Column(
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          reallyWorthHead(),
                          registrationField(),
                          Padding(
                            padding: getPadding(top: 24.h, bottom: 6.h),
                            child: const FieldLabelWidget(
                              label: mileageLabel,
                              isMandatory: true,
                            ),
                          ),
                          // Mileage Text Field
                          mileageField(),
                          Padding(
                            padding: getPadding(top: 14.h, bottom: 6.h),
                            child: const FieldLabelWidget(
                              label: extriorGradeLabel,
                              isMandatory: true,
                            ),
                          ),
                          // Exterior Grade Dropdown
                          exteriorGradeField(),
                        ],
                      ),
                    ),
                  ),
                  saveCheckWorthAndSkipNow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget reallyWorthHead() {
    return Padding(
      padding: getPadding(top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            letsSeeWhatsYourCar,
            style: AppTextStyle.regularTextStyle.copyWith(
              color: ColorConstant.kColor7C7C7C,
              fontSize: getFontSize(16),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            reallyWorth.toUpperCase(),
            style: AppTextStyle.regularTextStyle.copyWith(
              color: ColorConstant.kColor353333,
              fontSize: getFontSize(30),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget registrationField() {
    return Container(
      width: getHorizontalSize(size.width),
      margin: getMargin(top: 24.h),
      padding: getPadding(
        left: 25.w,
        top: 23.h,
        right: 25.w,
        bottom: 15.h,
      ),
      decoration: AppDecoration.outlineBlack9003f4.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder17,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            text: TextSpan(
              children: [
                TextSpan(
                  text: registrationNumber,
                  style: AppTextStyle.txtPTSansRegular14WhiteA700,
                ),
                TextSpan(
                  text: mandatoryField,
                  style: AppTextStyle.txtPTSansRegular16WhiteA700.copyWith(
                    color: ColorConstant.kColorRed,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 20),
            child: registrationTextfield(),
          )
        ],
      ),
    );
  }

  Widget mileageField() {
    return CommonTextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        CurrencyInputFormatter(),
        LengthLimitingTextInputFormatter(mileageMaxLength),
      ],
      hint: enterMileageHint,
      autoValidate: AutovalidateMode.onUserInteraction,
      textInputType: TextInputType.number,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(
          top: 19,
          bottom: 13,
          right: 18,
        ),
        child: Text(
          milesLabel,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: AppTextStyle.txtInterRegular12Gray600,
        ),
      ),
      validator: (val) {
        if (val != null && val.trim().isEmpty) {
          return 'Mileage is required';
        }
        return null;
      },
      prefixIcon: CustomImageView(
        fit: BoxFit.contain,
        svgPath: Assets.mileageCar,
        height: getVerticalSize(20),
        width: getHorizontalSize(30),
        margin: getMargin(left: 15, right: 10),
      ),
      controller: _mileageController,
      textInputAction: TextInputAction.done,
      readOnly: fromEdit ?? false,
    );
  }

  Widget exteriorGradeField() {
    return FutureBuilder(
      future: getExterior(),
      builder: (context, snap) {
        Widget childWidget;
        if (snap.hasData) {
          if (snap.data != null) {
            childWidget = CommonTextFormField(
              onTap: fromEdit ?? false
                  ? null
                  : () async => await onTapExteriorGradePopup(),
              hint: selectExteriorGradeHint,
              readOnly: true,
              isDropDown: true,
              controller: _exteriorGradeController,
              validator: (val) {
                if (val != null && val.trim().isEmpty) {
                  return 'Exterior grade is required';
                }
                return null;
              },
            );
          } else {
            childWidget = const CenterText(text: errorOccurred);
          }
          return childWidget;
        }
        return shimmerLoader(
          Container(
            height: getVerticalSize(41.h),
            decoration: BoxDecoration(
              color: ColorConstant.kColorWhite,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        );
      },
    );
  }

  Future<List<ExteriorGrade>?> getExterior() async {
    if (exteriorItemList.isNotEmpty) return exteriorItemList;
    final result =
        await Locator.instance.get<CarRepo>().getExteriorGradesList();
    var data = result.fold((error) {
      return null;
    }, (data) {
      exteriorItemList = data;
      return data;
    });
    return data;
  }

  Widget registrationTextfield() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.done,
      controller: _registerNumberController,
      decoration: _buildDecoration(),
      style: fontStyle(false),
      readOnly: fromEdit ?? false,
      inputFormatters: [
        RegistrationTextFormatter(
          mask: 'xxxx xxx',
          separator: ' ',
        ),
        UpperCaseTextFormatter(),
        FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9 ]')),
      ],
      onChanged: (value) {},
      validator: (val) {
        if (val != null && val.trim().isEmpty) {
          return 'Registration number is required';
        } else if (!Validation.isValidRegistrationNumber(val)) {
          return 'Please enter valid registration number';
        }
        return null;
      },
    );
  }

  InputDecoration _buildDecoration() {
    return InputDecoration(
      hintText: enterRegistrationNumberHint,
      hintStyle: fontStyle(true),
      border: _setBorderStyle(),
      enabledBorder: _setBorderStyle(),
      focusedBorder: _setBorderStyle(),
      disabledBorder: _setBorderStyle(),
      prefixIcon: Container(
        decoration: AppDecoration.fillBlue900.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder2,
        ),
        margin: getMargin(left: 5.w, top: 5.h, right: 10.w, bottom: 5.h),
        padding: getPadding(top: 6.h, bottom: 6.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageView(
              imagePath: Assets.ukFlag,
              height: getVerticalSize(10),
              width: getHorizontalSize(16),
              margin: getMargin(bottom: 3.h),
            ),
            Text(
              ukLabel,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppTextStyle.txtInterRegular13WhiteA700,
            ),
          ],
        ),
      ),
      fillColor: ColorConstant.whiteA700,
      filled: true,
      isDense: true,
      contentPadding: getPadding(all: 10),
    );
  }

  TextStyle fontStyle(bool isHint) {
    return AppTextStyle.smallTextStyle.copyWith(
      color: isHint ? ColorConstant.kGreyColor : ColorConstant.kColor373737,
      fontSize: getFontSize(26),
      fontWeight: isHint ? FontWeight.w400 : FontWeight.w700,
    );
  }

  OutlineInputBorder _setBorderStyle() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        getHorizontalSize(5),
      ),
      borderSide: BorderSide(
        color: ColorConstant.gray30001,
      ),
    );
  }

  Widget saveCheckWorthAndSkipNow() {
    return SafeArea(
      child: Padding(
        padding: getPadding(bottom: 32.h),
        child: CustomElevatedButton(
          width: size.width,
          title: saveAndCheckWorthButton,
          onTap: () => onTapSaveCheckWorth(),
        ),
      ),
    );
  }

  Future<void> onTapSaveCheckWorth() async {
    Locator.instance.get<SharedPrefServices>().clearCarData();
    if (fromEdit ?? false) {
      Navigator.pushNamed(
        context,
        CarValuationWowScreen.routeName,
        arguments: {
          'carModel': widget.carModel,
          'fromEdit': fromEdit,
        },
      );
    } else {
      if (_formKey.currentState!.validate()) {
        if (_exteriorGradeController.text.isNotEmpty) {
          final registraionNumber =
              _registerNumberController.text.replaceAll(' ', '').trim();
          final mileage = _mileageController.text.replaceAll(',', '').trim();

          BlocProvider.of<ValuationCheckBloc>(context)
              .add(GetCarValuationDetails(
            registration: registraionNumber,
            mileage: mileage,
            exterior: exteriorItemList[selectedIndex ?? 0].percentageValue ?? 0,
          ));
        } else {
          showSnackBar(message: 'Please select exterior grade');
        }
      }
    }
  }

  ///exterior drop down
  Future<dynamic> onTapExteriorGradePopup() async {
    final value = await customPopup(
      content: ExteriorGradeDropDown(
        selectedIndex: selectedIndex,
        itemList: exteriorItemList,
      ),
    );
    if (value != null) {
      setState(() => selectedIndex = value as int);
      _exteriorGradeController.text =
          exteriorItemList[selectedIndex ?? 0].grade ?? '';
    }
  }
}
