// ignore_for_file: constant_identifier_names

import '../../core/configurations.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      this.shape,
      this.padding,
      this.variant,
      this.alignment,
      this.margin,
      this.width,
      this.height,
      this.child,
      this.onTap});

  final IconButtonShape? shape;
  final IconButtonPadding? padding;
  final IconButtonVariant? variant;
  final Alignment? alignment;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Widget? child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildIconButtonWidget(),
          )
        : _buildIconButtonWidget();
  }

  Widget _buildIconButtonWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: IconButton(
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        iconSize: getSize(height ?? 0),
        padding: const EdgeInsets.all(0),
        icon: Container(
          alignment: Alignment.center,
          width: getSize(width ?? 0),
          height: getSize(height ?? 0),
          padding: _setPadding(),
          decoration: _buildDecoration(),
          child: child,
        ),
        onPressed: onTap,
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: _setColor(),
      border: _setBorder(),
      borderRadius: _setBorderRadius(),
      gradient: _setGradient(),
      boxShadow: _setBoxShadow(),
    );
  }

  EdgeInsetsGeometry _setPadding() {
    switch (padding) {
      case IconButtonPadding.PaddingAll5:
        return getPadding(
          all: 5,
        );
      case IconButtonPadding.PaddingAll6:
        return getPadding(
          all: 6,
        );
      case IconButtonPadding.PaddingAll7:
        return getPadding(
          all: 7,
        );
      case IconButtonPadding.PaddingAll8:
        return getPadding(
          all: 8,
        );
      case IconButtonPadding.PaddingAll9:
        return getPadding(
          all: 9,
        );
      case IconButtonPadding.PaddingAll23:
        return getPadding(
          all: 23,
        );
      case IconButtonPadding.PaddingAll14:
        return getPadding(
          all: 14,
        );
      case IconButtonPadding.PaddingAll17:
        return getPadding(
          all: 17,
        );
      default:
        return getPadding(
          all: 9,
        );
    }
  }

  Color? _setColor() {
    switch (variant) {
      case IconButtonVariant.OutlineBluegray100:
        return ColorConstant.whiteA700;
      case IconButtonVariant.FillBlack90090:
        return ColorConstant.black90090;
      case IconButtonVariant.FillGray100:
        return ColorConstant.gray100;
      case IconButtonVariant.Fill353333:
        return ColorConstant.kColor353333;
      case IconButtonVariant.kPrimaryDarkRed:
        return ColorConstant.kPrimaryDarkRed;
      case IconButtonVariant.Outline:
        return null;
      default:
        return ColorConstant.black900;
    }
  }

  Border? _setBorder() {
    switch (variant) {
      case IconButtonVariant.OutlineBluegray100:
        return Border.all(
          color: ColorConstant.blueGray100,
          width: getHorizontalSize(
            1.00,
          ),
        );
      default:
        return null;
    }
  }

  BorderRadius _setBorderRadius() {
    switch (shape) {
      case IconButtonShape.RoundedBorder30:
        return BorderRadius.circular(
          getHorizontalSize(
            30.00,
          ),
        );
      case IconButtonShape.CircleBorder12:
        return BorderRadius.circular(
          getHorizontalSize(
            12.00,
          ),
        );
      case IconButtonShape.CircleBorder21:
        return BorderRadius.circular(
          getHorizontalSize(
            21.00,
          ),
        );
      case IconButtonShape.CircleBorder15:
        return BorderRadius.circular(
          getHorizontalSize(
            15.00,
          ),
        );
      case IconButtonShape.RoundedBorder24:
        return BorderRadius.circular(
          getHorizontalSize(
            24.00,
          ),
        );
      case IconButtonShape.RoundedBorder100:
        return BorderRadius.circular(
          getHorizontalSize(
            100.00,
          ),
        );
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            18.00,
          ),
        );
    }
  }

  LinearGradient? _setGradient() {
    switch (variant) {
      case IconButtonVariant.primaryGradient:
        return LinearGradient(colors: kPrimaryGradientColor);
      default:
        return null;
    }
  }

  List<BoxShadow>? _setBoxShadow() {
    switch (variant) {
      case IconButtonVariant.Outline:
        return [
          BoxShadow(
            color: ColorConstant.black9000c,
            spreadRadius: getHorizontalSize(
              2.00,
            ),
            blurRadius: getHorizontalSize(
              2.00,
            ),
            offset: const Offset(
              0,
              4,
            ),
          )
        ];
      default:
        return null;
    }
  }
}

enum IconButtonShape {
  RoundedBorder18,
  RoundedBorder30,
  CircleBorder12,
  CircleBorder21,
  CircleBorder15,
  RoundedBorder24,
  RoundedBorder100,
}

enum IconButtonPadding {
  PaddingAll5,
  PaddingAll6,
  PaddingAll7,
  PaddingAll8,
  PaddingAll9,
  PaddingAll23,
  PaddingAll14,
  PaddingAll17,
}

enum IconButtonVariant {
  OutlineBluegray100,
  FillBlack900,
  primaryGradient,
  FillBlack90090,
  Outline,
  Fill353333,
  FillGray100,
  kPrimaryDarkRed,
}
