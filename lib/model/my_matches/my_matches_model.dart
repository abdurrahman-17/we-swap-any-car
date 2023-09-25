import '../car_model/liked_car_model.dart';

class MyMatchModel {
  LikedCarModel? carOne;
  LikedCarModel? carTwo;

  MyMatchModel({this.carOne, this.carTwo});

  MyMatchModel.fromJson(Map<String, dynamic> json) {
    if (json['cars1'] != null) {
      carOne = LikedCarModel.fromJson(json['cars1'] as Map<String, dynamic>);
    }
    if (json['cars2'] != null) {
      carTwo = LikedCarModel.fromJson(json['cars2'] as Map<String, dynamic>);
    }
  }

  Map<String, dynamic> toJson() => {
        'cars1': carOne?.toJson(),
        'cars2': carTwo?.toJson(),
      };
}
