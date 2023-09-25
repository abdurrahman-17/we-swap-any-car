class PremiumPosts {
  String? id;
  num? amount;
  int? days;
  String? description;
  String? planName;
  String? status;
  String? updatedAt;
  List<dynamic>? userType;
  String? createdAt;

  PremiumPosts({
    this.id,
    this.amount,
    this.days,
    this.description,
    this.planName,
    this.status,
    this.updatedAt,
    this.userType,
    this.createdAt,
  });

  PremiumPosts.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String?;
    amount = json['amount'] as num?;
    days = json['days'] as int?;
    description = json['description'] as String?;
    planName = json['planName'] as String?;
    status = json['status'] as String?;
    updatedAt = json['updatedAt'] as String?;
    userType = json['userType'] as List<dynamic>?;
    createdAt = json['createdAt'] as String?;
  }
}
