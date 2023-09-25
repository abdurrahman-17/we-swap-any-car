import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:validators/validators.dart';

import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/postcode/postcode_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../main.dart';
import '../../model/car_model/value_section_input.dart';
import '../../model/post_code/address_detail_model.dart';
import '../../model/user/user_location_model.dart';
import '../../model/user/user_model.dart';
import '../../repository/authentication_repo.dart';
import '../../repository/user_repo.dart';
import '../../service/shared_preference_service.dart';
import '../../utility/custom_formatter.dart';
import '../../utility/date_time_utils.dart';
import '../../utility/file_upload_helper.dart';
import '../../utility/file_utils.dart';
import '../../utility/validator.dart';
import '../add_car/add_car_stepper_screen.dart';
import '../common_popup_widget/sucess_popup_widget.dart';
import '../common_popup_widget/thank_you_popup_widget.dart';
import '../common_widgets/common_admin_support_button.dart';
import '../common_widgets/common_divider.dart';
import '../common_widgets/common_loader.dart';
import '../common_widgets/common_popups.dart';
import '../common_widgets/common_top_model_sheet.dart';
import '../common_widgets/custom_radio_button.dart';
import '../common_widgets/custom_text_widget.dart';
import '../common_widgets/custom_top_sheet.dart';
import '../common_widgets/field_label.dart';
import '../create_avatar/select_profile_avatar.dart';
import '../delete_questionnaire/delete_questionnaire_initial_screen.dart';
import '../landing_screen/landing_screen.dart';
import '../subscription/subscription_screen.dart';
import 'widgets/terms_and_condition.dart';

class SignUpProfileScreen extends StatefulWidget {
  static const String routeName = 'sign_up_profile_screen';
  final UserType? userType;
  final bool isUpgrade;
  final UserModel? user;

  const SignUpProfileScreen({
    Key? key,
    required this.userType,
    this.isUpgrade = false,
    this.user,
  }) : super(key: key);

  @override
  State<SignUpProfileScreen> createState() => _SignUpProfileScreenState();
}

class _SignUpProfileScreenState extends State<SignUpProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController fnController = TextEditingController();
  final TextEditingController lnController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController cnController = TextEditingController();
  final TextEditingController postCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController townController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController aboutCompanyController = TextEditingController();
  final TextEditingController companyUrlController = TextEditingController();
  final TextEditingController companyContactController =
      TextEditingController();
  final SuggestionsBoxController postCodeSuggestionController =
      SuggestionsBoxController();

  List<String> radioList = UserGender.values.map((e) => e.name).toList();

  bool isEmailVerified = false;
  bool isPhoneVerified = false;
  String? profileImage;
  File? imageFile;
  List<String> postCodeResults = [];
  bool isEmailValid = false;
  bool isPhoneValid = false;
  bool termsAnDConditionCheckBox = false;
  String gender = '';
  bool isLoading = false;
  bool isTownRemoved = false;
  bool isAddressRemoved = false;
  bool isFormValidationTriggered = false;
  bool isFirstLoad = true;
  bool isValueChanged = false;
  bool isEdit = false;
  bool isPhoneNumberChangeVerified = false;
  bool isContinueWithRequestUpdatePhone = false;
  ValuesSectionInput? selectedAddressLine;
  AddressDetailModel? selectedAddressDetailModel;

  @override
  void initState() {
    BlocProvider.of<PostCodeDetailsBloc>(context).add(PostCodeInitialEvent());
    if (widget.user != null) {
      profileImage = (widget.userType == UserType.private)
          ? widget.user?.avatarImage
          : widget.user?.trader?.logo;
      fnController.text = widget.user!.firstName ?? '';
      lnController.text = widget.user!.lastName ?? '';
      emailController.text = widget.user!.email ?? '';
      phoneNoController.text = phoneNumberFormatter(widget.user!.phone ?? '');
      companyContactController.text = widget.user?.trader?.companyContact ?? '';
      if (companyContactController.text.isNotEmpty) {
        companyContactController.text =
            phoneNumberFormatter(companyContactController.text);
      }
      cnController.text = widget.user!.trader?.companyName ?? '';
      isFirstLoad = false;
      BlocProvider.of<PostCodeDetailsBloc>(context)
          .add(GetAddressEvent(postcode: widget.user!.postCode ?? ''));
      postCodeController.text = postCodeFormatter(widget.user!.postCode ?? '');
      postCodeResults = [postCodeController.text];
      addressController.text = widget.user!.addressLine1 ?? '';
      townController.text = widget.user?.town ?? '';
      if (widget.user?.dateOfBirth != null) {
        dobController.text = customDateFormat(convertStringToDateTime(
            widget.user!.dateOfBirth!,
            isAWSDateFormat: true)!);
      }
      aboutCompanyController.text =
          widget.user!.trader?.companyDescription ?? '';
      gender = widget.user!.gender ?? '';
      if (widget.isUpgrade) {
        profileImage = imageFile = null;
      }
      companyUrlController.text = widget.user?.trader?.companyWebsiteUrl ?? "";
      isEmailVerified = isPhoneVerified = true;
    } else {
      socialLoginAutoPopulateData();
      gender = radioList[2];
    }

    super.initState();
  }

  //populate data
  void socialLoginAutoPopulateData() async {
    final result =
        await Locator.instance.get<AuthenticationRepo>().populateUserData();
    emailController.text = result.email;
    isEmailVerified = result.isEmailVerified;
    isEmailValid = result.isEmailVerified;
    phoneNoController.text = result.phone;
    isPhoneVerified = result.isPhoneVerified;
    isPhoneValid = result.isPhoneVerified;
    fnController.text = result.firstName;
    lnController.text = result.lastName;
    setState(() {});
  }

  void deleteUser() {
    Navigator.pushNamed(
      context,
      DeleteQuestionnaireInitialScreen.routeName,
      arguments: {
        'userId': widget.user?.userId ?? '',
        'surveyType': SurveyType.deleteProfile,
      },
    );
  }

  void saveUserData() async {
    Map<String, dynamic> user = {};
    if (isEdit && widget.user != null) {
      user["_id"] = widget.user?.userId;
    }
    user["cognitoId"] = SharedPrefServices().getCognitoId();
    user["firstName"] = fnController.text.trim();
    user["lastName"] = lnController.text.trim();
    user["email"] = emailController.text.trim();
    user["phone"] =
        countryCode + phoneNoController.text.trim().replaceAllWhiteSpace();
    user["phoneVerified"] = isPhoneVerified;
    user["emailVerified"] = isEmailVerified;
    user["town"] = townController.text.trim();
    user["addressLine1"] = addressController.text.trim();
    user["postCode"] = postCodeController.text.replaceAllWhiteSpace();
    user["userType"] = convertEnumToString(widget.userType!);
    if (selectedAddressDetailModel != null) {
      UserLocationModel userLocationModel = UserLocationModel(
          type: "point",
          coordinates: [
            selectedAddressDetailModel!.latitude!,
            selectedAddressDetailModel!.longitude!
          ]);
      user["userLocation"] = userLocationModel.toJson();
    }
    if (isEdit && widget.user != null && widget.userType != UserType.private) {
      user["traderId"] = widget.user?.traderId;
    }
    if (widget.userType == UserType.private) {
      user["dateOfBirth"] = customDateFormat(
          convertStringToDateTime(dobController.text, isStandard: true)!,
          isUtc: true);
      user["gender"] = gender;
      user["avatarImage"] = profileImage;
    } else {
      Map<String, dynamic> traderData = {};
      traderData["email"] = user["email"];
      traderData["phone"] = user["phone"];
      traderData["companyName"] = cnController.text.trim();
      traderData["companyDescription"] = aboutCompanyController.text.trim();
      traderData["addressLine1"] = user["addressLine1"];
      traderData["town"] = user["town"];
      if (companyContactController.text.isNotEmpty) {
        traderData["companyContact"] =
            countryCode + companyContactController.text.replaceAllWhiteSpace();
      } else {
        traderData["companyContact"] = '';
      }
      if (companyUrlController.text.isNotEmpty) {
        if (companyUrlController.text.startsWith("https") ||
            companyUrlController.text.startsWith("http")) {
          traderData["companyWebsiteUrl"] = companyUrlController.text.trim();
        } else {
          traderData["companyWebsiteUrl"] =
              "https://${companyUrlController.text.trim()}";
        }
      } else {
        traderData["companyWebsiteUrl"] = '';
      }

      if (imageFile != null) {
        final url = await Locator.instance.get<UserRepo>().uploadFile(
              filePath: imageFile!.path,
              fileName: imageFile!.name,
            );
        if (url != null) {
          traderData["logo"] = getEncodedUrl(url);
        }
      } else if (profileImage != null || profileImage != "") {
        traderData["logo"] = profileImage;
      }

      user['trader'] = traderData;
    }
    //social login params
    final socialLoginType =
        Locator.instance.get<AuthenticationRepo>().getLoginType();
    if (socialLoginType != SocialLogin.none) {
      final authUser =
          await Locator.instance.get<UserRepo>().getCognitoUserData();
      if (authUser != null) {
        user['socialMediaType'] = convertEnumToString(socialLoginType);
        user['socialMediaID'] = authUser.username;
      }
    }
    if (isEdit && widget.user != null) {
      ///Update
      if (!mounted) return;
      BlocProvider.of<UserBloc>(context).add(UpdateUserEvent(userData: user));
    } else {
      ///create
      if (!mounted) return;
      BlocProvider.of<UserBloc>(context).add(CreateUserEvent(userData: user));
    }
  }

  void saveOrSignUp() async {
    setState(() => isLoading = true);
    final isSignedIn =
        await Locator.instance.get<AuthenticationRepo>().checkAuthenticated();
    if (isSignedIn) {
      saveUserData();
    } else {
      Map<String, String> userAttributes = {
        "firstName": fnController.text,
        "lastName": lnController.text,
        "email": emailController.text.trim(),
        "phoneNumber":
            countryCode + phoneNoController.text.replaceAllWhiteSpace()
      };
      if (!mounted) return;
      BlocProvider.of<AuthenticationBloc>(context).add(
          SignUpWithEmailOrPhoneEvent(
              emailOrPhone: emailController.text.trim(),
              userAttributes: userAttributes));
    }
  }

  void setProgressLoad(bool isLoader) {
    if (isLoader) {
      progressDialogue();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDisabled =
        isEdit || widget.user == null || widget.isUpgrade ? false : true;

    return GestureDetector(
      onTap: () => postCodeSuggestionController.suggestionsBox?.close(),
      child: CustomScaffold(
        resizeToAvoidBottomInset: true,
        title: widget.userType == UserType.private
            ? myProfileAppBar
            : companyProfileAppBar,
        actions: [
          AdminSupportButton(
            padding: getPadding(
              right: widget.user != null && !widget.isUpgrade ? 0.w : 10.w,
            ),
          ),
          if (widget.user != null && !widget.isUpgrade)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: ColorConstant.kColor7C7C7C),
              color: ColorConstant.whiteA700,
              position: PopupMenuPosition.under,
              onSelected: (value) async {
                if (value.toLowerCase() == "edit") {
                  setState(() {
                    isEdit = true;
                    termsAnDConditionCheckBox = true;
                  });
                  BlocProvider.of<PostCodeDetailsBloc>(context)
                      .add(GetAddressEvent(postcode: widget.user!.postCode!));
                } else if (value.toLowerCase() == "save") {
                  onTapSave();
                } else if (value.toLowerCase() == "delete account") {
                  bool result = await confirmationPopup(
                    message: deleteMessage,
                    title: confirmTitle,
                    isQuestion: true,
                  );
                  if (result) {
                    deleteUser();
                  }
                }
              },
              itemBuilder: (BuildContext context) {
                return [isEdit ? "Save" : "Edit", "Delete Account"]
                    .map((String choice) => PopupMenuItem<String>(
                        value: choice, child: Text(choice)))
                    .toList();
              },
            )
        ],
        body: bodyWidget(isDisabled),
      ),
    );
  }

  Widget bodyWidget(bool isDisabled) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is CreateUserState) {
          if (state.userDataSaveStatus == ProviderStatus.success) {
            if (Locator.instance.get<AuthenticationRepo>().getLoginType() !=
                SocialLogin.none) {
              Locator.instance.get<AuthenticationRepo>().updateCognito(
                  firstName: state.user!.firstName!,
                  lastName: state.user!.lastName!,
                  phoneNumber: "$countryCode${state.user!.phone}",
                  email: "${state.user!.email}");
            }
            setProgressLoad(false);
            thankYouPopup(widget.userType!);
          } else if (state.userDataSaveStatus == ProviderStatus.error) {
            setProgressLoad(false);
            showSnackBar(message: state.errorMessage ?? '');
          } else {
            setState(() => isLoading = false);
            setProgressLoad(true);
          }
        } else if (state is UpdateUserState) {
          if (state.userDataUpdateStatus == ProviderStatus.success) {
            Navigator.pushNamedAndRemoveUntil(
                context, LandingScreen.routeName, (route) => false);
            successToast();
          } else if (state.userDataUpdateStatus == ProviderStatus.error) {
            setProgressLoad(false);
            showSnackBar(message: state.errorMessage ?? '');
          } else {
            setState(() => isLoading = false);
            setProgressLoad(true);
          }
        }
      },
      child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) async {
          ///SIGN-UP
          if (state is SignUpState) {
            if (state.signUpStatus == ProviderStatus.success) {
              BlocProvider.of<AuthenticationBloc>(context).add(
                SignInWithEmailOrPhoneEvent(
                  emailOrPhone: state.emailOrPhone!,
                  isSignUp: true,
                ),
              );
            } else if (state.signUpStatus == ProviderStatus.error) {
              setState(() => isLoading = false);
              showSnackBar(
                  message: state.errorMessage ?? "User creation failed");
            } else {
              ///signUp loading
              setState(() => isLoading = true);
            }
          }

          ///SIGN-IN
          else if (state is SignInState) {
            if (state.signInStatus == ProviderStatus.success) {
              saveUserData();

              ///create user
            } else if (state.signInStatus == ProviderStatus.error) {
              setState(() => isLoading = false);
              showSnackBar(message: state.errorMessage ?? '');
            } else if (state.signInStatus == ProviderStatus.loading) {
              //signIn loading
              setState(() => isLoading = true);
            }
          } else if (state is OtpSendSuccessState && !state.isLogin) {
            //otp send success
            setState(() => isLoading = false);
            bool? result = await showCommonTopModalSheet(
              context,
              CustomTopSheet(
                isEmail: isStringNumeric(state.emailOrPhone) ? false : true,
                emailOrPhone: isStringNumeric(state.emailOrPhone)
                    ? maskString(
                        state.emailOrPhone.substring(3),
                        length: 0,
                      )
                    : state.emailOrPhone,
                verifyTap: (otp) {
                  BlocProvider.of<AuthenticationBloc>(context).add(
                      EmailOrPhoneVerificationConfirmEvent(
                          emailOrPhone: state.emailOrPhone,
                          isEmail: isStringNumeric(state.emailOrPhone)
                              ? false
                              : true,
                          verificationCode: otp));
                },
                resendTap: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(
                      EmailOrPhoneVerificationOtpResend(
                          emailOrPhone: state.emailOrPhone,
                          isEmail: !isStringNumeric(state.emailOrPhone)));
                },
              ),
              barrierDismissible: false,
            );
            if (result != null && result) {
              successPopup();
              setState(() {
                isStringNumeric(state.emailOrPhone)
                    ? isPhoneVerified = true
                    : isEmailVerified = true;
              });
            }
          } else if (state is OtpSendErrorState) {
            showSnackBar(message: state.errorMessage);
          } else if (state is UpdateOtpSendSuccessState) {
            //Update otp send success
            setState(() => isLoading = false);
            bool? result = await showCommonTopModalSheet(
              context,
              CustomTopSheet(
                emailOrPhone:
                    maskString(state.newPhoneNumber.substring(3), length: 0),
                verifyTap: (otp) {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(UpdatePhoneVerificationConfirmEvent(
                    phoneNumber: state.phoneNumber,
                    newphoneNumber: state.newPhoneNumber,
                    verificationCode: otp,
                    continueWithReq: isContinueWithRequestUpdatePhone,
                  ));
                },
                resendTap: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(UpdatePhoneVerificationOtpResend(
                    phoneNumber: state.phoneNumber,
                    newphoneNumber: state.newPhoneNumber,
                    continueWithReq: isContinueWithRequestUpdatePhone,
                  ));
                },
              ),
              barrierDismissible: false,
            );
            if (result != null && result) {
              setState(() {
                isPhoneVerified = true;
                isPhoneNumberChangeVerified = true;
                phoneNoController.text =
                    phoneNumberFormatter(widget.user!.phone!);
              });
              showSnackBar(message: updatePhoneNumberMessage);
            }
          } else if (state is UpdateOtpSendErrorState) {
            if (state.errorMessage == changeRequestExistsSameNumber) {
              infoOrThankyouPopup(
                message: phoneNumberRequestExistsErrorMsg,
                buttonText: closeButton,
                onTapButton: () {
                  Navigator.pop(context);
                },
              );
            } else if (state.errorMessage == changeRequestExistsDiffNumber ||
                state.errorMessage ==
                    changeRequestExistsSameNumberFromDiffUser) {
              bool isOk = await confirmationPopup(
                title: confirmTitle,
                message: state.errorMessage ==
                        changeRequestExistsSameNumberFromDiffUser
                    ? phoneNumberRequestSameNumberExistsErrorMsg
                    : '$phoneNumberRequestDiffNumberExistsErrorMsg1'
                        '${state.data!['newPhoneNumber'] ?? ""}'
                        '$phoneNumberRequestDiffNumberExistsErrorMsg2',
                isQuestion: true,
              );
              if (isOk) {
                isContinueWithRequestUpdatePhone = true;

                // ignore: use_build_context_synchronously
                BlocProvider.of<AuthenticationBloc>(context).add(
                  UpdatePhoneVerificationEvent(
                    newphoneNumber: countryCode + phoneNoController.text.trim(),
                    phoneNumber: widget.user!.phone!,
                    continueWithReq: true,
                  ),
                );
              }
            } else if (state.errorMessage == phoneNumberExistsUpdatePhone) {
              showSnackBar(message: phoneNumberAlreadyExists);
            } else {
              showSnackBar(message: state.errorMessage);
            }
          }
        },
        builder: (context, state) {
          return IgnorePointer(
            ignoring: isLoading,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: getPadding(left: 25.w, right: 25.w),
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: getPadding(top: 20, bottom: 31),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            profileImageWidget(isDisabled),
                            if (widget.user == null ||
                                widget.isUpgrade ||
                                isEdit)
                              GestureDetector(
                                onTap: () async {
                                  if (!isDisabled) {
                                    if (widget.userType == UserType.private) {
                                      getAvatar(setState);
                                    } else {
                                      getCompanyLogo(setState);
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: getPadding(top: 8),
                                  child: FieldLabelWidget(
                                    label: widget.userType == UserType.private
                                        ? isEdit
                                            ? (imageFile == null &&
                                                    profileImage == null
                                                ? createAvatar
                                                : changeAvatar)
                                            : createAvatar
                                        : isEdit
                                            ? (imageFile == null &&
                                                    profileImage == null
                                                ? uploadCompanyLogo
                                                : changeCompanyLogo)
                                            : uploadCompanyLogo,
                                    style: AppTextStyle
                                        .txtSansRegular12Bluegray900,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const GradientDivider(),
                      Padding(
                        padding: getPadding(top: 20, bottom: 5),
                        child: const FieldLabelWidget(
                          label: firstNameLabel,
                          isMandatory: true,
                        ),
                      ),
                      CommonTextFormField(
                        hint: textFieldLabelEnterTheText + firstNameLabel,
                        bgColor: isDisabled ? ColorConstant.kColorEAEAEA : null,
                        readOnly: isDisabled,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(32),
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z-]")),
                        ],
                        controller: fnController,
                        autoValidate: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (fnController.text.trim().isEmpty) {
                            fnController.clear();
                            return firstNameRequiredErrorMsg;
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: getPadding(top: 14, bottom: 5),
                        child: const FieldLabelWidget(
                          label: lastNameLabel,
                          isMandatory: true,
                        ),
                      ),
                      CommonTextFormField(
                        controller: lnController,
                        hint: textFieldLabelEnterTheText + lastNameLabel,
                        bgColor: isDisabled ? ColorConstant.kColorEAEAEA : null,
                        readOnly: isDisabled,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(32),
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z- ]")),
                        ],
                        autoValidate: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (lnController.text.trim().isEmpty) {
                            lnController.clear();
                            return lastNameRequiredErrorMsg;
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: getPadding(top: 14, bottom: 5),
                        child: const FieldLabelWidget(
                          label: emailAddressLabel,
                          isMandatory: true,
                        ),
                      ),
                      emailField(state),
                      Padding(
                        padding: getPadding(top: 14.h, bottom: 5.h),
                        child: const FieldLabelWidget(
                          label: phoneNumberLabel,
                          isMandatory: true,
                        ),
                      ),
                      phoneNumberField(state),
                      //company name and url
                      if (widget.userType != UserType.private)
                        companyDetails(isDisabled),

                      ///GENDER ,DOB & post code
                      if (widget.userType == UserType.private)
                        personalDetails(isDisabled),

                      Padding(
                        padding: getPadding(top: 14, bottom: 5),
                        child: const FieldLabelWidget(
                          label: addressLineOne,
                          isMandatory: true,
                        ),
                      ),
                      addressWidget(),
                      Padding(
                        padding: getPadding(top: 14, bottom: 5),
                        child: const FieldLabelWidget(
                          label: townLabel,
                          isMandatory: true,
                        ),
                      ),
                      townWidget(),
                      if (widget.userType != UserType.private)
                        aboutCompany(isDisabled),
                      SizedBox(height: 10.h),
                      // Terms & conditions Checkbox
                      if (widget.isUpgrade || widget.user == null || isEdit)
                        TermsAndConditions(
                          isDisabled: isEdit,
                          isProfile: widget.user != null,
                          termsAnDConditionCheckBox: termsAnDConditionCheckBox,
                          onChanged: (value) {
                            termsAnDConditionCheckBox = value;
                          },
                        ),

                      ///SAVE / CREATE BUTTON
                      if (!widget.isUpgrade && (isEdit || widget.user == null))
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 26, bottom: 10),
                            child: CustomElevatedButton(
                              isLoading: isLoading,
                              title: widget.user == null
                                  ? createAccountButton
                                  : isEdit
                                      ? saveButton
                                      : editButton,
                              onTap: () async {
                                if (isEdit ||
                                    widget.user == null ||
                                    widget.isUpgrade) {
                                  onTapSave();
                                } else {
                                  setState(() => isEdit = true);
                                }
                              },
                            ),
                          ),
                        ),

                      ///UPGRADE TO DEALER BUTTON
                      if ((widget.isUpgrade ||
                              widget.userType == UserType.private) &&
                          widget.user != null &&
                          !isEdit)
                        SafeArea(
                          child: Padding(
                            padding: getPadding(top: 15.h, bottom: 20.h),
                            child: CustomElevatedButton(
                              isLoading: isLoading,
                              title: upgradeToTradeButton,
                              onTap: widget.user?.upgradeToDealer?.status ==
                                      convertEnumToString(Status.pending)
                                  ? () => showSnackBar(
                                      message: upgradeToDealerReqexists)
                                  : widget.user != null && !widget.isUpgrade
                                      ? () => Navigator.pushNamed(
                                            context,
                                            SignUpProfileScreen.routeName,
                                            arguments: {
                                              "userType": UserType.dealerAdmin,
                                              "user": widget.user,
                                              'isUpgrade': true,
                                            },
                                          )
                                      : () => onTapSave(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget profileImageWidget(bool isDisabled) {
    return GestureDetector(
      onTap: () async {
        if (!isDisabled) {
          if (widget.userType == UserType.private) {
            getAvatar(setState);
          } else {
            getCompanyLogo(setState);
          }
        }
      },
      child: Container(
        height: getSize(87),
        width: getSize(87),
        decoration: AppDecoration.kGradientBoxDecoration.copyWith(
          border: Border.all(color: ColorConstant.kPrimaryLightRed),
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: isLoading
            ? const LottieLoader()
            : (profileImage == null && imageFile == null)
                ? !isDisabled
                    ? Icon(
                        Icons.camera_alt_outlined,
                        color: ColorConstant.kColorEBEBEB,
                        size: getSize(20),
                      )
                    : CustomImageView(
                        svgPath: widget.userType == UserType.private
                            ? Assets.privatePlaceholder
                            : Assets.dealerPlaceholder,
                        color: ColorConstant.kColorWhite,
                        margin: getMargin(all: 16.r),
                      )
                : CustomImageView(
                    fit: BoxFit.fill,
                    file: imageFile,
                    url: profileImage,
                    height: getSize(87),
                    width: getSize(87),
                    radius: BorderRadius.circular(100.r),
                  ),
      ),
    );
  }

  Widget emailField(AuthenticationState state) {
    return CommonTextFormField(
      readOnly: isEmailVerified,
      bgColor: isEmailVerified ? ColorConstant.kColorEAEAEA : null,
      cursorHgt: 21,
      hint: textFieldLabelEnterTheText + emailAddressLabel,
      autoValidate: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        if (value.isEmpty || value == "") {
          setState(() => isEmailValid = false);
        } else if (Validation.isValidEmail(value.trim())) {
          setState(() => isEmailValid = true);
        } else {
          setState(() => isEmailValid = false);
        }
      },
      suffixIcon: state is EmailOrPhoneVerifyingState && state.isEmail
          ? Transform.scale(
              scale: 0.4,
              child: const CircularLoader(),
            )
          : Padding(
              padding: getPadding(
                top: 9.5.h,
                bottom: 9.5.h,
                right: 8.w,
              ),
              child: Padding(
                padding: getPadding(left: 8.w),
                child: isEmailVerified
                    ? Icon(
                        CupertinoIcons.checkmark_seal_fill,
                        color: ColorConstant.kColor95C926,
                        size: getSize(21),
                      )
                    : isEmailValid
                        ? GradientElevatedButton(
                            width: getHorizontalSize(72),
                            height: getVerticalSize(10),
                            title: verify,
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              if (!isEmailVerified) {
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(
                                  EmailOrPhoneVerificationEvent(
                                    emailOrPhone: emailController.text.trim(),
                                    isEmail: true,
                                  ),
                                );
                              }
                            },
                          )
                        : null,
              ),
            ),
      textInputType: TextInputType.emailAddress,
      controller: emailController,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (emailController.text.trim().isEmpty) {
          emailController.clear();
          return emailRequiredErrorMsg;
        } else if (!Validation.isValidEmail(emailController.text.trim())) {
          return invalidEmailErrorMsg;
        }
        return null;
      },
    );
  }

  Widget phoneNumberField(AuthenticationState state) {
    return CommonTextFormField(
      cursorHgt: 21,
      readOnly: isPhoneNumberChangeVerified
          ? true
          : (isEdit && widget.user != null)
              ? false
              : isPhoneVerified,
      bgColor: isPhoneNumberChangeVerified
          ? ColorConstant.kColorEAEAEA
          : (isEdit && widget.user != null)
              ? null
              : isPhoneVerified
                  ? ColorConstant.kColorEAEAEA
                  : null,
      hint: textFieldLabelEnterTheText + phoneNumberLabel,
      textInputType: TextInputType.phone,
      inputCharLength: phoneNumberLength,
      autoValidate: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        if (widget.user != null) {
          if (value == phoneNumberFormatter(widget.user!.phone!)) {
            setState(() => isPhoneVerified = true);
          } else {
            setState(() => isPhoneVerified = false);
          }
        }

        if (value.isEmpty || value == "") {
          setState(() => isPhoneValid = false);
        } else if (Validation.isValidPhone(value.trim())) {
          setState(() => isPhoneValid = true);
        } else {
          setState(() => isPhoneValid = false);
        }
      },
      suffixIcon: state is EmailOrPhoneVerifyingState && !state.isEmail
          ? Transform.scale(scale: 0.4, child: const CircularLoader())
          : Padding(
              padding: getPadding(
                top: 9.5.h,
                bottom: 9.5.h,
                right: 8.w,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: isPhoneVerified
                    ? Icon(
                        CupertinoIcons.checkmark_seal_fill,
                        color: ColorConstant.kColor95C926,
                        size: getSize(21),
                      )
                    : isPhoneValid
                        ? GradientElevatedButton(
                            width: getHorizontalSize(72),
                            height: getVerticalSize(10),
                            title: verify,
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              if (!isPhoneVerified) {
                                if (isEdit && widget.user != null) {
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .add(
                                    UpdatePhoneVerificationEvent(
                                      newphoneNumber: countryCode +
                                          phoneNoController.text.trim(),
                                      phoneNumber: widget.user!.phone!,
                                      continueWithReq: false,
                                    ),
                                  );
                                } else {
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .add(
                                    EmailOrPhoneVerificationEvent(
                                      emailOrPhone: countryCode +
                                          phoneNoController.text.trim(),
                                      isEmail: false,
                                    ),
                                  );
                                }
                              }
                            },
                          )
                        : null,
              ),
            ),
      prefixIcon: Padding(
        padding: getPadding(
          top: 13,
          left: 13,
          bottom: 13,
          right: 8,
        ),
        child: CustomImageView(
          imagePath: Assets.ukFlag,
          height: getVerticalSize(5),
          width: getHorizontalSize(5),
          radius: BorderRadius.circular(2.r),
          margin: getMargin(
            left: 4,
            top: 3,
            bottom: 3,
          ),
        ),
      ),
      controller: phoneNoController,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (phoneNoController.text.isEmpty) {
          phoneNoController.clear();
          return phoneNoRequiredErrorMsg;
        } else if (!Validation.isValidPhone(phoneNoController.text.trim())) {
          return invalidPhoneNoErrorMsg;
        }
        return null;
      },
    );
  }

  Widget companyDetails(bool isDisabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: getPadding(top: 15, bottom: 5),
          child: const FieldLabelWidget(label: telephoneNumber),
        ),
        CommonTextFormField(
          prefixIcon: Padding(
            padding:
                const EdgeInsets.only(top: 13, left: 13, bottom: 13, right: 8),
            child: CustomImageView(
              imagePath: Assets.ukFlag,
              height: getVerticalSize(5),
              width: getHorizontalSize(5),
              radius: BorderRadius.circular(2.r),
              margin: getMargin(
                left: 4,
                top: 3,
                bottom: 3,
              ),
            ),
          ),
          readOnly: isDisabled,
          bgColor: isDisabled ? ColorConstant.kColorEAEAEA : null,
          controller: companyContactController,
          hint: textFieldLabelEnterTheText + telephoneNumber,
          textInputType: TextInputType.number,
          inputFormatters: [
            MaskedTextInputFormatter(
              mask: 'xxxx xxxxxxx',
              separator: ' ',
            )
          ],
          maxLines: 1,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if ((value.replaceAllWhiteSpace()).length < 10) {
                return "Invalid Telephone";
              } else if (!Validation.isValidPhone(
                  companyContactController.text.trim())) {
                return invalidPhoneNoErrorMsg;
              }
            }
            return null;
          },
        ),
        Padding(
          padding: getPadding(top: 14, bottom: 5),
          child: const FieldLabelWidget(
            label: companyNameLabel,
            isMandatory: true,
          ),
        ),
        CommonTextFormField(
          controller: cnController,
          hint: textFieldLabelEnterTheText + companyNameLabel,
          textInputType: TextInputType.text,
          readOnly: isDisabled,
          inputCharLength: 50,
          bgColor: isDisabled ? ColorConstant.kColorEAEAEA : null,
          autoValidate: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (cnController.text.trim().isEmpty) {
              cnController.clear();
              return companyNameRequiredErrorMsg;
            }
            return null;
          },
        ),
        Padding(
          padding: getPadding(top: 15, bottom: 5),
          child: const FieldLabelWidget(
            label: companyWebsiteUrlLabel,
          ),
        ),
        CommonTextFormField(
          controller: companyUrlController,
          textInputAction: TextInputAction.done,
          hint: textFieldLabelEnterTheText + companyWebsiteUrlLabel,
          textInputType: TextInputType.url,
          readOnly: isDisabled,
          bgColor: isDisabled ? ColorConstant.kColorEAEAEA : null,
          maxLines: 1,
          autoValidate: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value?.trim() == null || value == "") {
              return null;
            } else if (!isURL(value)) {
              return invalidWebsiteUrlErrorMsg;
            }
            return null;
          },
        ),
        postCodeWidget(15),
      ],
    );
  }

  Widget personalDetails(bool isDisabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: getPadding(top: 14),
          child: const FieldLabelWidget(
            label: genderLabel,
            isMandatory: true,
          ),
        ),
        IgnorePointer(
          ignoring: isDisabled,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomRadioWithLabel(
                  text: maleRadio,
                  value: radioList[0],
                  groupValue: gender,
                  disabledColor: isDisabled ? ColorConstant.kColorEAEAEA : null,
                  onChanged: (value) {
                    setState(() => gender = value!);
                  },
                  onTapLabel: () {
                    setState(() => gender = radioList[0]);
                  },
                ),
                CustomRadioWithLabel(
                  text: femaleRadio,
                  value: radioList[1],
                  groupValue: gender,
                  disabledColor: isDisabled ? ColorConstant.kColorEAEAEA : null,
                  onChanged: (value) {
                    setState(() => gender = value!);
                  },
                  onTapLabel: () {
                    setState(() => gender = radioList[1]);
                  },
                ),
                CustomRadioWithLabel(
                  text: iWouldRatherNotSay,
                  value: radioList[2],
                  groupValue: gender,
                  disabledColor: isDisabled ? ColorConstant.kColorEAEAEA : null,
                  onChanged: (value) {
                    setState(() => gender = value!);
                  },
                  onTapLabel: () {
                    setState(() => gender = radioList[2]);
                  },
                )
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: getPadding(bottom: 5, top: 14),
              child: const FieldLabelWidget(
                label: dateOfBirthLabel,
                isMandatory: true,
              ),
            ),
            IgnorePointer(
              ignoring: isDisabled,
              child: CommonTextFormField(
                onTap: openDatePicker,
                contentPadding: EdgeInsets.only(left: 18.w),
                maxLines: 1,
                suffixIcon: CustomImageView(
                  svgPath: Assets.calendar,
                  height: getSize(18),
                  width: getSize(18),
                  margin: getMargin(right: 20, top: 2, left: 15),
                ),
                controller: dobController,
                readOnly: true,
                bgColor: isDisabled ? ColorConstant.kColorEAEAEA : null,
                textInputType: TextInputType.number,
                hint: dobTextFieldHintText,
                autoValidate: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (dobController.text.isEmpty) {
                    return dobRequiredErrorMsg;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        postCodeWidget(14)
      ],
    );
  }

  Widget aboutCompany(bool isDisabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: getPadding(top: 14, bottom: 5),
          child: const FieldLabelWidget(
            label: companyDescriptionLabel,
          ),
        ),
        CommonTextFormField(
          controller: aboutCompanyController,
          textInputAction: TextInputAction.done,
          hint: textFieldLabelEnterTheText + companyDescriptionLabel,
          textInputType: TextInputType.text,
          maxLines: 4,
          minLines: 4,
          inputCharLength: 250,
          maxLength: 250,
          readOnly: isDisabled,
          bgColor: isDisabled ? ColorConstant.kColorEAEAEA : null,
          autoValidate: AutovalidateMode.onUserInteraction,
          validator: (value) => null,
        ),
        SizedBox(height: 5.h),
        if (widget.userType != UserType.private &&
            (isEdit || widget.user == null))
          mandatoryText(thisWillGoInTheAdvertsText),
      ],
    );
  }

  Widget townWidget() {
    bool isDisabled =
        isEdit || widget.user == null || widget.isUpgrade ? false : true;
    return BlocBuilder<PostCodeDetailsBloc, PostCodeDetailsState>(
      builder: (context, state) {
        if (state is AddressDetailsState) {
          if (state.addressDetailStatus == ProviderStatus.loading) {
            return shimmerLoader(
              Container(
                height: getVerticalSize(41.h),
                decoration: BoxDecoration(
                  color: ColorConstant.kColorWhite,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            );
          } else if (!isFirstLoad &&
              state.addressDetailStatus == ProviderStatus.success) {
            selectedAddressDetailModel = state.addressDetailModel;
            townController.text = selectedAddressDetailModel?.townOrCity ?? '';
          } else if (state.addressDetailStatus == ProviderStatus.error) {
            // showSnackBar(message: errorOccurred);
          }
        }
        return Padding(
          padding: getPadding(
              bottom: (!widget.isUpgrade &&
                      !isEdit &&
                      widget.user != null &&
                      widget.userType == UserType.private)
                  ? 26
                  : 0),
          child: CommonTextFormField(
            controller: townController,
            textInputAction: TextInputAction.done,
            hint: townLabel,
            textInputType: TextInputType.text,
            readOnly: true,
            bgColor: isDisabled ? ColorConstant.kColorEAEAEA : null,
            onChanged: (value) {},
            autoValidate: isTownRemoved
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (townController.text.trim().isEmpty) {
                townController.clear();
                return townRequiredErrorMsg;
              }
              return null;
            },
          ),
        );
      },
    );
  }

  Widget addressWidget() {
    bool isDisabled =
        isEdit || widget.user == null || widget.isUpgrade ? false : true;
    return BlocBuilder<PostCodeDetailsBloc, PostCodeDetailsState>(
      builder: (context, state) {
        final postCodeBloc = context.read<PostCodeDetailsBloc>();
        if (state is AddressListState || state is AddressDetailsState) {
          if (state is AddressListState &&
              state.addressFetchStatus == ProviderStatus.loading) {
            return shimmerLoader(
              Container(
                height: getVerticalSize(41.h),
                decoration: BoxDecoration(
                  color: ColorConstant.kColorWhite,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            );
          } else if (!isFirstLoad &&
              (state is AddressListState || state is AddressDetailsState)) {
            List<ValuesSectionInput> tempList = [];
            if (widget.user != null && !isEdit) {
              for (var element in postCodeBloc.addressList + []) {
                if (element.address == widget.user!.addressLine1) {
                  selectedAddressLine = ValuesSectionInput(
                      id: element.id, name: element.address ?? '');
                }
              }
            }
            for (var element in postCodeBloc.addressList + []) {
              tempList.add(ValuesSectionInput(
                  id: element.id, name: element.address ?? ''));
            }

            if (isDisabled) {
              return CommonTextFormField(
                readOnly: true,
                controller: addressController,
                maxLines: 4,
                bgColor: isDisabled ? ColorConstant.kColorEAEAEA : null,
              );
            }

            return IgnorePointer(
              ignoring: isDisabled,
              child: CommonDropDown(
                isSelectedItemBuilder: true,
                bgColor: isDisabled ? ColorConstant.kColorEAEAEA : null,
                selectedValue: selectedAddressLine,
                margin: getMargin(top: 5),
                autovalidateMode: isAddressRemoved
                    ? AutovalidateMode.always
                    : AutovalidateMode.onUserInteraction,
                items: tempList,
                isDense: true,
                validatorMsg: addressRequiredErrorMsg,
                onChanged: (value) {
                  setState(() => isValueChanged = true);
                  selectedAddressLine = value;
                  townController.text = '';
                  addressController.text = value?.name ?? '';
                  BlocProvider.of<PostCodeDetailsBloc>(context).add(
                      GetAddressDetailEvent(
                          addressId: selectedAddressLine?.id ?? ''));
                },
                searchHintText: searchAddressHintText,
              ),
            );
          }
        }
        return IgnorePointer(
          child: CommonDropDown(
            selectedValue: selectedAddressLine,
            margin: getMargin(top: 5),
            isDense: true,
            autovalidateMode: isAddressRemoved
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            items: testSelectableList,
            validatorMsg: addressRequiredErrorMsg,
            onChanged: (value) {},
            searchHintText: searchAddressHintText,
          ),
        );
      },
    );
  }

  Widget postCodeWidget(double top) {
    bool isDisabled =
        isEdit || widget.user == null || widget.isUpgrade ? false : true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: getPadding(top: top, bottom: 5),
          child: const FieldLabelWidget(
            label: postCodeLabel,
            isMandatory: true,
          ),
        ),
        TypeAheadFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (!Validation.isValidPostcode(postCodeController.text.trim(),
                isRequired: true)) {
              postCodeController.clear();
              return postCodeRequiredErrorMsg;
            } else if (postCodeResults.isEmpty) {
              return invalidPostCodeErrorMsg;
            }
            return null;
          },
          suggestionsCallback: (pattern) async {
            if (pattern.isEmpty) {
              return [];
            } else {
              List<String> result =
                  await Locator.instance.get<UserRepo>().getPostCodes(pattern);
              setState(() => postCodeResults = result);
              return result;
            }
          },
          itemBuilder: (context, itemData) => ListTile(
            title: Text(itemData.toString()),
          ),
          noItemsFoundBuilder: (context) => const SizedBox(),
          loadingBuilder: (context) {
            return const SizedBox(
              height: 100,
              child: Center(child: CircularLoader()),
            );
          },
          onSuggestionSelected: (suggestion) {
            isFirstLoad = false;
            postCodeController.text = "$suggestion";
            addressController.text = '';
            townController.text = "";
            if (isFormValidationTriggered || selectedAddressLine != null) {
              isTownRemoved = true;
              isAddressRemoved = true;
            }
            selectedAddressLine = null;
            BlocProvider.of<PostCodeDetailsBloc>(context)
                .add(GetAddressEvent(postcode: postCodeController.text));
          },
          hideKeyboardOnDrag: true,
          hideSuggestionsOnKeyboardHide: false,
          minCharsForSuggestions: 1,
          direction: AxisDirection.up,
          suggestionsBoxDecoration: SuggestionsBoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
          ),
          debounceDuration: const Duration(milliseconds: 500),
          textFieldConfiguration: TextFieldConfiguration(
            onSubmitted: (newValue) {
              isFirstLoad = false;
              postCodeController.text = newValue;
              selectedAddressLine = null;
              BlocProvider.of<PostCodeDetailsBloc>(context)
                  .add(GetAddressEvent(postcode: postCodeController.text));
            },
            decoration: commonInputDecoration.copyWith(
              hintText: typeToSearch,
              fillColor: isDisabled ? ColorConstant.kColorEAEAEA : null,
            ),
            enabled: !isDisabled,
            inputFormatters: [
              UpperCaseTextFormatter(),
              LengthLimitingTextInputFormatter(10),
              NoLeadingSpaceFormatter(),
            ],
            controller: postCodeController,
            style: TextStyle(
              fontFamily: Assets.primaryFontPTSans,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.none,
              color: ColorConstant.kColor353333,
            ),
          ),
          suggestionsBoxController: postCodeSuggestionController,
        )
      ],
    );
  }

  void getAvatar(void Function(void Function()) setState) async {
    Object? avatarImgUrl =
        await Navigator.pushNamed(context, SelectProfileAvatarScreen.routeName);
    if (avatarImgUrl != null) {
      setState(() => profileImage = avatarImgUrl as String);
    }
  }

  void getCompanyLogo(void Function(void Function()) setState) {
    FileManager().showModelSheetForImage(
      setLoader: setLoader,
      getFile: (value) async {
        if (value != null && value.isNotEmpty) {
          String? croppedImagePath = await imageCropper(filePath: value);
          if (croppedImagePath != null) {
            setState(() => imageFile = File(croppedImagePath));
          }
        }
        setState(() => isLoading = false);
      },
    );
  }

  void setLoader() => setState(() => isLoading = true);

  void onTapSave() {
    final isValid = _formKey.currentState!.validate();
    isFormValidationTriggered = true;
    if (isValid) {
      if (!isEmailVerified || !isPhoneVerified) {
        showSnackBar(message: emailOrPhoneNotVerified);
      } else if (widget.userType == UserType.private && gender.isEmpty) {
        showSnackBar(message: chooseYourGender);
      } else if (!termsAnDConditionCheckBox &&
          (widget.isUpgrade || widget.user == null)) {
        showSnackBar(message: pleaseAcceptPolicy);
      } else if (widget.isUpgrade) {
        onTapUpgradeToDealer();
      } else {
        saveOrSignUp();
      }
    }
  }

  void onTapUpgradeToDealer() async {
    setState(() => isLoading = true);
    Map<String, dynamic> traderData = {};
    traderData["email"] = emailController.text;
    traderData["phone"] = phoneNoController.text;
    traderData["companyName"] = cnController.text.trim();
    traderData["companyDescription"] = aboutCompanyController.text.trim();
    traderData["addressLine1"] = addressController.text;
    traderData["town"] = townController.text;
    if (companyContactController.text.isNotEmpty) {
      traderData["companyContact"] =
          countryCode + companyContactController.text.trim();
    } else {
      traderData["companyContact"] = '';
    }
    if (companyUrlController.text.isNotEmpty) {
      if (companyUrlController.text.startsWith("https") ||
          companyUrlController.text.startsWith("http")) {
        traderData["companyWebsiteUrl"] = companyUrlController.text.trim();
      } else {
        traderData["companyWebsiteUrl"] =
            "https://${companyUrlController.text.trim()}";
      }
    } else {
      traderData["companyWebsiteUrl"] = '';
    }
    if (imageFile != null) {
      final url = await Locator.instance.get<UserRepo>().uploadFile(
            filePath: imageFile!.path,
            fileName: imageFile!.name,
          );
      if (url != null) {
        traderData["logo"] = getEncodedUrl(url);
      }
    }
    if (!mounted) return;
    setState(() => isLoading = false);
    Navigator.pushNamed(
      context,
      SubscriptionPage.routeName,
      arguments: {"userUpgradeData": traderData},
    );
  }

  Future<void> openDatePicker() async {
    DateTime lastDate = DateTime(getCurrentDateTime().year - 18,
        getCurrentDateTime().month, getCurrentDateTime().day);
    DateTime selectedDate = dobController.text.isNotEmpty
        ? convertStringToDateTime(dobController.text, isStandard: true)!
        : lastDate;
    DateTime? pickedDate = await showCommonDatePicker(
      initialDate: selectedDate,
      firstDate:
          DateTime(1900, getCurrentDateTime().month, getCurrentDateTime().day),
      lastDate: lastDate,
    );
    if (pickedDate != null) {
      setState(() {
        dobController.text = customDateFormat(pickedDate);
      });
    }
  }

  void successPopup() {
    customPopup(
      hasContentPadding: false,
      content: const SuccessfulPopup(),
    );
    delayedStart(() => Navigator.pop(globalNavigatorKey.currentContext!));
  }
}

void successToast() {
  delayedStart(() {
    showSnackBar(message: dataSavedSuccessfully);
  }, duration: const Duration(seconds: 1));
}

void thankYouPopup(UserType userType) {
  customPopup(
    hasContentPadding: false,
    content: const ThankYouPopup(),
  );
  delayedStart(() {
    if (userType == UserType.private) {
      ///Add Car Stepper Page
      log("Private account -> Add Car Stepper Screen");
      Navigator.pushNamedAndRemoveUntil(globalNavigatorKey.currentContext!,
          AddCarStepperScreen.routeName, (route) => false);
    } else {
      ///subscription page
      log("Dealer account -> subscription page");
      Navigator.pushNamedAndRemoveUntil(globalNavigatorKey.currentContext!,
          SubscriptionPage.routeName, (route) => false);
    }
  });
}
