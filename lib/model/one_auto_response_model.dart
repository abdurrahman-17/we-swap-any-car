class OneAutoResponseModel {
  String? status;
  int? statusCode;
  String? message;
  OneAutoData? data;
  int? timestamp;

  OneAutoResponseModel(
      {this.status, this.statusCode, this.message, this.data, this.timestamp});

  OneAutoResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as String?;
    statusCode = json['statusCode'] as int?;
    message = json['message'] as String?;
    if (json['data'] != null) {
      data = OneAutoData.fromJson(json['data'] as Map<String, dynamic>);
    }
    timestamp = json['timestamp'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (data['data'] != null) {
      data['data'] = this.data!.toJson();
    }
    data['timestamp'] = timestamp;
    return data;
  }
}

class OneAutoData {
  RequestParameter? requestParameter;
  ResponseParameter? responseParameter;

  OneAutoData({this.requestParameter, this.responseParameter});

  OneAutoData.fromJson(Map<String, dynamic> json) {
    if (json['requestParameter'] != null) {
      requestParameter = RequestParameter.fromJson(
          json['requestParameter'] as Map<String, dynamic>);
    }

    if (json['responseParameter'] != null) {
      responseParameter = ResponseParameter.fromJson(
          json['responseParameter'] as Map<String, dynamic>);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (requestParameter != null) {
      data['requestParameter'] = requestParameter!.toJson();
    }
    if (responseParameter != null) {
      data['responseParameter'] = responseParameter!.toJson();
    }
    return data;
  }
}

class RequestParameter {
  String? currentMileage;
  String? exteriorGrade;
  String? vehicleRegistrationMark;

  RequestParameter(
      {this.currentMileage, this.exteriorGrade, this.vehicleRegistrationMark});

  RequestParameter.fromJson(Map<String, dynamic> json) {
    currentMileage = json['current_mileage'] as String?;
    exteriorGrade = json['exterior_grade'] as String?;
    vehicleRegistrationMark = json['vehicle_registration_mark'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_mileage'] = currentMileage;
    data['exterior_grade'] = exteriorGrade;
    data['vehicle_registration_mark'] = vehicleRegistrationMark;
    return data;
  }
}

class ResponseParameter {
  String? version;
  String? mileageUnit;
  String? currencyUnit;
  num? retailValuation;
  num? wsacValue;

  ResponseParameter({
    this.version,
    this.mileageUnit,
    this.currencyUnit,
    this.retailValuation,
    this.wsacValue,
  });

  ResponseParameter.fromJson(Map<String, dynamic> json) {
    version = json['version'] as String?;
    mileageUnit = json['mileage_unit'] as String?;
    currencyUnit = json['currency_unit'] as String?;
    retailValuation = json['retail_valuation'] as num?;
    wsacValue = json['wsac_value'] as num?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version'] = version;
    data['mileage_unit'] = mileageUnit;
    data['currency_unit'] = currencyUnit;
    data['retail_valuation'] = retailValuation;
    data['wsac_value'] = wsacValue;
    return data;
  }
}

// class ResponseParameter {
//   ResponseParameter({
//     required this.success,
//     required this.result,
//   });

//   String success;
//   Either<ErrorResult, OneAutoResult> result;

//   factory ResponseParameter.fromJson(Map<String, dynamic> json) =>
//       ResponseParameter(
//         success: json['success'] as String,
//         result: json['success'] as String == 'false'
//       ? Left(ErrorResult.fromJson(json['result'] as Map<String, dynamic>))
//       : Right(
//              OneAutoResult.fromJson(json['result'] as Map<String, dynamic>)),
//       );

//   Map<String, dynamic> toJson() => {
//         'success': success,
//         'result': result,
//       };
// }



