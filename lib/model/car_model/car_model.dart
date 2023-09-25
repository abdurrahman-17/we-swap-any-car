import 'car_added_accessories.dart';
import 'car_additional_info.dart';
import 'car_additional_props.dart';
import 'car_analytics.dart';
import 'car_condition_damage_model.dart';
import 'car_exterior_grade.dart';
import 'car_hpi_and_mot.dart';
import 'car_location.dart';
import 'car_service_history.dart';
import 'car_upload_photos_and_video.dart';
import 'value_section_input.dart';

class CarModel {
  num? mileage;
  String? model;
  num? tradeValue;
  num? wsacValue;
  num? userExpectedValue;
  bool? quickSale;
  String? slug;
  String? userId;
  num? engineSize;
  String? status;
  List<String>? createStatus;
  String? postType;
  bool? priceApproved;
  String? surveyQuestions;
  String? createdAt;
  String? updatedAt;
  String? updatedBy;
  String? id;
  num? yearOfManufacture;
  num? noOfDoors;
  AdditionalProps? additionalProps;
  List<Map<String, dynamic>>? premiumPostLogs;
  AdditionalInformation? additionalInformation;
  AddedAccessories? addedAccessories;
  CarAnalytics? analytics;
  CarLocation? carLocation;
  ValuesSectionInput? colour;
  ConditionAndDamage? conditionAndDamage;
  ExteriorGrade? exteriorGrade;
  ValuesSectionInput? fuelType;
  HpiAndMot? hpiAndMot;
  ValuesSectionInput? manufacturer;
  String? registration;
  ServiceHistory? serviceHistory;
  ValuesSectionInput? transmissionType;
  ValuesSectionInput? bodyType;
  UploadPhotosAndVideo? uploadPhotos;
  String? userType;
  String? ownerProfileImage;
  String? ownerUserName;
  num? userRating;
  String? companyLogo;
  String? companyName;
  num? companyRating;

  CarModel({
    this.mileage,
    this.model,
    this.tradeValue,
    this.wsacValue,
    this.userExpectedValue,
    this.quickSale,
    this.slug,
    this.userId,
    this.engineSize,
    this.status,
    this.createStatus,
    this.postType,
    this.priceApproved,
    this.surveyQuestions,
    this.createdAt,
    this.updatedAt,
    this.updatedBy,
    this.id,
    this.yearOfManufacture,
    this.noOfDoors,
    this.additionalProps,
    this.premiumPostLogs,
    this.additionalInformation,
    this.addedAccessories,
    this.analytics,
    this.carLocation,
    this.colour,
    this.conditionAndDamage,
    this.exteriorGrade,
    this.fuelType,
    this.hpiAndMot,
    this.manufacturer,
    this.registration,
    this.serviceHistory,
    this.transmissionType,
    this.bodyType,
    this.uploadPhotos,
    this.userType,
    this.ownerProfileImage,
    this.ownerUserName,
    this.userRating,
    this.companyName,
    this.companyLogo,
    this.companyRating,
  });

  CarModel.fromJson(Map<String, dynamic> json) {
    mileage = json['mileage'] as num?;
    model = json['model'] as String?;
    tradeValue = json['tradeValue'] as num?;
    wsacValue = json['wsacValue'] as num?;
    userExpectedValue = json['userExpectedValue'] as num?;
    quickSale = json['quickSale'] as bool?;
    slug = json['slug'] as String?;
    userId = json['userId'] as String?;
    status = json['status'] as String?;
    registration = json['registration'] as String?;
    engineSize = json['engineSize'] as num?;
    postType = json['postType'] as String?;
    priceApproved = json['priceApproved'] as bool?;
    surveyQuestions = json['surveyQuestions'] as String?;
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
    updatedBy = json['updatedBy'] as String?;
    ownerProfileImage = json['ownerProfileImage'] as String?;
    ownerUserName = json['ownerUserName'] as String?;
    userRating = json['userRating'] as num?;
    companyName = json['companyName'] as String?;
    companyLogo = json['companyLogo'] as String?;
    companyRating = json['companyRating'] as num?;
    id = json['_id'] as String?;
    yearOfManufacture = json['yearOfManufacture'] as num?;
    noOfDoors = json['doors'] as num?;
    userType = json['userType'] as String?;
    if (json['createStatus'] != null) {
      createStatus = [];
      for (final item in json['createStatus'] as List) {
        createStatus!.add("$item");
      }
    }
    if (json['additionalInformation'] != null) {
      additionalInformation = AdditionalInformation.fromJson(
          json['additionalInformation'] as Map<String, dynamic>);
    }
    if (json['premiumPost'] != null) {
      additionalProps =
          AdditionalProps.fromJson(json['premiumPost'] as Map<String, dynamic>);
    }
    if (json['PremiumPostLogs'] != null) {
      premiumPostLogs = [];
      for (final item in json['PremiumPostLogs'] as List) {
        premiumPostLogs!.add(item as Map<String, dynamic>);
      }
    }
    if (json['addedAccessories'] != null) {
      addedAccessories = AddedAccessories.fromJson(
          json['addedAccessories'] as Map<String, dynamic>);
    }
    if (json['analytics'] != null) {
      analytics =
          CarAnalytics.fromJson(json['analytics'] as Map<String, dynamic>);
    }
    if (json['carLocation'] != null) {
      carLocation =
          CarLocation.fromJson(json['carLocation'] as Map<String, dynamic>);
    }
    if (json['colour'] != null) {
      colour =
          ValuesSectionInput.fromJson(json['colour'] as Map<String, dynamic>);
    }
    if (json['conditionAndDamage'] != null) {
      conditionAndDamage = ConditionAndDamage.fromJson(
          json['conditionAndDamage'] as Map<String, dynamic>);
    }
    if (json['exteriorGrade'] != null) {
      exteriorGrade =
          ExteriorGrade.fromJson(json['exteriorGrade'] as Map<String, dynamic>);
    }
    if (json['fuelType'] != null) {
      fuelType =
          ValuesSectionInput.fromJson(json['fuelType'] as Map<String, dynamic>);
    }
    if (json['hpiAndMot'] != null) {
      hpiAndMot = HpiAndMot.fromJson(json['hpiAndMot'] as Map<String, dynamic>);
    }
    if (json['manufacturer'] != null) {
      manufacturer = ValuesSectionInput.fromJson(
          json['manufacturer'] as Map<String, dynamic>);
    }
    if (json['serviceHistory'] != null) {
      serviceHistory = ServiceHistory.fromJson(
          json['serviceHistory'] as Map<String, dynamic>);
    }
    if (json['transmissionType'] != null) {
      transmissionType = ValuesSectionInput.fromJson(
          json['transmissionType'] as Map<String, dynamic>);
    }
    if (json['bodyType'] != null) {
      bodyType =
          ValuesSectionInput.fromJson(json['bodyType'] as Map<String, dynamic>);
    }
    if (json['uploadPhotos'] != null) {
      uploadPhotos = UploadPhotosAndVideo.fromJson(
          json['uploadPhotos'] as Map<String, dynamic>);
    }
  }

  Map<String, dynamic> toJson() => {
        'mileage': mileage,
        'model': model,
        'tradeValue': tradeValue,
        'wsacValue': wsacValue,
        'userExpectedValue': userExpectedValue,
        'quickSale': quickSale,
        'slug': slug,
        'userId': userId,
        'status': status,
        'createStatus': createStatus,
        'engineSize': engineSize,
        'postType': postType,
        'priceApproved': priceApproved,
        'surveyQuestions': surveyQuestions,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'updatedBy': updatedBy,
        'userType': userType,
        '_id': id,
        'yearOfManufacture': yearOfManufacture,
        'doors': noOfDoors,
        'ownerProfileImage': ownerProfileImage,
        'ownerUserName': ownerUserName,
        'userRating': userRating,
        'companyName': companyName,
        'companyLogo': companyLogo,
        'companyRating': companyRating,
        'additionalInformation': additionalInformation?.toJson(),
        'premiumPost': additionalProps?.toJson(),
        'addedAccessories': addedAccessories?.toJson(),
        'analytics': analytics?.toJson(),
        'carLocation': carLocation?.toJson(),
        'colour': colour?.toJson(),
        'conditionAndDamage': conditionAndDamage,
        'exteriorGrade': exteriorGrade?.toJson(),
        'fuelType': fuelType?.toJson(),
        'hpiAndMot': hpiAndMot?.toJson(),
        'manufacturer': manufacturer?.toJson(),
        'registration': registration,
        'serviceHistory': serviceHistory?.toJson(),
        'transmissionType': transmissionType?.toJson(),
        'bodyType': bodyType?.toJson(),
        'uploadPhotos': uploadPhotos?.toJson(),
      };
}
