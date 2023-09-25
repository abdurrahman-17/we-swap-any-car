import 'package:flutter/services.dart';

import '../../../bloc/car_details/car_details_bloc.dart';
import '../../../core/configurations.dart';
import '../../../model/car_detail_model/hpi_history_result_model.dart';
import '../../../model/car_model/car_hpi_history_check.dart';
import '../../../model/car_model/car_model.dart';
import '../../../model/car_model/value_section_input.dart';
import '../../../utility/custom_formatter.dart';
import '../../../utility/date_time_utils.dart';
import '../../common_popup_widget/hpi_history_check_popup.dart';
import '../../common_widgets/common_admin_support_button.dart';
import '../../common_widgets/common_loader.dart';
import '../../common_widgets/common_popups.dart';
import '../../common_widgets/field_label.dart';

class HPIAndMOTScreen extends StatefulWidget {
  static const String routeName = 'hpi_and_mot_screen';
  const HPIAndMOTScreen({
    Key? key,
    this.carModel,
  }) : super(key: key);
  final CarModel? carModel;

  @override
  State<HPIAndMOTScreen> createState() => _HPIAndMOTScreenState();
}

class _HPIAndMOTScreenState extends State<HPIAndMOTScreen> {
  final TextEditingController hpiHistoryCheckedController =
      TextEditingController();
  final TextEditingController vinController = TextEditingController();
  final TextEditingController firstRegisteredController =
      TextEditingController();
  final TextEditingController keeperStartDateController =
      TextEditingController();
  final TextEditingController lastMotController = TextEditingController();
  ValuesSectionInput? selectedPreOwner;
  ValuesSectionInput? noOfKeys;
  ValuesSectionInput? onFinance;
  ValuesSectionInput? privatePlate;
  ValuesSectionInput? keepingPlate;
  HPIHistoryCheck? historyCheck;
  GlobalKey<FormState> formKey = GlobalKey();
  bool hpiHasWarnings = false;
  bool onFinanceDisable = false;
  bool sellerKeepingPlateDisable = false;
  bool isOneAutoResponse = false;

  void autoPopulateData() {
    if (widget.carModel?.hpiAndMot != null) {
      final hpiAndMot = widget.carModel!.hpiAndMot!;
      if (hpiAndMot.vin != null) {
        vinController.text = hpiAndMot.vin ?? '';
      }
      if (hpiAndMot.keeperStartDate != null &&
          hpiAndMot.keeperStartDate!.isNotEmpty) {
        final DateTime dateTime =
            convertStringToDateTime(hpiAndMot.keeperStartDate!)!;
        keeperStartDateController.text = customDateFormat(dateTime);
      }
      if (hpiAndMot.firstRegisted != null &&
          hpiAndMot.firstRegisted!.isNotEmpty) {
        final DateTime dateTime =
            convertStringToDateTime(hpiAndMot.firstRegisted!)!;
        firstRegisteredController.text = customDateFormat(dateTime);
      }
      if (hpiAndMot.lastMotDate != null && hpiAndMot.lastMotDate!.isNotEmpty) {
        final DateTime dateTime =
            convertStringToDateTime(hpiAndMot.lastMotDate!)!;
        lastMotController.text = customDateFormat(dateTime);
      }
      if (hpiAndMot.historyCheck != null) {
        historyCheck = hpiAndMot.historyCheck;
      }
      if (hpiAndMot.isPreOwnerNotDisclosed ?? false) {
        selectedPreOwner = ValuesSectionInput(
          id: "-1",
          name: "Not Disclosed",
        );
      } else if (hpiAndMot.previousOwner != null) {
        selectedPreOwner = ValuesSectionInput(
          id: hpiAndMot.previousOwner.toString(),
          name: hpiAndMot.previousOwner.toString(),
        );
      }
      if (hpiAndMot.numberOfKeys != null) {
        noOfKeys = ValuesSectionInput(
          id: hpiAndMot.numberOfKeys.toString(),
          name: hpiAndMot.numberOfKeys.toString(),
        );
      }
      if (hpiAndMot.onFinance != null && hpiAndMot.onFinance!.isNotEmpty) {
        onFinanceDisable = isDisbaled(hpiAndMot.onFinance == 'Yes');
        onFinance = ValuesSectionInput(
          id: hpiAndMot.onFinance,
          name: hpiAndMot.onFinance,
        );
      } else {
        onFinanceDisable = true;
      }
      if (hpiAndMot.privatePlate != null) {
        if (!(hpiAndMot.privatePlate ?? false)) {
          sellerKeepingPlateDisable = true;
        }
        privatePlate = ValuesSectionInput(
          id: hpiAndMot.privatePlate! ? 'Yes' : 'No',
          name: hpiAndMot.privatePlate! ? 'Yes' : 'No',
        );
      }
      if (hpiAndMot.sellerKeepingPlate != null) {
        keepingPlate = ValuesSectionInput(
          id: hpiAndMot.sellerKeepingPlate! ? 'Yes' : 'No',
          name: hpiAndMot.sellerKeepingPlate! ? 'Yes' : 'No',
        );
      }
    }
  }

  bool isDisbaled(bool dataIsAvail) => isOneAutoResponse && dataIsAvail;

  @override
  void initState() {
    if (widget.carModel?.tradeValue != null &&
        widget.carModel!.tradeValue! != 0) {
      isOneAutoResponse = true;
    }
    autoPopulateData();
    super.initState();
  }

  List<HPIHistoryResultModel> get fetchInitialHpiHistoryCheck =>
      hpiCheckContents
          .map((entry) => HPIHistoryResultModel(message: entry))
          .toList();

  Future<List<HPIHistoryResultModel>> getHpiHistoryIssues() async {
    final HPIHistoryCheck? resultModel =
        widget.carModel?.hpiAndMot?.historyCheck;

    final List<HPIHistoryResultModel> tempHpiHistoryCheck =
        fetchInitialHpiHistoryCheck;
    tempHpiHistoryCheck[0].result = resultModel?.cherishedDataQty;
    tempHpiHistoryCheck[1].result = resultModel?.colourChangesQty;
    tempHpiHistoryCheck[2].result = resultModel?.conditionDataQty;
    tempHpiHistoryCheck[3].result = resultModel?.financeDataQty;
    tempHpiHistoryCheck[4].result = resultModel?.highRiskDataQty;
    tempHpiHistoryCheck[5].result =
        ((resultModel?.keeperChangesQty ?? 0) > 0) ? true : false;
    tempHpiHistoryCheck[6].result = resultModel?.stolenVehicleDataQty;
    tempHpiHistoryCheck[7].result = resultModel?.isScrapped;

    //Warning counts
    return await setHistoryCheck(hpiHistoryCheckResult: tempHpiHistoryCheck);
  }

  Future<List<HPIHistoryResultModel>> setHistoryCheck(
      {required List<HPIHistoryResultModel> hpiHistoryCheckResult}) async {
    final warningList =
        hpiHistoryCheckResult.where((e) => (e.result ?? false)).toList();
    if (warningList.isNotEmpty &&
        warningList.length <= hpiHistoryCheckResult.length) {
      hpiHistoryCheckedController.text = (warningList.length == 1)
          ? widget.carModel!.userType == convertEnumToString(UserType.private)
              ? carHpiHistoryAIssue
              : carHpiHistoryAMarker
          : widget.carModel!.userType == convertEnumToString(UserType.private)
              ? carHpiHistoryAreIssues
              : carHpiHistoryAreMarkers;
      hpiHasWarnings = true;
    } else {
      hpiHistoryCheckedController.text = carHpiHistoryAllClear;
    }
    return warningList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarDetailsBloc, CarDetailsState>(
      listener: (context, state) {
        if (state is UpdateCarInfoState &&
            state.carCreateStatus == CarCreateStatus.hpiAndMot) {
          if (state.updateCarStatus == ProviderStatus.success) {
            Navigator.pop(context);
            CarModel? car = state.car;
            Navigator.of(context).pop({'carModel': car});
          } else if (state.updateCarStatus == ProviderStatus.error) {
            Navigator.pop(context);
            showSnackBar(message: state.errorMessage ?? '');
          } else {
            progressDialogue();
          }
        }
      },
      child: CustomScaffold(
        title: hpiAndMotAppBar,
        backWidget: const SizedBox(),
        actions: const [
          AdminSupportButton(),
        ],
        body: Stack(
          children: [
            CustomImageView(
              width: MediaQuery.of(context).size.width,
              svgPath: Assets.homeBackground,
              alignment: Alignment.bottomCenter,
              fit: BoxFit.fill,
            ),
            SafeArea(
              child: Padding(
                padding: getPadding(left: 25.w, right: 25.w, top: 15.h),
                child: Column(
                  children: [
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: SingleChildScrollView(
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                hpiDetailsWidget(),
                                SizedBox(height: 20.h),
                                motDetailsWidget(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              title: backButton,
                              onTap: () => Navigator.of(context).pop(),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: GradientElevatedButton(
                              title: saveButton,
                              onTap: () => onTapSave(),
                            ),
                          )
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
    );
  }

  Widget hpiDetailsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hpiHistoryDetails,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: AppTextStyle.txtPTSansRegular16.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (isOneAutoResponse)
          Padding(
            padding: getPadding(top: 20.h, bottom: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FieldLabelWidget(label: hpiHistoryCheck),
                FutureBuilder<List<HPIHistoryResultModel>>(
                  future: getHpiHistoryIssues(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: getPadding(top: 6.h),
                        child: CommonTextFormField(
                          maxLines: 1,
                          suffixIcon: hpiHasWarnings
                              ? IconButton(
                                  icon: Icon(
                                    Icons.warning_rounded,
                                    color: ColorConstant.kColorEACE76,
                                    size: getSize(20),
                                  ),
                                  onPressed: () {
                                    onTapHistoryInfo(snapshot.data);
                                  },
                                )
                              : null,
                          controller: hpiHistoryCheckedController,
                          hint: selectDropdownHint,
                          readOnly: true,
                        ),
                      );
                    }
                    return shimmerLoader(
                      Container(
                        height: getVerticalSize(41.h),
                        margin: getMargin(top: 6.h),
                        decoration: BoxDecoration(
                          color: ColorConstant.kColorWhite,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        const FieldLabelWidget(
          isMandatory: true,
          label: hpiVin,
        ),
        Padding(
          padding: EdgeInsets.only(top: 6.h, bottom: 10.h),
          child: CommonTextFormField(
            inputFormatters: [
              UpperCaseTextFormatter(),
              FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
            ],
            textCapitalization: TextCapitalization.characters,
            controller: vinController,
            readOnly: true,
            inputCharLength: 30,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            fieldWithLabel(
              ignoring: true,
              isDate: true,
              label: hpiKeeperStart,
              controller: keeperStartDateController,
            ),
            SizedBox(width: 14.w),
            fieldWithLabel(
              ignoring: true,
              isDate: true,
              label: hpiFirstRegistered,
              controller: firstRegisteredController,
            ),
          ],
        ),
      ],
    );
  }

  Widget motDetailsWidget() {
    List<ValuesSectionInput> preOwnerItems = [
      if (widget.carModel?.hpiAndMot?.previousOwner != null)
        ValuesSectionInput(
          id: widget.carModel?.hpiAndMot?.previousOwner.toString(),
          name: widget.carModel?.hpiAndMot?.previousOwner.toString(),
        ),
      ValuesSectionInput(
        id: "-1",
        name: "Not Disclosed",
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          motDetailsLabel,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: AppTextStyle.txtPTSansRegular16.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: getPadding(top: 20.h),
          child: const FieldLabelWidget(
            isMandatory: true,
            label: lastMotDateLabel,
          ),
        ),

        ///LAST MOT
        Padding(
          padding: getPadding(top: 6.h),
          child: IgnorePointer(
            child: CommonTextFormField(
              maxLines: 1,
              // suffixIcon: IconButton(
              //   icon: CustomImageView(
              //     svgPath: Assets.calendar,
              //     height: getSize(16),
              //     width: getSize(16),
              //   ),
              //   onPressed: () {
              //     onTapOpenDatePicker(
              //       context,
              //       lastMotController,
              //     );
              //   },
              // ),
              controller: lastMotController,
            ),
          ),
        ),
        Padding(
          padding: getPadding(top: 10.h, bottom: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///PRE OWNER
              fieldWithLabel(
                label: previousOwnerLabel,
                dropdownItems: preOwnerItems,
                selectedValue: getSelectedItem(
                  list: preOwnerItems,
                  value: selectedPreOwner,
                ),
                validationString: 'Prev. owners is required',
                onChanged: (val) {
                  selectedPreOwner = val;
                },
              ),
              SizedBox(width: 14.w),

              ///KEYS
              fieldWithLabel(
                label: noOfKeysLabel,
                dropdownItems: numbersSelectableList,
                selectedValue: getSelectedItem(
                  list: numbersSelectableList,
                  value: noOfKeys,
                ),
                validationString: 'No. of keys is required',
                onChanged: (val) {
                  noOfKeys = val;
                },
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            fieldWithLabel(
              hint: false,
              ignoring: onFinanceDisable,
              label: onFinanaceLabel,
              dropdownItems: yesNoSelectableList,
              selectedValue: getSelectedItem(
                list: yesNoSelectableList,
                value: onFinance,
              ),
              onChanged: (val) {
                onFinance = val;
              },
            ),
            SizedBox(width: 14.w),
            fieldWithLabel(
              label: privatePlateLabel,
              dropdownItems: yesNoSelectableList,
              selectedValue: getSelectedItem(
                list: yesNoSelectableList,
                value: privatePlate,
              ),
              validationString: 'Private plate is required',
              onChanged: (val) {
                privatePlate = val;
                if (val != null && val.name == 'Yes') {
                  sellerKeepingPlateDisable = false;
                  keepingPlate = null;
                } else {
                  sellerKeepingPlateDisable = true;
                  keepingPlate = yesNoSelectableList[1];
                }
                setState(() {});
              },
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: getPadding(top: 11.h),
              child: const FieldLabelWidget(
                isMandatory: true,
                label: sellerKeepingPlateLabel,
              ),
            ),
            IgnorePointer(
              ignoring: sellerKeepingPlateDisable,
              child: CommonDropDown(
                selectedValue: getSelectedItem(
                  list: yesNoSelectableList,
                  value: keepingPlate,
                ),
                hintText: selectDropdownHint,
                width: double.infinity,
                margin: getMargin(top: 6.h),
                items: yesNoSelectableList,
                onChanged: (val) {
                  keepingPlate = val;
                },
                validatorMsg: 'Seller keeping private plate is required',
              ),
            ),
          ],
        ),
        SizedBox(height: 35.h)
      ],
    );
  }

  ValuesSectionInput? getSelectedItem(
      {required List<ValuesSectionInput> list,
      required ValuesSectionInput? value}) {
    List<ValuesSectionInput> item =
        list.where((element) => element.id == value?.id).toList();

    return item.isNotEmpty ? item.first : null;
  }

  Widget fieldWithLabel({
    bool ignoring = false,
    bool hint = true,
    required String label,
    List<ValuesSectionInput>? dropdownItems,
    bool isDate = false,
    ValuesSectionInput? selectedValue,
    TextEditingController? controller,
    ValueChanged<ValuesSectionInput?>? onChanged,
    String? validationString,
    String? Function(String?)? textFieldValidator,
  }) {
    return Expanded(
      child: IgnorePointer(
        ignoring: ignoring,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldLabelWidget(
              label: label,
              isMandatory: true,
            ),
            dropdownItems != null && dropdownItems.isNotEmpty
                ? CommonDropDown(
                    selectedValue: selectedValue,
                    hintText: hint ? selectDropdownHint : null,
                    width: double.infinity,
                    margin: getMargin(top: 6.h),
                    items: dropdownItems,
                    onChanged: onChanged,
                    validatorMsg: validationString,
                  )
                : Padding(
                    padding: getPadding(top: 6.h),
                    child: CommonTextFormField(
                      maxLines: 1,
                      suffixIcon: isDate && !ignoring
                          ? IconButton(
                              icon: CustomImageView(
                                svgPath: Assets.calendar,
                                height: getSize(16),
                                width: getSize(16),
                              ),
                              onPressed: () {
                                onTapOpenDatePicker(context, controller!);
                              },
                            )
                          : const SizedBox(),
                      controller: controller!,
                      validator: textFieldValidator ?? (val) => null,
                      readOnly: isDate,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  ///add extra items popup
  Future<void> onTapHistoryInfo(
      List<HPIHistoryResultModel>? hpiHistoryCheckPoints) async {
    await customPopup(
      barrierDismissible: false,
      content: HpiHistoryCheckPopup(
        hpiHistoryCheckPoints: hpiHistoryCheckPoints ?? [],
      ),
    );
  }

  Future<void> onTapOpenDatePicker(
      BuildContext context, TextEditingController controller) async {
    DateTime? initialDate;
    if (controller.text.isNotEmpty) {
      initialDate = convertStringToDateTime(controller.text, isStandard: true);
    }
    showCommonDatePicker(
      initialDate: initialDate,
      firstDate: DateTime(1920),
      lastDate: getCurrentDateTime(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      if (controller == firstRegisteredController) {
        setState(() {
          firstRegisteredController.text = customDateFormat(pickedDate);
        });
      } else if (controller == keeperStartDateController) {
        setState(() {
          keeperStartDateController.text = customDateFormat(pickedDate);
        });
      } else if (controller == lastMotController) {
        setState(() {
          lastMotController.text = customDateFormat(pickedDate);
        });
      }
    });
  }

  void onTapSave() {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      List<String> createStatus = widget.carModel?.createStatus ?? [];
      createStatus.add(convertEnumToString(CarCreateStatus.hpiAndMot));
      BlocProvider.of<CarDetailsBloc>(context).add(
        UpdateCarInfoEvent(
          carInfoData: {
            '_id': widget.carModel?.id,
            'createStatus': createStatus.toSet().toList(),
            'hpiAndMot': {
              if (historyCheck != null) 'historyCheck': historyCheck!.toJson(),
              if (vinController.text.isNotEmpty)
                'vin': vinController.text.trim(),
              if (keeperStartDateController.text.isNotEmpty)
                'keeperStartDate': customDateFormat(
                    convertStringToDateTime(keeperStartDateController.text,
                        isStandard: true)!,
                    isUtc: true),
              if (firstRegisteredController.text.isNotEmpty)
                'firstRegisted': customDateFormat(
                    convertStringToDateTime(firstRegisteredController.text,
                        isStandard: true)!,
                    isUtc: true),
              if (lastMotController.text.isNotEmpty)
                'lastMotDate': customDateFormat(
                    convertStringToDateTime(lastMotController.text,
                        isStandard: true)!,
                    isUtc: true),
              'previousOwner': widget.carModel?.hpiAndMot?.previousOwner,
              'isPreOwnerNotDisclosed':
                  selectedPreOwner?.id == '-1' ? true : false,
              'numberOfKeys': noOfKeys!.name,
              if (onFinance != null) 'onFinance': onFinance!.name,
              'privatePlate': privatePlate!.name == 'Yes' ? true : false,
              'sellerKeepingPlate': keepingPlate!.name == 'Yes' ? true : false,
            }
          },
          carCreateStatus: CarCreateStatus.hpiAndMot,
        ),
      );
    }
  }
}
