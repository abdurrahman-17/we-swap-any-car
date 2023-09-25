import 'dart:async';

import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../bloc/user/user_bloc.dart';
import '../../../core/locator.dart';
import '../../../core/configurations.dart';
import '../../../main.dart';
import '../../../model/car_model/value_section_input.dart';
import '../../../model/technical_details/manufacturer.dart';
import '../../../model/user/user_model.dart';
import '../../../repository/car_repo.dart';
import '../../../utility/common_keys.dart' as key;
import '../../../utility/custom_formatter.dart';
import '../../../utility/date_time_utils.dart';
import '../../common_widgets/common_divider.dart';
import '../../common_widgets/common_expansion_tile.dart';
import '../../common_widgets/common_loader.dart';
import '../../common_widgets/custom_checkbox.dart';
import '../../common_widgets/custom_radio_button.dart';
import '../../common_widgets/custom_range_slider.dart';

Future<dynamic> filterLikedCarBottomSheet(Map<String, dynamic> filterData) {
  return showModalBottomSheet(
    isDismissible: true,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.85),
    backgroundColor: ColorConstant.kBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
    ),
    context: globalNavigatorKey.currentContext!,
    builder: (context) =>
        LikedCarsFilterBottomSheetWidget(filterData: filterData),
  );
}

class LikedCarsFilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> filterData;
  const LikedCarsFilterBottomSheetWidget({
    Key? key,
    required this.filterData,
  }) : super(key: key);

  @override
  State<LikedCarsFilterBottomSheetWidget> createState() =>
      _LikedCarsFilterBottomSheetWidgetState();
}

class _LikedCarsFilterBottomSheetWidgetState
    extends State<LikedCarsFilterBottomSheetWidget> {
  List<ValuesSectionInput> bodyTypes = [];
  List<ValuesSectionInput> fuelTypes = [];
  List<ValuesSectionInput> transmissionTypes = [];
  //selected
  List<ValuesSectionInput> selectedBodyTypes = [];
  List<Manufacturers> selectedManufacturers = [];
  List<BrandModel> selectedModels = [];
  List<ValuesSectionInput> selectedTransmissionTypes = [];
  List<ValuesSectionInput> selectedFuelsTypes = [];
  String selectedUserTypeItem = convertEnumToString(FilterUserTypes.none);

  late double selectedStartYear;
  late double selectedEndYear;

  double initialStartYear = 1950;
  double initialEndYear = getCurrentDateTime().year.toDouble();

  double priceStart = 100;
  double priceEnd = 1000000;

  ValuesSectionInput? selectedPriceRangeValue;
  bool isAnimationCompleted = false;

  int selectedIndex = -1;
  late UserModel? currentUserData;
  final TextEditingController _makeSearchController = TextEditingController();
  final SuggestionsBoxController makeNamesSuggestionController =
      SuggestionsBoxController();

  //Make Model Search
  bool isModelFirstLoad = true;
  final TextEditingController _modelSearchController = TextEditingController();
  final SuggestionsBoxController modelsSuggestionController =
      SuggestionsBoxController();

  ///collapse or expand- expansion tile
  void collapseOrExpand({required bool newState, required int index}) {
    if (newState) {
      selectedIndex = index;
    } else {
      selectedIndex = -1;
    }
    setState(() {});
  }

  Future<void> getTechnicalDetails() async {
    final result =
        await Locator.instance.get<CarRepo>().getCarTechincalDetails();
    return result.fold((l) => null, (technicalDetails) {
      bodyTypes = (technicalDetails.bodyTypes ?? [])
          .map((e) => ValuesSectionInput(id: e.id, name: e.name))
          .toList();
      transmissionTypes = (technicalDetails.transmissionTypes ?? [])
          .map((e) => ValuesSectionInput(id: e.id, name: e.name))
          .toList();
      fuelTypes = (technicalDetails.fuelTypes ?? [])
          .map((e) => ValuesSectionInput(id: e.id, name: e.name))
          .toList();
      setState(() {});
    });
  }

  @override
  void initState() {
    getTechnicalDetails();
    if (widget.filterData.isNotEmpty) {
      populateData(widget.filterData);
    } else {
      selectedStartYear = initialStartYear;
      selectedEndYear = initialEndYear;
    }
    currentUserData = context.read<UserBloc>().currentUser;
    //initial item selection for new price range drop down .
    for (var item in priceRangeList) {
      if (item.id == ("${priceStart.truncate()}-${priceEnd.truncate()}")) {
        selectedPriceRangeValue = item;
      }
    }
    delayForCompleteAnimation();
    super.initState();
  }

  void delayForCompleteAnimation() {
    Timer(const Duration(milliseconds: 2150), () {
      setState(() {
        isAnimationCompleted = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.7,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, controller) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  child: Padding(
                    padding: getPadding(left: 30, right: 30, top: 35),
                    child: Column(
                      children: [
                        makeFilter(),
                        CommonDivider(color: ColorConstant.kColorCECECE),
                        bodyTypeFilter(),
                        CommonDivider(color: ColorConstant.kColorCECECE),
                        yearFilter(),
                        CommonDivider(color: ColorConstant.kColorCECECE),
                        newPriceFilter(),
                        CommonDivider(color: ColorConstant.kColorCECECE),
                        transmissionFilter(),
                        CommonDivider(color: ColorConstant.kColorCECECE),
                        fuelTypeFilter(),
                        CommonDivider(color: ColorConstant.kColorCECECE),
                        userTypeFilter(),
                        CommonDivider(color: ColorConstant.kColorCECECE),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: getPadding(
                    top: 10.h, left: 20.w, right: 20.w, bottom: 15.h),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        height: 43.h,
                        title: resetFilterButton.toUpperCase(),
                        onTap: () {
                          Navigator.pop(context, const <String, dynamic>{});
                        },
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: GradientElevatedButton(
                        height: 40.h,
                        title: applyButton.toUpperCase(),
                        onTap: () {
                          onTapApply();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget makeFilter() {
    return FilterExpansionTile(
      initiallyExpanded: selectedIndex == 0,
      locationIndex: 3,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 0);
      },
      title: makeModelLabel,
      subTitle: youCanSelectMultipleBrand,
      children: Column(
        children: [
          searchMakeField(),
          if (selectedManufacturers.isEmpty)
            Text(
              note + noteCantGetModelsWithoutSelectMake,
              style: AppTextStyle.txtPTSansRegular12Gray600,
            ),
          if (selectedManufacturers.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedManufacturers.length,
              separatorBuilder: (context, index) => const CommonDivider(),
              itemBuilder: (_, int index) {
                final item = selectedManufacturers[index];
                return CustomCheckboxWithLabel(
                  isRemove: true,
                  label: item.name ?? '',
                  value: selectedManufacturers.contains(item),
                  onChanged: (_) {
                    if (selectedManufacturers.contains(item)) {
                      selectedManufacturers.remove(item);
                      selectedModels.removeWhere(
                          (element) => item.brandModels!.contains(element));
                    } else {
                      selectedManufacturers.add(item);
                    }

                    setState(() {});
                  },
                );
              },
            ),
          if (selectedManufacturers.isNotEmpty)
            Column(
              children: [
                const CommonDivider(),
                searchModelField(),
                if (selectedModels.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: selectedModels.length,
                    padding: getPadding(bottom: 15.h),
                    separatorBuilder: (context, index) => const CommonDivider(),
                    itemBuilder: (_, int index) {
                      final item = selectedModels[index];
                      return CustomCheckboxWithLabel(
                        isRemove: true,
                        label: item.name ?? '',
                        value: selectedModels.contains(item),
                        onChanged: (_) {
                          if (selectedModels.contains(item)) {
                            selectedModels.remove(item);
                          } else {
                            selectedModels.add(item);
                          }
                          setState(() {});
                        },
                      );
                    },
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget searchMakeField() {
    return Padding(
      padding: getPadding(top: 8.h, bottom: 8.h),
      child: TypeAheadFormField<Manufacturers>(
        validator: (value) => null,
        suggestionsCallback: (pattern) async {
          if (pattern.isEmpty) {
            return [];
          } else {
            final result = await Locator.instance
                .get<CarRepo>()
                .getManufacturersWithmodels();
            return result.fold((l) => <Manufacturers>[], (r) {
              final searchedList = r
                  .where((element) => element.name!
                      .toLowerCase()
                      .contains(pattern.toLowerCase()))
                  .toList();
              return searchedList;
            });
          }
        },
        itemBuilder: (context, Manufacturers itemData) {
          return ListTile(
            title: Text(itemData.name ?? ''),
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
        onSuggestionSelected: (Manufacturers suggestion) {
          if (selectedManufacturers
              .where((element) => element.id == suggestion.id)
              .isEmpty) {
            selectedManufacturers.add(suggestion);
          }
          _makeSearchController.clear();
          _modelSearchController.clear();
          setState(() {});
        },
        hideKeyboardOnDrag: true,
        hideSuggestionsOnKeyboardHide: false,
        minCharsForSuggestions: 1,
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
        ),
        debounceDuration: const Duration(milliseconds: 500),
        textFieldConfiguration: TextFieldConfiguration(
          inputFormatters: [
            NoLeadingSpaceFormatter(),
          ],
          textCapitalization: TextCapitalization.characters,
          onSubmitted: (newValue) {},
          decoration: commonInputDecoration.copyWith(
            hintText:
                textFieldLabelSearchTheText + brandNameLabel.toLowerCase(),
          ),
          controller: _makeSearchController,
          style: AppTextStyle.regularTextStyle.copyWith(
            fontWeight: FontWeight.w700,
            color: ColorConstant.kColor353333,
          ),
        ),
        suggestionsBoxController: makeNamesSuggestionController,
      ),
    );
  }

  Widget searchModelField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.h),
        Text(
          youCanSelectMultipleModel,
          style: AppTextStyle.smallTextStyle,
        ),
        Padding(
          padding: getPadding(top: 8.h, bottom: 8.h),
          child: TypeAheadFormField<BrandModel>(
            direction: AxisDirection.up,
            validator: (value) => null,
            suggestionsCallback: (pattern) async {
              if (pattern.isEmpty) {
                return [];
              } else {
                List<BrandModel> tempSelectedMakesModels = [];
                for (var element in selectedManufacturers) {
                  tempSelectedMakesModels.addAll(element.brandModels ?? []);
                }
                final searchedList = tempSelectedMakesModels
                    .where((element) => element.name!
                        .toLowerCase()
                        .contains(pattern.toLowerCase()))
                    .toList();
                return searchedList;
              }
            },
            itemBuilder: (context, BrandModel itemData) {
              return ListTile(
                title: Text(itemData.name ?? ''),
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
            onSuggestionSelected: (BrandModel suggestion) {
              isModelFirstLoad = false;
              if (selectedModels
                  .where((element) => element.id == suggestion.id)
                  .isEmpty) {
                selectedModels.add(suggestion);
              }
              _makeSearchController.clear();
              _modelSearchController.clear();
              setState(() {});
            },
            hideKeyboardOnDrag: true,
            hideSuggestionsOnKeyboardHide: false,
            minCharsForSuggestions: 1,
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
            ),
            debounceDuration: const Duration(milliseconds: 500),
            textFieldConfiguration: TextFieldConfiguration(
              inputFormatters: [
                NoLeadingSpaceFormatter(),
              ],
              textCapitalization: TextCapitalization.characters,
              onSubmitted: (newValue) {
                isModelFirstLoad = false;
              },
              decoration: commonInputDecoration.copyWith(
                hintText:
                    textFieldLabelSearchTheText + modelLabel.toLowerCase(),
              ),
              controller: _modelSearchController,
              style: AppTextStyle.regularTextStyle.copyWith(
                fontWeight: FontWeight.w700,
                color: ColorConstant.kColor353333,
              ),
            ),
            suggestionsBoxController: modelsSuggestionController,
          ),
        ),
      ],
    );
  }

  Widget bodyTypeFilter() {
    return FilterExpansionTile(
      initiallyExpanded: selectedIndex == 1,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 1);
      },
      title: bodyTypeLabel,
      subTitle: youCanSelectMultipleBodytype,
      children: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: bodyTypes.length,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        separatorBuilder: (context, index) => const CommonDivider(),
        itemBuilder: (_, int index) {
          final bodyType = bodyTypes[index];
          return CustomCheckboxWithLabel(
            label: bodyType.name ?? '',
            value: isSelectedItem(selectedBodyTypes, bodyType),
            onChanged: (value) {
              if (isSelectedItem(selectedBodyTypes, bodyType)) {
                selectedBodyTypes
                    .remove(getSelectedItem(selectedBodyTypes, bodyType));
              } else {
                selectedBodyTypes.add(bodyType);
              }
            },
          );
        },
      ),
    );
  }

  Widget yearFilter() {
    return FilterExpansionTile(
      initiallyExpanded: selectedIndex == 2,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 2);
      },
      title: yearLabel,
      subTitle: youCanAdjustSliderToSelectYear,
      children: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
        child: CustomRangeSlider(
          selectedStartValue: selectedStartYear,
          selectedEndValue: selectedEndYear,
          startValueLabel: initialStartYear.toInt().toString(),
          endValueLabel: initialEndYear.toInt().toString(),
          trackHeight: 1,
          activeTrackColor: ColorConstant.kColor353333,
          min: initialStartYear,
          max: initialEndYear,
          onChanged: (value) {
            selectedStartYear = value.start;
            selectedEndYear = value.end;
          },
        ),
      ),
    );
  }

  Widget newPriceFilter() {
    return FilterExpansionTile(
      initiallyExpanded: selectedIndex == 3,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 3);
      },
      title: priceLabel,
      subTitle: youCanChoosePriceSlider,
      children: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 0.w),
        child: isAnimationCompleted
            ? CommonDropDown(
                hintText: hintTextPriceRangeDropDown,
                selectedValue: selectedPriceRangeValue,
                items: priceRangeList,
                onChanged: (value) {
                  if (value?.id != null) {
                    selectedPriceRangeValue = value;
                    if (value != null && value.id != null) {
                      priceStart = double.parse(value.id!.split('-')[0]);
                      priceEnd = double.parse(value.id!.split('-')[1]);
                    }
                  }
                },
              )
            : shimmerLoader(
                Container(
                  height: getVerticalSize(41.h),
                  decoration: BoxDecoration(
                    color: ColorConstant.kColorWhite,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
      ),
    );
  }

  Widget transmissionFilter() {
    return FilterExpansionTile(
      initiallyExpanded: selectedIndex == 4,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 4);
      },
      title: transmissionLabel,
      subTitle: youCanSelectMultipleTransmission,
      children: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transmissionTypes.length,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        separatorBuilder: (context, index) => const CommonDivider(),
        itemBuilder: (_, int index) {
          final transmission = transmissionTypes[index];
          return CustomCheckboxWithLabel(
            label: transmission.name ?? '',
            value: isSelectedItem(selectedTransmissionTypes, transmission),
            onChanged: (value) {
              if (isSelectedItem(selectedTransmissionTypes, transmission)) {
                selectedTransmissionTypes.remove(
                    getSelectedItem(selectedTransmissionTypes, transmission));
              } else {
                selectedTransmissionTypes.add(transmission);
              }
            },
          );
        },
      ),
    );
  }

  Widget fuelTypeFilter() {
    return FilterExpansionTile(
      initiallyExpanded: selectedIndex == 5,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 5);
      },
      title: fuelTypeLabel,
      subTitle: youCanSelectMultipleFuelTypes,
      children: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: fuelTypes.length,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        separatorBuilder: (context, index) => const CommonDivider(),
        itemBuilder: (_, int index) {
          final fuelType = fuelTypes[index];
          return CustomCheckboxWithLabel(
            label: fuelTypes[index].name ?? '',
            value: isSelectedItem(selectedFuelsTypes, fuelType),
            onChanged: (value) {
              if (isSelectedItem(selectedFuelsTypes, fuelType)) {
                selectedFuelsTypes
                    .remove(getSelectedItem(selectedFuelsTypes, fuelType));
              } else {
                selectedFuelsTypes.add(fuelType);
              }
            },
          );
        },
      ),
    );
  }

  bool isSelectedItem(List<ValuesSectionInput> list, ValuesSectionInput item) {
    return list.any((element) => element.id == item.id);
  }

  ValuesSectionInput getSelectedItem(
      List<ValuesSectionInput> list, ValuesSectionInput item) {
    return list.where((element) => element.id == item.id).first;
  }

  Widget userTypeFilter() {
    return FilterExpansionTile(
      initiallyExpanded: selectedIndex == 6,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 6);
      },
      title: userTypeLabel,
      subTitle: youCanSelectOnlyOneType,
      children: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filterUserTypeList.length,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        separatorBuilder: (context, index) => const CommonDivider(),
        itemBuilder: (_, int index) {
          final Map<String, dynamic> type =
              filterUserTypeList[index] as Map<String, dynamic>;
          return Padding(
            padding: getPadding(top: 6.h, bottom: 6.h),
            child: CustomRadioWithLabel(
              text: type.keys.first,
              value: type.values.first as String,
              groupValue: selectedUserTypeItem,
              onChanged: (value) =>
                  setState(() => selectedUserTypeItem = value!),
              onTapLabel: () => setState(
                () => selectedUserTypeItem = type.values.first.toString(),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> onTapApply() async {
    final Map<String, dynamic> selectedFilters = {
      if (selectedManufacturers.isNotEmpty) 'makers': selectedManufacturers,
      if (selectedModels.isNotEmpty) 'model': selectedModels,
      if (selectedBodyTypes.isNotEmpty) 'bodyType': selectedBodyTypes,
      'year': {
        'max': selectedEndYear.round(),
        'min': selectedStartYear.round(),
      },
      if (selectedPriceRangeValue != null)
        'priceFilter': {
          'max': priceEnd.round(),
          'min': priceStart.round(),
        },
      if (selectedTransmissionTypes.isNotEmpty)
        'transmissionType': selectedTransmissionTypes,
      if (selectedFuelsTypes.isNotEmpty) 'fuelType': selectedFuelsTypes,
      if (selectedUserTypeItem != convertEnumToString(FilterUserTypes.none))
        'userType': selectedUserTypeItem
    };
    Navigator.pop(context, selectedFilters);
  }

  void populateData(Map<String, dynamic> filterJson) {
    if (filterJson.containsKey(key.makers)) {
      selectedManufacturers = List.from(filterJson[key.makers] as List);
    }
    if (filterJson.containsKey(key.model)) {
      selectedModels = List.from(filterJson[key.model] as List);
    }
    if (filterJson.containsKey(key.bodyType)) {
      selectedBodyTypes = List.from(filterJson[key.bodyType] as List);
    }
    if (filterJson.containsKey(key.year)) {
      selectedEndYear = (filterJson[key.year]['max'] as num).toDouble();
      selectedStartYear = (filterJson[key.year]['min'] as num).toDouble();
    }
    if (filterJson.containsKey(key.priceFilterKey)) {
      priceEnd = (filterJson[key.priceFilterKey]['max'] as num).toDouble();
      priceStart = (filterJson[key.priceFilterKey]['min'] as num).toDouble();
    }
    if (filterJson.containsKey(key.transmissionType)) {
      selectedTransmissionTypes =
          List.from(filterJson[key.transmissionType] as List);
    }
    if (filterJson.containsKey(key.fuelType)) {
      selectedFuelsTypes = List.from(filterJson[key.fuelType] as List);
    }
    if (filterJson.containsKey(key.userType)) {
      selectedUserTypeItem = filterJson[key.userType] as String;
    }
    setState(() {});
  }
}
