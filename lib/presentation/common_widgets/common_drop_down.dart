import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';

import '../../core/configurations.dart';
import '../../model/car_model/value_section_input.dart';

class CommonDropDown extends StatelessWidget {
  CommonDropDown({
    Key? key,
    this.width,
    this.margin,
    this.icon,
    this.hintText,
    this.prefix,
    this.items = const [],
    this.onChanged,
    this.validatorMsg,
    this.selectedValue,
    this.isProperCase = false,
    this.searchHintText,
    this.autovalidateMode,
    this.isDense = false,
    this.scrollPadding = const EdgeInsets.all(0),
    this.bgColor,
    this.isSelectedItemBuilder = false,
  }) : super(key: key);

  final double? width;
  final EdgeInsetsGeometry? margin;
  final Widget? icon;
  final String? hintText;
  final Widget? prefix;
  final List<ValuesSectionInput> items;
  final ValueChanged<ValuesSectionInput?>? onChanged;
  final String? validatorMsg;
  final ValuesSectionInput? selectedValue;
  final bool isProperCase;
  final String? searchHintText;
  final AutovalidateMode? autovalidateMode;
  final bool? isDense;
  final Color? bgColor;
  final EdgeInsetsGeometry? scrollPadding;
  final TextEditingController searchEditingController = TextEditingController();
  final bool isSelectedItemBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width != null ? getHorizontalSize(width ?? 0) : double.infinity,
      margin: margin,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField2<ValuesSectionInput>(
          buttonStyleData: ButtonStyleData(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          autovalidateMode:
              autovalidateMode ?? AutovalidateMode.onUserInteraction,
          isExpanded: true,
          isDense: isDense ?? false,
          hint: Text(
            hintText ?? '',
            style: hintText == filterByLabel
                ? _setHintStyle().copyWith(fontWeight: FontWeight.w700)
                : _setHintStyle(),
          ),
          value: selectedValue != null
              ? items
                  .where((element) =>
                      (element.id ?? '').toLowerCase() ==
                      (selectedValue?.id ?? '').toLowerCase())
                  .first
              : null,
          validator: (val) {
            if (validatorMsg != null && validatorMsg!.isNotEmpty) {
              if (val == null) {
                return '       ${validatorMsg ?? '*Required'}';
              }
              return null;
            } else {
              return null;
            }
          },
          style: _setFontStyle(),
          decoration: _buildDecoration(searchHintText != null),
          iconStyleData: IconStyleData(
            icon: Padding(
              padding: getPadding(right: 15.w),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: getSize(18),
              ),
            ),
            openMenuIcon: Padding(
              padding: getPadding(right: 15.w),
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                size: getSize(18),
              ),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            scrollPadding: scrollPadding,
            //for display scroll indicator always
            scrollbarTheme: Platform.isAndroid
                ? ScrollbarThemeData(
                    thumbVisibility: MaterialStateProperty.all(true),
                  )
                : null,
            maxHeight: MediaQuery.sizeOf(context).height / 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          selectedItemBuilder: isSelectedItemBuilder
              ? (context) {
                  return items.map((ValuesSectionInput item) {
                    return Text(
                      isProperCase
                          ? (item.name ?? '').toProperCase()
                          : (item.name ?? ''),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    );
                  }).toList();
                }
              : null,
          items: items.map((ValuesSectionInput item) {
            return DropdownMenuItem<ValuesSectionInput>(
              value: item,
              child: Text(
                isProperCase
                    ? (item.name ?? '').toProperCase()
                    : (item.name ?? ''),
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          dropdownSearchData: searchHintText != null
              ? DropdownSearchData(
                  searchController: searchEditingController,
                  searchInnerWidgetHeight: getVerticalSize(50),
                  searchInnerWidget: Container(
                    height: getVerticalSize(50),
                    padding: EdgeInsets.only(
                      top: 8.h,
                      bottom: 4.h,
                      right: 8.w,
                      left: 8.w,
                    ),
                    child: TextFormField(
                      expands: true,
                      maxLines: null,
                      controller: searchEditingController,
                      decoration: InputDecoration(
                        isDense: false,
                        hintText: searchHintText,
                        hintStyle: _setHintStyle(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: _setSearchPadding(),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return (item.value?.name ?? '')
                        .toLowerCase()
                        .contains(searchValue.toLowerCase());
                  },
                )
              : null,
        ),
      ),
    );
  }

  InputDecoration _buildDecoration(bool isContent) {
    return InputDecoration(
      hintText: isContent ? '      $selectDropdownHint' : '     $hintText',
      hintStyle: _setHintStyle(),
      border: _setBorderStyle(),
      focusedBorder: _setBorderStyle(),
      enabledBorder: _setBorderStyle(),
      disabledBorder: _setBorderStyle(),
      errorBorder: _setBorderStyle(isError: true),
      focusedErrorBorder: _setBorderStyle(isError: true),
      prefixIcon: prefix,
      fillColor: bgColor ?? ColorConstant.whiteA700,
      filled: true,
      isDense: true,
      contentPadding: isContent ? _setContentPadding() : _setPadding(),
    );
  }

  TextStyle _setHintStyle() {
    return TextStyle(
      color: ColorConstant.kColor7C7C7C,
      fontSize: getFontSize(14),
      fontWeight: FontWeight.w100,
      fontFamily: Assets.primaryFontPTSans,
    );
  }

  TextStyle _setFontStyle() {
    return TextStyle(
      color: ColorConstant.blueGray900,
      fontSize: getFontSize(14),
      fontFamily: Assets.primaryFontPTSans,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w700,
    );
  }

  InputBorder _setBorderStyle({bool isError = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.r),
      borderSide: BorderSide(
        color: isError ? Colors.red : ColorConstant.kColorD9D9D9,
      ),
    );
  }

  EdgeInsetsGeometry _setPadding() {
    return EdgeInsetsDirectional.fromSTEB(0.w, 0.h, 0.w, 0.h);
  }

  EdgeInsetsGeometry _setSearchPadding() {
    return EdgeInsetsDirectional.fromSTEB(10.w, 0.h, 0.w, 0.h);
  }

  EdgeInsetsGeometry _setContentPadding() {
    return EdgeInsetsDirectional.fromSTEB(0.w, 11.h, 0.w, 11.h);
  }
}
