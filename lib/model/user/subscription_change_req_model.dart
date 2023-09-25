class SubscriptionChangeReq {
  String? status;
  String? planName;
  String? planId;

  SubscriptionChangeReq({this.status, this.planName, this.planId});

  SubscriptionChangeReq.fromJson(Map<String, dynamic> json) {
    status = json['status'] as String?;
    planName = json['planName'] as String?;
    planId = json['planId'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['planName'] = planName;
    data['planId'] = planId;
    return data;
  }
}
