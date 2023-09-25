class TransactionModel {
  String? status;
  String? sId;

  TransactionModel({this.status, this.sId});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'].toString();
    status = "";
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        '_id': sId,
      };
}
