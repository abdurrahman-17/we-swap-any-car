import 'package:equatable/equatable.dart';

import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/user/premium_posts_model.dart';
import '../../model/user/subscription.dart';
import '../../repository/subscription_repo.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  List<SubscriptionModel> subscriptionPlans = [];
  SubscriptionBloc() : super(SubscriptionInitialState()) {
    on<SubscriptionEvent>((event, emit) {
      emit(SubscriptionInitialState());
    });

    // fetch subscriptions data
    on<GetSubscriptionDataEvent>((event, emit) async {
      emit(const GetSubscriptionDataState(
          subscriptionDataStatus: ProviderStatus.loading));

      final result = await Locator.instance
          .get<SubscriptionRepo>()
          .fetchSubscriptionsData();

      final GetSubscriptionDataState state = result.fold((fail) {
        return const GetSubscriptionDataState(
          subscriptionDataStatus: ProviderStatus.error,
        );
      }, (subscriptionsData) {
        subscriptionPlans = subscriptionsData;
        return GetSubscriptionDataState(
          subscriptionDataStatus: ProviderStatus.success,
          subscriptionsData: subscriptionsData,
        );
      });
      emit(state);
    });

    // add selected subscription
    on<AddSubscriptionPlanEvent>((event, emit) async {
      emit(AddSubscriptionPlanState(
        subscriptionAddStatus: ProviderStatus.loading,
        subscriptionPageName: event.subscriptionPageName,
      ));

      final result = await Locator.instance
          .get<SubscriptionRepo>()
          .addSubscription(event.planData);

      final AddSubscriptionPlanState state = result.fold((fail) {
        return AddSubscriptionPlanState(
          subscriptionAddStatus: ProviderStatus.error,
          subscriptionPageName: event.subscriptionPageName,
        );
      }, (subscriptionsData) {
        return AddSubscriptionPlanState(
          subscriptionAddStatus: ProviderStatus.success,
          subscriptionsData: subscriptionsData,
          subscriptionPageName: event.subscriptionPageName,
        );
      });
      emit(state);
    });

    // upgrade subscription
    on<UpgradeSubscriptionPlanEvent>((event, emit) async {
      emit(UpgradeSubscriptionPlanState(
        subscriptionUpgradeStatus: ProviderStatus.loading,
        subscriptionPageName: event.subscriptionPageName,
      ));

      final result = await Locator.instance
          .get<SubscriptionRepo>()
          .upgradeSubscription(event.planData);

      final UpgradeSubscriptionPlanState state = result.fold((fail) {
        return UpgradeSubscriptionPlanState(
          subscriptionUpgradeStatus: ProviderStatus.error,
          subscriptionPageName: event.subscriptionPageName,
        );
      }, (subscriptionsData) {
        return UpgradeSubscriptionPlanState(
          subscriptionUpgradeStatus: ProviderStatus.success,
          subscriptionsData: subscriptionsData,
          subscriptionPageName: event.subscriptionPageName,
        );
      });
      emit(state);
    });

    // fetch premium posts
    on<GetpremiumPostEvent>((event, emit) async {
      emit(const GetPremiumPostState(
          premiumPostDataStatus: ProviderStatus.loading));

      final result = await Locator.instance
          .get<SubscriptionRepo>()
          .fetchPremiumPosts(userType: event.userType);

      final GetPremiumPostState state = result.fold((fail) {
        return const GetPremiumPostState(
          premiumPostDataStatus: ProviderStatus.error,
        );
      }, (subscriptionsData) {
        return GetPremiumPostState(
          premiumPostDataStatus: ProviderStatus.success,
          premiumPostData: subscriptionsData,
        );
      });
      emit(state);
    });

    // Cancel subscription
    on<CancelSubscriptionPlanEvent>((event, emit) async {
      emit(const CancelSubscriptionPlanState(
        subscriptionCancelStatus: ProviderStatus.loading,
      ));

      final result = await Locator.instance
          .get<SubscriptionRepo>()
          .cancelSubscription(event.planData);

      final CancelSubscriptionPlanState state = result.fold((fail) {
        return const CancelSubscriptionPlanState(
          subscriptionCancelStatus: ProviderStatus.error,
        );
      }, (subscriptionsData) {
        return CancelSubscriptionPlanState(
          subscriptionCancelStatus: ProviderStatus.success,
          subscriptionsData: subscriptionsData,
        );
      });
      emit(state);
    });
  }
}
