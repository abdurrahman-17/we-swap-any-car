class PhoneNumberChangeStatusModel {
  String? requestId;
  String? updatedAt;
  String? status;

  PhoneNumberChangeStatusModel({
    this.requestId,
    this.status,
    this.updatedAt,
  });
  PhoneNumberChangeStatusModel.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'] as String?;
    updatedAt = json['updatedAt'] as String?;
    status = json['status'] as String?;
  }
}
