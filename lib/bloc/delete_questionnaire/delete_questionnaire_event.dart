part of 'delete_questionnaire_bloc.dart';

abstract class DeleteQuestionnaireEvent extends Equatable {
  const DeleteQuestionnaireEvent();

  @override
  List<Object> get props => [];
}

class GetFeedbackQuestionsEvent extends DeleteQuestionnaireEvent {
  final String type;

  const GetFeedbackQuestionsEvent({
    required this.type,
  });
}

class UpdateFeedbackAnswerEvent extends DeleteQuestionnaireEvent {
  final Map<String, dynamic> questionnaireAnswersJson;
  const UpdateFeedbackAnswerEvent({
    required this.questionnaireAnswersJson,
  });
}
