import 'dart:developer';

import '../../bloc/report_issue/report_issue_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/car_model/car_model.dart';
import '../../model/car_model/value_section_input.dart';
import '../../repository/car_repo.dart';
import '../common_popup_widget/thank_you_popup_with_button_widget.dart';
import '../common_widgets/common_loader.dart';
import '../common_widgets/common_popups.dart';
import '../common_widgets/custom_text_widget.dart';
import '../landing_screen/landing_screen.dart';

class ReportAnIssueScreen extends StatefulWidget {
  static const String routeName = 'report_an_issue_screen';
  const ReportAnIssueScreen({
    super.key,
    this.car,
  });
  final CarModel? car;
  @override
  State<ReportAnIssueScreen> createState() => _ReportAnIssueScreenState();
}

class _ReportAnIssueScreenState extends State<ReportAnIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _discriptionController = TextEditingController();
  final bool isUser = false;
  bool isLoading = false;
  ValuesSectionInput? selectedIssueType;

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
  Widget build(BuildContext context) {
    return BlocListener<ReportIssueBloc, ReportIssueState>(
      listener: (context, state) {
        if (state is PostReportIssueState) {
          if (state.reportIssueStatus == ProviderStatus.success) {
            progressLoad(false);
            customPopup(
              hasContentPadding: false,
              barrierDismissible: false,
              content: ThankYouPopUpWithButton(
                subTitle: forReportingIssue,
                buttonTitle: goToHomeButton,
                onTapButton: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    LandingScreen.routeName,
                    (route) => false,
                  );
                },
              ),
            );
          } else if (state.reportIssueStatus == ProviderStatus.error) {
            progressLoad(false);
            showSnackBar(message: errorOccurred);
          }
        }
      },
      child: CustomScaffold(
        title: reportAnIssueAppBar,
        body: Stack(
          children: [
            CustomImageView(
              svgPath: Assets.homeBackground,
              fit: BoxFit.fill,
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
            ),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.car != null)
                              Container(
                                padding: getPadding(all: 11),
                                decoration: AppDecoration.outlineBlack9000c4
                                    .copyWith(
                                        borderRadius:
                                            BorderRadiusStyle.roundedBorder20),
                                child: Row(
                                  children: [
                                    CustomImageView(
                                      url: widget.car?.uploadPhotos
                                              ?.rightImages?[0] ??
                                          '',
                                      height: getVerticalSize(47),
                                      width: getHorizontalSize(57),
                                      radius: BorderRadius.circular(
                                        getHorizontalSize(11),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: getPadding(left: 12.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.car?.model ??
                                                  notApplicable,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppTextStyle
                                                  .txtPTSansBold14Bluegray900,
                                            ),
                                            Padding(
                                              padding: getPadding(top: 5),
                                              child: Text(
                                                widget.car?.ownerUserName ??
                                                    shortAppName,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppTextStyle
                                                    .txtPTSansBold10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    CustomImageView(
                                      svgPath: Assets.forwardGradient,
                                      margin: getMargin(right: 12.w),
                                    )
                                  ],
                                ),
                              ),
                            if (widget.car != null)
                              Padding(
                                padding: getPadding(top: 30.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomImageView(
                                      svgPath: Assets.infoGradient,
                                      margin: getMargin(right: 10.w),
                                    ),
                                    Flexible(
                                      child: Text(
                                        doubleCheckProfileBeforeReport,
                                        textAlign: TextAlign.left,
                                        style: AppTextStyle
                                            .txtPTSansBold13blueGray900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: getPadding(top: 19.h, bottom: 10.h),
                              child: Text(
                                issueTypeLabel,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppTextStyle.txtPTSansRegular12Gray600,
                              ),
                            ),
                            FutureBuilder(
                              future: Locator.instance
                                  .get<CarRepo>()
                                  .getIssueTypes(),
                              builder: (context, snap) {
                                if (snap.hasData) {
                                  if (snap.data != null) {
                                    return snap.data!.fold((l) {
                                      return const CenterText(
                                          text: errorOccurred);
                                    }, (issueTypes) {
                                      return CommonDropDown(
                                        width: size.width,
                                        selectedValue: selectedIssueType,
                                        hintText: chooseIssueTypeHint,
                                        items: issueTypes,
                                        onChanged: (value) {
                                          selectedIssueType = value;
                                        },
                                      );
                                    });
                                  }
                                }
                                return shimmerLoader(
                                  Container(
                                    height: getVerticalSize(41.h),
                                    decoration: BoxDecoration(
                                      color: ColorConstant.kColorWhite,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: getPadding(top: 20.h, bottom: 10.h),
                              child: Text(
                                discriptionLabel,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppTextStyle.txtPTSansRegular12Gray600,
                              ),
                            ),
                            CommonTextFormField(
                              controller: _discriptionController,
                              hint: enterDescriptionHint,
                              textInputType: TextInputType.multiline,
                              minLines: 9,
                              maxLines: 9,
                              validator: (val) {
                                if (val != null && val.trim().isEmpty) {
                                  return 'Please enter the discription';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: 15.h, right: 25.w, left: 25.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            onTap: () => Navigator.pop(context),
                            title: "CANCEL",
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: GradientElevatedButton(
                            title: submitButton,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                progressLoad(true);
                                final Map<String, dynamic> reportData = {
                                  'description': _discriptionController.text,
                                  'reportedBy': context
                                      .read<UserBloc>()
                                      .currentUser!
                                      .userId,
                                  'subject': selectedIssueType?.id ?? '',
                                  'reportedTo': widget.car?.userId ?? '',
                                };
                                log(reportData.toString());
                                BlocProvider.of<ReportIssueBloc>(context).add(
                                  PostReportIssueEvent(reportData: reportData),
                                );
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
      ),
    );
  }
}
