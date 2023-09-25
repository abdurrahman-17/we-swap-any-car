import '../../../../core/configurations.dart';
import '../../../../utility/date_time_utils.dart';

class PaymentHistoryTile extends StatelessWidget {
  const PaymentHistoryTile({
    Key? key,
    required this.paymentHistoryData,
  }) : super(key: key);

  final Map<String, dynamic> paymentHistoryData;

  @override
  Widget build(BuildContext context) {
    final RegExp regexToRemoveDecimalIfZero = RegExp(r'([.]*0)(?!.*\d)');
    final amount = paymentHistoryData['amount']
        .toString()
        .replaceAll(regexToRemoveDecimalIfZero, '');
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 5.h,
            horizontal: 19.w,
          ),
          margin: EdgeInsets.symmetric(vertical: 6.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: ColorConstant.kColorWhite),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    customDateFormat(DateTime.parse(
                        paymentHistoryData['createdAt'].toString())),
                    style: AppTextStyle.regularTextStyle.copyWith(
                      color: ColorConstant.black90090,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "DONE",
                    style: AppTextStyle.regularTextStyle.copyWith(
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.greenA700),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: transactionIdPaymentHistory,
                          style: AppTextStyle.regularTextStyle.copyWith(
                            color: ColorConstant.black90090,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: paymentHistoryData['transactionId'].toString(),
                          style: AppTextStyle.regularTextStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.black900,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '£$amount',
                    style: AppTextStyle.regularTextStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.black900,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
