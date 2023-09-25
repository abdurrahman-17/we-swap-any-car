import '../../../../core/configurations.dart';
import '../../../../model/car_summary_model.dart';

class CarInfoCardWidget extends StatelessWidget {
  const CarInfoCardWidget({super.key, required this.carInfo});

  final CarSummaryDetails carInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 11.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              carInfo.label,
              style: AppTextStyle.smallTextStyle.copyWith(
                color: ColorConstant.kColorC2512E,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              carInfo.value,
              style: AppTextStyle.regularTextStyle.copyWith(
                color: ColorConstant.kColorBlack,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
