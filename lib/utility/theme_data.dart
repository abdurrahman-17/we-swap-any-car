import '../core/configurations.dart';

final themData = ThemeData(
  primarySwatch: kPrimaryMaterialColor,
  colorScheme: ColorScheme.light(primary: ColorConstant.kPrimaryDarkRed),
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: ColorConstant.kColorWhite,
      titleTextStyle: AppTextStyle.appBarTextStyle,
      foregroundColor: Colors.black),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.black,
  ),
);
