class UpgradeSubscription {
  String? requestId;
  String? planId;
  String? status;
  bool? isInitialSubscription;

  UpgradeSubscription({
    this.requestId,
    this.planId,
    this.status,
    this.isInitialSubscription,
  });

  UpgradeSubscription.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'] as String?;
    planId = json['planId'] as String?;
    status = json['status'] as String?;
    isInitialSubscription = json['isInitialSubscription'] as bool?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['planId'] = planId;
    data['status'] = status;
    data['isInitialSubscription'] = isInitialSubscription;
    return data;
  }
}
