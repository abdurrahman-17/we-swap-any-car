import '../core/configurations.dart';

class AppDecoration {
  static BoxDecoration get outlineWhiteA7002 => BoxDecoration(
        border: Border.all(
          color: ColorConstant.whiteA700,
          width: getHorizontalSize(1.w),
        ),
        gradient: LinearGradient(
          begin: const Alignment(0, 0.5),
          end: const Alignment(1, 0.5),
          colors: [
            ColorConstant.kPrimaryLightRed,
            ColorConstant.kPrimaryDarkRed,
          ],
        ),
      );

  static BoxDecoration get gradientBlack90093Black90093 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            ColorConstant.kColorBlack.withOpacity(0.8),
          ],
        ),
      );

  static BoxDecoration get kGradientBoxDecoration => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorConstant.kPrimaryLightRed,
            ColorConstant.kPrimaryDarkRed,
          ],
        ),
      );

  static BoxDecoration get outlineBlack9003f => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.13, -0.1),
          end: const Alignment(0.92, 1.72),
          colors: [
            ColorConstant.deepOrangeA200,
            ColorConstant.yellow900,
          ],
        ),
      );

  static BoxDecoration get rectangle213 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.75, 0),
          end: const Alignment(0.68, 1.2),
          colors: [
            ColorConstant.kColorWhite,
            ColorConstant.grey,
          ],
        ),
      );

  static BoxDecoration get outlineBlack9003f2 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.05, 0.20),
          end: const Alignment(0.99, 0.88),
          colors: [
            ColorConstant.greenA700,
            ColorConstant.orange600,
          ],
        ),
      );

  static BoxDecoration get outlineBlack9003f4 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.6, 3),
          end: const Alignment(0.9, 2),
          colors: [
            ColorConstant.deepOrangeA200,
            ColorConstant.yellow900,
          ],
        ),
      );

  static BoxDecoration get outlineBlack90021 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black90021,
            spreadRadius: getHorizontalSize(2),
            blurRadius: getHorizontalSize(2),
            offset: const Offset(0, 4),
          ),
        ],
      );
  static BoxDecoration get outlineBlack900 => BoxDecoration(
        color: ColorConstant.gray200,
        border: Border.all(
          color: ColorConstant.black900,
          width: getHorizontalSize(9),
        ),
      );
  static BoxDecoration get fillBlack900 => BoxDecoration(
        color: ColorConstant.black900,
      );
  static BoxDecoration get outlineWhiteA700 => BoxDecoration(
        border: Border.all(
          color: ColorConstant.whiteA700,
          width: getHorizontalSize(1),
        ),
        gradient: LinearGradient(
          begin: const Alignment(0.5, 0),
          end: const Alignment(0.5, 1),
          colors: [
            ColorConstant.redA700,
            ColorConstant.redA700,
            ColorConstant.redA70001,
          ],
        ),
      );

  static BoxDecoration get outlineBlack9000c4 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9000c,
            spreadRadius: getHorizontalSize(2),
            blurRadius: getHorizontalSize(2),
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get outlineBlack9000c2 => BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorConstant.deepOrangeA200,
            ColorConstant.yellow900,
          ],
        ),
      );
  static BoxDecoration get outlineBlack9000c => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9000c,
            spreadRadius: getHorizontalSize(2),
            blurRadius: getHorizontalSize(2),
            offset: const Offset(0, 4),
          ),
        ],
      );
  static BoxDecoration get outlineBlack9000c1 => BoxDecoration(
        color: ColorConstant.gray30001,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9000c,
            spreadRadius: getHorizontalSize(2),
            blurRadius: getHorizontalSize(2),
            offset: const Offset(0, 4),
          ),
        ],
      );
  static BoxDecoration get outlineBlack9002 => BoxDecoration(
        color: ColorConstant.gray100,
        border: Border.all(
          color: ColorConstant.black900,
          width: getHorizontalSize(9.w),
        ),
      );

  static BoxDecoration get fillBlue900 => BoxDecoration(
        color: ColorConstant.blue900,
      );

  static BoxDecoration get gradientDeeporangeA200Yellow900 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.13, -0.1),
          end: const Alignment(0.92, 1.72),
          colors: [
            ColorConstant.deepOrangeA200,
            ColorConstant.yellow900,
          ],
        ),
      );

  static BoxDecoration get gradientRed100YellowA700 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(2.5, 0),
          end: const Alignment(1, 1),
          colors: [
            ColorConstant.red100,
            ColorConstant.yellowA700,
          ],
        ),
      );

  static BoxDecoration get fillGray100 => BoxDecoration(
        color: ColorConstant.gray100,
      );
}

class BorderRadiusStyle {
  static BorderRadius customBorderTL20 = BorderRadius.only(
    topLeft: Radius.circular(
      getHorizontalSize(20.r),
    ),
    topRight: Radius.circular(
      getHorizontalSize(20),
    ),
  );

  static BorderRadius customBorderBL20 = BorderRadius.only(
    bottomLeft: Radius.circular(
      getHorizontalSize(20.r),
    ),
    bottomRight: Radius.circular(
      getHorizontalSize(20.r),
    ),
  );

  static BorderRadius roundedBorder29 = BorderRadius.circular(
    getHorizontalSize(29.r),
  );

  static BorderRadius circleBorder25 = BorderRadius.circular(
    getHorizontalSize(25.r),
  );

  static BorderRadius roundedBorder17 = BorderRadius.circular(
    getHorizontalSize(17.r),
  );

  static BorderRadius roundedBorder39 = BorderRadius.circular(
    getHorizontalSize(39.r),
  );

  static BorderRadius roundedBorder5 = BorderRadius.circular(
    getHorizontalSize(5.r),
  );

  static BorderRadius roundedBorder24 = BorderRadius.circular(
    getHorizontalSize(24.r),
  );

  static BorderRadius roundedBorder2 = BorderRadius.circular(
    getHorizontalSize(2.r),
  );

  static BorderRadius roundedBorder15 = BorderRadius.circular(
    getHorizontalSize(15.r),
  );

  static BorderRadius roundedBorder100 = BorderRadius.circular(
    getHorizontalSize(100.r),
  );

  static BorderRadius roundedBorder20 = BorderRadius.circular(
    getHorizontalSize(20.r),
  );

  static BorderRadius txtCircleBorder21 = BorderRadius.circular(
    getHorizontalSize(21.r),
  );

  static BorderRadius circleBorder100 = BorderRadius.circular(
    getHorizontalSize(100.r),
  );
}
