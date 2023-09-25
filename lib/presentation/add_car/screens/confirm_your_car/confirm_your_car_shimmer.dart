import '../../../../core/configurations.dart';
import '../../../common_widgets/common_loader.dart';
import '../../../common_widgets/field_label.dart';

class ConfirmYourCarShimmer extends StatelessWidget {
  const ConfirmYourCarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: getPadding(top: 15.h, left: 25.w, right: 25.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vehicleDetailsTitle,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppTextStyle.txtPTSansRegular16,
            ),

            ///BRAND
            Padding(
                padding: getPadding(top: 16.h, bottom: 6.h),
                child: const FieldLabelWidget(
                  label: brandNameLabel,
                  isMandatory: true,
                )),
            shimmerLoader(
              Container(
                height: getVerticalSize(41.h),
                decoration: BoxDecoration(
                  color: ColorConstant.kColorWhite,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),

            ///MODEL
            Padding(
              padding: getPadding(top: 10.h, bottom: 6.h),
              child: const FieldLabelWidget(
                label: modelLabel,
                isMandatory: true,
              ),
            ),
            shimmerLoader(
              Container(
                height: getVerticalSize(41.h),
                decoration: BoxDecoration(
                  color: ColorConstant.kColorWhite,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            const CarConfirmDropDownFieldsShimmers(),
          ],
        ),
      ),
    );
  }
}

class CarConfirmDropDownFieldsShimmers extends StatelessWidget {
  const CarConfirmDropDownFieldsShimmers({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: getPadding(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //MANUFACTURE YEAR
              shimmerDropDown(label: yearDropDownLabel),
              SizedBox(width: 15.w),

              ///ENGINE SIZE
              shimmerDropDown(label: engineSizeLabel),
            ],
          ),
        ),
        Padding(
          padding: getPadding(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///NUMBER OF DOORS
              shimmerDropDown(label: noOfDoorsDropDownLabel),
              SizedBox(width: 15.w),
              //FUEL TYPE
              shimmerDropDown(label: fuelTypeDropDownLabel),
            ],
          ),
        ),

        ///BODY TYPE
        Padding(
          padding: getPadding(top: 10.h, bottom: 6.h),
          child: const FieldLabelWidget(
            label: bodyTypeLabel,
            isMandatory: true,
          ),
        ),
        shimmerLoader(
          Container(
            height: getVerticalSize(41.h),
            decoration: BoxDecoration(
              color: ColorConstant.kColorWhite,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),

        ///CAR COLOR
        Padding(
          padding: getPadding(top: 10.h, bottom: 6.h),
          child: const FieldLabelWidget(
            label: colorDropDownLabel,
            isMandatory: true,
          ),
        ),
        shimmerLoader(
          Container(
            height: getVerticalSize(41.h),
            decoration: BoxDecoration(
              color: ColorConstant.kColorWhite,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),

        ///TRANSMISSION TYPE
        Padding(
          padding: getPadding(top: 10.h, bottom: 6.h),
          child: const FieldLabelWidget(
            label: transmissionLabel,
            isMandatory: true,
          ),
        ),
        shimmerLoader(
          Container(
            height: getVerticalSize(41.h),
            decoration: BoxDecoration(
              color: ColorConstant.kColorWhite,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ],
    );
  }

  Widget shimmerDropDown({required String label}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldLabelWidget(
            label: label,
            isMandatory: true,
          ),
          shimmerLoader(
            Container(
              margin: getMargin(top: 6.h),
              height: getVerticalSize(41.h),
              decoration: BoxDecoration(
                color: ColorConstant.kColorWhite,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
