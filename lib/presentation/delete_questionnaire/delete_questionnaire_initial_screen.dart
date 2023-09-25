import 'package:wsac/presentation/common_widgets/common_loader.dart';

import '../../bloc/delete_questionnaire/delete_questionnaire_bloc.dart';
import '../../bloc/list_unlist/list_unlist_bloc_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../core/configurations.dart';
import '../../main.dart';
import '../common_widgets/common_admin_support_button.dart';
import '../landing_screen/landing_screen.dart';
import 'delete_questonnaire_screen.dart';

class DeleteQuestionnaireInitialScreen extends StatelessWidget {
  static const String routeName = 'delete_questionnaire_initial_screen';
  const DeleteQuestionnaireInitialScreen({
    Key? key,
    required this.carId,
    required this.userId,
    required this.surveyType,
  }) : super(key: key);

  final SurveyType surveyType;
  final String? carId;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteQuestionnaireBloc, DeleteQuestionnaireState>(
          listener: (context, state) {
            if (state is GetFeedbackQuestionsState) {
              if (state.feedbackDataStatus == ProviderStatus.success) {
                setLoader(false);
                Navigator.pushNamed(
                  globalNavigatorKey.currentContext!,
                  DeleteQuestionnaireScreen.routeName,
                  arguments: {
                    'surveyType': surveyType,
                    'feedbackQuestions': state.feedbackQuestionsList,
                    'carId': carId,
                    'userId': userId
                  },
                );
              } else if (state.feedbackDataStatus == ProviderStatus.error) {
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
                logoutAction();
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
                state.routeName == DeleteQuestionnaireInitialScreen.routeName) {
              if (state.deleteStatus == ProviderStatus.success) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LandingScreen.routeName,
                  arguments: {"selectedIndex": 0},
                  (route) => false,
                );
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
        actions: const [
          AdminSupportButton(),
        ],
        body: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomImageView(
                width: MediaQuery.of(context).size.width,
                svgPath: Assets.gradientHomeBg,
                fit: BoxFit.fill,
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImageView(
                          svgPath: Assets.deleteQuestionnaireOneIcon),
                      Padding(
                        padding: getPadding(top: 33.h),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: weWouldLike,
                                style: AppTextStyle.regularTextStyle.copyWith(
                                  color: ColorConstant.kColor7C7C7C,
                                  fontSize: getFontSize(21.sp),
                                ),
                              ),
                              TextSpan(
                                text: experienceText,
                                style: AppTextStyle.regularTextStyle.copyWith(
                                  color: ColorConstant.kColor353333,
                                  fontSize: getFontSize(36.sp),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 34.w),
                    child: Column(
                      children: [
                        ///START BUTTON
                        CustomElevatedButton(
                          title: startButton,
                          onTap: () => onTapStart(context),
                        ),

                        ///SKIP BUTTON
                        if (surveyType != SurveyType.deleteProfile)
                          Padding(
                            padding: getPadding(top: 5.h),
                            child: TextButton(
                              onPressed: () async {
                                if (surveyType == SurveyType.deleteProfile) {
                                  BlocProvider.of<UserBloc>(context).add(
                                      DeleteUserEvent(
                                          userData: {"userId": userId}));
                                } else if (surveyType ==
                                    SurveyType.deletePost) {
                                  BlocProvider.of<ListUnlistBlocBloc>(context)
                                      .add(DeleteMyCarEvent(
                                    carId: carId!,
                                    routeName: DeleteQuestionnaireInitialScreen
                                        .routeName,
                                  ));
                                }
                              },
                              child: Text(
                                skipForNow,
                                style: AppTextStyle.txtPTSansRegular14WhiteA700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void setLoader(bool isLoader) {
    if (isLoader) {
      progressDialogue();
    } else {
      Navigator.pop(globalNavigatorKey.currentContext!);
    }
  }

  void onTapStart(BuildContext context) {
    BlocProvider.of<DeleteQuestionnaireBloc>(context)
        .add(GetFeedbackQuestionsEvent(type: convertEnumToString(surveyType)));
  }
}
