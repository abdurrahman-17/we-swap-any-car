import '../../bloc/subscription/subscription_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../core/configurations.dart';
import '../../model/payment/payment_response_model.dart';
import '../../model/user/subscription.dart';
import '../../model/user/user_model.dart';
import '../../utility/common_keys.dart';
import '../add_car/add_car_stepper_screen.dart';
import '../common_widgets/common_admin_support_button.dart';
import '../common_widgets/common_loader.dart';
import '../common_widgets/common_popups.dart';
import '../error_screen/error_widget.dart';
import '../payment/payment_screen.dart';
import 'widgets/subscription_tile.dart';
import 'paid_plan_screen.dart';

class SubscriptionPage extends StatefulWidget {
  static const String routeName = "subscription_page";
  const SubscriptionPage({
    Key? key,
    this.userUpgradeData,
    this.payAsyouGoExpired,
    this.traderInactive,
  }) : super(key: key);

  final Map<String, dynamic>? userUpgradeData;
  final bool? payAsyouGoExpired;
  final bool? traderInactive;

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int isSelectedIndex = 0;
  UserModel? user;
  late SubscriptionBloc subscriptionBloc;
  bool userDataUpdateFailed = false;

  @override
  void initState() {
    user = context.read<UserBloc>().currentUser;
    subscriptionBloc = BlocProvider.of<SubscriptionBloc>(context);
    getSubscriptionData();
    super.initState();
  }

  //fetch subscription plans
  void getSubscriptionData() {
    subscriptionBloc.add(GetSubscriptionDataEvent());
  }

  //update user data
  void updateCurrentUserData() {
    progressLoad(true);
    delayedStart(() {
      BlocProvider.of<UserBloc>(context)
          .add(GetCurrentUserDataEvent(key: emailKey, value: user!.email!));
    }, duration: const Duration(seconds: 1));
  }

  //upgrade subscription plan
  void upgradeSubscriptionApiCall(SubscriptionModel subscriptionItem) async {
    progressLoad(true);
    subscriptionBloc.add(UpgradeSubscriptionPlanEvent(
      planData: {
        "companyName": user?.trader?.companyName,
        "email": user?.email,
        "planId": subscriptionItem.sId,
        "firstName": user?.firstName,
        "planName": subscriptionItem.name,
        "planType": subscriptionItem.type,
        "traderId": user?.trader?.id,
        "userId": user?.userId,
      },
      subscriptionPageName: SubscriptionPageName.mySubscription,
    ));
  }

//pay as you go success
  void payAsYouGoPaymentSuccessAction() {
    Navigator.pushNamedAndRemoveUntil(
        context, AddCarStepperScreen.routeName, (route) => false);
    delayedStart(() {
      showSnackBar(message: paymentDoneSuccess);
    }, duration: const Duration(milliseconds: 500));
  }

  void updateUserApiCall(SubscriptionModel subscriptionItem,
      List<SubscriptionModel> subscriptionPlans) async {
    if (subscriptionItem.type ==
        convertEnumToString(SubscriptionsType.freeTrial)) {
      Navigator.pushNamed(
        context,
        PaidSubscriptionScreen.routeName,
        arguments: {
          "subscriptionPlans": subscriptionPlans,
          "plan": subscriptionItem,
        },
      );
    } else if (widget.userUpgradeData != null) {
      BlocProvider.of<UserBloc>(context).add(UpgradeToDealerEvent(
        userData: widget.userUpgradeData!,
        planId: subscriptionItem.sId!,
        planName: subscriptionItem.name!,
        planType: subscriptionItem.type!,
        userId: user!.userId!,
      ));
    } else {
      // paid subscriptions
      subscriptionBloc.add(AddSubscriptionPlanEvent(
        planData: {
          "companyName": user?.trader?.companyName,
          "firstName": user?.firstName,
          "lastName": user?.lastName,
          "town": user?.town,
          "email": user?.email,
          "planId": subscriptionItem.sId,
          "planName": subscriptionItem.name,
          "planType": subscriptionItem.type,
          "traderId": user?.trader?.id,
          "userId": user?.userId
        },
        subscriptionPageName: SubscriptionPageName.initialPage,
      ));
    }
  }

  void payAsYouGoAction(SubscriptionModel subscriptionItem) async {
    final PaymentResponseModel? paymentResponse = await Navigator.pushNamed(
      context,
      PaymentScreen.routeName,
      arguments: {"plan": subscriptionItem, "user": user},
    );

    if (paymentResponse != null) {
      //success
      if (paymentResponse.isSuccess!) {
        updateCurrentUserData();
      }
      //fail
      else {
        showSnackBar(message: paymentResponse.message ?? '');
        //payment failed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is GetUserDataState) {
          if (state.userDataFetchStatus == ProviderStatus.success) {
            progressLoad(false);
            payAsYouGoPaymentSuccessAction();
          } else if (state.userDataFetchStatus == ProviderStatus.error) {
            progressLoad(false);
            showSnackBar(message: state.errorMessage ?? errorOccurred);
            setState(() {
              userDataUpdateFailed = true;
            });
          }
        } else if (state is UpgradeToDealerState) {
          if (state.upgradeToDealerStatus == ProviderStatus.success) {
            progressLoad(false);
            if (state.user?.status ==
                convertEnumToString(SubscriptionChangeStatus.approved)) {
              Navigator.pushNamedAndRemoveUntil(
                  context, AddCarStepperScreen.routeName, (route) => false);
              showSnackBar(message: paymentDoneSuccess);
            } else {
              infoOrThankyouPopup(
                subTitle: forCHoosingWSACMsg,
                message: subscriptionThanks,
                buttonText: closeButton,
                isThankYou: true,
                onTapButton: () {
                  Navigator.pop(context);
                  progressLoad(true);
                  logoutAction();
                },
              );
            }
          } else if (state.upgradeToDealerStatus == ProviderStatus.error) {
            //error
            progressLoad(false);
            showSnackBar(message: upgradeToDealerFailedMsg);
          } else if (state.upgradeToDealerStatus == ProviderStatus.loading) {
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
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 25, left: 25),
                    child: Container(
                      padding: const EdgeInsets.only(left: 13),
                      width: size.width,
                      height: 33,
                      decoration: BoxDecoration(
                        color: ColorConstant.kblackColor12,
                        borderRadius: BorderRadiusStyle.roundedBorder15,
                      ),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          topMessage,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  BlocConsumer<SubscriptionBloc, SubscriptionState>(
                      listener: (context, state) {
                    if (state is AddSubscriptionPlanState &&
                        state.subscriptionPageName ==
                            SubscriptionPageName.initialPage) {
                      if (state.subscriptionAddStatus ==
                          ProviderStatus.success) {
                        progressLoad(false);
                        infoOrThankyouPopup(
                          subTitle: forCHoosingWSACMsg,
                          message: subscriptionThanks,
                          buttonText: closeButton,
                          isThankYou: true,
                          onTapButton: () {
                            Navigator.pop(context);
                            progressLoad(true);
                            logoutAction();
                          },
                        );
                      } else if (state.subscriptionAddStatus ==
                          ProviderStatus.error) {
                        //error
                        progressLoad(false);
                        showSnackBar(message: paymentApiFailed);
                      } else if (state.subscriptionAddStatus ==
                          ProviderStatus.loading) {
                        //loading
                        progressLoad(true);
                      }
                    } else if (state is UpgradeSubscriptionPlanState) {
                      if (state.subscriptionUpgradeStatus ==
                          ProviderStatus.success) {
                        progressLoad(false);
                        infoOrThankyouPopup(
                          subTitle: forCHoosingWSACMsg,
                          message: subscriptionThanks,
                          buttonText: closeButton,
                          isThankYou: true,
                          onTapButton: () {
                            Navigator.pop(context);
                            progressLoad(true);
                            logoutAction();
                          },
                        );
                      } else if (state.subscriptionUpgradeStatus ==
                          ProviderStatus.error) {
                        //error
                        progressLoad(false);
                        showSnackBar(message: paymentApiFailed);
                      }
                    }
                  }, builder: (context, state) {
                    if (state is GetSubscriptionDataState ||
                        state is AddSubscriptionPlanState) {
                      if (state is GetSubscriptionDataState &&
                              state.subscriptionDataStatus ==
                                  ProviderStatus.success ||
                          state is AddSubscriptionPlanState) {
                        return userDataUpdateFailed
                            ? errorBuild(
                                errorMessage: errorOccurredWhileFetch,
                                buttonLabel: retryButton,
                                onTap: updateCurrentUserData)
                            : subscriptionItems();
                      } else if ((state is GetSubscriptionDataState &&
                              state.subscriptionDataStatus ==
                                  ProviderStatus.error) ||
                          (state is AddSubscriptionPlanState &&
                              state.subscriptionAddStatus ==
                                  ProviderStatus.error)) {
                        return errorBuild(
                            errorMessage: state is GetSubscriptionDataState
                                ? getSubscriptionApiFailErrorMsg
                                : addNewSubscriptionApiFailErrorMsg,
                            buttonLabel: state is GetSubscriptionDataState
                                ? retryButton
                                : reloadButton,
                            onTap: getSubscriptionData);
                      }
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: 4,
                      padding: getPadding(left: 20.w, right: 20.w, top: 10.h),
                      itemBuilder: (ctx, index) {
                        return shimmerLoader(
                          AspectRatio(
                            aspectRatio: 1.8,
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              margin: getMargin(top: 5.h, bottom: 5.h),
                              decoration: BoxDecoration(
                                color: ColorConstant.kColorWhite,
                                borderRadius: BorderRadius.circular(21.r),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  })
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget errorBuild({
    required String errorMessage,
    required String buttonLabel,
    required void Function() onTap,
  }) {
    return Container(
      alignment: Alignment.topCenter,
      margin: getMargin(top: size.height * 0.15),
      height: size.height,
      child: ErrorWithButtonWidget(
        message: errorMessage,
        buttonLabel: buttonLabel,
        onTap: onTap,
      ),
    );
  }

  void progressLoad(bool value) {
    if (value) {
      progressDialogue();
    } else {
      Navigator.pop(context);
    }
  }

  Widget subscriptionItems() {
    ///for upgrade user remobing freeTrail and payAsYouGo plans
    List<SubscriptionModel> subscriptions = subscriptionBloc.subscriptionPlans;
    if (widget.userUpgradeData != null) {
      subscriptions = subscriptionBloc.subscriptionPlans
          .where((element) => (element.type !=
                  convertEnumToString(SubscriptionsType.freeTrial) &&
              (element.type !=
                  convertEnumToString(SubscriptionsType.payAsYouGo))))
          .toList();
    }
    //pay as you go expired || trader account inactive
    if ((widget.payAsyouGoExpired != null && widget.payAsyouGoExpired!) ||
        (widget.traderInactive != null && widget.traderInactive!)) {
      subscriptions = subscriptionBloc.subscriptionPlans
          .where((element) => (element.type !=
              convertEnumToString(SubscriptionsType.freeTrial)))
          .toList();
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: subscriptions.length,
      padding: EdgeInsets.symmetric(
        horizontal: 32.w,
        vertical: 15.h,
      ),
      itemBuilder: (context, index) {
        final subscriptionItem = subscriptions[index];
        return SubscriptionTile(
          isSelectedIndex: isSelectedIndex,
          payAsYouGoExpired: widget.payAsyouGoExpired ?? false,
          initialIndex: index,
          plan: subscriptionItem,
          onTap: () {},
          onTapPayNow: () async {
            bool isOk = await confirmationPopup(
              title: confirmTitle,
              message: areYouWantToSubscribe,
              isQuestion: true,
            );
            if (isOk) {
              payAsYouGoAction(subscriptionItem);
            }
          },
          onTapFreeTrial: () async {
            bool isOk = await confirmationPopup(
              title: confirmTitle,
              message: areYouWantToSubscribe,
              isQuestion: true,
            );

            if (isOk) {
              infoOrThankyouPopup(
                subTitle: forFreetrialChoosePaidPlan,
                buttonText: nextButton,
                isThankYou: true,
                onTapButton: () {
                  Navigator.pop(context);
                  updateUserApiCall(subscriptionItem, subscriptions);
                },
              );
            }
          },
          onTapSubscribe: () async {
            if (widget.traderInactive != null && widget.traderInactive!) {
              infoOrThankyouPopup(
                message: traderAccountStatusMsg,
                buttonText: closeButton,
                onTapButton: () {
                  Navigator.pop(context);
                },
              );
            } else {
              bool isOk = await confirmationPopup(
                title: "CONFIRM",
                message: areYouWantToSubscribe,
                isQuestion: true,
              );
              if (isOk) {
                if (widget.payAsyouGoExpired != null &&
                    widget.payAsyouGoExpired!) {
                  upgradeSubscriptionApiCall(subscriptionItem);
                } else {
                  updateUserApiCall(subscriptionItem, subscriptions);
                }
              }
            }
          },
          onTapContactUs: () async {
            if (widget.traderInactive != null && widget.traderInactive!) {
              infoOrThankyouPopup(
                message: traderAccountStatusMsg,
                buttonText: closeButton,
                onTapButton: () {
                  Navigator.pop(context);
                },
              );
            } else {
              bool isOk = await confirmationPopup(
                title: confirmTitle,
                message: areYouWantToSubscribe,
                isQuestion: true,
              );
              if (isOk) {
                if (widget.payAsyouGoExpired != null &&
                    widget.payAsyouGoExpired!) {
                  upgradeSubscriptionApiCall(subscriptionItem);
                } else {
                  updateUserApiCall(subscriptionItem, subscriptions);
                }
              }
            }
          },
        );
      },
    );
  }
}
