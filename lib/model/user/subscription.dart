class SubscriptionModel {
  String? sId;
  String? name;
  num? amount;
  String? description;
  String? cycleType;
  int? sortOrder;
  int? carLimit;
  bool? deleted;
  String? type;
  int? validity;
  String? updatedOn;
  String? endsOn;
  String? status;
  int? cycle;

  SubscriptionModel({
    this.sId,
    this.deleted,
    this.updatedOn,
    this.name,
    this.cycleType,
    this.amount,
    this.description,
    this.sortOrder,
    this.carLimit,
    this.type,
    this.validity,
    this.status,
    this.cycle,
    this.endsOn,
  });

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      sId = json['id'] as String?;
    }
    if (json['_id'] != null) {
      sId = json['_id'] as String?;
    }
    name = json['name'] as String?;
    description = json['description'] as String?;
    if (json['amount'] != null) {
      if (json['amount'].runtimeType == String) {
        amount = num.parse(json['amount'].toString());
      } else {
        amount = json['amount'] as num?;
      }
    }
    if (json['cycle'] != null) {
      cycle = json['cycle'] as int?;
    }
    cycleType = json['cycleType'] as String?;
    sortOrder = json['sortOrder'] as int?;
    carLimit = json['carLimit'] as int?;
    deleted = json['deleted'] as bool?;
    type = json['type'] as String?;
    status = json['status'] as String?;
    endsOn = json['endsOn'] as String?;
    validity = json['validity'] as int?;
  }
}
