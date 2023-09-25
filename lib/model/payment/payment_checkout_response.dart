class PaymentCheckoutResponse {
  String? transactionId;
  String? checkoutLink;
  String? paymentToken;

  PaymentCheckoutResponse(
      {this.transactionId, this.checkoutLink, this.paymentToken});

  PaymentCheckoutResponse.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'] as String?;
    checkoutLink = json['checkoutLink'] as String?;
    paymentToken = json['paymentToken'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transactionId'] = transactionId;
    data['checkoutLink'] = checkoutLink;
    data['paymentToken'] = paymentToken;
    return data;
  }
}
