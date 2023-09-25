import '../../core/configurations.dart';
import 'common_stepper_badge.dart';

class ProcessingTile extends StatelessWidget {
  const ProcessingTile({
    Key? key,
    required this.stepNumber,
    required this.title,
    required this.subTitle,
    this.hasStepBadge = false,
    this.status,
    this.onTap,
    required this.isMandatory,
    this.isEnabled = true,
  }) : super(key: key);
  final GestureTapCallback? onTap;
  final String title;
  final String subTitle;
  final ProgressStatus? status;
  final int stepNumber;
  final bool? hasStepBadge;
  final bool isMandatory;
  final bool? isEnabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: getPadding(top: 17.h, bottom: 17.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ProgressBagde(status: status),
                      SizedBox(width: 10.w),
                      if (hasStepBadge ?? false)
                        Container(
                          padding: getPadding(
                            left: 7.w,
                            right: 7.w,
                            top: 4.h,
                            bottom: 4.h,
                          ),
                          margin: getMargin(right: 8.w),
                          decoration: BoxDecoration(
                            color: !(isEnabled ?? false)
                                ? ColorConstant.kColorE2E2E2
                                : null,
                            borderRadius: BorderRadius.circular(5),
                            gradient: isEnabled ?? false
                                ? LinearGradient(colors: kPrimaryGradientColor)
                                : null,
                          ),
                          child: Text(
                            'STEP $stepNumber',
                            style: AppTextStyle.regularTextStyle.copyWith(
                              color: isEnabled ?? false
                                  ? ColorConstant.kColorWhite
                                  : ColorConstant.kColorBlack.withOpacity(0.4),
                              fontSize: getFontSize(10),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      RichText(
                        text: TextSpan(
                          text: title,
                          style: AppTextStyle.regularTextStyle.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isEnabled ?? false
                                ? ColorConstant.kPrimaryDarkRed
                                : ColorConstant.kGreyColor,
                          ),
                          children: [
                            if (isMandatory)
                              const TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: hasStepBadge ?? false ? 10.h : 8.h),
                  Padding(
                    padding: getPadding(left: 31),
                    child: Text(
                      subTitle,
                      style: AppTextStyle.regularTextStyle.copyWith(
                        fontSize: getFontSize(13),
                        color: ColorConstant.kColor7C7C7C,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: getSize(18),
              color: isEnabled ?? false
                  ? ColorConstant.kPrimaryDarkRed
                  : ColorConstant.kGreyColor,
            ),
          ],
        ),
      ),
    );
  }
}
