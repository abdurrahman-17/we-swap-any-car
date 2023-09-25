import 'package:dotted_line/dotted_line.dart';
import 'package:wsac/core/configurations.dart';
import '../../common_widgets/custom_icon_button.dart';

class UserDealItemHistory extends StatelessWidget {
  const UserDealItemHistory({
    Key? key,
    this.btnTitle,
    this.textTitle,
    this.imgIcon,
    this.isCar,
    this.isCash,
    this.margin,
    this.amount,
    this.carAmount,
    this.payType,
    this.onTap,
    this.userName,
    this.userPicture,
    this.carName,
    this.carModel,
    this.carPicture,
    this.carValue,
    this.traderName,
  }) : super(key: key);
  final String? btnTitle;
  final String? textTitle;
  final String? userName;
  final String? userPicture;
  final String? carName;
  final String? carModel;
  final String? carPicture;
  final String? carValue;
  final String? traderName;
  final Widget? imgIcon;
  final bool? isCar;
  final bool? isCash;
  final EdgeInsetsGeometry? margin;
  final String? amount;
  final String? carAmount;
  final String? payType;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        margin: margin,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(color: ColorConstant.grey),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: getPadding(left: 17, top: 20, right: 17, bottom: 20),
                  decoration: AppDecoration.outlineBlack9000c.copyWith(
                    borderRadius: BorderRadiusStyle.customBorderTL20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: getPadding(left: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomImageView(
                              url: userPicture,
                              height: getSize(36.00),
                              width: getSize(36.00),
                              margin: getMargin(bottom: 1),
                            ),
                            Padding(
                              padding: getPadding(left: 9, top: 2, bottom: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(userName!,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppTextStyle.txtPTSansBold12),
                                  Padding(
                                    padding: getPadding(top: 1),
                                    child: Text(
                                      traderName!,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppTextStyle.txtPTSansRegular10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: getPadding(top: 12, bottom: 12),
                              child: Text(carLabel,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppTextStyle.txtPTSansBold10),
                            ),
                            CustomIconButton(
                              height: 37,
                              width: 37,
                              margin: getMargin(left: 7, right: 5),
                              variant: IconButtonVariant.OutlineBluegray100,
                              padding: IconButtonPadding.PaddingAll6,
                              child: CustomImageView(
                                svgPath: Assets.imgCar,
                              ),
                            )
                          ],
                        ),
                      ),
                      dottedDivider(),
                      Padding(
                        padding: getPadding(left: 7, top: 12, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImageView(
                              url: carPicture,
                              fit: BoxFit.fill,
                              height: getSize(35.00),
                              width: getSize(35.00),
                              radius: BorderRadius.circular(
                                getHorizontalSize(17.00),
                              ),
                            ),
                            Padding(
                              padding: getPadding(left: 10, bottom: 3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(carName!,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppTextStyle
                                          .txtPTSansRegular12Gray600),
                                  Padding(
                                    padding: getPadding(top: 2),
                                    child: Text(
                                      carModel!,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppTextStyle
                                          .txtPTSansBold10Bluegray900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: getPadding(bottom: 15, right: 15),
                              child: Text(
                                carValue!,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppTextStyle.txtPTSansBold14Bluegray900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: getPadding(left: 25, top: 20, right: 17, bottom: 10),
                  decoration: AppDecoration.outlineBlack9000c1.copyWith(
                      borderRadius: BorderRadiusStyle.customBorderBL20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          CustomImageView(
                            url: userPicture,
                            height: getSize(36.00),
                            width: getSize(36.00),
                            margin: getMargin(bottom: 1),
                          ),
                          Padding(
                            padding: getPadding(left: 9, top: 9, bottom: 11),
                            child: Text(
                              traderName!,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppTextStyle.txtPTSansBold12Gray700,
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: getPadding(left: 33, top: 12, bottom: 12),
                            child: Text(
                              textTitle ?? labelSwapCash.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppTextStyle.txtPTSansBold10,
                            ),
                          ),
                          if (textTitle == swapAndCash.toUpperCase() ||
                              textTitle == cash.toUpperCase() ||
                              textTitle == swap.toUpperCase())
                            CustomIconButton(
                              height: 37,
                              width: 37,
                              margin: getMargin(left: 7, right: 5),
                              variant: IconButtonVariant.OutlineBluegray100,
                              padding: IconButtonPadding.PaddingAll6,
                              child: CustomImageView(
                                svgPath: textTitle != swap.toUpperCase()
                                    ? Assets.imgCarPlusCash
                                    : Assets.imgCar,
                              ),
                            ),

                          // imgIcon ??
                          //     CustomImageView(
                          //       svgPath: Assets.imgCarPlusCash,
                          //       height: getSize(37.00),
                          //       width: getSize(37.00),
                          //       margin: getMargin(left: 15, right: 15),
                          //     )
                        ],
                      ),
                      if (isCar == true) dottedDivider(),
                      if (isCar == true)
                        Padding(
                          padding: getPadding(top: 20, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomImageView(
                                url: carPicture,
                                fit: BoxFit.fill,
                                height: getSize(35.00),
                                width: getSize(35.00),
                                radius: BorderRadius.circular(
                                  getHorizontalSize(17.00),
                                ),
                              ),
                              Padding(
                                padding: getPadding(left: 10, bottom: 3),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(carName!,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppTextStyle
                                            .txtPTSansRegular12Gray600),
                                    Padding(
                                      padding: getPadding(top: 2),
                                      child: Text(
                                        carModel!,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppTextStyle
                                            .txtPTSansBold10Bluegray900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: getPadding(bottom: 15, right: 15),
                                child: Text(
                                  carValue!,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style:
                                      AppTextStyle.txtPTSansBold14Bluegray900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (isCash == true) dottedDivider(),
                      if (isCash == true)
                        Padding(
                          padding: getPadding(top: 5),
                          child: Row(
                            children: [
                              CustomIconButton(
                                height: 37,
                                width: 37,
                                variant: IconButtonVariant.OutlineBluegray100,
                                padding: IconButtonPadding.PaddingAll6,
                                child: const CustomImageView(
                                  svgPath: Assets.imgCash,
                                ),
                                onTap: () {
                                  // onTapBtnCamera();
                                },
                              ),
                              Padding(
                                padding: getPadding(left: 10),
                                child: Text(
                                  cashHistory.toUpperCase() +
                                      (payType != null
                                          ? '  (${payType!.toLowerCase()})'
                                          : ''),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppTextStyle.txtPTSansRegular12Gray600,
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding:
                                    getPadding(top: 9, bottom: 8, right: 15),
                                child: Text(
                                  carValue!, //
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style:
                                      AppTextStyle.txtPTSansBold14Bluegray900,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: getVerticalSize(120),
              left: getHorizontalSize(size.width / 4),
              child: GradientElevatedButton(
                width: 120,
                height: 40,
                onTap: () {},
                title: btnTitle ?? swapAndCash.toUpperCase(),
                buttonGradient: LinearGradient(
                  begin: const Alignment(
                    0.5,
                    0,
                  ),
                  end: const Alignment(
                    0.5,
                    1,
                  ),
                  colors: [
                    ColorConstant.pink700,
                    ColorConstant.pink900,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dottedDivider() {
    return Container(
      height: getVerticalSize(1.00),
      width: getHorizontalSize(262.00),
      margin: getMargin(left: 1, top: 13),
      child: const DottedLine(
        dashColor: Color(0xff7C7C7C),
      ),
    );
  }
}
