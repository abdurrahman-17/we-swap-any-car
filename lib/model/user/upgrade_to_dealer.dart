class UpgradeToDealer {
  String? requestId;
  String? status;

  UpgradeToDealer({
    this.requestId,
    this.status,
  });

  UpgradeToDealer.fromJson(Map<String, dynamic> json) {
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
