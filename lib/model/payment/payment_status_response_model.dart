class PaymentStatusResponseModel {
  String? paymentType;
  String? status;
  String? transactionId;

  PaymentStatusResponseModel({
    this.paymentType,
    this.status,
    this.transactionId,
  });

  PaymentStatusResponseModel.fromJson(Map<String, dynamic> json) {
    paymentType = json['paymentType'] as String?;
    status = json['status'] as String?;
    transactionId = json['transactionId'] as String?;
  }

  Map<String, dynamic> toJson() => {
        'paymentType': paymentType,
        'status': status,
        'transactionId': transactionId,
      };
}
