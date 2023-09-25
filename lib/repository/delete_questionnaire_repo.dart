import 'package:dartz/dartz.dart';

import '../core/locator.dart';
import '../model/error_model.dart';
import '../model/questionnaire_model/questionnaire_model.dart';
import '../service/graphQl_service/gq_service.dart';

class DeleteQuestionnaireRepo {
  ///fetch Subscription data
  Future<Either<ErrorModel, List<QuestionnaireModel>>> fetchFeedbackQuestions(
          {required String type}) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .getFeedBackQuestionsService(type: type);

  Future<Either<ErrorModel, String>> updateFeedbackRepo({
    required Map<String, dynamic> questionnaireAnswersJson,
  }) async =>
      await Locator.instance.get<GraphQlServices>().updateFeedbackAnswers(
          questionnaireAnswersJson: questionnaireAnswersJson);
}
