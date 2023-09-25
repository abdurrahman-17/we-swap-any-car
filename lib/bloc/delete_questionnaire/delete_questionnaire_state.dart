part of 'delete_questionnaire_bloc.dart';

abstract class DeleteQuestionnaireState extends Equatable {
  const DeleteQuestionnaireState();

  @override
  List<Object> get props => [];
}

class DeleteQuestionnaireInitial extends DeleteQuestionnaireState {}

class GetFeedbackQuestionsState extends DeleteQuestionnaireState {
  final ProviderStatus feedbackDataStatus;
  final List<QuestionnaireModel> feedbackQuestionsList;
  final String? errorMessage;

  const GetFeedbackQuestionsState({
    required this.feedbackDataStatus,
    this.feedbackQuestionsList = const [],
    this.errorMessage,
  });
  @override
  List<Object> get props => [feedbackDataStatus];
}

class UpdateFeedbackAnswerState extends DeleteQuestionnaireState {
  final ProviderStatus updateFeedbackAnswerStatus;
  final String? errorMessage;

  const UpdateFeedbackAnswerState({
    required this.updateFeedbackAnswerStatus,
    this.errorMessage,
  });

  @override
  List<Object> get props => [updateFeedbackAnswerStatus];
}
