import 'dart:developer';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_zoom_drawer/config.dart';

import '../about_us/about_us.dart';
import '../contact_us/contact_us_screen.dart';
import '../faq/faq_screen.dart';
import '../sign_up_profile/sign_up_profile_screen.dart';
import '../sign_up_profile/widgets/launch_terms_and_conditions.dart';
import '../landing_screen/landing_screen.dart';
import '../my_matches/my_matches.dart';
import '../report_an_issue/report_an_issue_screen.dart';
import '../settings_screen/settings_screen.dart';
import '../sign_in/sign_in_screen.dart';
import '../subscription/side_menu/my_subscription_screen.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/user/user_model.dart';
import '../../repository/authentication_repo.dart';
import '../../service/shared_preference_service.dart';
import '../history/transfer_history.dart';
import 'common_loader.dart';
import 'common_popups.dart';

class SideMenu extends StatefulWidget {
  final ZoomDrawerController zoomDrawerController;

  const SideMenu({super.key, required this.zoomDrawerController});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  UserModel? currentUser;
  UserType? userType;

  @override
  void initState() {
    currentUser = context.read<UserBloc>().currentUser;
    userType =
        EnumToString.fromString(UserType.values, currentUser?.userType ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is SignOutState) {
          if (state.signOutStatus == ProviderStatus.success) {
            logoutAction(isLogout: false);
          } else if (state.signOutStatus == ProviderStatus.error) {
            Navigator.pop(context);
            showSnackBar(message: "Logout failed");
          } else {
            progressDialogue();
          }
        }
      },
      child: Drawer(
        width: MediaQuery.of(context).size.width,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: SafeArea(
          child: Padding(
            padding: getPadding(left: 30.w, right: 30.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 35.h),
                  GestureDetector(
                    onTap: () => navigation(
                      SignUpProfileScreen.routeName,
                      arguments: {
                        "userType": userType,
                        "user": currentUser,
                      },
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: getSize(57),
                          width: getSize(57),
                          decoration: AppDecoration
                              .gradientDeeporangeA200Yellow900
                              .copyWith(
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: (userType != UserType.private &&
                                      currentUser?.trader?.logo == null) ||
                                  (userType == UserType.private &&
                                      currentUser?.avatarImage == null)
                              ? CustomImageView(
                                  svgPath: userType == UserType.private
                                      ? Assets.privatePlaceholder
                                      : Assets.dealerPlaceholder,
                                  color: ColorConstant.kColorWhite,
                                  margin: getMargin(all: 9),
                                )
                              : CustomImageView(
                                  url: userType == UserType.private
                                      ? (currentUser?.avatarImage ?? '')
                                      : (currentUser?.trader?.logo ?? ''),
                                  fit: BoxFit.fill,
                                  radius: BorderRadius.circular(100.r),
                                ),
                        ),
                        Padding(
                          padding: getPadding(top: 10.h),
                          child: Text(
                            (currentUser?.firstName?.toUpperCase() ?? '') +
                                blankSpace +
                                (currentUser?.lastName?.toUpperCase() ?? ''),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppTextStyle.txtPTSansBold14WhiteA700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: getVerticalSize(1.h),
                    width: getHorizontalSize(size.width / 2.5),
                    margin: getMargin(top: 20.h),
                    decoration: BoxDecoration(color: ColorConstant.whiteA700),
                  ),
                  SizedBox(height: 15.h),
                  drawerItem(
                    sideMenuHome,
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      LandingScreen.routeName,
                      (route) => false,
                    ),
                  ),
                  drawerItem(
                    sideMenuMyCars,
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      LandingScreen.routeName,
                      arguments: {'selectedIndex': 0},
                      (route) => false,
                    ),
                  ),
                  drawerItem(
                    sideMenuMyMatches,
                    onTap: () {
                      navigation(MyMatches.routeName);
                    },
                  ),
                  drawerItem(
                    sideMenuMySubscription,
                    onTap: () => navigation(
                      MySubscriptionPage.routeName,
                      arguments: {"initialIndex": 0},
                    ),
                  ),
                  drawerItem(
                    sideMenuHistory,
                    onTap: () {
                      navigation(TransferHistory.routeName);
                    },
                  ),
                  drawerItem(
                    sideMenuSettings,
                    onTap: () {
                      navigation(SettingsPage.routeName);
                    },
                  ),
                  drawerItem(
                    sideMenuTutorial,
                    onTap: () => showSnackBar(message: 'Coming Soon'),
                  ),
                  drawerItem(
                    sideMenuReportAnIssue,
                    onTap: () => navigation(ReportAnIssueScreen.routeName),
                  ),
                  drawerItem(
                    sideMenuShareTheApp,
                    onTap: () {
                      drawerToggle();
                      shareFeature(
                        content: shareTextSample,
                        subject: shareAppTitle,
                      );
                    },
                  ),
                  drawerItem(
                    sideMenuContactUs,
                    onTap: () => navigation(
                      ContactUsScreen.routeName,
                    ),
                  ),
                  drawerItem(
                    sideMenuAboutUs,
                    onTap: () => navigation(
                      AboutUsScreen.routeName,
                    ),
                  ),
                  drawerItem(
                    sideMenuFAQ,
                    onTap: () => navigation(
                      FAQScreen.routeName,
                    ),
                  ),
                  drawerItem(
                    sideMenuLogout,
                    onTap: () async {
                      final authBloc = context.read<AuthenticationBloc>();
                      bool result = await confirmationPopup(
                        title: 'Logout',
                        message: areYouSureWantToLogout,
                        isQuestion: true,
                      );
                      if (result) {
                        authBloc.add(SignOutEvent());
                      }
                    },
                  ),
                  if (currentUser?.userType ==
                      convertEnumToString(UserType.private))
                    Padding(
                      padding: getPadding(top: 15.h, bottom: 15.h),
                      child: CustomElevatedButton(
                        height: getVerticalSize(35.h),
                        buttonBgColor: ColorConstant.kColor303030,
                        title: upgradeTo + dealerType + account,
                        customBorderRadius: BorderRadius.circular(8.r),
                        onTap: () {
                          if (currentUser?.upgradeToDealer?.status ==
                              convertEnumToString(Status.pending)) {
                            showSnackBar(message: upgradeToDealerReqexists);
                          } else {
                            navigation(
                              SignUpProfileScreen.routeName,
                              arguments: {
                                'userType': UserType.dealerAdmin,
                                'user': currentUser,
                                'isUpgrade': true,
                              },
                            );
                          }
                        },
                      ),
                    ),
                  Container(
                    height: getVerticalSize(1.h),
                    width: getHorizontalSize(size.width / 2.5),
                    margin: getMargin(top: 15.h),
                    decoration: BoxDecoration(
                      color: ColorConstant.whiteA700,
                    ),
                  ),
                  Padding(
                    padding: getPadding(top: 18.h),
                    child: GestureDetector(
                      onTap: () {
                        navigation(
                          LaunchTermsAndConditions.routeName,
                          arguments: {'appBarTitle': "Terms & Conditions"},
                        );
                      },
                      child: Text(
                        sideMenuTermsAndCondition,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppTextStyle.txtPTSansRegular14WhiteA700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: getPadding(top: 18.h),
                    child: GestureDetector(
                      onTap: () {
                        navigation(
                          LaunchTermsAndConditions.routeName,
                          arguments: {'appBarTitle': "Privacy Policy"},
                        );
                      },
                      child: Text(
                        sideMenuPrivacyPolicy,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppTextStyle.txtPTSansRegular14WhiteA700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: getPadding(top: 18.h),
                    child: GestureDetector(
                      onTap: () {
                        navigation(
                          LaunchTermsAndConditions.routeName,
                          arguments: {'appBarTitle': "Cookie Policy"},
                        );
                      },
                      child: Text(
                        sideMenuCookiesPolicy,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppTextStyle.txtPTSansRegular14WhiteA700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: getPadding(top: 18.h),
                    child: GestureDetector(
                      onTap: () {
                        navigation(
                          LaunchTermsAndConditions.routeName,
                          arguments: {'appBarTitle': "Anti-Slavery Policy"},
                        );
                      },
                      child: Text(
                        sideMenuAntiSlaveryPolicy,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppTextStyle.txtPTSansRegular14WhiteA700,
                      ),
                    ),
                  ),
                  SizedBox(height: 35.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //logout action
  void logoutAction({bool isLogout = true}) async {
    if (isLogout) {
      await Locator.instance.get<AuthenticationRepo>().signOutUser();
    }
    Locator.instance.get<SharedPrefServices>().clearSharedPref();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
        context, SignInScreen.routeName, (route) => false);
  }

  void drawerToggle() {
    try {
      widget.zoomDrawerController.toggle!();
    } on Exception catch (e) {
      log('toggle exception:$e');
    }
  }

  void navigation(String route, {Object? arguments}) {
    drawerToggle();
    Navigator.pushNamed(context, route, arguments: arguments);
  }

  Widget drawerItem(
    String title, {
    GestureTapCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: getPadding(top: 7.h, bottom: 7.h),
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: AppTextStyle.txtPTSansRegular14WhiteA700,
        ),
      ),
    );
  }
}
