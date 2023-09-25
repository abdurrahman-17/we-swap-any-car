import 'package:geolocator/geolocator.dart';

import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../repository/user_repo.dart';
import '../../../service/geo_services.dart';
import '../../../utility/custom_formatter.dart';
import '../../../utility/validator.dart';
import '../../common_widgets/common_loader.dart';
import '../../common_widgets/common_slider.dart';
import '../../common_widgets/custom_checkbox.dart';

class LocationFilter extends StatefulWidget {
  const LocationFilter({
    Key? key,
    this.onChangedMiles,
    this.locationCoordinates,
  }) : super(key: key);
  final ValueChanged<int>? onChangedMiles;
  final ValueChanged<List<num>>? locationCoordinates;

  @override
  State<LocationFilter> createState() => _LocationFilterState();
}

class _LocationFilterState extends State<LocationFilter> {
  int miles = 10;
  bool postCode = true;
  bool currentLocation = false;
  bool isFirstLoad = true;
  List<String> postCodeResults = [];
  static TextEditingController postCodeSearch = TextEditingController();
  final SuggestionsBoxController postCodeSuggestionController =
      SuggestionsBoxController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomCheckboxWithLabel(
                isIconFirst: true,
                label: postCodeLabel,
                value: postCode,
                onChanged: (_) {
                  postCode = !postCode;
                  currentLocation = !currentLocation;
                  setState(() {});
                },
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CustomCheckboxWithLabel(
                isIconFirst: true,
                label: currentLocationLabel,
                isLocation: true,
                value: currentLocation,
                onChanged: (_) async {
                  try {
                    currentLocation = !currentLocation;
                    postCode = !postCode;
                    setState(() {});
                    final Position position =
                        await GeoServices().determinePosition();
                    widget.locationCoordinates!(
                        [position.latitude, position.longitude]);
                    // ignore: avoid_catches_without_on_clauses
                  } catch (e) {
                    showSnackBar(message: "$e");
                    setState(() {
                      currentLocation = !currentLocation;
                      postCode = !postCode;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        if (postCode)
          TypeAheadFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if ((!Validation.isValidPostcode(postCodeSearch.text.trim(),
                  isRequired: true))) {
                postCodeSearch.clear();
                return "Post code is required";
              } else if (postCodeResults.isEmpty) {
                return "Enter a valid post code";
              }
              return null;
            },
            suggestionsCallback: (pattern) async {
              if (pattern.isEmpty) {
                return [];
              } else {
                List<String> result = await Locator.instance
                    .get<UserRepo>()
                    .getPostCodes(pattern);

                setState(() {
                  postCodeResults = result;
                });
                return result;
              }
            },
            itemBuilder: (context, itemData) => ListTile(
              title: Text("$itemData"),
            ),
            noItemsFoundBuilder: (context) => const SizedBox(),
            loadingBuilder: (context) {
              return const SizedBox(
                height: 100,
                child: Center(child: CircularLoader()),
              );
            },
            onSuggestionSelected: (suggestion) async {
              isFirstLoad = false;
              postCodeSearch.text = "$suggestion";
              final relatedAddresses = await Locator.instance
                  .get<UserRepo>()
                  .getRelatedAddress(postCodeSearch.text);

              final result = await Locator.instance
                  .get<UserRepo>()
                  .getAddressDetails(relatedAddresses[0].id ?? '');

              result.fold((l) => l, (r) {
                widget.locationCoordinates!([
                  r.latitude!,
                  r.longitude!,
                ]);
              });
            },
            hideKeyboardOnDrag: true,
            hideSuggestionsOnKeyboardHide: false,
            minCharsForSuggestions: 1,
            direction: AxisDirection.up,
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
            ),
            debounceDuration: const Duration(milliseconds: 500),
            textFieldConfiguration: TextFieldConfiguration(
              onSubmitted: (newValue) {
                isFirstLoad = false;
                postCodeSearch.text = newValue;
              },
              decoration:
                  commonInputDecoration.copyWith(hintText: typeToSearch),
              inputFormatters: [
                UpperCaseTextFormatter(),
                LengthLimitingTextInputFormatter(10),
                NoLeadingSpaceFormatter(),
              ],
              controller: postCodeSearch,
              style: TextStyle(
                fontFamily: Assets.primaryFontPTSans,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none,
                color: ColorConstant.kColor353333,
              ),
            ),
            suggestionsBoxController: postCodeSuggestionController,
          ),
        SizedBox(height: 10.h),
        Text(
          maximumDistance,
          style: AppTextStyle.smallTextStyle,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 15.h, top: 5.h),
          child: CommonSlider(
            sliderValue: miles.toDouble(),
            min: 5,
            max: 100,
            displayStartValue: '5',
            displayEndValue: '100',
            displaySelectedLabel: ' $milesLabel',
            onChanged: (value) {
              miles = value.toInt();
              widget.onChangedMiles!(miles);
            },
          ),
        ),
      ],
    );
  }
}
