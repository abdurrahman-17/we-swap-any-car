import 'package:flutter/gestures.dart';

import '../../../core/configurations.dart';
import '../../common_widgets/custom_checkbox.dart';
import 'launch_terms_and_conditions.dart';

// ignore: must_be_immutable
class TermsAndConditions extends StatefulWidget {
  TermsAndConditions({
    super.key,
    required this.onChanged,
    required this.termsAnDConditionCheckBox,
    required this.isDisabled,
    required this.isProfile,
  });
  final void Function(bool) onChanged;
  bool termsAnDConditionCheckBox = false;
  bool isDisabled = false;
  bool isProfile = false;

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getPadding(top: 5, bottom: 5),
      child: Row(
        children: [
          // Terms & conditions Checkbox
          IgnorePointer(
            ignoring: widget.isDisabled,
            child: GradientCheckbox(
              value: widget.termsAnDConditionCheckBox,
              onChanged: (value) {
                if (widget.termsAnDConditionCheckBox) {
                  setState(() => widget.termsAnDConditionCheckBox = false);
                } else {
                  setState(() => widget.termsAnDConditionCheckBox = true);
                }
                widget.onChanged(widget.termsAnDConditionCheckBox);
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: getPadding(
                  left: getHorizontalSize(13), top: getVerticalSize(10)),
              child: RichText(
                overflow: TextOverflow.visible,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.isProfile
                          ? signUpagreement0
                          : signUpagreement1,
                      style: AppTextStyle.smallTextStyle.copyWith(
                        color: ColorConstant.kColor7C7C7C,
                      ),
                    ),
                    TextSpan(
                      text: signUpagreement6,
                      style: AppTextStyle.smallTextStyle.copyWith(
                        color: ColorConstant.kPrimaryDarkRed,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(
                            context,
                            LaunchTermsAndConditions.routeName,
                            arguments: {
                              'appBarTitle': sideMenuTermsAndCondition
                            },
                          );
                        },
                    ),
                    TextSpan(
                      text: signUpagreement2,
                      style: AppTextStyle.regularTextStyle.copyWith(
                        color: ColorConstant.kColor7C7C7C,
                      ),
                    ),
                    TextSpan(
                      text: signUpagreement3,
                      style: AppTextStyle.smallTextStyle.copyWith(
                        color: ColorConstant.kPrimaryDarkRed,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(
                            context,
                            LaunchTermsAndConditions.routeName,
                            arguments: {'appBarTitle': sideMenuPrivacyPolicy},
                          );
                        },
                    ),
                    TextSpan(
                      text: signUpagreement4,
                      style: AppTextStyle.smallTextStyle.copyWith(
                        color: ColorConstant.kColor7C7C7C,
                      ),
                    ),
                    TextSpan(
                      text: signUpagreement5,
                      style: AppTextStyle.smallTextStyle.copyWith(
                        color: ColorConstant.kPrimaryDarkRed,
                      ),
                      children: const [
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        )
                      ],
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(
                            context,
                            LaunchTermsAndConditions.routeName,
                            arguments: {'appBarTitle': sideMenuCookiesPolicy},
                          );
                        },
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
