import '../chat_group/chat_car_model.dart';

class OfferModel {
  List<ChatCarModel>? cars;
  String? offerType;
  String? offerStatus;
  num? cash;
  String? payType;
  String? transferSummaryId;

  OfferModel({
    this.cars,
    this.offerType,
    this.offerStatus,
    this.cash,
    this.payType,
    this.transferSummaryId,
  });

  OfferModel.fromJson(Map<String, dynamic> json) {
    offerType = json["offerType"] as String?;
    offerStatus = json["offerStatus"] as String?;
    payType = json["payType"] as String?;
    cash = json["cash"] as num?;
    if (json['cars'] != null) {
      cars = [];
      for (final item in json['cars'] as List) {
        cars!.add(ChatCarModel.fromJson(item as Map<String, dynamic>));
      }
    }
    transferSummaryId = json['transferSummaryId'] as String?;
  }

  Map<String, dynamic> toJson() {
    List<dynamic> temp = [];
    if (cars != null) {
      for (final item in cars!) {
        temp.add(item.toJson());
      }
    }
    return {
      "offerType": offerType,
      "offerStatus": offerStatus,
      if (cash != null) "cash": cash,
      if (payType != null) "payType": payType,
      if (temp.isNotEmpty) "cars": temp,
      if (transferSummaryId != null) "transferSummaryId": transferSummaryId,
    };
  }
}
