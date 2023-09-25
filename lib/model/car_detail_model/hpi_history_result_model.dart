class HPIHistoryResultModel {
  String? message;
  bool? result;

  HPIHistoryResultModel({this.message, this.result});

  HPIHistoryResultModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] as String;
    result = json['cleared'] as bool;
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'cleared': result,
      };
}
