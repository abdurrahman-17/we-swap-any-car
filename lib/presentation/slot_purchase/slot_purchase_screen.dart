import '../../core/configurations.dart';
import '../subscription/side_menu/my_subscription_tabs/dealer_account.dart';

class SlotPurchase extends StatefulWidget {
  static const String routeName = "SlotPurchase";
  const SlotPurchase({
    super.key,
    required this.subscriptionPageName,
  });

  final SubscriptionPageName subscriptionPageName;

  @override
  State<SlotPurchase> createState() => _SlotPurchaseState();
}

class _SlotPurchaseState extends State<SlotPurchase> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        title: subscriptionAppBar,
        body: SubscriptionDealerAccountTab(
          subscriptionPageName: widget.subscriptionPageName,
        ));
  }
}
