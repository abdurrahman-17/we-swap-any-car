// ignore_for_file: use_build_context_synchronously

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../bloc/user/user_bloc.dart';
import '../core/configurations.dart';
import '../core/locator.dart';
import '../main.dart';
import '../repository/authentication_repo.dart';
import '../service/deep_link_service.dart';
import '../service/shared_preference_service.dart';
import '../utility/common_keys.dart';
import '../utility/date_time_utils.dart';
import 'common_widgets/common_loader.dart';
import 'common_widgets/common_popups.dart';
import 'landing_screen/landing_screen.dart';
import 'network_lost_screen.dart';
import 'sign_in/sign_in_screen.dart';
import 'subscription/subscription_screen.dart';
import 'user_type_selection/user_types_selection.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/";
  const SplashScreen({
    required this.isSplash,
    super.key,
  });
  final bool isSplash;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DateTime currentNetworkDateTime = DateTime.now();

  @override
  void initState() {
    getServerDateTime();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bool isConnected = await isConnectedToInternet();
      if (!isConnected) {
        splashRemove();
        await Navigator.pushNamed(
          globalNavigatorKey.currentContext!,
          NetworkLostScreen.routeName,
          arguments: {"isSplash": true},
        );
      }
      loginCheck();
    });
    if (kReleaseMode) {
      checkJailBrake();
    }
    super.initState();
  }

  void getServerDateTime() async {
    currentNetworkDateTime = await networkDateTime();
  }

  void loginCheck() async {
    if (widget.isSplash) {
      BlocProvider.of<UserBloc>(context).add(CheckUserLoginEvent());
    } else {
      String email = await getEmailIdFromToken();
      Locator.instance.get<SharedPrefServices>().setEmail(email);

      BlocProvider.of<UserBloc>(context)
          .add(GetCurrentUserDataEvent(key: emailKey, value: email));
    }
  }

  void splashRemove() {
    if (widget.isSplash) {
      FlutterNativeSplash.remove();
    }
  }

  //navigation
  void navigation(String routeName) {
    splashRemove();
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
    );
  }

  void deepLinkCheckAndNavigation() {
    deepLinkHandling().then((value) {
      if (value) {
        splashRemove();
      } else {
        navigation(LandingScreen.routeName);
      }
    });
  }

  Future<String> getEmailIdFromToken() async {
    final tokens =
        await Locator.instance.get<AuthenticationRepo>().getRefreshToken();
    return tokens?.idToken.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) async {
        if (state is UserLoginState) {
          ///user is logged in already
          if (state.isSignedIn) {
            String email = await getEmailIdFromToken();
            Locator.instance.get<SharedPrefServices>().setEmail(email);

            ///check whether the data is entered or not
            BlocProvider.of<UserBloc>(context)
                .add(GetCurrentUserDataEvent(key: emailKey, value: email));
          }

          ///user not logged in
          else {
            navigation(SignInScreen.routeName);
          }
        } else if (state is GetUserDataState) {
          if (state.userDataFetchStatus == ProviderStatus.success) {
            ///no user data available in DB
            if (state.user?.userId == null) {
              navigation(SelectUserTypesScreen.routeName);
            } else {
              //inactive user
              if (state.user?.status == Status.inactive.name) {
                splashRemove();
                delayedStart(() {
                  infoOrThankyouPopup(
                    message: accountInactive,
                    buttonText: closeButton,
                    onTapButton: () {
                      progressLoad(true);
                      logoutAction();
                    },
                  );
                });
              }
              //private user
              else if (state.user?.userType ==
                  convertEnumToString(UserType.private)) {
                deepLinkCheckAndNavigation();
              }
              // Trader inactive
              else if (state.user?.trader?.status ==
                  convertEnumToString(Status.pending)) {
                splashRemove();
                delayedStart(() {
                  infoOrThankyouPopup(
                    message: traderAccountStatusMsg,
                    buttonText: closeButton,
                    onTapButton: () {
                      progressLoad(true);
                      logoutAction();
                    },
                  );
                });
              }
              //Initial subscription pending approval
              else if (state.user?.trader?.subscription == null &&
                  state.user?.trader?.upgradeSubscription
                          ?.isInitialSubscription ==
                      true) {
                splashRemove();
                delayedStart(() {
                  infoOrThankyouPopup(
                    message: subscriptionPendingApproval,
                    buttonText: closeButton,
                    onTapButton: () {
                      progressLoad(true);
                      logoutAction();
                    },
                  );
                });
              }
              //Pay as you go
              else if ((state.user?.trader?.subscription == null ||
                      (state.user!.trader!.subscription!.type ==
                              convertEnumToString(
                                  SubscriptionsType.freeTrial)) &&
                          DateTime.parse(
                                  state.user!.trader!.subscription!.endsOn!)
                              .isBefore(currentNetworkDateTime)) &&
                  state.user?.trader?.payAsYouGoList != null) {
                bool activePlanFlag = false;
                for (final item in state.user?.trader?.payAsYouGoList as List) {
                  if (item['status'] == Status.active.name) {
                    activePlanFlag = true;
                    break;
                  }
                }
                if (activePlanFlag) {
                  deepLinkCheckAndNavigation();
                } else if (state.user?.trader?.upgradeSubscription?.status ==
                    convertEnumToString(SubscriptionChangeStatus.pending)) {
                  splashRemove();
                  delayedStart(() {
                    infoOrThankyouPopup(
                      message: (state.user?.trader?.subscription != null &&
                              state.user!.trader!.subscription!.type ==
                                  convertEnumToString(
                                      SubscriptionsType.freeTrial))
                          ? freeTrialExpiredPopupMsg
                          : subscriptionPendingApproval,
                      buttonText: closeButton,
                      onTapButton: () {
                        progressLoad(true);
                        logoutAction();
                      },
                    );
                  });
                } else {
                  splashRemove();
                  Navigator.pushNamedAndRemoveUntil(
                      context, SubscriptionPage.routeName, (route) => false,
                      arguments: {
                        'payAsYouGoExpired': true,
                      });
                }
              }
              // Not Subscribed or not Pay as you go
              else if (state.user?.trader?.subscription == null) {
                navigation(SubscriptionPage.routeName);
              }
              //Free trial expired && subscription approval is pending
              else if ((state.user!.trader!.subscription!.type ==
                      convertEnumToString(SubscriptionsType.freeTrial)) &&
                  DateTime.parse(state.user!.trader!.subscription!.endsOn!)
                      .isBefore(currentNetworkDateTime)) {
                splashRemove();
                delayedStart(() {
                  infoOrThankyouPopup(
                    message: freeTrialExpiredPopupMsg,
                    buttonText: closeButton,
                    onTapButton: () {
                      progressLoad(true);
                      logoutAction();
                    },
                  );
                });
              }
              // Subscription approved
              else if (state.user?.trader?.subscription?.status ==
                  convertEnumToString(SubscriptionChangeStatus.active)) {
                deepLinkCheckAndNavigation();
              } else {
                navigation(SubscriptionPage.routeName);
              }
            }
          } else if (state.userDataFetchStatus == ProviderStatus.error) {
            showSnackBar(message: state.errorMessage ?? errorOccurred);
            splashRemove();
            logoutAction();
          }
        }
      },
      child: CustomScaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomImageView(
                svgPath: Assets.splashBg,
                width: size.width,
                fit: BoxFit.cover,
              ),
            ),
            !widget.isSplash
                ? const LottieLoader()
                : Positioned(
                    top: size.height / 4,
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomImageView(
                            svgPath: Assets.splashLogo,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          CustomImageView(
                            svgPath: Assets.splashText,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void progressLoad(bool value) {
    if (value) {
      progressDialogue(isCircularProgress: true);
    } else {
      Navigator.pop(context);
    }
  }
}
