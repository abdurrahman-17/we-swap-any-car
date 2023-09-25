import '../../bloc/authentication/authentication_bloc.dart';
import '../../core/locator.dart';
import '../../repository/authentication_repo.dart';
import '../../service/shared_preference_service.dart';
import '../../core/configurations.dart';
import '../../main.dart';
import '../common_widgets/common_loader.dart';
import '../common_widgets/common_popups.dart';
import '../common_widgets/custom_icon_button.dart';
import '../sign_up_profile/sign_up_profile_screen.dart';
import '../landing_screen/landing_screen.dart';
import '../sign_in/sign_in_screen.dart';

class SelectUserTypesScreen extends StatelessWidget {
  static const String routeName = 'user_type_selection_screen';
  const SelectUserTypesScreen({super.key});

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
      child: CustomScaffold(
        body: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              decoration: AppDecoration.gradientRed100YellowA700,
              child: CustomImageView(
                svgPath: Assets.areYouhereBg,
                height: getVerticalSize(size.height / 1.4),
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: getPadding(
                left: 32.w,
                right: 32.w,
                bottom: 12.h,
                top: size.height * 0.05,
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    CustomImageView(
                      svgPath: Assets.areYouHereCharacter,
                      height: getVerticalSize(300),
                      width: MediaQuery.of(context).size.width,
                      margin: getMargin(
                        right: 10,
                        bottom: 15,
                        top: 15,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 21, left: 15),
                      child: Text(
                        selectUserType,
                        style: AppTextStyle.regularTextStyle.copyWith(
                          fontSize: getFontSize(16),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    commonCardWidget(
                      userType: UserType.private,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          SignUpProfileScreen.routeName,
                          arguments: {"userType": UserType.private},
                        );
                      },
                    ),
                    SizedBox(height: 19.h),
                    commonCardWidget(
                      userType: UserType.dealerAdmin,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          SignUpProfileScreen.routeName,
                          arguments: {"userType": UserType.dealerAdmin},
                        );
                      },
                    ),
                    justBrowse(),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          alreadyHaveAnAccount,
                          textAlign: TextAlign.start,
                          style: AppTextStyle.regularTextStyle.copyWith(
                            fontSize: getFontSize(16),
                            color: ColorConstant.kColorF9BBCC,
                          ),
                        ),

                        ///SIGNIN
                        InkWell(
                          onTap: () async {
                            final nav = Navigator.of(context);
                            final authBloc = context.read<AuthenticationBloc>();
                            final isSignedIn = await Locator.instance
                                .get<AuthenticationRepo>()
                                .checkAuthenticated();
                            if (!isSignedIn) {
                              nav.pushReplacementNamed(SignInScreen.routeName);
                            } else {
                              authBloc.add(SignOutEvent());
                            }
                          },
                          child: Text(
                            signIn,
                            style: AppTextStyle.regularTextStyle.copyWith(
                              fontSize: getFontSize(16),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget commonCardWidget({
    required UserType userType,
    required GestureTapCallback? onTap,
  }) {
    return SizedBox(
      height: getVerticalSize(size.width / 3.7),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: AppDecoration.rectangle213.copyWith(
                borderRadius: BorderRadius.circular(18.r),
              ),
              alignment: Alignment.bottomLeft,
              child: CustomImageView(
                fit: BoxFit.fill,
                svgPath: Assets.selectUserCardBg,
                radius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.r),
                ),
              ),
            ),
            Padding(
              padding: getPadding(left: 43.w, right: 19.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      userType == UserType.private
                          ? privateUserType
                          : dealerType,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.regularTextStyle.copyWith(
                        color: ColorConstant.kColor372E2E,
                        fontSize: getFontSize(19),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  CustomIconButton(
                    height: getSize(24),
                    width: getSize(24),
                    shape: IconButtonShape.CircleBorder12,
                    padding: IconButtonPadding.PaddingAll5,
                    child: CustomImageView(
                      svgPath: Assets.imgQuestionSvg,
                    ),
                    onTap: () {
                      infoOrThankyouPopup(
                        title: userType == UserType.private
                            ? privateUserType
                            : dealerType,
                        buttonWidth: size.width,
                        message: loremIpsumsample,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget justBrowse() {
    return InkWell(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(
          globalNavigatorKey.currentContext!,
          LandingScreen.routeName,
          (route) => false,
          arguments: {'isGuest': true},
        );
      },
      child: Container(
        height: getVerticalSize(48),
        decoration: BoxDecoration(
          color: ColorConstant.kColorBlack,
          borderRadius: BorderRadius.circular(
            getHorizontalSize(15),
          ),
        ),
        alignment: Alignment.center,
        padding: getPadding(left: 43, right: 19),
        margin: getMargin(top: 24, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                justBrowseType,
                textAlign: TextAlign.center,
                style: AppTextStyle.regularTextStyle
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            CustomIconButton(
              height: getSize(24),
              width: getSize(24),
              shape: IconButtonShape.CircleBorder12,
              variant: IconButtonVariant.Fill353333,
              padding: IconButtonPadding.PaddingAll5,
              child: CustomImageView(
                svgPath: Assets.imgQuestionSvg,
              ),
              onTap: () {
                infoOrThankyouPopup(
                  title: justBrowseType,
                  message: loremIpsumsample,
                  buttonText: okButton,
                );
              },
            ),
          ],
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
    Navigator.pushNamedAndRemoveUntil(globalNavigatorKey.currentContext!,
        SignInScreen.routeName, (route) => false);
  }
}
