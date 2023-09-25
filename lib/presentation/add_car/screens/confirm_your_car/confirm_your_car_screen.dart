import 'dart:developer';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:wsac/service/shared_preference_service.dart';

import '../../../../bloc/car_details/car_details_bloc.dart';
import '../../../../bloc/user/user_bloc.dart';
import '../../../../core/configurations.dart';
import '../../../../core/locator.dart';
import '../../../../model/car_model/car_hpi_and_mot.dart';
import '../../../../model/car_model/car_location.dart';
import '../../../../model/car_model/car_model.dart';
import '../../../../model/car_model/value_section_input.dart';
import '../../../../model/technical_details/technical_details.dart';
import '../../../../model/user/user_model.dart';
import '../../../../repository/car_repo.dart';
import '../../../../utility/custom_formatter.dart';
import '../../../../utility/date_time_utils.dart';
import '../../../common_widgets/common_admin_support_button.dart';
import '../../../common_widgets/common_loader.dart';
import '../../../common_widgets/common_popups.dart';
import '../../../common_widgets/field_label.dart';
import '../check_car_valuation/check_car_worth.dart';
import 'confirm_your_car_shimmer.dart';

class ConfirmYourCarScreen extends StatefulWidget {
  static const String routeName = 'confirm_you_car_screen';

  const ConfirmYourCarScreen({super.key, this.carModel, this.fromEdit = false});

  final CarModel? carModel;
  final bool? fromEdit;

  @override
  State<ConfirmYourCarScreen> createState() => _ConfirmYourCarScreenState();
}

class _ConfirmYourCarScreenState extends State<ConfirmYourCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _engineSizeController = TextEditingController();
  final SuggestionsBoxController brandNameSuggestionController =
      SuggestionsBoxController();
  final AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;
  FocusNode focusNode = FocusNode();

  //Initial dropdown
  List<ValuesSectionInput> yearOfManufactures = [];
  List<ValuesSectionInput> colours = [];
  List<ValuesSectionInput> transmissionTypes = [];
  List<ValuesSectionInput> bodyTypes = [];
  List<ValuesSectionInput> noOfDoors = [];
  List<ValuesSectionInput> fuelTypes = [];
  List<ValuesSectionInput> searchedListData = [];

  List<int> completedScreen = [];
  ValuesSectionInput? selectedBrandName;
  ValuesSectionInput? selectedYearOfManufacture;
  ValuesSectionInput? selectedColour;
  ValuesSectionInput? selectedTransmissionType;
  ValuesSectionInput? selectedBodyType;
  ValuesSectionInput? selectedNoOfDoors;
  ValuesSectionInput? selectedFuelType;
  bool isFirstLoad = true;
  bool isDataExist = false;
  bool isOneAutoResponse = false;

  @override
  void initState() {
    if (widget.carModel?.tradeValue != null &&
        widget.carModel!.tradeValue! != 0) {
      isOneAutoResponse = true;
    }
    autoPopulateData(widget.carModel);
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        isDataExist = false;
        for (var element in searchedListData) {
          if (element.name!
              .toLowerCase()
              .contains(_brandController.text.toLowerCase())) {
            isDataExist = true;
            return;
          }
        }
        if (!isDataExist) {
          _brandController.clear();
        }
      }
    });
    super.initState();
  }

  Future<List<ValuesSectionInput>> callManufacturers() async {
    final result = await Locator.instance.get<CarRepo>().getManufacturers();
    return result.fold((l) => <ValuesSectionInput>[], (r) => r);
  }

  Future<CarTechnicalDetails> getTechnicalDetails() async {
    final result =
        await Locator.instance.get<CarRepo>().getCarTechincalDetails();

    return result.fold((l) => CarTechnicalDetails(isFailed: true), (r) => r);
  }

  void autoPopulateData(CarModel? carModel) {
    if (carModel != null) {
      selectedBrandName = carModel.manufacturer;
      _brandController.text = (carModel.manufacturer?.name ?? '').toUpperCase();
      _modelController.text = carModel.model ?? '';
      selectedYearOfManufacture = ValuesSectionInput(
          id: (carModel.yearOfManufacture ?? 0).toString(),
          name: (carModel.yearOfManufacture ?? 0).toString());
      selectedColour = carModel.colour;
      selectedTransmissionType = carModel.transmissionType;
      selectedBodyType = carModel.bodyType;
      selectedNoOfDoors = ValuesSectionInput(
        id: carModel.noOfDoors.toString(),
        name: carModel.noOfDoors.toString(),
      );
      _engineSizeController.text =
          (carModel.engineSize ?? 0.0).round().toString();

      selectedFuelType = carModel.fuelType;
      widget.carModel!.hpiAndMot = carModel.hpiAndMot;
    }
  }

  void autoPopulateDropDown(CarTechnicalDetails? technicalDetails) {
    yearOfManufactures = technicalDetails?.years ?? [];
    noOfDoors = technicalDetails?.noOfDoors ?? [];
    colours = (technicalDetails?.carColors ?? [])
        .map((e) => ValuesSectionInput(id: e.id, name: e.name))
        .toList();

    transmissionTypes = (technicalDetails?.transmissionTypes ?? [])
        .map((e) => ValuesSectionInput(id: e.id, name: e.name))
        .toList();
    bodyTypes = (technicalDetails?.bodyTypes ?? [])
        .map((e) => ValuesSectionInput(id: e.id, name: e.name))
        .toList();

    fuelTypes = (technicalDetails?.fuelTypes ?? [])
        .map((e) => ValuesSectionInput(id: e.id, name: e.name))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: confirmYourCarAppBar,
      actions: const [
        AdminSupportButton(),
      ],
      body: Stack(
        children: [
          CustomImageView(
            fit: BoxFit.fill,
            alignment: Alignment.bottomCenter,
            svgPath: Assets.homeBackground,
            width: MediaQuery.of(context).size.width,
          ),
          BlocListener<CarDetailsBloc, CarDetailsState>(
            listener: (context, state) {
              if (state is CreateCarState) {
                if (state.carCreateStatus == ProviderStatus.success) {
                  Navigator.of(context).pop();
                  CarModel? car = state.car;
                  car?.hpiAndMot = widget.carModel?.hpiAndMot;
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.pop(context, {'carModel': car});
                } else if (state.carCreateStatus == ProviderStatus.error) {
                  Navigator.of(context).pop();
                  showSnackBar(message: state.errorMessage ?? '');
                } else {
                  progressDialogue();
                }
              } else if (state is UpdateCarInfoState &&
                  state.carCreateStatus == CarCreateStatus.carWorth) {
                if (state.updateCarStatus == ProviderStatus.success) {
                  Navigator.pop(context);
                  CarModel? car = state.car;
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop({'carModel': car});
                } else if (state.updateCarStatus == ProviderStatus.error) {
                  Navigator.pop(context);
                  showSnackBar(message: state.errorMessage ?? '');
                } else {
                  progressDialogue();
                }
              }
            },
            child: formWidgets(),
          ),
        ],
      ),
    );
  }

  Widget formWidgets() {
    return SafeArea(
      child: Padding(
        padding: getPadding(left: 25.w, right: 25.w, top: 15.h),
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicleDetailsTitle,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppTextStyle.txtPTSansRegular16,
                        ),
                        brandField(),
                        modelField(),
                        FutureBuilder<CarTechnicalDetails>(
                          future: getTechnicalDetails(),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              if (snap.data != null &&
                                  (snap.data?.isFailed ?? false)) {
                                delayedStart(duration: Duration.zero, () async {
                                  await infoOrThankyouPopup(
                                    title: 'Failure',
                                    subTitle: 'Bad response, tap to refresh!',
                                    onTapButton: () async {
                                      Navigator.pop(context);
                                      await getTechnicalDetails();
                                    },
                                  );
                                });
                              } else if (snap.data != null) {
                                autoPopulateDropDown(snap.data);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    yearAndEngineSize(),
                                    noOfDoorsAndFuelType(),
                                    bodyTypeDropDown(),
                                    carColorsDropDown(),
                                    transmissionTypeDropDown(),
                                  ],
                                );
                              }
                            }
                            return const CarConfirmDropDownFieldsShimmers();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            notYourCarOrConfirm(),
          ],
        ),
      ),
    );
  }

  Widget brandField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: getPadding(
            top: 16.h,
            bottom: 6.h,
          ),
          child: const FieldLabelWidget(
            label: brandNameLabel,
            isMandatory: true,
          ),
        ),
        FutureBuilder<List<ValuesSectionInput>>(
          future: callManufacturers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              searchedListData = snapshot.data!;
              return TypeAheadFormField<ValuesSectionInput>(
                autovalidateMode: autovalidateMode,
                validator: (value) {
                  if (_brandController.text.isEmpty) {
                    _brandController.clear();
                    return 'Make is required';
                  }
                  return null;
                },
                suggestionsCallback: (pattern) async {
                  if (pattern.isEmpty) {
                    return [];
                  } else {
                    final searchedList = snapshot.data!
                        .where((element) => element.name!
                            .toLowerCase()
                            .contains(pattern.toLowerCase()))
                        .toList();
                    return searchedList;
                  }
                },
                itemBuilder: (context, ValuesSectionInput itemData) {
                  return ListTile(
                    title: Text(
                      (itemData.name ?? '').toUpperCase(),
                      style: AppTextStyle.regularTextStyle.copyWith(
                        color: ColorConstant.kColorBlack,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                },
                noItemsFoundBuilder: (context) => const SizedBox(),
                loadingBuilder: (context) {
                  return SizedBox(
                    height: getVerticalSize(100),
                    child: const Center(
                      child: CircularLoader(),
                    ),
                  );
                },
                onSuggestionSelected: (ValuesSectionInput suggestion) {
                  isFirstLoad = false;
                  selectedBrandName = suggestion;
                  _brandController.text = (suggestion.name ?? '').toUpperCase();
                },
                hideKeyboardOnDrag: true,
                hideSuggestionsOnKeyboardHide: false,
                minCharsForSuggestions: 1,
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                debounceDuration: const Duration(milliseconds: 500),
                textFieldConfiguration: TextFieldConfiguration(
                  focusNode: focusNode,
                  inputFormatters: [
                    NoLeadingSpaceFormatter(),
                  ],
                  maxLength: 38,
                  textCapitalization: TextCapitalization.characters,
                  onSubmitted: (newValue) {
                    isFirstLoad = false;
                    _brandController.text = newValue;
                  },
                  decoration: commonInputDecoration.copyWith(
                    hintText: 'Enter make',
                    counterText: '',
                  ),
                  controller: _brandController,
                  style: AppTextStyle.regularTextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.kColor353333,
                  ),
                ),
                suggestionsBoxController: brandNameSuggestionController,
              );
            } else {
              return shimmerLoader(
                Container(
                  height: getVerticalSize(41.h),
                  decoration: BoxDecoration(
                    color: ColorConstant.kColorWhite,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget modelField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: getPadding(
            top: 10.h,
            bottom: 6.h,
          ),
          child: const FieldLabelWidget(
            label: modelLabel,
            isMandatory: true,
          ),
        ),
        CommonTextFormField(
          inputCharLength: 80,
          controller: _modelController,
          hint: 'Enter model',
          inputFormatters: [
            UpperCaseTextFormatter(),
          ],
          validator: (val) {
            if (val != null && val.trim().isEmpty) {
              return '$modelLabel is required';
            }
            return null;
          },
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget yearAndEngineSize() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///MANUFACTURE YEAR
        Expanded(
          child: Padding(
            padding: getPadding(top: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FieldLabelWidget(
                  label: yearDropDownLabel,
                  isMandatory: true,
                ),
                CommonDropDown(
                  isDense: true,
                  searchHintText: 'Search year',
                  selectedValue: getSelectedItem(
                    list: yearOfManufactures,
                    value: selectedYearOfManufacture,
                  ),
                  autovalidateMode: autovalidateMode,
                  validatorMsg: '$yearDropDownLabel is required',
                  hintText: selectDropdownHint,
                  margin: getMargin(top: 6.h),
                  items: yearOfManufactures,
                  onChanged: (value) {
                    selectedYearOfManufacture = value;
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 15.w),

        ///ENGINE SIZE
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: getPadding(top: 10.h, bottom: 6.h),
                child: const FieldLabelWidget(
                  label: engineSizeLabel,
                  isMandatory: true,
                ),
              ),
              CommonTextFormField(
                inputCharLength: 5,
                maxLines: 1,
                controller: _engineSizeController,
                textInputType: TextInputType.number,
                hint: 'Enter engine size',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Engine size is required';
                  }
                  return null;
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget noOfDoorsAndFuelType() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///Number of Doors
        Expanded(
          child: Padding(
            padding: getPadding(top: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FieldLabelWidget(
                  label: noOfDoorsDropDownLabel,
                  isMandatory: true,
                ),
                CommonDropDown(
                  selectedValue: getSelectedItem(
                    list: noOfDoors,
                    value: selectedNoOfDoors,
                  ),
                  autovalidateMode: autovalidateMode,
                  validatorMsg: 'Doors is required',
                  hintText: selectDropdownHint,
                  margin: getMargin(top: 6.h),
                  items: noOfDoors,
                  onChanged: (value) {
                    selectedNoOfDoors = value;
                    Locator.instance
                        .get<SharedPrefServices>()
                        .setCarDoor(value!.name!);
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 15.w),
        //FUEL TYPE
        Expanded(
          child: Padding(
            padding: getPadding(top: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FieldLabelWidget(
                  label: fuelTypeDropDownLabel,
                  isMandatory: true,
                ),
                CommonDropDown(
                  selectedValue: getSelectedItem(
                    list: fuelTypes,
                    value: selectedFuelType,
                  ),
                  autovalidateMode: autovalidateMode,
                  validatorMsg: 'Fuel type is required',
                  hintText: selectDropdownHint,
                  margin: getMargin(top: 6.h),
                  items: fuelTypes,
                  onChanged: (value) {
                    selectedFuelType = value;
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bodyTypeDropDown() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///BODY TYPE
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: getPadding(top: 10.h, bottom: 6.h),
                child: const FieldLabelWidget(
                  label: bodyTypeLabel,
                  isMandatory: true,
                ),
              ),
              CommonDropDown(
                selectedValue: getSelectedItem(
                  list: bodyTypes,
                  value: selectedBodyType,
                ),
                autovalidateMode: autovalidateMode,
                validatorMsg: 'Body type is required',
                hintText: selectDropdownHint,
                items: bodyTypes,
                onChanged: (value) {
                  selectedBodyType = value;
                  Locator.instance
                      .get<SharedPrefServices>()
                      .setCarBodyType(value!);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget transmissionTypeDropDown() {
    ///TRANSMISSION TYPE
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: getPadding(top: 10.h, bottom: 6.h),
          child: const FieldLabelWidget(
            label: transmissionLabel,
            isMandatory: true,
          ),
        ),
        CommonDropDown(
          selectedValue: getSelectedItem(
            list: transmissionTypes,
            value: selectedTransmissionType,
          ),
          autovalidateMode: autovalidateMode,
          validatorMsg: '$transmissionLabel is required',
          hintText: selectDropdownHint,
          items: transmissionTypes,
          onChanged: (value) {
            selectedTransmissionType = value;
          },
        ),
      ],
    );
  }

  Widget carColorsDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: getPadding(top: 10.h, bottom: 6.h),
          child: const FieldLabelWidget(
            label: colorDropDownLabel,
            isMandatory: true,
          ),
        ),
        CommonDropDown(
          selectedValue: getSelectedItem(
            list: colours,
            value: selectedColour,
          ),
          autovalidateMode: autovalidateMode,
          validatorMsg: '$colorDropDownLabel is required',
          hintText: selectDropdownHint,
          items: colours,
          onChanged: (value) {
            selectedColour = value;
          },
        ),
      ],
    );
  }

  ValuesSectionInput? getSelectedItem(
      {required List<ValuesSectionInput> list,
      required ValuesSectionInput? value}) {
    List<ValuesSectionInput> item = list
        .where((element) =>
            (element.id ?? '').toLowerCase() == (value?.id ?? '').toLowerCase())
        .toList();

    return item.isNotEmpty ? item.first : null;
  }

  Widget notYourCarOrConfirm() {
    return Padding(
      padding: getPadding(top: 12.h, bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((isOneAutoResponse) && !(widget.fromEdit ?? false))
            GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  CheckCarWorthScreen.routeName,
                  (route) => true,
                );
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: notYourCarLabel,
                      style: AppTextStyle.smallTextStyle.copyWith(
                        color: ColorConstant.kColor353333,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: ' \n',
                      style: AppTextStyle.smallTextStyle.copyWith(
                        color: ColorConstant.kColor353333,
                      ),
                    ),
                    TextSpan(
                      text: reEnterYourRegistrationLabel,
                      style: AppTextStyle.smallTextStyle.copyWith(
                        color: ColorConstant.kColor7C7C7C,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ),
          Padding(
            padding: getPadding(top: 17.h),
            child: CustomElevatedButton(
              title: confirmButton,
              onTap: () => createCar(),
            ),
          )
        ],
      ),
    );
  }

  Widget shimmerDropDown({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: getPadding(top: 10.h, bottom: 6.h),
          child: FieldLabelWidget(
            label: label,
            isMandatory: true,
          ),
        ),
        shimmerLoader(
          Container(
            height: getVerticalSize(41.h),
            decoration: BoxDecoration(
              color: ColorConstant.kColorWhite,
              borderRadius: BorderRadius.circular(25.r),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> createCar() async {
    if (_formKey.currentState!.validate()) {
      UserModel? user = context.read<UserBloc>().currentUser;
      widget.carModel!.engineSize = double.parse(_engineSizeController.text);

      if (widget.carModel?.hpiAndMot != null) {
        widget.carModel!.hpiAndMot!.keeperStartDate =
            widget.carModel?.hpiAndMot?.keeperStartDate != null
                ? customDateFormat(
                    convertStringToDateTime(
                      widget.carModel!.hpiAndMot!.keeperStartDate!,
                      isAWSDateFormat: true,
                    )!,
                    isUtc: true,
                  )
                : null;
        widget.carModel!.hpiAndMot!.lastMotDate =
            widget.carModel?.hpiAndMot?.lastMotDate != null
                ? customDateFormat(
                    convertStringToDateTime(
                      widget.carModel!.hpiAndMot!.lastMotDate!,
                      isAWSDateFormat: true,
                    )!,
                    isUtc: true,
                  )
                : null;
        widget.carModel!.hpiAndMot!.firstRegisted =
            widget.carModel?.hpiAndMot?.firstRegisted != null
                ? customDateFormat(
                    convertStringToDateTime(
                      widget.carModel!.hpiAndMot!.firstRegisted!,
                      isAWSDateFormat: true,
                    )!,
                    isUtc: true,
                  )
                : null;
      } else {
        widget.carModel!.hpiAndMot = HpiAndMot(
            keeperStartDate: widget.carModel?.hpiAndMot?.keeperStartDate != null
                ? customDateFormat(
                    convertStringToDateTime(
                      widget.carModel!.hpiAndMot!.keeperStartDate!,
                      isAWSDateFormat: true,
                    )!,
                    isUtc: true,
                  )
                : null,
            lastMotDate: widget.carModel?.hpiAndMot?.lastMotDate != null
                ? customDateFormat(
                    convertStringToDateTime(
                      widget.carModel!.hpiAndMot!.lastMotDate!,
                      isAWSDateFormat: true,
                    )!,
                    isUtc: true,
                  )
                : null,
            firstRegisted: widget.carModel?.hpiAndMot?.firstRegisted != null
                ? customDateFormat(
                    convertStringToDateTime(
                      widget.carModel!.hpiAndMot!.firstRegisted!,
                      isAWSDateFormat: true,
                    )!,
                    isUtc: true,
                  )
                : null);
      }
      widget.carModel!.fuelType = selectedFuelType;
      if (user?.userLocation != null) {
        widget.carModel!.carLocation = CarLocation(
            coordinates: user?.userLocation?.coordinates ?? [],
            type: user?.userLocation?.type ?? '');
      }
      widget.carModel!.model = _modelController.text.trim();
      widget.carModel!.noOfDoors = selectedNoOfDoors?.name != null
          ? int.parse(selectedNoOfDoors!.name!)
          : 0;
      widget.carModel!.yearOfManufacture =
          int.parse(selectedYearOfManufacture?.name ?? '');
      widget.carModel!.colour = selectedColour;
      widget.carModel!.transmissionType = selectedTransmissionType;
      widget.carModel!.bodyType = selectedBodyType;
      widget.carModel!.ownerUserName = user!.userName;
      widget.carModel!.ownerProfileImage = user.avatarImage;
      if (selectedBrandName != null) {
        widget.carModel!.manufacturer = selectedBrandName;
      } else {
        widget.carModel!.manufacturer = ValuesSectionInput(
          id: _brandController.text,
          name: _brandController.text,
        );
      }
      widget.carModel!.userType = user.userType;
      widget.carModel!.userId = user.userId;
      List<String> createStatus = widget.carModel?.createStatus ?? [];
      createStatus.add(convertEnumToString(CarCreateStatus.carWorth));

      if (widget.fromEdit ?? false) {
        final Map<String, dynamic> carinfojson = {
          '_id': widget.carModel!.id,
          'createStatus': createStatus.toSet().toList(),
          'addedAccessories': widget.carModel!.addedAccessories!.toJson(),
          'manufacturer': widget.carModel!.manufacturer!.toJson(),
          'userExpectedValue': widget.carModel!.userExpectedValue,
          'quickSale': widget.carModel!.quickSale,
          'engineSize': widget.carModel!.engineSize,
          'hpiAndMot': widget.carModel!.hpiAndMot!.toJson(),
          'fuelType': widget.carModel!.fuelType!.toJson(),
          'bodyType': widget.carModel!.bodyType!.toJson(),
          'model': widget.carModel!.model,
          'yearOfManufacture': widget.carModel!.yearOfManufacture!,
          'colour': widget.carModel!.colour!.toJson(),
          'transmissionType': widget.carModel!.transmissionType!.toJson(),
          'doors': widget.carModel!.noOfDoors,
        };
        log(carinfojson.toString());
        BlocProvider.of<CarDetailsBloc>(context).add(
          UpdateCarInfoEvent(
            carInfoData: carinfojson,
            carCreateStatus: CarCreateStatus.carWorth,
          ),
        );
      } else {
        final Map<String, dynamic> carinfojson = {
          'registration': widget.carModel!.registration,
          'mileage': widget.carModel!.mileage,
          'exteriorGrade': widget.carModel!.exteriorGrade!.toJson(),
          'userType': widget.carModel!.userType,
          'userId': widget.carModel!.userId,
          'createStatus': createStatus.toSet().toList(),
          'carLocation':
              widget.carModel?.carLocation?.toJson() ?? <String, dynamic>{},
          'tradeValue': widget.carModel!.tradeValue ?? 0,
          'wsacValue': widget.carModel!.wsacValue,
          'addedAccessories': widget.carModel!.addedAccessories!.toJson(),
          'manufacturer': widget.carModel!.manufacturer!.toJson(),
          'additionalInformation':
              widget.carModel?.additionalInformation?.toJson() ??
                  <String, dynamic>{},
          'ownerProfileImage': widget.carModel!.ownerProfileImage,
          'ownerUserName': widget.carModel!.ownerUserName,
          'userRating': widget.carModel?.userRating ?? 0.0,
          'userExpectedValue': widget.carModel!.userExpectedValue,
          'quickSale': widget.carModel!.quickSale,
          'engineSize': widget.carModel!.engineSize,
          'hpiAndMot': widget.carModel?.hpiAndMot != null
              ? widget.carModel!.hpiAndMot!.toJson()
              : null,
          'fuelType': widget.carModel!.fuelType!.toJson(),
          'bodyType': widget.carModel!.bodyType!.toJson(),
          'model': widget.carModel!.model,
          'yearOfManufacture': widget.carModel!.yearOfManufacture!,
          'colour': widget.carModel!.colour!.toJson(),
          'transmissionType': widget.carModel!.transmissionType!.toJson(),
          'doors': widget.carModel!.noOfDoors,
        };
        log(carinfojson.toString());
        BlocProvider.of<CarDetailsBloc>(context)
            .add(CreateCarEvent(carInfoData: carinfojson));
      }
    }
  }
}
