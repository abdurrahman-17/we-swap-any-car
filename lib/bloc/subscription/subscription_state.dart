part of 'subscription_bloc.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

class SubscriptionInitialState extends SubscriptionState {}

class GetSubscriptionDataState extends SubscriptionState {
  final ProviderStatus subscriptionDataStatus;
  final List<SubscriptionModel> subscriptionsData;

  const GetSubscriptionDataState({
    required this.subscriptionDataStatus,
    this.subscriptionsData = const [],
  });
  @override
  List<Object> get props => [subscriptionDataStatus];
}

class AddSubscriptionPlanState extends SubscriptionState {
  final ProviderStatus subscriptionAddStatus;
  final SubscriptionModel? subscriptionsData;
  final SubscriptionPageName subscriptionPageName;

  const AddSubscriptionPlanState({
    required this.subscriptionAddStatus,
    required this.subscriptionPageName,
    this.subscriptionsData,
  });
  @override
  List<Object> get props => [subscriptionAddStatus];
}

class UpgradeSubscriptionPlanState extends SubscriptionState {
  final ProviderStatus subscriptionUpgradeStatus;
  final SubscriptionModel? subscriptionsData;
  final SubscriptionPageName subscriptionPageName;

  const UpgradeSubscriptionPlanState({
    required this.subscriptionUpgradeStatus,
    required this.subscriptionPageName,
    this.subscriptionsData,
  });
  @override
  List<Object> get props => [subscriptionUpgradeStatus];
}

class GetPremiumPostState extends SubscriptionState {
  final ProviderStatus premiumPostDataStatus;
  final PremiumPosts? premiumPostData;

  const GetPremiumPostState({
    required this.premiumPostDataStatus,
    this.premiumPostData,
  });
  @override
  List<Object> get props => [premiumPostDataStatus];
}

class CancelSubscriptionPlanState extends SubscriptionState {
  final ProviderStatus subscriptionCancelStatus;
  final SubscriptionModel? subscriptionsData;

  const CancelSubscriptionPlanState({
    required this.subscriptionCancelStatus,
    this.subscriptionsData,
  });
  @override
  List<Object> get props => [subscriptionCancelStatus];
}
