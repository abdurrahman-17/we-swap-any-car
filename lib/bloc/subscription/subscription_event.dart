part of 'subscription_bloc.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object> get props => [];
}

class GetSubscriptionDataEvent extends SubscriptionEvent {}

class AddSubscriptionPlanEvent extends SubscriptionEvent {
  final Map<String, dynamic> planData;
  final SubscriptionPageName subscriptionPageName;
  const AddSubscriptionPlanEvent({
    required this.planData,
    required this.subscriptionPageName,
  });
}

class UpgradeSubscriptionPlanEvent extends SubscriptionEvent {
  final Map<String, dynamic> planData;
  final SubscriptionPageName subscriptionPageName;
  const UpgradeSubscriptionPlanEvent({
    required this.planData,
    required this.subscriptionPageName,
  });
}

class GetpremiumPostEvent extends SubscriptionEvent {
  final String userType;
  const GetpremiumPostEvent({
    required this.userType,
  });
}

class CancelSubscriptionPlanEvent extends SubscriptionEvent {
  final Map<String, dynamic> planData;
  const CancelSubscriptionPlanEvent({
    required this.planData,
  });
}
