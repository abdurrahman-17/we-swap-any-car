import '../../../core/configurations.dart';
import 'widgets/payment_history_tile.dart';

class PremiumPaymentHistory extends StatefulWidget {
  static const String routeName = 'premium_post_payment_history';
  final List<Map<String, dynamic>> premiumPostLogs;

  const PremiumPaymentHistory({
    super.key,
    required this.premiumPostLogs,
  });

  @override
  State<PremiumPaymentHistory> createState() => _PremiumPaymentHistoryState();
}

class _PremiumPaymentHistoryState extends State<PremiumPaymentHistory> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        title: paymentHistoryAppBar,
        body: Stack(
          children: [
            CustomImageView(
              imagePath: Assets.redMountainWithWhite,
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
            ),
            SingleChildScrollView(
              child: Padding(
                padding: getPadding(bottom: 25),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: getPadding(left: 20.w, right: 20.w, top: 15.h),
                  itemBuilder: (ctx, int index) {
                    return PaymentHistoryTile(
                      paymentHistoryData: widget.premiumPostLogs[index],
                    );
                  },
                  itemCount: widget.premiumPostLogs.length,
                ),
              ),
            ),
          ],
        ));
  }
}
