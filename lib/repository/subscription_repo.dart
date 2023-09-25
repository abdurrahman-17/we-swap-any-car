import 'package:dartz/dartz.dart';

import '../core/locator.dart';
import '../model/error_model.dart';
import '../model/user/premium_posts_model.dart';
import '../model/user/subscription.dart';
import '../service/graphQl_service/gq_service.dart';

class SubscriptionRepo {
  ///fetch Subscription data
  Future<Either<ErrorModel, List<SubscriptionModel>>>
      fetchSubscriptionsData() async =>
          await Locator.instance.get<GraphQlServices>().fetchSubscriptions();

  //add selected subscription
  Future<Either<ErrorModel, SubscriptionModel>> addSubscription(
          Map<String, dynamic> subscriptionData) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .addSubscription(subscriptionData);

  //upgrade subscription
  Future<Either<ErrorModel, SubscriptionModel>> upgradeSubscription(
          Map<String, dynamic> subscriptionData) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .upgradeSubscription(subscriptionData);

  //fetch premium posts
  Future<Either<ErrorModel, PremiumPosts>> fetchPremiumPosts(
          {required String userType}) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .getPremiumPosts(userType: userType);

  //cancel subscription
  Future<Either<ErrorModel, SubscriptionModel>> cancelSubscription(
          Map<String, dynamic> subscriptionData) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .cancelSubscription(subscriptionData);
}
