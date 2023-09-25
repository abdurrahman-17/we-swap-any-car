class AddFinanceRequestResponseModel {
  String? sId;
  double? amount;
  String? createdAt;
  String? transactionId;
  String? status;
  String? updatedAt;
  String? updatedBy;
  String? userEmail;
  String? userId;
  String? userName;

  AddFinanceRequestResponseModel(
      {this.sId,
      this.amount,
      this.createdAt,
      this.transactionId,
      this.status,
      this.updatedAt,
      this.updatedBy,
      this.userEmail,
      this.userId,
      this.userName});

  AddFinanceRequestResponseModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] as String?;
    amount = json['amount'] as double?;
    createdAt = json['createdAt'] as String?;
    transactionId = json['transactionId'] as String?;
    status = json['status'] as String?;
    updatedAt = json['updatedAt'] as String?;
    updatedBy = json['updatedBy'] as String?;
    userEmail = json['userEmail'] as String?;
    userId = json['userId'] as String?;
    userName = json['userName'] as String?;
  }
}
