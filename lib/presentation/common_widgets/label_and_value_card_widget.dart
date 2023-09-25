import '../../core/configurations.dart';

class LabelAndValueCardWidget extends StatelessWidget {
  const LabelAndValueCardWidget({
    super.key,
    required this.label,
    required this.value,
    this.valueOverflow,
  });

  final String label;
  final String value;
  final TextOverflow? valueOverflow;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 11.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyle.smallTextStyle.copyWith(
                color: ColorConstant.kColorC2512E,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              value,
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
