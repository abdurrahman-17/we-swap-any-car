class AdditionalProps {
  num? amount;
  String? expiry;
  bool? isPremium;
  String? transactionId;

  AdditionalProps({
    this.expiry,
    this.isPremium,
    this.transactionId,
    this.amount,
  });

  factory AdditionalProps.fromJson(Map<String, dynamic> json) =>
      AdditionalProps(
        amount: json['amount'] as num?,
        expiry: json['expiry'] as String?,
        isPremium: json['isPremium'] as bool?,
        transactionId: json['transactionId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'expiry': expiry,
        'isPremium': isPremium,
        'transactionId': transactionId,
      };
}
