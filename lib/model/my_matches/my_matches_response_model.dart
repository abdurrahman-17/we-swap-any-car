import 'package:wsac/model/my_matches/my_matches_model.dart';

class MyMatchesResponseModel {
  List<MyMatchModel>? myMatchesList;
  int? pageNo;
  int? totalPages;
  int? totalRecords;

  MyMatchesResponseModel({
    this.myMatchesList,
    this.pageNo,
    this.totalPages,
    this.totalRecords,
  });

  MyMatchesResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['myMatchesList'] != null) {
      final myMatches = json['myMatchesList'] as List<dynamic>;
      myMatchesList = <MyMatchModel>[];
      for (var v in myMatches) {
        myMatchesList!.add(MyMatchModel.fromJson(v as Map<String, dynamic>));
      }
    }
    pageNo = json['pageNo'] as int?;
    totalPages = json['totalPages'] as int?;
    totalRecords = json['totalRecords'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (myMatchesList != null) {
      data['myMatchesList'] = myMatchesList!.map((v) => v.toJson()).toList();
    }
    data['pageNo'] = pageNo;
    data['totalPages'] = totalPages;
    data['totalRecords'] = totalRecords;
    return data;
  }
}
