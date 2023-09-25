import 'dart:developer';

import 'package:flutter/services.dart';

import '../../bloc/get_car_system_config/get_system_config_bloc.dart';
import '../../core/configurations.dart';
import '../../main.dart';
import '../../model/car_model/car_model.dart';
import '../../utility/custom_formatter.dart';
import '../common_widgets/common_loader.dart';
import '../common_widgets/common_popups.dart';

class AddEditCarValuationPopup extends StatelessWidget {
  AddEditCarValuationPopup({super.key, required this.fromEdit, this.car});
  final bool fromEdit;
  final CarModel? car;
  final TextEditingController _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final RegExp regexToRemoveDecimalIfZero = RegExp(r'([.]*0)(?!.*\d)');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            fromEdit ? editCarValue : addCarValue,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppTextStyle.txtPTSansBold14,
          ),
          Container(
            margin: getMargin(top: 19.h),
            child: Text(
              msgReducingThePrice,
              textAlign: TextAlign.left,
              style: AppTextStyle.txtPTSansRegular12Gray600,
            ),
          ),
          if (fromEdit)
            Padding(
              padding: getPadding(top: 22.h),
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: currentValueLabel,
                      style: AppTextStyle.regularTextStyle.copyWith(
                        color: ColorConstant.kColor7C7C7C,
                      ),
                    ),
                    const TextSpan(text: '  '),
                    TextSpan(
                      text: euro +
                          currencyFormatter(
                              car?.userExpectedValue?.toInt() ?? 0),
                      style: AppTextStyle.regularTextStyle.copyWith(
                        color: ColorConstant.kColorBlack,
                        fontSize: getFontSize(18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(height: 9.h),
          CommonTextFormField(
            controller: _priceController,
            hint: fromEdit ? enterNewValueHint : addCarValueHint,
            textInputType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              CurrencyInputFormatter(),
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (val) {
              if (val != null && val.trim().isEmpty) {
                return 'Car value is required';
              }
              return null;
            },
          ),
          Container(
            margin: getMargin(top: 18.h, bottom: 3.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    height: 39.h,
                    title: cancelButton,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: 9.w),
                BlocListener<CarSystemConfigBloc, CarSystemConfigState>(
                  listener: (context, state) async {
                    log(state.toString());
                    if (state is GetSystemConfigurationState) {
                      if (state.configurationStatus == ProviderStatus.success) {
                        Navigator.pop(context);
                        final int userInputValue = int.parse(
                            _priceController.text.replaceAll(',', ''));

                        final double percentageAcceptance =
                            state.systemConfigurations!.priceApprovePercentage;

                        final wsacValue = car?.wsacValue?.toInt() ?? 0;
                        final calculatedValue =
                            (wsacValue * (percentageAcceptance / 100)) +
                                wsacValue;
                        log("calculatedValue:$calculatedValue");
                        log("userInputValue:$userInputValue");

                        if (userInputValue >= (calculatedValue.toInt()) &&
                            car?.tradeValue != null) {
                          await showAdminApprovalPopup(percentageAcceptance);

                          Navigator.of(globalNavigatorKey.currentContext!)
                              .pop(userInputValue);
                        } else {
                          Navigator.of(globalNavigatorKey.currentContext!)
                              .pop(userInputValue);
                        }
                      } else if (state.configurationStatus ==
                          ProviderStatus.error) {
                        Navigator.pop(context);
                        showSnackBar(
                            message: state.errorMessage ?? errorOccurred);
                      } else {
                        progressDialogue();
                      }
                    }
                  },
                  child: Expanded(
                    child: GradientElevatedButton(
                      title: saveButton,
                      height: 39.h,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          final int carValue = int.parse(
                              _priceController.text.replaceAll(',', ''));
                          if (fromEdit) {
                            BlocProvider.of<CarSystemConfigBloc>(context)
                                .add(GetSystemConfigurationEvent());
                          } else {
                            Navigator.pop(context, carValue);
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showAdminApprovalPopup(double increaseValPercentage) async {
    await infoOrThankyouPopup(
      subTitle: valuationIsMoreThanActualValuation +
          increaseValPercentage
              .toString()
              .replaceAll(regexToRemoveDecimalIfZero, '') +
          valuationIsMoreThanActualValuation1,
    );
  }
}
