import 'dart:async';

import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../model/car_model/value_section_input.dart';
import '../../../model/technical_details/car_colors.dart';
import '../../../model/technical_details/manufacturer.dart';
import '../../../repository/car_repo.dart';
import '../../../utility/custom_formatter.dart';
import '../../../utility/date_time_utils.dart';
import '../../../utility/invert_color.dart';
import '../../common_widgets/common_divider.dart';
import '../../common_widgets/common_expansion_tile.dart';
import '../../common_widgets/common_loader.dart';
import '../../common_widgets/common_slider.dart';
import '../../common_widgets/custom_checkbox.dart';
import '../../common_widgets/custom_range_slider.dart';
import 'doors_slider.dart';
import 'location_filter.dart';
import '../../../utility/common_keys.dart' as key;

class FilterBottomSheetWidget extends StatefulWidget {
  const FilterBottomSheetWidget({
    super.key,
    required this.filterData,
  });
  final Map<String, dynamic> filterData;
  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  //Initial Data
  List<ValuesSectionInput> bodyTypes = [];
  List<ValuesSectionInput> fuelTypes = [];
  List<ValuesSectionInput> transmissionTypes = [];
  List<CarColors> carColors = [];

  final initialStartYear = 1950;
  final initialEndYear = getCurrentDateTime().year;

  //Selected Items
  List<int> selectedViewCars = [];
  List<ValuesSectionInput> selectedBodyTypes = [];
  List<ValuesSectionInput> selectedTransmissionTypes = [];
  List<ValuesSectionInput> selectedFuelsTypes = [];
  List<CarColors> selectedColors = [];
  List<String> selectedUserTypes = [];
  List<Manufacturers> selectedManufacturers = [];
  List<BrandModel> selectedModels = [];
  List<num> locationCoordinates = [];
  int selectedMiles = 10;
  String selectedPostCode = '';
  double selectedStartPrice = 100;
  double selectedEndPrice = 1000000;
  double selectedStartYear = 0.0;
  double selectedEndYear = 0.0;
  int selectedDoor = 2;
  int selectedMileage = 0;

  ValuesSectionInput? selectedPriceRangeValue;
  bool isAnimationCompleted = false;

  int selectedIndex = -1;
  int locationIndex = -1;
  static final TextEditingController _quickSearchController =
      TextEditingController();
  static TextEditingController engineSizeController = TextEditingController();

  //Make Search
  bool isMakeFirstLoad = true;
  final TextEditingController _makeSearchController = TextEditingController();
  final SuggestionsBoxController makeNamesSuggestionController =
      SuggestionsBoxController();

  //Model Search
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
    locationIndex = index;
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
      carColors = technicalDetails.carColors ?? [];
      setState(() {});
    });
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
      selectedEndPrice =
          (filterJson[key.priceFilterKey]['max'] as num).toDouble();
      selectedStartPrice =
          (filterJson[key.priceFilterKey]['min'] as num).toDouble();
    }
    if (filterJson.containsKey(key.transmissionType)) {
      selectedTransmissionTypes =
          List.from(filterJson[key.transmissionType] as List);
    }
    if (filterJson.containsKey(key.fuelType)) {
      selectedFuelsTypes = List.from(filterJson[key.fuelType] as List);
    }
    setState(() {});
  }

  @override
  void initState() {
    getTechnicalDetails();
    populateData(widget.filterData);
    selectedStartYear = initialStartYear.toDouble();
    selectedEndYear = initialEndYear.toDouble();
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
    return SafeArea(
      bottom: false,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          int sensitivity = 8;
          if (details.delta.dy > sensitivity) {
            Navigator.of(context).pop();
          }
        },
        child: CustomScaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: Container(
            margin: getMargin(top: 30.h),
            decoration: BoxDecoration(
              color: ColorConstant.kBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.r),
                topRight: Radius.circular(40.r),
              ),
            ),
            child: Stack(
              children: [
                CustomImageView(
                  width: getHorizontalSize(size.width),
                  svgPath: Assets.homeBackground,
                  fit: BoxFit.fill,
                  alignment: Alignment.bottomCenter,
                ),
                Column(
                  children: [
                    Container(
                      height: getVerticalSize(8.h),
                      width: getHorizontalSize(size.width / 4),
                      margin: getMargin(top: 8.h, bottom: 15.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.r),
                        color: ColorConstant.kColorADADAD,
                      ),
                    ),
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: getPadding(
                              left: 25.w,
                              right: 25.w,
                              top: 10.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  filterLabel.toUpperCase(),
                                  style: AppTextStyle.regularTextStyle.copyWith(
                                    fontSize: getSize(16),
                                    color: ColorConstant.kColor353333,
                                  ),
                                ),
                                makeFilter(),
                                const GradientDivider(),
                                engineSizeFilter(),
                                const GradientDivider(),
                                bodyTypeFilter(),
                                const GradientDivider(),
                                newPriceFilter(),
                                const GradientDivider(),
                                locationFilter(),
                                const GradientDivider(),
                                colorFilter(),
                                const GradientDivider(),
                                transmissionFilter(),
                                const GradientDivider(),
                                fuelTypeFilter(),
                                const GradientDivider(),
                                yearFilter(),
                                const GradientDivider(),
                                userTypeFilter(),
                                const GradientDivider(),
                                mileageFilter(),
                                const GradientDivider(),
                                doorsFilter(),
                                const GradientDivider(),
                                viewCarFilter(),
                                const GradientDivider(),
                                keywordFilter(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    applyAndReset(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget keywordFilter() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            keywordSearchLabel,
            style: AppTextStyle.regularTextStyle.copyWith(
              fontWeight: FontWeight.w700,
              color: ColorConstant.kColor353333,
            ),
          ),
          SizedBox(height: 10.h),
          CommonTextFormField(
            validator: (value) => null,
            controller: _quickSearchController,
            hint: searchKeywordHint,
          ),
        ],
      ),
    );
  }

  Widget makeFilter() {
    return FilterExpansionTile(
      locationIndex: locationIndex,
      initiallyExpanded: selectedIndex == 0,
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
          isMakeFirstLoad = false;
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
          onSubmitted: (newValue) {
            isMakeFirstLoad = false;
          },
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

  Widget engineSizeFilter() {
    return FilterExpansionTile(
      locationIndex: locationIndex,
      initiallyExpanded: selectedIndex == 1,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 1);
      },
      title: engineSizeLabel,
      children: Padding(
        padding: getPadding(bottom: 8.h),
        child: CommonTextFormField(
          validator: (value) => null,
          textInputType: TextInputType.number,
          controller: engineSizeController,
          hint: textFieldLabelEnterTheText + engineSizeLabel,
        ),
      ),
    );
  }

  Widget bodyTypeFilter() {
    return FilterExpansionTile(
      locationIndex: locationIndex,
      initiallyExpanded: selectedIndex == 2,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 2);
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
            value: selectedBodyTypes.contains(bodyType),
            onChanged: (_) {
              if (selectedBodyTypes.contains(bodyType)) {
                selectedBodyTypes.remove(bodyType);
              } else {
                selectedBodyTypes.add(bodyType);
              }
            },
          );
        },
      ),
    );
  }

  Widget newPriceFilter() {
    return FilterExpansionTile(
      locationIndex: locationIndex,
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
                      selectedStartPrice =
                          double.parse(value.id!.split('-')[0]);
                      selectedEndPrice = double.parse(value.id!.split('-')[1]);
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

  Widget locationFilter() {
    return FilterExpansionTile(
      locationIndex: locationIndex,
      initiallyExpanded: selectedIndex == 4,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 4);
      },
      title: locationLabel,
      children: LocationFilter(
        onChangedMiles: (value) {
          selectedMiles = value;
        },
        locationCoordinates: (value) {
          locationCoordinates = value;
        },
      ),
    );
  }

  Widget colorFilter() {
    return FilterExpansionTile(
      locationIndex: locationIndex,
      initiallyExpanded: selectedIndex == 5,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 5);
      },
      title: colourLabel,
      subTitle: youCanSelectMultipleColorFromList,
      children: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 10.h,
          mainAxisExtent: getVerticalSize(31.h),
        ),
        itemCount: carColors.length,
        itemBuilder: (context, index) {
          final color = carColors[index];
          return InkWell(
            onTap: () {
              if (selectedColors.contains(color)) {
                selectedColors.remove(color);
              } else {
                selectedColors.add(color);
              }
              setState(() {});
            },
            child: Container(
              padding: getPadding(
                left: 10.w,
                right: 10.w,
                top: 6.h,
                bottom: 6.h,
              ),
              decoration: BoxDecoration(
                color: ColorConstant.fromHex(color.colorCode!),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      color.name ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.smallTextStyle.copyWith(
                        color: InvertColorHelper.invert(
                            ColorConstant.fromHex(color.colorCode ?? '')),
                        fontSize: getFontSize(11),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInCubic,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: selectedColors.contains(color)
                          ? ColorConstant.kColorBlack
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    width: getSize(19),
                    height: getSize(19),
                    alignment: Alignment.center,
                    child: selectedColors.contains(color)
                        ? Icon(
                            Icons.check_rounded,
                            color: ColorConstant.kColorWhite,
                            size: getSize(10),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget transmissionFilter() {
    return FilterExpansionTile(
      locationIndex: locationIndex,
      initiallyExpanded: selectedIndex == 6,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 6);
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
            value: selectedTransmissionTypes.contains(transmission),
            onChanged: (_) {
              if (selectedTransmissionTypes.contains(transmission)) {
                selectedTransmissionTypes.remove(transmission);
              } else {
                selectedTransmissionTypes.add(transmission);
              }
              setState(() {});
            },
          );
        },
      ),
    );
  }

  Widget fuelTypeFilter() {
    return FilterExpansionTile(
      locationIndex: locationIndex,
      initiallyExpanded: selectedIndex == 7,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 7);
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
            value: selectedFuelsTypes.contains(fuelType),
            onChanged: (_) {
              if (selectedFuelsTypes.contains(fuelType)) {
                selectedFuelsTypes.remove(fuelType);
              } else {
                selectedFuelsTypes.add(fuelType);
              }
              setState(() {});
            },
          );
        },
      ),
    );
  }

  Widget yearFilter() {
    return FilterExpansionTile(
      locationIndex: locationIndex,
      initiallyExpanded: selectedIndex == 8,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 8);
      },
      title: yearLabel,
      subTitle: youCanAdjustSliderToSelectYear,
      children: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
        child: CustomRangeSlider(
          selectedStartValue: selectedStartYear,
          selectedEndValue: selectedEndYear,
          startValueLabel: initialStartYear.toString(),
          endValueLabel: initialEndYear.toString(),
          min: initialStartYear.toDouble(),
          max: initialEndYear.toDouble(),
          onChanged: (value) {
            selectedStartYear = value.start;
            selectedEndYear = value.end;
          },
        ),
      ),
    );
  }

  Widget userTypeFilter() {
    return FilterExpansionTile(
      locationIndex: locationIndex,
      initiallyExpanded: selectedIndex == 9,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 9);
      },
      title: userTypeLabel,
      subTitle: youCanSelectOnlyOneType,
      children: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: userTypesList.length,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        separatorBuilder: (context, index) => const CommonDivider(),
        itemBuilder: (_, int index) {
          final type = userTypesList[index];
          return CustomCheckboxWithLabel(
            label: type,
            value: selectedUserTypes.contains(type),
            onChanged: (_) {
              if (selectedUserTypes.contains(type)) {
                selectedUserTypes.remove(type);
              } else {
                selectedUserTypes.add(type);
              }
            },
          );
        },
      ),
    );
  }

  Widget mileageFilter() {
    return FilterExpansionTile(
      locationIndex: locationIndex,
      initiallyExpanded: selectedIndex == 10,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 10);
      },
      title: mileageabel,
      subTitle: selectMiles,
      children: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: CommonSlider(
          isValuation: true,
          sliderValue: selectedMileage.toDouble(),
          min: 0,
          max: 1000000,
          displayStartValue: '',
          displayEndValue: '',
          displaySelectedLabel: '',
          onChanged: (value) {
            selectedMileage = value.toInt();
          },
        ),
      ),
    );
  }

  Widget doorsFilter() {
    return FilterExpansionTile(
      locationIndex: locationIndex,
      initiallyExpanded: selectedIndex == 11,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 11);
      },
      title: doorsLabel,
      subTitle: selectDoors,
      children: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: DoorsSlider(
          onChangedCallBack: (value) {
            selectedDoor = value as int;
          },
        ),
      ),
    );
  }

  Widget viewCarFilter() {
    return FilterExpansionTile(
      locationIndex: locationIndex,
      initiallyExpanded: selectedIndex == 12,
      onExpansionChanged: (newState) {
        collapseOrExpand(newState: newState, index: 12);
      },
      title: viewCarLabel,
      children: Padding(
        padding: getPadding(bottom: 15.h),
        child: Row(
          children: [
            Flexible(
              child: CustomCheckboxWithLabel(
                isIconFirst: true,
                hasBorder: true,
                label: recentToOld,
                value: selectedViewCars.contains(0),
                onChanged: (_) {
                  if (selectedViewCars.contains(0)) {
                    selectedViewCars.remove(0);
                  } else {
                    selectedViewCars.add(0);
                  }
                  setState(() {});
                },
              ),
            ),
            Flexible(
              child: CustomCheckboxWithLabel(
                isIconFirst: true,
                hasBorder: true,
                label: quickSale,
                value: selectedViewCars.contains(1),
                onChanged: (_) {
                  if (selectedViewCars.contains(1)) {
                    selectedViewCars.remove(1);
                  } else {
                    selectedViewCars.add(1);
                  }
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget applyAndReset() {
    return Padding(
      padding: getPadding(
        top: 15.h,
        bottom: 15.h,
        left: 20.w,
        right: 20.w,
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomElevatedButton(
              title: resetButton.toUpperCase(),
              onTap: () => Navigator.pop(
                context,
                {'filters': <String, dynamic>{}},
              ),
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: GradientElevatedButton(
              title: applyButton.toUpperCase(),
              onTap: onTapApply,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onTapApply() async {
    // price range is 100 to 1000000
    //user has not edited the price range on filter
    bool isUserActivatedPriceRange =
        !(selectedStartPrice == 100 && selectedEndPrice == 1000000);
    final Map<String, dynamic> selectedFilters = {
      'bodyType': selectedBodyTypes.map((e) => e.name).toList(),
      'makers': selectedManufacturers.map((e) => e.name).toList(),
      'model': selectedModels.map((e) => e.name).toList(),
      'colors': selectedColors.map((e) => e.name).toList(),
      'transmissionType': selectedTransmissionTypes.map((e) => e.name).toList(),
      'fuelType': selectedFuelsTypes.map((e) => e.name).toList(),
      'tradeType': selectedUserTypes,
      'doors': {
        'max': selectedDoor,
        'min': 0,
      },
      'engineSize': {
        'max': int.parse(
          engineSizeController.text.isNotEmpty
              ? engineSizeController.text
              : '0',
        ),
        'min': 0,
      },
      'listQuickSaleOnly': selectedViewCars.contains(1),
      'locationFilter': {
        'coordinates': locationCoordinates,
        'miles': selectedMiles,
      },
      'postType': '',
      'mileage': {
        'max': selectedMileage,
        'min': 0,
      },
      if (isUserActivatedPriceRange)
        'priceFilter': {
          'max': selectedEndPrice.round(),
          'min': selectedStartPrice.round(),
        },
      'search': _quickSearchController.text,
      'year': {
        'max': selectedEndYear.round(),
        'min': selectedStartYear.round(),
      },
    };

    Navigator.pop(
      context,
      {'filters': selectedFilters},
    );
  }
}
