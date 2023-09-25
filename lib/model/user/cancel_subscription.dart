class CancelSubscription {
  String? requestId;
  String? status;

  CancelSubscription({
    this.requestId,
    this.status,
  });

  CancelSubscription.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'] as String?;
    status = json['status'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['status'] = status;
    return data;
  }
}
