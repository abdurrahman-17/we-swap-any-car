import 'dart:developer';

import '../../bloc/subscription/subscription_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../core/configurations.dart';
import '../../model/user/subscription.dart';
import '../../model/user/user_model.dart';
import '../add_car/add_car_stepper_screen.dart';
import '../common_widgets/common_admin_support_button.dart';
import '../common_widgets/common_popups.dart';
import '../common_widgets/common_loader.dart';
import 'widgets/subscription_tile.dart';

class PaidSubscriptionScreen extends StatefulWidget {
  static const String routeName = "paid_subscription_screen";
  const PaidSubscriptionScreen({
    super.key,
    required this.subscriptionPlans,
    required this.plan,
  });

  final List<SubscriptionModel> subscriptionPlans;
  final SubscriptionModel plan;

  @override
  State<PaidSubscriptionScreen> createState() => _PaidSubscriptionScreenState();
}

class _PaidSubscriptionScreenState extends State<PaidSubscriptionScreen> {
  int isSelectedIndex = -1;
  List<SubscriptionModel> paidPlans = [];
  UserModel? user;

  @override
  void initState() {
    super.initState();
    user = context.read<UserBloc>().currentUser;
    paidPlans = widget.subscriptionPlans
        .where((element) =>
            element.type != convertEnumToString(SubscriptionsType.freeTrial) &&
            element.type != convertEnumToString(SubscriptionsType.payAsYouGo))
        .toList();
  }

  void updateSubscription(SubscriptionModel subscriptionItem) {
    BlocProvider.of<SubscriptionBloc>(context)
        .add(AddSubscriptionPlanEvent(planData: {
      "companyName": user?.trader?.companyName,
      "email": user?.email,
      "firstName": user?.firstName,
      "lastName": user?.lastName,
      "town": user?.town,
      "planId": widget.plan.sId,
      "planName": widget.plan.name,
      "planType": widget.plan.type,
      "traderId": user?.trader?.id,
      "userId": user?.userId,
      "upcomingPlanId": subscriptionItem.sId,
    }, subscriptionPageName: SubscriptionPageName.freeTrailPage));
  }

  void progressLoad(bool value) {
    if (value) {
      progressDialogue(isCircularProgress: true);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionBloc, SubscriptionState>(
      listener: (context, state) {
        if (state is AddSubscriptionPlanState &&
            state.subscriptionPageName == SubscriptionPageName.freeTrailPage) {
          if (state.subscriptionAddStatus == ProviderStatus.success) {
            progressLoad(false);

            if (state.subscriptionsData?.status ==
                convertEnumToString(SubscriptionChangeStatus.approved)) {
              showSnackBar(message: paymentDoneSuccess);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AddCarStepperScreen.routeName,
                (route) => false,
              );
            } else {
              infoOrThankyouPopup(
                isThankYou: true,
                subTitle: forCHoosingWSACMsg,
                message: subscriptionThanks,
                buttonText: closeButton,
                onTapButton: () {
                  Navigator.pop(context);
                  progressLoad(true);
                  logoutAction();
                  log("logout action");
                },
              );
            }
          } else if (state.subscriptionAddStatus == ProviderStatus.error) {
            //error
            progressLoad(false);
            showSnackBar(message: paymentApiFailed);
          } else if (state.subscriptionAddStatus == ProviderStatus.loading) {
            //loading
            progressLoad(true);
          }
        }
      },
      child: CustomScaffold(
        title: subscriptionAppBar,
        actions: const [
          AdminSupportButton(),
        ],
        body: Stack(
          children: [
            CustomImageView(
              svgPath: Assets.homeBackground,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
            ),
            ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: paidPlans.length,
                  padding:
                      EdgeInsets.symmetric(horizontal: 35.w, vertical: 15.h),
                  itemBuilder: (context, index) {
                    final subscriptionItem = paidPlans[index];
                    return SubscriptionTile(
                      isSelectedIndex: isSelectedIndex,
                      initialIndex: index,
                      plan: subscriptionItem,
                      payAsYouGoExpired: false,
                      onTap: () {},
                      onTapPayNow: () async {},
                      onTapFreeTrial: () async {
                        bool isOk = await confirmationPopup(
                          title: confirmTitle,
                          message: thankYouForCHoosingFreeTrial,
                        );
                        if (isOk) updateSubscription(subscriptionItem);
                      },
                      onTapContactUs: () async {
                        bool isOk = await confirmationPopup(
                          title: confirmTitle,
                          message: areYouWantToSubscribe,
                          isQuestion: true,
                        );
                        if (isOk) updateSubscription(subscriptionItem);
                      },
                      onTapSubscribe: () async {
                        setState(() {
                          isSelectedIndex = index;
                        });
                        bool isOk = await confirmationPopup(
                          title: confirmTitle,
                          message: areYouWantToSubscribe,
                          isQuestion: true,
                        );
                        if (isOk) updateSubscription(subscriptionItem);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
