import '../car_model/value_section_input.dart';

class HpiResponseModel {
  String? status;
  num? statusCode;
  String? message;
  Data? data;
  num? timestamp;

  HpiResponseModel(
      {this.status, this.statusCode, this.message, this.data, this.timestamp});

  HpiResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as String?;
    statusCode = json['statusCode'] as num?;
    message = json['message'] as String?;
    if (json['data'] != null) {
      data = Data.fromJson(json['data'] as Map<String, dynamic>);
    }
    timestamp = json['timestamp'] as num?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['timestamp'] = timestamp;
    return data;
  }
}

class Data {
  HPIRequestParameter? requestParameter;
  HPIResponseParameter? responseParameter;

  Data({this.requestParameter, this.responseParameter});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['requestParameter'] != null) {
      requestParameter = HPIRequestParameter.fromJson(
          json['requestParameter'] as Map<String, dynamic>);
    }

    if (json['responseParameter'] != null) {
      responseParameter = HPIResponseParameter.fromJson(
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

class HPIRequestParameter {
  String? vehicleRegistrationMark;

  HPIRequestParameter({this.vehicleRegistrationMark});

  HPIRequestParameter.fromJson(Map<String, dynamic> json) {
    vehicleRegistrationMark = json['vehicle_registration_mark'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vehicle_registration_mark'] = vehicleRegistrationMark;
    return data;
  }
}

class HPIResponseParameter {
  String? dateLastUpdated;
  String? vehicleRegistrationMark;
  ValuesSectionInput? manufacturer;
  ValuesSectionInput? colour;
  ValuesSectionInput? fuelType;
  ValuesSectionInput? transmission;
  String? dvlaModelDesc;
  num? dvlaDoorplanCode;
  num? numberGears;
  num? numberSeats;
  String? registrationDate;
  num? manufacturedYear;
  String? vehicleIdentificationNumber;
  String? firstRegistrationDate;
  String? lastKeeperChangeDate;
  num? engineCapacityCc;
  bool? isScrapped;
  num? v5cDataQty;
  bool? vehicleIdentityCheckQty;
  num? keeperChangesQty;
  bool? colourChangesQty;
  bool? financeDataQty;
  bool? cherishedDataQty;
  bool? conditionDataQty;
  bool? stolenVehicleDataQty;
  bool? highRiskDataQty;

  HPIResponseParameter(
      {this.dateLastUpdated,
      this.vehicleRegistrationMark,
      this.manufacturer,
      this.dvlaModelDesc,
      this.fuelType,
      this.dvlaDoorplanCode,
      this.transmission,
      this.numberGears,
      this.numberSeats,
      this.registrationDate,
      this.manufacturedYear,
      this.vehicleIdentificationNumber,
      this.firstRegistrationDate,
      this.lastKeeperChangeDate,
      this.engineCapacityCc,
      this.isScrapped,
      this.colour,
      this.v5cDataQty,
      this.vehicleIdentityCheckQty,
      this.keeperChangesQty,
      this.colourChangesQty,
      this.financeDataQty,
      this.cherishedDataQty,
      this.conditionDataQty,
      this.stolenVehicleDataQty,
      this.highRiskDataQty});

  HPIResponseParameter.fromJson(Map<String, dynamic> json) {
    if (json['manufacturer'] != null) {
      manufacturer = ValuesSectionInput.fromJson(
          json['manufacturer'] as Map<String, dynamic>);
    }
    if (json['fuelType'] != null) {
      fuelType =
          ValuesSectionInput.fromJson(json['fuelType'] as Map<String, dynamic>);
    }
    if (json['transmission'] != null) {
      transmission = ValuesSectionInput.fromJson(
          json['transmission'] as Map<String, dynamic>);
    }
    if (json['colour'] != null) {
      colour =
          ValuesSectionInput.fromJson(json['colour'] as Map<String, dynamic>);
    }
    dateLastUpdated = json['date_last_updated'] as String?;
    vehicleRegistrationMark = json['vehicle_registration_mark'] as String?;
    dvlaModelDesc = json['dvla_model_desc'] as String?;
    dvlaDoorplanCode = json['dvla_doorplan_code'] as num?;
    numberGears = json['number_gears'] as num?;
    numberSeats = json['number_seats'] as num?;
    lastKeeperChangeDate = json['date_last_keeper_change'] as String?;
    registrationDate = json['registration_date'] as String?;
    manufacturedYear = json['manufactured_year'] as num?;
    vehicleIdentificationNumber =
        json['vehicle_identification_number'] as String?;
    firstRegistrationDate = json['first_registration_date'] as String?;
    engineCapacityCc = json['engine_capacity_cc'] as num?;
    isScrapped = json['is_scrapped'] as bool?;
    v5cDataQty = json['v5c_data_qty'] as num?;
    vehicleIdentityCheckQty = json['vehicle_identity_check_qty'] as bool?;
    keeperChangesQty = json['keeper_changes_qty'] as num?;
    colourChangesQty = json['colour_changes_qty'] as bool?;
    financeDataQty = json['finance_data_qty'] as bool?;
    cherishedDataQty = json['cherished_data_qty'] as bool?;
    conditionDataQty = json['condition_data_qty'] as bool?;
    stolenVehicleDataQty = json['stolen_vehicle_data_qty'] as bool?;
    highRiskDataQty = json['high_risk_data_qty'] as bool?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (manufacturer != null) {
      data['manufacturer'] = manufacturer!.toJson();
    }
    if (fuelType != null) {
      data['fuelType'] = fuelType!.toJson();
    }
    if (transmission != null) {
      data['transmission'] = transmission!.toJson();
    }
    if (colour != null) {
      data['colour'] = colour!.toJson();
    }
    data['dvla_model_desc'] = dvlaModelDesc;
    data['dvla_doorplan_code'] = dvlaDoorplanCode;
    data['date_last_updated'] = dateLastUpdated;
    data['vehicle_registration_mark'] = vehicleRegistrationMark;
    data['number_gears'] = numberGears;
    data['number_seats'] = numberSeats;
    data['registration_date'] = registrationDate;
    data['manufactured_year'] = manufacturedYear;
    data['vehicle_identification_number'] = vehicleIdentificationNumber;
    data['first_registration_date'] = firstRegistrationDate;
    data['date_last_keeper_change'] = lastKeeperChangeDate;
    data['engine_capacity_cc'] = engineCapacityCc;
    data['is_scrapped'] = isScrapped;
    data['v5c_data_qty'] = v5cDataQty;
    data['vehicle_identity_check_qty'] = vehicleIdentityCheckQty;
    data['keeper_changes_qty'] = keeperChangesQty;
    data['colour_changes_qty'] = colourChangesQty;
    data['finance_data_qty'] = financeDataQty;
    data['cherished_data_qty'] = cherishedDataQty;
    data['condition_data_qty'] = conditionDataQty;
    data['stolen_vehicle_data_qty'] = stolenVehicleDataQty;
    data['high_risk_data_qty'] = highRiskDataQty;
    return data;
  }
}
