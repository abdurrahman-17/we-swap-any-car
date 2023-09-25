import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wsac/presentation/sign_in/widgets/social_login_buttons.dart';
import '../../main.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../repository/authentication_repo.dart';
import '../../service/shared_preference_service.dart';
import '../../utility/validator.dart';
import '../common_popup_widget/sucess_popup_widget.dart';
import '../common_widgets/common_loader.dart';
import '../common_widgets/common_popups.dart';
import '../common_widgets/common_top_model_sheet.dart';
import '../common_widgets/custom_checkbox.dart';
import '../common_widgets/custom_top_sheet.dart';
import '../user_type_selection/user_types_selection.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = "sign_in_screen";
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailOrPhoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool rememberCheck = false;
  bool isEmailOrPhnNumberValid = false;
  bool isLoading = false;
  AutovalidateMode? autoValidate;
  bool enableFlag = false;
  late AuthenticationBloc authenticationBloc;

  void emailOrPhnNumberValidation(bool value) {
    setState(() => isEmailOrPhnNumberValid = value);
  }

  @override
  void initState() {
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    authenticationBloc.add(SignInitialEvent());
    Locator.instance.get<SharedPrefServices>().setHelpInfo(true);
    emailOrPhoneController.text =
        Locator.instance.get<AuthenticationRepo>().getEmailOrPhone();
    if (emailOrPhoneController.text.isNotEmpty) {
      isEmailOrPhnNumberValid = true;
      rememberCheck = true;
      if (isStringNumeric(emailOrPhoneController.text)) {
        enableFlag = true;
      }
    }
    super.initState();
  }

  void setLoader(bool isLoader) {
    if (isLoader) {
      progressDialogue();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async {
        if (state is SignInState) {
          //success
          if (state.signInStatus == ProviderStatus.success) {
            if (state.socialLogin == SocialLogin.none) {
              setState(() {
                isLoading = false;
              });
              bool? result = await showCommonTopModalSheet(
                context,
                CustomTopSheet(
                  isEmail: isStringNumeric(state.emailOrPhone!) ? false : true,
                  emailOrPhone: state.emailOrPhone!,
                  verifyTap: (otp) {
                    authenticationBloc.add(VerifyOTPEvent(otp: otp));
                  },
                  resendTap: () {
                    authenticationBloc.add(ResendOtpEvent(
                        emailOrPhone: emailOrPhoneController.text
                            .replaceAllWhiteSpace()));
                  },
                ),
                barrierDismissible: false,
              );
              if (result != null && result) {
                navigation(false);
              }
            } else {
              navigation(true);
            }
          } else if (state.signInStatus == ProviderStatus.error) {
            //error
            if (state.socialLogin == SocialLogin.none) {
              setState(() {
                isLoading = false;
              });
            } else {
              //social loader dismiss
              setLoader(false);
            }
            showSnackBar(message: state.errorMessage ?? '');
          } else if (state.signInStatus == ProviderStatus.loading) {
            //loading
            if (state.socialLogin == SocialLogin.none) {
              setState(() {
                isLoading = true;
              });
            } else {
              //social loader
              setLoader(true);
            }
          }
        }
      },
      child: CustomScaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(
                Assets.splashBg,
                width: size.width,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: getPadding(
                top: MediaQuery.of(context).size.height / 6,
                left: 30.w,
                right: 30.w,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomImageView(
                          svgPath: Assets.logoFrame,
                          width: size.width / 2.5,
                          fit: BoxFit.cover,
                        ),
                        signInTextField(),
                        Padding(
                          padding: EdgeInsets.only(top: 15.h),
                          child: Row(
                            children: [
                              GradientCheckbox(
                                value: rememberCheck,
                                onChanged: (_) {
                                  if (rememberCheck) {
                                    setState(() => rememberCheck = false);
                                  } else {
                                    setState(() => rememberCheck = true);
                                  }
                                },
                              ),
                              SizedBox(width: 13.w),
                              Text(
                                rememberMe,
                                textAlign: TextAlign.start,
                                style: AppTextStyle.regularTextStyle.copyWith(
                                    color: ColorConstant.kColor353333),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: CustomElevatedButton(
                            title: signInButton,
                            isLoading: isLoading,
                            onTap: () async => onTapSignIn(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.w, 30.h, 0.w, 0.h),
                          child: Text(
                            orSignInUsing,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.regularTextStyle
                                .copyWith(color: ColorConstant.kColor353333),
                          ),
                        ),

                        ///SOCIAL LOGINS
                        const SocialLoginButtons(),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: getPadding(bottom: 40.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dontHaveAnAccount,
                            textAlign: TextAlign.start,
                            style: AppTextStyle.regularTextStyle.copyWith(
                              fontSize: getFontSize(16),
                              color: ColorConstant.kColorF9BBCC,
                            ),
                          ),

                          ///SIGNUP
                          InkWell(
                            onTap: () => Navigator.pushReplacementNamed(
                                context, SelectUserTypesScreen.routeName),
                            child: Text(
                              signUpLabel,
                              style: AppTextStyle.regularTextStyle.copyWith(
                                fontSize: getFontSize(16),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailOrPhoneController.dispose();
    super.dispose();
  }

  Widget signInTextField() {
    return IgnorePointer(
      ignoring: isLoading,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: getPadding(top: 50.h),
          child: CommonTextFormField(
            prefixIcon: enableFlag
                ? Padding(
                    padding: const EdgeInsets.only(
                        top: 13, left: 13, bottom: 13, right: 8),
                    child: CustomImageView(
                      imagePath: Assets.ukFlag,
                      height: getVerticalSize(5.00),
                      width: getHorizontalSize(5.00),
                      radius: BorderRadius.circular(getHorizontalSize(2.00)),
                      margin: getMargin(
                        left: 4,
                        top: 3,
                        bottom: 3,
                      ),
                    ),
                  )
                : null,
            autoValidate: autoValidate,
            cursorHgt: 21,
            controller: emailOrPhoneController,
            hint: emailAddressOrPhoneNumberHint,
            textInputAction: TextInputAction.done,
            textInputType: isStringNumeric(emailOrPhoneController.text.trim())
                ? TextInputType.text
                : TextInputType.emailAddress,
            onChanged: (value) {
              ///flag show
              if (emailOrPhoneController.text.trim().isEmpty) {
                enableFlag = false;
              } else if (value.contains(RegExp(r'[a-zA-Z@]'))) {
                enableFlag = false;
              } else {
                enableFlag = true;
              }

              ///validation icon
              if (isStringNumeric(value.trim()) &&
                  !Validation.isValidPhone(value.trim(),
                      isRequired: true, isSignIn: true)) {
                return emailOrPhnNumberValidation(false);
              } else if (!isStringNumeric(value.trim()) &&
                  !Validation.isValidEmail(value.trim(), isRequired: true)) {
                emailOrPhnNumberValidation(false);
              } else {
                emailOrPhnNumberValidation(true);
              }
            },
            validator: (value) {
              if (emailOrPhoneController.text.trim().isEmpty) {
                return "Email or phone number is required";
              } else if (isStringNumeric(emailOrPhoneController.text.trim()) &&
                  !Validation.isValidPhone(emailOrPhoneController.text.trim(),
                      isRequired: true, isSignIn: true)) {
                return "Enter a valid phone number";
              } else if (!isStringNumeric(emailOrPhoneController.text.trim()) &&
                  !Validation.isValidEmail(emailOrPhoneController.text.trim(),
                      isRequired: true)) {
                return "Enter a valid email";
              } else {
                return null;
              }
            },
            suffixIcon: isEmailOrPhnNumberValid
                ? Icon(
                    CupertinoIcons.checkmark_seal_fill,
                    color: ColorConstant.kColor95C926,
                    size: getSize(21),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Future<void> onTapSignIn() async {
    autoValidate = AutovalidateMode.onUserInteraction;
    if (_formKey.currentState!.validate() && isEmailOrPhnNumberValid) {
      FocusScope.of(context).unfocus();
      if (rememberCheck) {
        Locator.instance
            .get<AuthenticationRepo>()
            .saveEmailOrPhone(emailOrPhoneController.text);
      } else if (Locator.instance.get<AuthenticationRepo>().getEmailOrPhone() !=
          "") {
        Locator.instance.get<AuthenticationRepo>().clearEmailOrPhone();
      }
      authenticationBloc.add(SignInWithEmailOrPhoneEvent(
          emailOrPhone: emailOrPhoneController.text.trim().toLowerCase()));
    }
  }
}

void navigation(bool isSocialLogin) {
  if (isSocialLogin) {
    Navigator.pushNamedAndRemoveUntil(
        globalNavigatorKey.currentContext!,
        SplashScreen.routeName,
        arguments: {"isSplash": false},
        (route) => false);
  } else {
    customPopup(hasContentPadding: false, content: const SuccessfulPopup());

    delayedStart(() {
      Navigator.pushNamedAndRemoveUntil(
          globalNavigatorKey.currentContext!,
          SplashScreen.routeName,
          arguments: {"isSplash": false},
          (route) => false);
    });
  }
}
