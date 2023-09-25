import 'car_model.dart';

class GetCarsResponseModel {
  int? totalPages;
  int? totalRecords;
  int? pageNo;
  String? paginationKey;
  List<CarModel>? cars;

  GetCarsResponseModel(
      {this.totalPages,
      this.totalRecords,
      this.pageNo,
      this.paginationKey,
      this.cars});

  GetCarsResponseModel.fromJson(Map<String, dynamic> json) {
    totalPages = json['totalPages'] as int?;
    totalRecords = json['totalRecords'] as int?;
    pageNo = json['pageNo'] as int?;
    paginationKey = json['paginationKey'] as String?;
    if (json['cars'] != null) {
      final List<dynamic> carList = json['cars'] as List;
      cars = <CarModel>[];
      for (var v in carList) {
        cars!.add(CarModel.fromJson(v as Map<String, dynamic>));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalPages'] = totalPages;
    data['totalRecords'] = totalRecords;
    data['pageNo'] = pageNo;
    data['paginationKey'] = paginationKey;
    if (cars != null) {
      data['cars'] = cars!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
