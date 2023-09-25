import 'package:dartz/dartz.dart';

import '../core/locator.dart';
import '../model/faq/faq_model.dart';
import '../model/error_model.dart';
import '../model/send_email_response_model.dart';
import '../service/api_service/api_service.dart';
import '../service/graphQl_service/gq_service.dart';
// import '../service/graphQl_service/graphql_service.dart';

class ContactUsRepo {
  ///fetch Subscription data
  Future<Either<ErrorModel, List<FaqModel>>> fetchFaqQuestions() async =>
      await Locator.instance.get<GraphQlServices>().getFaqQuestionsService();

  ///
  Future<Either<ErrorModel, SendEmailResponseModel>> sendEmailContactUsRepo(
          Map<String, dynamic> contactUsEmailBody) async =>
      await Locator.instance
          .get<ApiService>()
          .sendEmailContactUs(contactUsEmailBody);
}
