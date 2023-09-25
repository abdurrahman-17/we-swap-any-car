class ChatCarModel {
  String? carId;
  String? carName;
  num? carCash;
  String? carImage;
  String? carModelName;
  String? userId;

  ChatCarModel({
    this.carId,
    this.carName,
    this.carCash,
    this.carImage,
    this.carModelName,
    this.userId,
  });

  ChatCarModel.fromJson(Map<String, dynamic> json) {
    carId = json["carId"] as String?;
    carName = json["carName"] as String?;
    carCash = json["carCash"] as num?;
    carImage = json["carImage"] as String?;
    carModelName = json["carModel"] as String?;
    userId = json["userId"] as String?;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "carId": carId,
        "carName": carName,
        "carCash": carCash,
        "carImage": carImage,
        "carModel": carModelName,
        "userId": userId,
      };

  Map<String, dynamic> toTransactionCars() => <String, dynamic>{
        if (carId != null) "id": carId,
        if (carName != null) "manufacturer": carName,
        if (carCash != null) "amount": carCash,
        if (carImage != null) "image": carImage,
        if (carModelName != null) "model": carModelName,
        // if (userId != null) "manufacturerId": userId,
        // "payBy": pay != null
        //     ? convertEnumToString(
        //         pay == payMe ? TransactionPayBy.buyer
        //: TransactionPayBy.seller)
        //     : convertEnumToString(TransactionPayBy.seller)
      };
}
