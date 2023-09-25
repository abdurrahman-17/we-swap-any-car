import 'dart:developer';

import '../../model/payment/payment_response_model.dart';
import '../../model/user/subscription.dart';
import '../../model/user/user_model.dart';
import '../../bloc/payment/payment_bloc.dart';
import '../../core/configurations.dart';
import '../common_widgets/common_loader.dart';
import 'payment_web_view.dart';

class PaymentScreen extends StatefulWidget {
  static const String routeName = "PaymentScreen";
  const PaymentScreen({
    super.key,
    this.plan,
    required this.user,
    this.premiumPostId,
    this.carId,
  });

  final SubscriptionModel? plan;
  final UserModel user;
  final String? premiumPostId;
  final String? carId;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.plan != null) {
      log("Subscription Pay as you go checkout");
      final Map<String, dynamic> jsonBody = {
        "amount": widget.plan!.amount,
        "amountDescription": widget.plan!.description,
        "userId": widget.user.userId,
        "userEmail": widget.user.email,
        "userPhone": widget.user.phone,
        "planId": widget.plan!.sId,
        "traderId": widget.user.trader?.id,
        "planName": widget.plan!.name,
      };
      BlocProvider.of<PaymentBloc>(context)
          .add(GetCheckoutDetailsEvent(checkoutData: jsonBody));
    } else {
      log("Premium post checkout");
      final Map<String, dynamic> jsonBody = {
        "carId": widget.carId,
        "userId": widget.user.userId,
        "userEmail": widget.user.email,
        "userPhone": widget.user.phone,
        "planId": widget.premiumPostId,
        "traderId": widget.user.trader?.id,
        "paymentType": "premium",
      };
      BlocProvider.of<PaymentBloc>(context)
          .add(GetCheckoutDetailsEvent(checkoutData: jsonBody));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, state) {
            if (state is CheckoutResponseState) {
              if (state.checkoutDataFetchStatus == ProviderStatus.success) {
                return PaymentWebView(
                  url: state.paymentCheckoutResponse!.checkoutLink!,
                );
              } else if (state.checkoutDataFetchStatus ==
                  ProviderStatus.error) {
                Navigator.pop(
                  context,
                  PaymentResponseModel(
                      isSuccess: false,
                      message: state.errorMessage == payAsyouGoLimitExceededMsg
                          ? payAsyouGoLimitExceededMsg
                          : paymentApiFailed),
                );
              }
            }
            return shimmerPaymentLoader(context);
          },
        ),
      ),
    );
  }
}

Widget shimmerPaymentLoader(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.h),
          Text(
            "Payment Details",
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 30),
          ),
          SizedBox(height: 5.h),
          for (int i = 0; i < 12; i++)
            shimmerLoader(
              Container(
                margin: getMargin(top: 6),
                height: i % 2 == 0 ? 20 : 40,
                width: i % 2 == 0 ? getHorizontalSize(200) : null,
                decoration: BoxDecoration(
                  color: ColorConstant.kColorWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          shimmerLoader(
            Container(
              margin: getMargin(top: 16, left: 20, right: 20),
              height: 35,
              decoration: BoxDecoration(
                color: ColorConstant.kColorWhite,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
