import 'package:wsac/model/car_model/car_model.dart';

class OtherCarsByUserResponseModel {
  int? totalPages;
  int? totalRecords;
  int? pageNo;
  List<CarModel>? cars;

  OtherCarsByUserResponseModel(
      {this.totalPages, this.totalRecords, this.pageNo, this.cars});

  OtherCarsByUserResponseModel.fromJson(Map<String, dynamic> json) {
    totalPages = json['totalPages'] as int?;
    totalRecords = json['totalRecords'] as int?;
    pageNo = json['pageNo'] as int?;
    if (json['cars'] != null) {
      final otherCars = json['cars'] as List<dynamic>;
      cars = <CarModel>[];
      for (var v in otherCars) {
        cars!.add(CarModel.fromJson(v as Map<String, dynamic>));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalPages'] = totalPages;
    data['totalRecords'] = totalRecords;
    data['pageNo'] = pageNo;
    if (cars != null) {
      data['cars'] = cars!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
