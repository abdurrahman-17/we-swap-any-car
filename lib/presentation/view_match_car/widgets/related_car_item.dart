import '../../../core/configurations.dart';
import '../../../model/car_model/car_model.dart';
import '../../common_widgets/common_quick_offer_banner.dart';

class RelatedCarItem extends StatelessWidget {
  const RelatedCarItem({Key? key, required this.car}) : super(key: key);
  final CarModel car;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getHorizontalSize(size.width / 1.7),
      decoration: AppDecoration.outlineBlack90021.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CustomImageView(
                url: car.uploadPhotos?.rightImages?.first,
                width: double.infinity,
                height: getVerticalSize(size.height / 7),
                radius: BorderRadius.circular(20.r),
                fit: BoxFit.contain,
              ),
              if (car.postType == convertEnumToString(CarPostType.premium))
                Positioned(
                  top: 15,
                  right: 15,
                  child: CustomImageView(
                    svgPath: Assets.premium,
                    height: getVerticalSize(25),
                  ),
                ),
              Container(
                width: double.infinity,
                alignment: Alignment.bottomLeft,
                padding: getPadding(all: 16),
                decoration: AppDecoration.gradientBlack90093Black90093.copyWith(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: getPadding(top: 16.h),
                      child: Text(
                        car.manufacturer?.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppTextStyle.txtOswaldRegular12,
                      ),
                    ),
                    Text(
                      car.model ?? '',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyle.txtPTSansBold10,
                    )
                  ],
                ),
              ),
              if (car.quickSale ?? false) const QuickOfferBanner(),
            ],
          ),
          Padding(
            padding: getPadding(top: 8.h, left: 16.w, right: 16.w),
            child: Text(
              euro + currencyFormatter(car.userExpectedValue ?? 0),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppTextStyle.txtOswaldRegular16Bluegray900,
            ),
          ),
          Padding(
            padding: getPadding(
              left: 16.w,
              top: 2.h,
              bottom: 15.h,
              right: 16.w,
            ),
            child: Text(
              '${(car.fuelType?.name ?? notApplicable).toUpperCase()}'
              '$mileageOfVehicle${currencyFormatter(car.mileage!)} '
              '${milesLabel.toUpperCase()}',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppTextStyle.txtPTSansBold10Bluegray900,
            ),
          )
        ],
      ),
    );
  }
}
