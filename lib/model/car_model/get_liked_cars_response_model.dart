import 'liked_car_model.dart';

class GetLikedCarsResponseModel {
  int? totalPages;
  int? totalRecords;
  int? pageNo;
  int? sortBy;
  List<LikedCarModel>? cars;

  GetLikedCarsResponseModel(
      {this.totalPages,
      this.totalRecords,
      this.pageNo,
      this.sortBy,
      this.cars});

  GetLikedCarsResponseModel.fromJson(Map<String, dynamic> json) {
    totalPages = json['totalPages'] as int?;
    totalRecords = json['totalRecords'] as int?;
    pageNo = json['pageNo'] as int?;
    sortBy = json['sortBy'] as int?;
    if (json['cars'] != null) {
      final List<dynamic> carList = json['cars'] as List;
      cars = <LikedCarModel>[];
      for (var v in carList) {
        cars!.add(LikedCarModel.fromJson(v as Map<String, dynamic>));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalPages'] = totalPages;
    data['totalRecords'] = totalRecords;
    data['pageNo'] = pageNo;
    data['sortBy'] = sortBy;
    return data;
  }
}
