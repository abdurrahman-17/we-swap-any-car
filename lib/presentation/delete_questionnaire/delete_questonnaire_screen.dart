import 'package:enum_to_string/enum_to_string.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../bloc/delete_questionnaire/delete_questionnaire_bloc.dart';
import '../../bloc/list_unlist/list_unlist_bloc_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../core/configurations.dart';
import '../../main.dart';
import '../../model/questionnaire_model/feedback_answer_model.dart';
import '../../model/questionnaire_model/questionnaire_model.dart';
import '../../model/user/user_model.dart';
import '../common_popup_widget/thank_you_popup_with_button_widget.dart';
import '../common_widgets/common_admin_support_button.dart';
import '../common_widgets/common_divider.dart';
import '../common_widgets/common_loader.dart';
import '../common_widgets/common_popups.dart';
import '../common_widgets/custom_checkbox.dart';
import '../common_widgets/custom_radio_button.dart';
import '../landing_screen/landing_screen.dart';

class DeleteQuestionnaireScreen extends StatefulWidget {
  static const String routeName = 'delete_questionnaire_screen';

  const DeleteQuestionnaireScreen({
    Key? key,
    this.surveyType,
    required this.feedbackQuestions,
    required this.carId,
    required this.userId,
  }) : super(key: key);

  final SurveyType? surveyType;
  final List<QuestionnaireModel> feedbackQuestions;
  final String? carId;
  final String? userId;

  @override
  State<DeleteQuestionnaireScreen> createState() =>
      _DeleteQuestionnaireScreenState();
}

class _DeleteQuestionnaireScreenState extends State<DeleteQuestionnaireScreen> {
  double progressValue = 0;
  int pageIndex = 0;
  int completedPages = 0;
  String radioVal = '';
  YesNoAnswer? radioEnum;
  final TextEditingController _feedBackController = TextEditingController();
  bool isOptionSelected = true;
  UserModel? user;
  List<dynamic> selectedOptions = [];
  List<FeedbackAnswerModel> questionnaireAnswers = [];

  @override
  void initState() {
    loadQuestions();
    user = context.read<UserBloc>().currentUser;
    super.initState();
  }

  void loadQuestions() {
    for (final item in widget.feedbackQuestions) {
      questionnaireAnswers.add(FeedbackAnswerModel(
        ansType: item.ansType,
        question: item.question,
        questionId: item.id,
        type: item.type,
        answerChoice: [],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteQuestionnaireBloc, DeleteQuestionnaireState>(
          listener: (context, state) async {
            if (state is UpdateFeedbackAnswerState) {
              if (state.updateFeedbackAnswerStatus == ProviderStatus.success) {
                setLoader(false);
                if (widget.surveyType == SurveyType.deleteProfile) {
                  BlocProvider.of<UserBloc>(context).add(
                      DeleteUserEvent(userData: {"userId": widget.userId}));
                } else if (widget.surveyType == SurveyType.deletePost) {
                  BlocProvider.of<ListUnlistBlocBloc>(context)
                      .add(DeleteMyCarEvent(
                    carId: widget.carId!,
                    routeName: DeleteQuestionnaireScreen.routeName,
                  ));
                }
              } else if (state.updateFeedbackAnswerStatus ==
                  ProviderStatus.error) {
                setLoader(false);
                showSnackBar(message: state.errorMessage ?? '');
              } else {
                setLoader(true);
              }
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is DeleteUserState) {
              if (state.userDataDeleteStatus == ProviderStatus.success) {
                setLoader(false);
                showThankYouPopup(
                  onTap: logoutAction,
                );
              } else if (state.userDataDeleteStatus == ProviderStatus.error) {
                setLoader(false);
                showSnackBar(message: state.errorMessage ?? '');
              } else {
                setLoader(true);
              }
            }
          },
        ),
        BlocListener<ListUnlistBlocBloc, ListUnlistBlocState>(
          listener: (context, state) {
            if (state is DeleteMyCarState &&
                state.routeName == DeleteQuestionnaireScreen.routeName) {
              if (state.deleteStatus == ProviderStatus.success) {
                showThankYouPopup(
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          LandingScreen.routeName,
                          arguments: {"selectedIndex": 0},
                          (route) => false,
                        ));
              } else if (state.deleteStatus == ProviderStatus.error) {
                setLoader(false);
                showSnackBar(message: state.errorMessage ?? '');
              } else {
                setLoader(true);
              }
            }
          },
        ),
      ],
      child: CustomScaffold(
        title: surveyAppBar,
        resizeToAvoidBottomInset: true,
        appBarColor: ColorConstant.kColorWhite,
        backWidget: pageIndex == 0 ? null : const SizedBox(),
        actions: const [
          AdminSupportButton(),
        ],
        body: Stack(
          children: [
            CustomImageView(
              svgPath: Assets.homeBackground,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
              alignment: Alignment.bottomCenter,
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        circularProgressView(),
                        Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.5, 0.5],
                            colors: [
                              ColorConstant.kColorWhite,
                              Colors.transparent,
                            ],
                          )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        ColorConstant.lightGreenA700,
                                        ColorConstant.kColorC8CC00
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(25)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Text(
                                  completedPages.toString() +
                                      blankSpace +
                                      of +
                                      blankSpace +
                                      widget.feedbackQuestions.length
                                          .toString() +
                                      blankSpace +
                                      questionsCompletedLabel,
                                  style:
                                      AppTextStyle.txtPTSansRegular16WhiteA700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: getPadding(
                            left: 24.w,
                            right: 24.w,
                            top: 60.h,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$questionText: ${pageIndex + 1}".toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppTextStyle.txtPTSansBold14,
                              ),
                              Padding(
                                padding: getPadding(top: 16.h),
                                child: Text(
                                  widget.feedbackQuestions[pageIndex]
                                          .question ??
                                      '',
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  maxLines: 3,
                                  style: AppTextStyle.txtPTSansRegular14,
                                ),
                              ),
                              Padding(
                                padding: getPadding(top: 15.h, bottom: 18.h),
                                child: Column(
                                  children: [
                                    if (widget.feedbackQuestions[pageIndex]
                                            .ansType ==
                                        convertEnumToString(AnswerType.yesno))
                                      yesNoAnswers(),
                                    if (widget.feedbackQuestions[pageIndex]
                                            .ansType ==
                                        convertEnumToString(
                                            AnswerType.multichoice))
                                      mulptipleAnswerList(),
                                  ],
                                ),
                              ),
                              if (widget.feedbackQuestions[pageIndex].ansType ==
                                  convertEnumToString(AnswerType.textbox))
                                Text(
                                  shareFeedback,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppTextStyle.txtPTSansRegular14Gray600,
                                ),
                              if (widget.feedbackQuestions[pageIndex].ansType ==
                                      convertEnumToString(AnswerType.textbox) ||
                                  widget.feedbackQuestions[pageIndex].ansType ==
                                      convertEnumToString(
                                          AnswerType.yesnoText) ||
                                  widget.feedbackQuestions[pageIndex].ansType ==
                                      convertEnumToString(
                                          AnswerType.multichoiceText))
                                Padding(
                                  padding: getPadding(top: 16.h, bottom: 16.h),
                                  child: CommonTextFormField(
                                    validator: (p0) => null,
                                    controller: _feedBackController,
                                    inputCharLength: 500,
                                    maxLines: 6,
                                    minLines: 5,
                                    onChanged: (value) =>
                                        questionnaireAnswers[pageIndex]
                                            .feedbackAnswer = value,
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: getPadding(
                    top: 15.h,
                    bottom: 15.h,
                    left: 24.w,
                    right: 24.w,
                  ),
                  child: Row(
                    children: [
                      if (pageIndex != 0)
                        Expanded(
                          child: CustomElevatedButton(
                            title: previousButton,
                            onTap: () async => onPreviousFeedbackAnswer(),
                          ),
                        ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Visibility(
                          visible: isOptionSelected,
                          replacement: Text(
                            widget.feedbackQuestions[pageIndex].ansType ==
                                    convertEnumToString(AnswerType.textbox)
                                ? plsEnterFeedback
                                : atleastOneOption,
                            style: const TextStyle(color: Colors.red),
                          ),
                          child: GradientElevatedButton(
                            title:
                                widget.feedbackQuestions.length - 1 == pageIndex
                                    ? submitButton
                                    : nextButton,
                            onTap: () async => onTapNextAndSubmit(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget circularProgressView() {
    return Container(
      width: double.infinity,
      color: ColorConstant.kColorWhite,
      padding: getPadding(top: 20.h, bottom: 20.h),
      child: SizedBox(
        height: getSize(132),
        width: getSize(132),
        child: SfRadialGauge(
          axes: [
            RadialAxis(
              showLabels: false,
              showTicks: false,
              startAngle: 270,
              endAngle: 270,
              axisLineStyle: const AxisLineStyle(thickness: 9),
              pointers: <GaugePointer>[
                RangePointer(
                  value:
                      ((completedPages / widget.feedbackQuestions.length) * 100)
                          .floor()
                          .toDouble(),
                  width: 0.15,
                  sizeUnit: GaugeSizeUnit.factor,
                  gradient: SweepGradient(
                    colors: kPrimaryGradientColor,
                    stops: const <double>[0.25, 0.75],
                  ),
                  enableAnimation: true,
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  positionFactor: 0.1,
                  angle: 90,
                  widget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ((completedPages / widget.feedbackQuestions.length) *
                                100)
                            .floor()
                            .toString(),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppTextStyle.txtPTSansRegular20.copyWith(
                          fontFamily: Assets.magistralFontStyle,
                          fontSize: getFontSize(40.sp),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        percentageIconText.toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppTextStyle.txtPTSansRegular14Black900.copyWith(
                          fontFamily: Assets.magistralFontStyle,
                          fontSize: getFontSize(16.sp),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget yesNoAnswers() {
    return Row(
      children: [
        CustomRadioWithLabel(
          text: yesNoSelectableList[0].name,
          value: YesNoAnswer.yes.name,
          groupValue: questionnaireAnswers[pageIndex].answer,
          onChanged: (value) {
            setState(() =>
                questionnaireAnswers[pageIndex].answer = YesNoAnswer.yes.name);
          },
        ),
        SizedBox(width: 90.w),
        CustomRadioWithLabel(
          text: yesNoSelectableList[1].name,
          value: YesNoAnswer.no.name,
          groupValue: questionnaireAnswers[pageIndex].answer,
          onChanged: (value) {
            setState(() {
              questionnaireAnswers[pageIndex].answer = YesNoAnswer.no.name;
            });
          },
        ),
      ],
    );
  }

  Widget mulptipleAnswerList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.feedbackQuestions[pageIndex].options!.length,
      separatorBuilder: (context, index) => const CommonDivider(),
      itemBuilder: (_, int index) {
        final item = widget.feedbackQuestions[pageIndex].options;
        final option = item?[index] ?? '';

        return CustomCheckboxWithLabel(
          label: option,
          value: questionnaireAnswers[pageIndex].answerChoice!.contains(option),
          isGradientCheckBox: true,
          onChanged: (_) {
            if (questionnaireAnswers[pageIndex]
                .answerChoice!
                .contains(option)) {
              questionnaireAnswers[pageIndex].answerChoice!.remove(option);
            } else {
              questionnaireAnswers[pageIndex].answerChoice!.add(option);
            }
            setState(() {});
          },
        );
      },
    );
  }

  void updateProgress() {
    completedPages = 0;
    for (final element in questionnaireAnswers) {
      final answerTypeField =
          EnumToString.fromString(AnswerType.values, element.ansType ?? '');
      switch (answerTypeField) {
        case AnswerType.multichoice:
        case AnswerType.multichoiceText:
          {
            if ((element.answerChoice ?? []).isNotEmpty) {
              completedPages = completedPages + 1;
            }
            break;
          }
        case AnswerType.yesno:
        case AnswerType.yesnoText:
          {
            if ((element.answer ?? '').isNotEmpty) {
              completedPages = completedPages + 1;
            }
            break;
          }
        case AnswerType.textbox:
          {
            if ((element.feedbackAnswer ?? '').isNotEmpty) {
              completedPages = completedPages + 1;
            }
            break;
          }
        default:
          break;
      }
    }
  }

  Future<void> onPreviousFeedbackAnswer() async {
    updateProgress();
    setState(() => --pageIndex);
    _feedBackController.clear();
    final currentPageQuestion = widget.feedbackQuestions[pageIndex];
    if (currentPageQuestion.ansType ==
        convertEnumToString(AnswerType.textbox)) {
      _feedBackController.text =
          questionnaireAnswers[pageIndex].feedbackAnswer ?? '';
    }
  }

  Future<void> onTapNextAndSubmit() async {
    bool isCurrentQuestionValid = true;
    final currentPageQuestion = widget.feedbackQuestions[pageIndex];
    if (currentPageQuestion.ansType ==
            convertEnumToString(AnswerType.multichoice) ||
        currentPageQuestion.ansType ==
            convertEnumToString(AnswerType.multichoiceText)) {
      isCurrentQuestionValid =
          questionnaireAnswers[pageIndex].answerChoice!.isNotEmpty;
    } else if (currentPageQuestion.ansType ==
            convertEnumToString(AnswerType.yesno) ||
        currentPageQuestion.ansType ==
            convertEnumToString(AnswerType.yesnoText)) {
      isCurrentQuestionValid = questionnaireAnswers[pageIndex].answer != null;
    } else if (currentPageQuestion.ansType ==
        convertEnumToString(AnswerType.textbox)) {
      isCurrentQuestionValid =
          questionnaireAnswers[pageIndex].feedbackAnswer != null &&
              questionnaireAnswers[pageIndex].feedbackAnswer!.isNotEmpty;
    }
    //if not lat item
    if (widget.feedbackQuestions.length - 1 != pageIndex) {
      _feedBackController.clear();
      _feedBackController.text =
          questionnaireAnswers[pageIndex + 1].feedbackAnswer ?? '';
    }

    if (!isCurrentQuestionValid) {
      showSnackBar(
        message: widget.feedbackQuestions[pageIndex].ansType ==
                convertEnumToString(AnswerType.textbox)
            ? plsEnterFeedback
            : atleastOneOption,
      );
      return;
    }
    //last question
    if (widget.feedbackQuestions.length - 1 == pageIndex) {
      //new schema
      Map<String, dynamic> answerJson = {};
      List<Map<String, dynamic>> answersMapList = [];

      answerJson['userId'] = widget.userId;
      answerJson['type'] = questionnaireAnswers.first.type;
      if (user?.traderId != null) {
        answerJson['traderId'] = user!.traderId!;
      }
      if (widget.carId != null) {
        answerJson['carId'] = widget.carId;
      }
      answerJson['answers'] = answersMapList;
      for (int i = 0; i < questionnaireAnswers.length; i++) {
        answersMapList.insert(i, questionnaireAnswers[i].toJson());
      }

      BlocProvider.of<DeleteQuestionnaireBloc>(context)
          .add(UpdateFeedbackAnswerEvent(questionnaireAnswersJson: answerJson));
    } else {
      updateProgress();
      setState(() {
        ++pageIndex;
        isOptionSelected = true;
      });
    }
  }

  void setLoader(bool isLoader) {
    if (isLoader) {
      progressDialogue();
    } else {
      Navigator.pop(globalNavigatorKey.currentContext!);
    }
  }

  void showThankYouPopup({void Function()? onTap}) {
    customPopup(
      hasContentPadding: false,
      content: ThankYouPopUpWithButton(
        subTitle: thanksForFeedback,
        buttonTitle: okButton,
        onTapButton: onTap ??
            () => Navigator.pop(globalNavigatorKey.currentContext!, true),
      ),
    );
  }
}
