import 'dart:developer';

import '../../core/configurations.dart';
import '../../main.dart';
import '../../bloc/need_finance/need_finance_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../model/user/user_model.dart';
import '../../utility/custom_formatter.dart';
import '../common_widgets/common_admin_support_button.dart';
import '../common_widgets/common_loader.dart';
import '../common_widgets/common_popups.dart';
import '../common_widgets/common_slider.dart';
import '../common_widgets/custom_checkbox.dart';
import '../landing_screen/landing_screen.dart';

class NeedFinanceScreen extends StatefulWidget {
  static const String routeName = 'need_finance_screen';
  const NeedFinanceScreen({super.key});

  @override
  State<NeedFinanceScreen> createState() => _NeedFinanceScreenState();
}

class _NeedFinanceScreenState extends State<NeedFinanceScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late bool isChecked = false;
  late int price = 1100;
  UserModel? user;
  bool isLoading = false;

  void setLoading(bool value) => setState(() => isLoading = value);

  void progressLoad(bool value) {
    setLoading(value);
    if (value) {
      progressDialogue(isCircularProgress: true);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    user = context.read<UserBloc>().currentUser;
    autoPopulateData();
    super.initState();
  }

  void autoPopulateData() {
    _nameController.text = (user?.firstName?.toProperCase() ?? '') +
        blankSpace +
        (user?.lastName?.toProperCase() ?? '');
    _emailController.text = user?.email ?? '';
    _phoneController.text = phoneNumberFormatter(user!.phone!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NeedFinanceBloc, NeedFinanceState>(
      listener: (context, state) async {
        if (state is AddFinanceRequestState &&
            state.needFinanceStatus == ProviderStatus.success) {
          progressLoad(false);
          await infoOrThankyouPopup(
            message: requestSendToAdmin,
            onTapButton: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                LandingScreen.routeName,
                (route) => false,
              );
            },
          );
        }
      },
      child: CustomScaffold(
        title: needFinanceAppBar,
        actions: const [
          AdminSupportButton(),
        ],
        body: Stack(
          children: [
            CustomImageView(
              svgPath: Assets.homeBackground,
              fit: BoxFit.fill,
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 34.w),
                child: Column(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: getPadding(top: 15.h, bottom: 4.h),
                                child: Text(
                                  nameLabel,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppTextStyle.txtPTSansRegular12Gray600,
                                ),
                              ),
                              CommonTextFormField(
                                controller: _nameController,
                                hint: enterUserNameHint,
                                readOnly: true,
                                validator: (value) => null,
                              ),
                              Padding(
                                padding: getPadding(top: 10.h, bottom: 4.h),
                                child: Text(
                                  emailAddressLabel,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppTextStyle.txtPTSansRegular12Gray600,
                                ),
                              ),
                              CommonTextFormField(
                                suffixIcon: (user?.emailVerified ?? false)
                                    ? const Padding(
                                        padding: EdgeInsets.all(14.0),
                                        child: CustomImageView(
                                          svgPath: Assets.verifiedCheck,
                                        ),
                                      )
                                    : null,
                                textInputType: TextInputType.emailAddress,
                                readOnly: true,
                                controller: _emailController,
                                hint: enterEmailAddressHint,
                                textInputAction: TextInputAction.done,
                                validator: (value) => null,
                              ),
                              Padding(
                                padding: getPadding(top: 10.h, bottom: 4.h),
                                child: Text(
                                  phoneNumberLabel,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppTextStyle.txtPTSansRegular12Gray600,
                                ),
                              ),
                              CommonTextFormField(
                                textInputType: TextInputType.phone,
                                inputCharLength: phoneNumberLength,
                                readOnly: true,
                                suffixIcon: (user?.phoneVerified ?? false)
                                    ? const Padding(
                                        padding: EdgeInsets.all(14.0),
                                        child: CustomImageView(
                                          svgPath: Assets.verifiedCheck,
                                        ),
                                      )
                                    : null,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(
                                    top: 13.h,
                                    left: 13.w,
                                    bottom: 13.h,
                                    right: 8.w,
                                  ),
                                  child: CustomImageView(
                                    imagePath: Assets.ukFlag,
                                    height: getVerticalSize(5),
                                    width: getHorizontalSize(5),
                                    radius: BorderRadius.circular(
                                        getHorizontalSize(2)),
                                    margin:
                                        getMargin(left: 4, top: 3, bottom: 3),
                                  ),
                                ),
                                controller: _phoneController,
                                hint: enterPhoneNumberHint,
                                textInputAction: TextInputAction.done,
                                validator: (value) => null,
                              ),
                              Padding(
                                padding: getPadding(top: 22.h, bottom: 9.h),
                                child: Text(
                                  howMuchDoYouBorrow,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppTextStyle.txtPTSansRegular12Gray600,
                                ),
                              ),
                              CommonSlider(
                                isValuation: true,
                                sliderValue: price.toDouble(),
                                min: 1000,
                                max: 50000,
                                displayStartValue:
                                    euro + currencyFormatter(1000),
                                displayEndValue:
                                    euro + currencyFormatter(50000),
                                displaySelectedLabel: euro,
                                onChanged: (value) {
                                  price = value.toInt();
                                },
                                isButtonsNeeded: true,
                              ),
                              Padding(
                                padding: getPadding(top: 33.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GradientCheckbox(
                                      value: isChecked,
                                      size: 16,
                                      checkBoxRadius: 5.r,
                                      onChanged: (val) {
                                        setState(() => isChecked = val!);
                                      },
                                    ),
                                    SizedBox(width: 13.w),
                                    Flexible(
                                      child: RichText(
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: byCheckingMsgNeedFinance,
                                              style: AppTextStyle
                                                  .regularTextStyle
                                                  .copyWith(
                                                color:
                                                    ColorConstant.kColor353333,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  termsConditionMsgNeedFinance,
                                              style: AppTextStyle
                                                  .regularTextStyle
                                                  .copyWith(
                                                color: ColorConstant
                                                    .kPrimaryDarkRed,
                                              ),
                                            ),
                                            TextSpan(
                                              text: privacyPolicyMsgNeedFinance,
                                              style: AppTextStyle
                                                  .regularTextStyle
                                                  .copyWith(
                                                color: ColorConstant
                                                    .kPrimaryDarkRed,
                                              ),
                                            ),
                                            TextSpan(
                                              text: andMsgNeedFinance,
                                              style: AppTextStyle
                                                  .regularTextStyle
                                                  .copyWith(
                                                color:
                                                    ColorConstant.kColor353333,
                                              ),
                                            ),
                                            TextSpan(
                                              text: cookiePolicyMsgNeedFinance,
                                              style: AppTextStyle
                                                  .regularTextStyle
                                                  .copyWith(
                                                color: ColorConstant
                                                    .kPrimaryDarkRed,
                                              ),
                                            ),
                                            const TextSpan(
                                              text: mandatoryField,
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                              ),
                                            )
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
                      ),
                    ),
                    Padding(
                      padding: getPadding(top: 15.h, bottom: 15.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              title: cancelButton,
                              onTap: () async {
                                bool result = await confirmationPopup(
                                  messageTextAlign: TextAlign.center,
                                  title: informationLabel,
                                  message: areYouSureWantToCancelThis,
                                  isQuestion: true,
                                );
                                if (result) {
                                  Navigator.of(
                                          globalNavigatorKey.currentContext!)
                                      .pop();
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: GradientElevatedButton(
                              title: submitButton,
                              onTap: () => onTapSubmit(),
                            ),
                          ),
                        ],
                      ),
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

  void onTapSubmit() {
    if (_formKey.currentState!.validate()) {
      if (isChecked) {
        progressLoad(true);
        final Map<String, dynamic> needFinanceData = {
          'amount': price.toString(),
          'transactionId': "sdf343fdfdfs",
          'userEmail': user?.email ?? '',
          'userId': user?.userId ?? '',
          'userName': user?.userName ?? '',
        };
        log(needFinanceData.toString());
        BlocProvider.of<NeedFinanceBloc>(context).add(
          AddFinanceRequestEvent(needFinanceData: needFinanceData),
        );
      } else {
        showSnackBar(
          message: 'Please accept Terms & Condition, '
              'Privacy Policy and Cookie Policy',
        );
      }
    }
  }
}
