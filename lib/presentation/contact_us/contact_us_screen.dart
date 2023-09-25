import 'package:wsac/bloc/faq/faq_bloc.dart';
import 'package:wsac/presentation/common_popup_widget/common_dropdown_popup.dart';
import 'package:wsac/presentation/common_widgets/field_label.dart';

import '../../core/configurations.dart';
import '../../model/car_model/value_section_input.dart';
import '../common_popup_widget/thank_you_popup_with_button_widget.dart';
import '../common_widgets/common_loader.dart';
import '../common_widgets/common_popups.dart';
import '../landing_screen/landing_screen.dart';

class ContactUsScreen extends StatefulWidget {
  static const String routeName = 'contact_us_screen';
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  ValuesSectionInput? selectedIssueType;
  bool isLoading = false;
  int? selectedIndex;

  void setLoading(bool value) => setState(() => isLoading = value);

  void progressLoad(bool value) {
    setLoading(value);
    if (value) {
      progressDialogue();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FaqBloc, FaqState>(
      listener: (context, state) {
        if (state is SendEmailContactUsState &&
            state.sendEmailContactUsFetchStatus == ProviderStatus.success) {
          progressLoad(false);
          customPopup(
            hasContentPadding: false,
            barrierDismissible: false,
            content: ThankYouPopUpWithButton(
              subTitle: forContactingUs,
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
        }
      },
      child: CustomScaffold(
        title: contactUsAppBar,
        body: Stack(
          children: [
            CustomImageView(
              svgPath: Assets.homeBackground,
              fit: BoxFit.fill,
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
            ),
            SafeArea(
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: getPadding(top: 10.h, left: 25, right: 25),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomImageView(
                              svgPath: Assets.infoGradient,
                              height: getSize(21),
                              width: getSize(21),
                            ),
                            Padding(
                              padding: getPadding(left: 13),
                              child: Text(
                                feelFreeToContactUs,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppTextStyle.smallTextStyle.copyWith(
                                  color: ColorConstant.kColor353333,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: getPadding(top: 20.h, bottom: 6.h),
                                child: const FieldLabelWidget(
                                  label: subjectLabel,
                                ),
                              ),
                              CommonTextFormField(
                                controller: _subjectController,
                                isDropDown: true,
                                readOnly: true,
                                hint: chooseIssueTypeHint,
                                onTap: () =>
                                    onTapSubjectsPopup(testSelectableList),
                              ),
                              Padding(
                                padding: getPadding(top: 20.h, bottom: 6.h),
                                child: const FieldLabelWidget(
                                  label: discriptionLabel,
                                ),
                              ),
                              CommonTextFormField(
                                controller: _descriptionController,
                                hint: enterDescriptionHint,
                                textInputType: TextInputType.multiline,
                                minLines: 14,
                                maxLines: 14,
                                validator: (val) {
                                  if (val != null && val.trim().isEmpty) {
                                    return 'Please enter the description';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 15.h, right: 25.w, left: 25.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        onTap: () => Navigator.pop(context),
                        title: cancelButton,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: GradientElevatedButton(
                        title: submitButton,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {}
                        },
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

  ///exterior drop down
  Future<dynamic> onTapSubjectsPopup(List<ValuesSectionInput> items) async {
    final value = await customPopup(
      content: CommonDropDownPopup(
        selectedIndex: selectedIndex,
        itemList: items.map((e) => e.name ?? '').toList(),
      ),
    );
    if (value != null) {
      setState(() => selectedIndex = value as int);
      _subjectController.text = items[selectedIndex ?? 0].name ?? '';
    }
  }
}
