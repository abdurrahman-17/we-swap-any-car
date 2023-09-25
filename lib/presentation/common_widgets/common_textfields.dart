import 'package:flutter/services.dart';

import '../../core/configurations.dart';
import '../../utility/custom_formatter.dart';

class CommonTextFormField extends StatefulWidget {
  const CommonTextFormField({
    Key? key,
    required this.controller,
    this.obscureText,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.letterSpacing,
    this.borderRadius = 25,
    this.validator,
    this.maxLength,
    this.readOnly = false,
    this.autoValidate,
    this.textInputType,
    this.bgColor,
    this.inputCharLength,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onTap,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.hint,
    this.maxLines,
    this.minLines,
    this.focusNode,
    this.cursorHgt,
    this.inputFormatters,
    this.isDropDown = false,
    this.contentPadding,
    this.scrollPadding = const EdgeInsets.all(20),
    this.style,
  }) : super(key: key);
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final GestureTapCallback? onTap;
  final TextEditingController controller;
  final bool? obscureText;
  final String? label;
  final String? hint;
  final double borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;
  final bool readOnly;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autoValidate;
  final Color? bgColor;
  final int? inputCharLength;
  final int? minLines;
  final int? maxLines;
  final double? cursorHgt;
  final double? letterSpacing;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool isDropDown;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsets scrollPadding;
  final FocusNode? focusNode;
  final TextStyle? style;
  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  List<TextInputFormatter> inputFormatters = [
    NoLeadingSpaceFormatter(),
  ];

  @override
  void initState() {
    super.initState();

    if (widget.inputFormatters == null) {
      inputFormatters = [
        NoLeadingSpaceFormatter(),
      ];
      if (widget.textInputType == TextInputType.phone) {
        inputFormatters.addAll([
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          CustomInputFormatter(),
          LengthLimitingTextInputFormatter(widget.inputCharLength! + 1),
        ]);
      } else if (widget.inputCharLength != null) {
        inputFormatters.add(
          LengthLimitingTextInputFormatter(widget.inputCharLength),
        );
      }
    } else {
      inputFormatters.addAll(widget.inputFormatters ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      scrollPadding: widget.scrollPadding,
      cursorHeight: widget.cursorHgt ?? 18,
      controller: widget.controller,
      obscureText: widget.obscureText ?? false,
      textInputAction: widget.textInputAction,
      maxLength: widget.maxLength,
      keyboardType: widget.textInputType ?? TextInputType.text,
      autovalidateMode:
          widget.autoValidate ?? AutovalidateMode.onUserInteraction,
      enableSuggestions: false,
      autocorrect: false,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      focusNode: widget.focusNode,
      textCapitalization: widget.textCapitalization,
      inputFormatters: inputFormatters,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      style: widget.style ??
          TextStyle(
            fontFamily: Assets.primaryFontPTSans,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.none,
            color: ColorConstant.kColor353333,
            letterSpacing: widget.letterSpacing,
          ),
      maxLines: widget.maxLines ?? 1,
      minLines: widget.minLines ?? 1,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        counterText: widget.maxLength != null ? null : '',
        hintText: widget.hint,
        labelText: widget.label,
        prefixIcon: widget.prefixIcon,
        enabledBorder: outlineInputBorder(widget.borderRadius),
        focusedBorder: outlineInputBorder(widget.borderRadius),
        border: outlineInputBorder(widget.borderRadius),
        focusedErrorBorder:
            outlineInputBorder(widget.borderRadius, isError: true),
        errorBorder: outlineInputBorder(widget.borderRadius, isError: true),
        hintStyle: AppTextStyle.hintTextStyle,
        filled: true,
        fillColor: widget.bgColor ?? ColorConstant.kColorWhite,
        contentPadding: widget.contentPadding ??
            EdgeInsetsDirectional.fromSTEB(18.w, 11.h, 18.w, 11.h),
        suffixIcon: widget.isDropDown
            ? Icon(
                Icons.keyboard_arrow_down_rounded,
                color: ColorConstant.kColor7C7C7C,
                size: 19,
              )
            : widget.suffixIcon != null
                ? Padding(
                    padding: getPadding(right: 5),
                    child: widget.suffixIcon,
                  )
                : null,
      ),
    );
  }
}

OutlineInputBorder outlineInputBorder(double borderRadius,
    {bool isError = false}) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: isError ? Colors.red : ColorConstant.kColorD9D9D9,
    ),
    borderRadius: BorderRadius.circular(borderRadius),
  );
}
