import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../core/locator.dart';
import '../../model/questionnaire_model/questionnaire_model.dart';

import '../../repository/delete_questionnaire_repo.dart';
import '../../utility/enums.dart';

part 'delete_questionnaire_event.dart';
part 'delete_questionnaire_state.dart';

class DeleteQuestionnaireBloc
    extends Bloc<DeleteQuestionnaireEvent, DeleteQuestionnaireState> {
  DeleteQuestionnaireBloc() : super(DeleteQuestionnaireInitial()) {
    on<GetFeedbackQuestionsEvent>((event, emit) async {
      emit(const GetFeedbackQuestionsState(
        feedbackDataStatus: ProviderStatus.loading,
      ));

      final result = await Locator.instance
          .get<DeleteQuestionnaireRepo>()
          .fetchFeedbackQuestions(type: event.type);
      final GetFeedbackQuestionsState state = result.fold((fail) {
        return GetFeedbackQuestionsState(
          feedbackDataStatus: ProviderStatus.error,
          errorMessage: fail.message,
        );
      }, (feedbackQuestions) {
        return GetFeedbackQuestionsState(
          feedbackDataStatus: ProviderStatus.success,
          feedbackQuestionsList: feedbackQuestions,
        );
      });
      emit(state);
    });

    // update feedback answer repo
    on<UpdateFeedbackAnswerEvent>((event, emit) async {
      emit(const UpdateFeedbackAnswerState(
          updateFeedbackAnswerStatus: ProviderStatus.loading));
      final result = await Locator.instance
          .get<DeleteQuestionnaireRepo>()
          .updateFeedbackRepo(
            questionnaireAnswersJson: event.questionnaireAnswersJson,
          );
      final UpdateFeedbackAnswerState state = result.fold((fail) {
        return UpdateFeedbackAnswerState(
          updateFeedbackAnswerStatus: ProviderStatus.error,
          errorMessage: fail.message,
        );
      }, (updatedFeedbackAnswers) {
        return const UpdateFeedbackAnswerState(
          updateFeedbackAnswerStatus: ProviderStatus.success,
        );
      });
      emit(state);
    });
  }
}
