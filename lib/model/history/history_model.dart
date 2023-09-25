class HistoryModel {
  List<HistoryData>? data;

  HistoryModel({this.data});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <HistoryData>[];
      json['data'].forEach((Map<String, dynamic> v) {
        data!.add(HistoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HistoryData {
  String? userName;
  String? userPicture;
  String? transactionMethod;
  String? carName;
  String? carModel;
  String? carValue;
  String? carPicture;
  String? traderName;

  HistoryData(
      {this.userName,
      this.userPicture,
      this.transactionMethod,
      this.carName,
      this.carModel,
      this.carValue,
      this.carPicture,
      this.traderName});

  HistoryData.fromJson(Map<String, dynamic> json) {
    userName = json['userName'] as String;
    userPicture = json['userPicture'] as String;
    transactionMethod = json['transactionMethod'] as String;
    carName = json['carName'] as String;
    carModel = json['carModel'] as String;
    carValue = json['carValue'] as String;
    carPicture = json['carPicture'] as String;
    traderName = json['traderName'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['userPicture'] = userPicture;
    data['transactionMethod'] = transactionMethod;
    data['carName'] = carName;
    data['carModel'] = carModel;
    data['carValue'] = carValue;
    data['carPicture'] = carPicture;
    data['traderName'] = traderName;
    return data;
  }
}
