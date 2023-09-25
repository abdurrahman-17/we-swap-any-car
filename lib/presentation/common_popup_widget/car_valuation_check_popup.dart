import '../../core/configurations.dart';
import '../../main.dart';
import '../../model/car_model/car_model.dart';
import '../common_widgets/common_popups.dart';
import '../add_car/screens/check_car_valuation/car_valuation_wow.dart';
import 'add_edit_car_valuation_popup.dart';

class CarValuationCheckPopup extends StatelessWidget {
  const CarValuationCheckPopup({
    super.key,
    required this.carModel,
  });

  final CarModel carModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomImageView(
          svgPath: Assets.checkPopupBg,
          fit: BoxFit.fill,
          radius: BorderRadius.only(
            bottomLeft: Radius.circular(40.r),
            bottomRight: Radius.circular(40.r),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 30.w, right: 30.w, bottom: 15.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImageView(
                svgPath: Assets.sittedManChairTable,
                fit: BoxFit.fill,
                margin: EdgeInsets.only(top: 58.h, bottom: 28.h),
              ),
              CustomImageView(
                svgPath: Assets.sadEmoji,
                fit: BoxFit.fill,
                margin: EdgeInsets.only(bottom: 12.h),
              ),
              Text(
                sorry,
                style: AppTextStyle.regularTextStyle.copyWith(
                  fontSize: 22.sp,
                  color: ColorConstant.kColor353333,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                detailsMissing,
                style: AppTextStyle.regularTextStyle.copyWith(
                  color: ColorConstant.kColor7C7C7C,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.h),
                child: CustomElevatedButton(
                  title: enterManuallyButton,
                  onTap: () {
                    Navigator.pop(context);
                    onTapOpenAddValuePopup();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> onTapOpenAddValuePopup() async {
    final result =
        await customPopup(content: AddEditCarValuationPopup(fromEdit: false));

    carModel.userExpectedValue = result as num;
    carModel.wsacValue = result;
    Navigator.pushNamed(
      globalNavigatorKey.currentContext!,
      CarValuationWowScreen.routeName,
      arguments: {"carModel": carModel},
    );
  }
}
