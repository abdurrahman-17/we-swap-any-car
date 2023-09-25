import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../repository/application_repo.dart';
import '../repository/authentication_repo.dart';
import '../repository/car_repo.dart';
import '../repository/chat_repo.dart';
import '../repository/contact_us_repo.dart';
import '../repository/delete_questionnaire_repo.dart';
import '../repository/notification_repo.dart';
import '../repository/payment_repo.dart';
import '../repository/subscription_repo.dart';
import '../repository/user_repo.dart';
import '../service/amplify_service/amplify_service.dart';
import '../service/api_service/api_service.dart';
import '../service/firebase_service.dart';
import '../service/graphQl_service/gq_service.dart';
// import '../service/graphQl_service/graphql_service.dart';
import '../service/remote_config_service.dart';
import '../service/shared_preference_service.dart';

class Locator {
  static GetIt _i = GetIt.instance;
  static GetIt get instance => _i;

  Locator.setup() {
    _i = GetIt.I;

    ///service
    _i.registerSingleton<RemoteConfigService>(RemoteConfigService());
    _i.registerSingleton<SharedPrefServices>(SharedPrefServices());
    _i.registerSingleton<AmplifyService>(AmplifyService());
    _i.registerSingleton<FirebaseService>(
        FirebaseService(firestore: FirebaseFirestore.instance));
    _i.registerSingleton<ApiService>(ApiService());
    _i.registerSingleton<GraphQlServices>(GraphQlServices());

    //repository
    _i.registerSingleton<ApplicationRepo>(ApplicationRepo());
    _i.registerSingleton<AuthenticationRepo>(AuthenticationRepo());
    _i.registerSingleton<UserRepo>(UserRepo());
    _i.registerSingleton<CarRepo>(CarRepo());
    _i.registerSingleton<SubscriptionRepo>(SubscriptionRepo());
    _i.registerSingleton<PaymentRepo>(PaymentRepo());
    _i.registerSingleton<ChatRepo>(ChatRepo());
    _i.registerSingleton<ContactUsRepo>(ContactUsRepo());
    _i.registerSingleton<NotificationRepo>(NotificationRepo());
    _i.registerSingleton<DeleteQuestionnaireRepo>(DeleteQuestionnaireRepo());
  }
}
