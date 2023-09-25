import '../../core/configurations.dart';
import '../../main.dart';
import '../../utility/validator.dart';
import '../common_widgets/common_popups.dart';
import '../common_widgets/common_top_model_sheet.dart';
import '../common_widgets/custom_top_sheet.dart';
import 'thank_you_popup_with_button_widget.dart';

class EditPhoneNumberPopup extends StatefulWidget {
  const EditPhoneNumberPopup({Key? key}) : super(key: key);

  @override
  State<EditPhoneNumberPopup> createState() => _EditPhoneNumberPopupState();
}

class _EditPhoneNumberPopupState extends State<EditPhoneNumberPopup> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomImageView(
              svgPath: Assets.smallPopupBg,
              fit: BoxFit.fill,
              width: size.width,
              radius: BorderRadius.only(
                bottomLeft: Radius.circular(38.r),
                bottomRight: Radius.circular(38.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 27.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    addYourNewNumberTitle,
                    style: AppTextStyle.regularTextStyle.copyWith(
                      color: ColorConstant.kColor030303,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                    child: Text(
                      phoneNumberSubtitle,
                      style: AppTextStyle.hintTextStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: CommonTextFormField(
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.phone,
                      inputCharLength: phoneNumberLength,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(
                            top: 13.h, left: 13.w, bottom: 13.h, right: 8.w),
                        child: CustomImageView(
                          imagePath: Assets.ukFlag,
                          height: getVerticalSize(5),
                          width: getHorizontalSize(5),
                          radius: BorderRadius.circular(getHorizontalSize(2)),
                          margin: getMargin(left: 4, top: 3, bottom: 3),
                        ),
                      ),
                      controller: _phoneController,
                      hint: 'Phone number',
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            title: cancelButton,
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                        SizedBox(width: 13.w),
                        Expanded(
                          child: GradientElevatedButton(
                            title: saveButton,
                            onTap: () async {
                              if (_phoneController.text.isEmpty) {
                                showSnackBar(
                                    message: 'Please enter phone number');
                              } else if (!Validation.isValidPhone(
                                  _phoneController.text)) {
                                showSnackBar(
                                    message: 'Please enter valid phone number');
                              } else {
                                Navigator.pop(context);
                                bool? result = await showCommonTopModalSheet(
                                  globalNavigatorKey.currentContext!,
                                  CustomTopSheet(
                                    isEmail: true,
                                    emailOrPhone: _phoneController.text,
                                    verifyTap: (String otp) {},
                                    resendTap: () {},
                                  ),
                                );

                                if (result != null && result) {
                                  Navigator.pop(
                                      globalNavigatorKey.currentContext!);
                                  customPopup(
                                    hasContentPadding: false,
                                    content: ThankYouPopUpWithButton(
                                      subTitle: msgTheAdminApproveMobileChange,
                                      buttonTitle: okButton,
                                      subTitleAlign: TextAlign.center,
                                      onTapButton: () => Navigator.pop(context),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
