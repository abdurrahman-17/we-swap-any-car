import 'package:enum_to_string/enum_to_string.dart';

import '../../../../bloc/subscription/subscription_bloc.dart';
import '../../../../bloc/user/user_bloc.dart';
import '../../../../core/configurations.dart';
import '../../../../model/payment/payment_response_model.dart';
import '../../../../model/user/subscription.dart';
import '../../../../model/user/user_model.dart';
import '../../../../utility/common_keys.dart';
import '../../../../utility/date_time_utils.dart';
import '../../../common_widgets/common_loader.dart';
import '../../../common_widgets/common_popups.dart';
import '../../../error_screen/error_widget.dart';
import '../../../payment/payment_screen.dart';
import '../widgets/current_plan_tile.dart';
import '../widgets/dealer_account_subscription_tile.dart';

class SubscriptionDealerAccountTab extends StatefulWidget {
  const SubscriptionDealerAccountTab({
    super.key,
    required this.subscriptionPageName,
  });

  final SubscriptionPageName subscriptionPageName;

  @override
  State<SubscriptionDealerAccountTab> createState() =>
      _SubscriptionDealerAccountTabState();
}

class _SubscriptionDealerAccountTabState
    extends State<SubscriptionDealerAccountTab> {
  late UserModel? currentUser;
  late UserType? userType;
  late SubscriptionBloc subscriptionBloc;
  final int isSelectedIndex = 0;
  bool userDataUpdateFailed = false;
  bool isUpdateUserData = false;
  bool isUpgradeSuccess = false;
  bool isCancelSuccess = false;
  DateTime currentNetworkDateTime = DateTime.now();

  @override
  void initState() {
    getServerDateTime();
    currentUser = context.read<UserBloc>().currentUser;
    userType =
        EnumToString.fromString(UserType.values, currentUser?.userType ?? '');
    subscriptionBloc = BlocProvider.of<SubscriptionBloc>(context);
    fetchUserData();
    getSubscriptionData();
    super.initState();
  }

  void getServerDateTime() async {
    currentNetworkDateTime = await networkDateTime();
  }

  //fetch subscription plans
  void getSubscriptionData() {
    subscriptionBloc.add(GetSubscriptionDataEvent());
  }

  //fetch user data
  void fetchUserData() {
    BlocProvider.of<UserBloc>(context).add(
        GetCurrentUserDataEvent(key: emailKey, value: currentUser!.email!));
  }

  //update user data
  void updateCurrentUserData() {
    isUpdateUserData = true;
    progressLoad(true);
    delayedStart(() {
      BlocProvider.of<UserBloc>(context).add(
          GetCurrentUserDataEvent(key: emailKey, value: currentUser!.email!));
    }, duration: const Duration(seconds: 3));
  }

  //cancel subscription plan
  void cancelSubscriptionAction() {
    progressLoad(true);
    subscriptionBloc.add(CancelSubscriptionPlanEvent(planData: {
      "firstName": currentUser?.firstName,
      "companyName": currentUser?.trader?.companyName,
      "email": currentUser?.email,
      "planId": currentUser?.trader?.subscription?.sId,
      "planName": currentUser?.trader?.subscription?.name,
      "planType": currentUser?.trader?.subscription?.type,
      "traderId": currentUser?.trader?.id,
      "userId": currentUser?.userId
    }));
  }

  //pay as you go
  void payAsYouGoAction(SubscriptionModel subscriptionItem) async {
    final PaymentResponseModel? paymentResponse = await Navigator.pushNamed(
        context, PaymentScreen.routeName,
        arguments: {"plan": subscriptionItem, "user": currentUser});

    if (paymentResponse != null) {
      if (paymentResponse.isSuccess!) {
        //payment success
        updateCurrentUserData();
      } else {
        //payment failed or pay as you go limit exceeded
        showSnackBar(message: paymentResponse.message ?? '');
      }
    }
  }

  //upgrade subscription plan
  void upgradeSubscriptionApiCall(SubscriptionModel subscriptionItem) async {
    progressLoad(true);
    subscriptionBloc.add(UpgradeSubscriptionPlanEvent(
      planData: {
        "companyName": currentUser?.trader?.companyName,
        "email": currentUser?.email,
        "planId": subscriptionItem.sId,
        "firstName": currentUser?.firstName,
        "planName": subscriptionItem.name,
        "planType": subscriptionItem.type,
        "traderId": currentUser?.trader?.id,
        "userId": currentUser?.userId,
      },
      subscriptionPageName: SubscriptionPageName.mySubscription,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (isUpdateUserData) {
              if (state is GetUserDataState) {
                if (state.userDataFetchStatus == ProviderStatus.success) {
                  if (widget.subscriptionPageName ==
                          SubscriptionPageName.myCar ||
                      widget.subscriptionPageName ==
                          SubscriptionPageName.carSummary) {
                    Navigator.pop(context);
                    progressLoad(false);
                    showSnackBar(
                        message: isUpgradeSuccess
                            ? upgradeSuccessSnackbarMsg
                            : isCancelSuccess
                                ? cancelSubSuccessSnackbarMsg
                                : paymentDoneSuccess);
                    if (userDataUpdateFailed) userDataUpdateFailed = false;
                    if (isUpgradeSuccess) isUpgradeSuccess = false;
                    if (isCancelSuccess) isCancelSuccess = false;
                  } else {
                    progressLoad(false);
                    setState(() {
                      currentUser = state.user;
                    });
                    showSnackBar(
                        message: isUpgradeSuccess
                            ? upgradeSuccessSnackbarMsg
                            : isCancelSuccess
                                ? cancelSubSuccessSnackbarMsg
                                : paymentDoneSuccess);
                    if (isUpgradeSuccess) isUpgradeSuccess = false;
                    if (isCancelSuccess) isCancelSuccess = false;
                    if (userDataUpdateFailed) {
                      setState(() {
                        userDataUpdateFailed = false;
                      });
                    }
                  }
                } else if (state.userDataFetchStatus == ProviderStatus.error) {
                  progressLoad(false);
                  setState(() {
                    userDataUpdateFailed = true;
                  });
                  showSnackBar(
                      message: isUpgradeSuccess
                          ? upgradeSuccessSnackbarMsg
                          : isCancelSuccess
                              ? cancelSubSuccessSnackbarMsg
                              : paymentDoneSuccess);
                }
              }
            }
          },
        ),
        BlocListener<SubscriptionBloc, SubscriptionState>(
          listener: (context, state) {
            if (state is CancelSubscriptionPlanState) {
              if (state.subscriptionCancelStatus == ProviderStatus.success) {
                progressLoad(false);
                setState(() {
                  isCancelSuccess = true;
                });
                updateCurrentUserData();
              } else if (state.subscriptionCancelStatus ==
                  ProviderStatus.error) {
                progressLoad(false);
                showSnackBar(message: cancelSubFailedSnackbarMsg);
              }
            } else if (state is UpgradeSubscriptionPlanState) {
              if (state.subscriptionUpgradeStatus == ProviderStatus.success) {
                progressLoad(false);
                setState(() {
                  isUpgradeSuccess = true;
                });
                updateCurrentUserData();
              } else if (state.subscriptionUpgradeStatus ==
                  ProviderStatus.error) {
                progressLoad(false);
                showSnackBar(message: upgradeFailedSnackbarMsg);
              }
            }
          },
        ),
      ],
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child:
              BlocBuilder<UserBloc, UserState>(builder: (context, userState) {
            if (userState is GetUserDataState) {
              if (userState.userDataFetchStatus == ProviderStatus.success) {
                return BlocBuilder<SubscriptionBloc, SubscriptionState>(
                    builder: (context, state) {
                  if ((state is GetSubscriptionDataState &&
                          state.subscriptionDataStatus ==
                              ProviderStatus.success) ||
                      (state is UpgradeSubscriptionPlanState) ||
                      state is CancelSubscriptionPlanState) {
                    return userDataUpdateFailed
                        ? errorBuild(
                            errorMessage: errorOccurredWhileFetch,
                            buttonLabel: retryButton,
                            onTap: () {
                              updateCurrentUserData();
                            })
                        : successBuild();
                  } else if (state is GetSubscriptionDataState &&
                      state.subscriptionDataStatus == ProviderStatus.error) {
                    return errorBuild(
                      errorMessage: getMySubscriptionApiFailErrorMsg,
                      buttonLabel: retryButton,
                      onTap: () => getSubscriptionData(),
                    );
                  }
                  return shimmerLoaderEffect();
                });
              } else if (userState.userDataFetchStatus ==
                  ProviderStatus.error) {
                return errorBuild(
                  errorMessage: getMySubscriptionApiFailErrorMsg,
                  buttonLabel: retryButton,
                  onTap: () => fetchUserData(),
                );
              }
            }
            return shimmerLoaderEffect();
          }),
        ),
      ),
    );
  }

  Widget successBuild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        paddingWidget(
          horizontal: 25,
          top: 16,
          bottom: 9,
          child: Text(
            currentPlanTitle,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppTextStyle.txtPTSansRegular14Black900,
          ),
        ),
        //current plan tile
        paddingWidget(
          horizontal: 25,
          bottom: 9,
          child: CurrentPlanTile(
            amount: currentUser?.trader?.subscription?.amount,
            totalCarLimit: currentUser?.trader?.totalCarLimit ?? 0,
            planName: (currentUser?.trader?.subscription != null &&
                        currentUser?.trader?.subscription?.type ==
                            convertEnumToString(SubscriptionsType.freeTrial) &&
                        DateTime.parse(
                                currentUser!.trader!.subscription!.endsOn!)
                            .isBefore(currentNetworkDateTime)) &&
                    currentUser?.trader?.payAsYouGoList != null
                ? currentUser!.trader!.payAsYouGoList![0]['name'] as String
                : currentUser?.trader?.subscription?.name ??
                    currentUser!.trader!.payAsYouGoList![0]['name'] as String,
            carListed: currentUser?.trader?.carsListed ?? 0,
            planType: (currentUser?.trader?.subscription != null &&
                        currentUser?.trader?.subscription?.type ==
                            convertEnumToString(SubscriptionsType.freeTrial) &&
                        DateTime.parse(
                                currentUser!.trader!.subscription!.endsOn!)
                            .isBefore(currentNetworkDateTime)) &&
                    currentUser?.trader?.payAsYouGoList != null
                ? convertEnumToString(SubscriptionsType.payAsYouGo)
                : currentUser?.trader?.subscription?.type,
            cycle: currentUser?.trader?.subscription?.cycle,
            onTapCancel: currentUser?.trader?.cancelSubscription?.status ==
                    convertEnumToString(UpgradeSubscriptionStatus.pending)
                ? () {
                    showSnackBar(message: cancelRequestExistsErrorMsg);
                  }
                : () async {
                    bool isOk = await confirmationPopup(
                      title: confirmTitle,
                      message: areYouWantToCancel,
                      isQuestion: true,
                    );
                    if (isOk) {
                      cancelSubscriptionAction();
                    }
                  },
          ),
        ),
        if (currentUser?.trader?.subscription?.type !=
            convertEnumToString(SubscriptionsType.unlimited))
          paddingWidget(
            horizontal: 25,
            bottom: 9,
            child: Text(
              otherPlansTitle,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppTextStyle.txtPTSansRegular14Black900,
            ),
          ),
        //other subscription plans list
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: currentUser?.trader?.subscription?.type ==
                  convertEnumToString(SubscriptionsType.unlimited)
              ? 0
              : subscriptionBloc.subscriptionPlans.length,
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          itemBuilder: (context, index) {
            final subscriptionItem = subscriptionBloc.subscriptionPlans[index];
            return DealerAccountSubscriptionTile(
              isSelectedIndex: isSelectedIndex,
              initialIndex: index,
              plan: subscriptionItem,
              currentPlanName: currentUser?.trader?.subscription?.name,
              currentPlanType: currentUser?.trader?.subscription?.type,
              currentPlanCarLimit:
                  currentUser?.trader?.subscription?.carLimit ?? 0,
              subscriptionUpgradeStatus:
                  currentUser?.trader?.upgradeSubscription?.status,
              cancelSubscriptionStatus:
                  currentUser?.trader?.cancelSubscription?.status,
              onTapPayNow: () async {
                bool isOk = await confirmationPopup(
                  title: confirmTitle,
                  message: areYouWantToSubscribe,
                  isQuestion: true,
                );
                if (isOk) payAsYouGoAction(subscriptionItem);
              },
              onTapUpgrade: () async {
                bool isOk = await confirmationPopup(
                  title: confirmTitle,
                  message: areYouWantToSubscribe,
                  isQuestion: true,
                );
                if (isOk) {
                  upgradeSubscriptionApiCall(subscriptionItem);
                }
              },
              onTapContactUs: () async {
                bool isOk = await confirmationPopup(
                  title: confirmTitle,
                  message: areYouWantToSubscribe,
                  isQuestion: true,
                );
                if (isOk) {
                  upgradeSubscriptionApiCall(subscriptionItem);
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget shimmerLoaderEffect() {
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

  Widget paddingWidget(
      {required Widget child,
      double? bottom = 20,
      double? horizontal = 0,
      double top = 0}) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: bottom!,
        top: top,
        left: horizontal!,
        right: horizontal,
      ),
      child: child,
    );
  }

  void progressLoad(bool value) {
    if (value) {
      progressDialogue();
    } else {
      Navigator.pop(context);
    }
  }
}
