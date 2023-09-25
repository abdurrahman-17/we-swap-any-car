import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:smart_auth/smart_auth.dart';

import '../../bloc/authentication/authentication_bloc.dart';
import '../../core/configurations.dart';
import 'common_divider.dart';

class CustomTopSheet extends StatefulWidget {
  const CustomTopSheet({
    Key? key,
    this.isEmail = false,
    required this.emailOrPhone,
    required this.verifyTap,
    required this.resendTap,
  }) : super(key: key);

  final bool isEmail;
  final String emailOrPhone;
  final void Function(String otp) verifyTap;
  final VoidCallback resendTap;

  @override
  State<CustomTopSheet> createState() => _CustomTopSheetState();
}

class _CustomTopSheetState extends State<CustomTopSheet> {
  final smartAuth = SmartAuth();
  TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Timer? _timer;
  int _start = otpTimer;
  bool resendStart = false;

  bool isLoading = false;
  bool isResendLoading = false;
  AutovalidateMode? autoValidate;

  @override
  void initState() {
    timerStart();
    if (Platform.isAndroid) {
      getSmsCode();
    }
    super.initState();
  }

  //OTP auto populate
  void getSmsCode() async {
    final res = await smartAuth.getSmsCode();
    if (res.succeed) {
      log('SMS: ${res.code}');
      setState(() {
        otpController.text = res.code ?? '';
      });
      getSmsCode();
    } else {
      log('SMS Failure:');
      getSmsCode();
    }
  }

  void timerStart() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _timer = null;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is OtpLoadingState) {
          setState(() {
            isLoading = true;
          });
        } else if (state is OtpVerifiedState) {
          ///successfully loggedIn
          Navigator.pop(context, true);
        } else if (state is OtpVerifyFailedState) {
          ///failed
          setState(() {
            isLoading = false;
          });
          showSnackBar(
              message:
                  'The code you have entered is incorrect. Please try again.');
        } else if (state is OtpResendLoadingState) {
          setState(() {
            isResendLoading = true;
          });
        } else if (state is OtpResendSuccessState) {
          showSnackBar(message: "Code resend successfully");
          setState(() {
            _start = otpTimer;
            isResendLoading = false;
            timerStart();
          });
        } else if (state is OtpResendFailedState) {
          showSnackBar(message: "Code resend failed");
          setState(() {
            isResendLoading = false;
          });
        } else if (state is UpdateOtpResendSuccessState) {
          showSnackBar(message: "Code resend successfully");
          setState(() {
            _start = otpTimer;
            isResendLoading = false;
            timerStart();
          });
        } else if (state is UpdateOtpResendFailedState) {
          showSnackBar(message: "Code resend failed");
          setState(() {
            isResendLoading = false;
          });
        }
      },
      child: Container(
        padding: getPadding(left: 32.w, right: 32.w, bottom: 33.h),
        decoration: AppDecoration.fillGray100.copyWith(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(39.r),
            bottomRight: Radius.circular(39.r),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: getPadding(top: 20.h, bottom: 20.h),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CustomImageView(
                        svgPath: Assets.backArrow,
                        height: getVerticalSize(10.00),
                        width: getHorizontalSize(12.00),
                        margin: getMargin(top: 9, bottom: 4),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 110),
                      child: Text(
                        verifyCode,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.txtPTSansBold14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: size.width,
                child: Text(
                  widget.isEmail
                      ? msgPleaseVerifyYourEmail
                      : msgPleaseVerifyYourPhoneNumber,
                  textAlign: TextAlign.left,
                  style: AppTextStyle.txtPTSansRegular14Gray600,
                ),
              ),
              Padding(
                padding: getPadding(top: 24.h, bottom: 17.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          widget.isEmail
                              ? const SizedBox()
                              : Padding(
                                  padding: getPadding(right: 10.w),
                                  child: Text(
                                    countryCode,
                                    style:
                                        AppTextStyle.regularTextStyle.copyWith(
                                      fontSize: 16.sp,
                                      color: ColorConstant.kColorBlack,
                                    ),
                                  ),
                                ),
                          Text(
                            widget.emailOrPhone,
                            style: AppTextStyle.regularTextStyle.copyWith(
                              fontSize: 16.sp,
                              color: ColorConstant.kColorBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        widget.isEmail ? editEmail : editNumber,
                        style: AppTextStyle.smallTextStyle
                            .copyWith(color: ColorConstant.kColor7C7C7C),
                      ),
                    ),
                  ],
                ),
              ),
              const GradientDivider(),
              Padding(
                padding: getPadding(left: 3.w, top: 19.h),
                child: Text(
                  widget.isEmail
                      ? enterCodeReceivedOnMail
                      : enterCodeReceivedOnPhnNumber,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppTextStyle.txtPTSansRegular14Gray600,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.w, top: 10.h),
                child: Form(
                  key: _formKey,
                  child: CommonTextFormField(
                    cursorHgt: 21,
                    controller: otpController,
                    letterSpacing: 1.5,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    autoValidate: autoValidate,
                    inputCharLength: 6,
                    validator: (value) {
                      if (otpController.text.isEmpty) {
                        return 'Code is required';
                      } else if (otpController.text.trim().length != 6) {
                        return 'Enter valid code';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: getPadding(top: 15, right: 1),
                  child: Text(
                    msgYouCanEnterCodeManually,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppTextStyle.txtSansRegular12Bluegray900,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.h, bottom: 14.h),
                child: CustomElevatedButton(
                  isLoading: isLoading,
                  onTap: () {
                    autoValidate = AutovalidateMode.onUserInteraction;
                    setState(() {});
                    if (_formKey.currentState!.validate()) {
                      widget.verifyTap(otpController.text.trim());
                    }
                  },
                  title: isLoading ? verifying : verify,
                ),
              ),
              Padding(
                padding: getPadding(top: 13, right: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        if (_start == 0) {
                          widget.resendTap();
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            resendCode,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: _start == 0
                                ? AppTextStyle.txtPTSansBold14Bluegray900
                                : AppTextStyle.txtPTSansRegular14,
                          ),
                          if (isResendLoading)
                            Container(
                              padding: const EdgeInsets.only(left: 5),
                              height: 15,
                              width: 20,
                              child: const CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      _start != 0
                          ? '00:${_start <= 9 ? '0$_start' : _start}'
                          : '',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyle.txtPTSansBold14Bluegray900,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      smartAuth.removeSmsListener();
    }

    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }
}
