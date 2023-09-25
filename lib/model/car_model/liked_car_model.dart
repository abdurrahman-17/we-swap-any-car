import 'car_additional_info.dart';
import 'car_analytics.dart';
import 'value_section_input.dart';

class LikedCarModel {
  String? sId;
  AdditionalInformation? additionalInformation;
  CarAnalytics? analytics;
  String? avatarImage;
  ValuesSectionInput? bodyType;
  String? carId;
  String? carName;
  String? companyDescription;
  String? createdAt;
  String? description;
  ValuesSectionInput? fuelType;
  String? image;
  String? likedBy;
  num? likes;
  ValuesSectionInput? manufacturer;
  num? mileage;
  String? model;
  String? ownerId;
  String? ownerType;
  String? postType;
  bool? quickSale;
  num? rating;
  String? registration;
  String? status;
  ValuesSectionInput? transmissionType;
  num? userExpectedValue;
  String? userName;
  String? userType;
  num? wsacValue;
  num? yearOfManufacture;
  String? companyLogo;
  String? companyName;
  num? companyRating;

  LikedCarModel({
    this.sId,
    this.additionalInformation,
    this.analytics,
    this.avatarImage,
    this.bodyType,
    this.carId,
    this.carName,
    this.companyDescription,
    this.createdAt,
    this.description,
    this.fuelType,
    this.image,
    this.likedBy,
    this.likes,
    this.manufacturer,
    this.mileage,
    this.model,
    this.ownerId,
    this.ownerType,
    this.postType,
    this.quickSale,
    this.rating,
    this.registration,
    this.status,
    this.transmissionType,
    this.userExpectedValue,
    this.userName,
    this.userType,
    this.wsacValue,
    this.yearOfManufacture,
    this.companyLogo,
    this.companyName,
    this.companyRating,
  });

  LikedCarModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] as String?;
    if (json['additionalInformation'] != null) {
      additionalInformation = AdditionalInformation.fromJson(
          json['additionalInformation'] as Map<String, dynamic>);
    }
    avatarImage = json['avatarImage'] as String?;
    bodyType = json['bodyType'] != null
        ? ValuesSectionInput.fromJson(json['bodyType'] as Map<String, dynamic>)
        : null;
    carId = json['carId'] as String?;
    carName = json['carName'] as String?;
    companyDescription = json['companyDescription'] as String?;
    createdAt = json['createdAt'] as String?;
    description = json['description'] as String?;
    fuelType = json['fuelType'] != null
        ? ValuesSectionInput.fromJson(json['fuelType'] as Map<String, dynamic>)
        : null;
    image = json['image'] as String?;
    likedBy = json['likedBy'] as String?;
    likes = json['likes'] as num?;
    manufacturer = json['manufacturer'] != null
        ? ValuesSectionInput.fromJson(
            json['manufacturer'] as Map<String, dynamic>)
        : null;
    mileage = json['mileage'] as num?;
    model = json['model'] as String?;
    ownerId = json['ownerId'] as String?;
    ownerType = json['ownerType'] as String?;
    postType = json['postType'] as String?;
    quickSale = json['quickSale'] as bool?;
    rating = json['rating'] as num?;
    registration = json['registration'] as String?;
    status = json['status'] as String?;
    transmissionType = json['transmissionType'] != null
        ? ValuesSectionInput.fromJson(
            json['transmissionType'] as Map<String, dynamic>)
        : null;
    userExpectedValue = json['userExpectedValue'] as num?;
    userName = json['userName'] as String?;
    userType = json['userType'] as String?;
    wsacValue = json['wsacValue'] as num?;
    companyName = json['companyName'] as String?;
    companyLogo = json['companyLogo'] as String?;
    companyRating = json['companyRating'] as num?;
    yearOfManufacture = json['yearOfManufacture'] as num?;
    if (json['analytics'] != null) {
      analytics =
          CarAnalytics.fromJson(json['analytics'] as Map<String, dynamic>);
    }
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'additionalInformation': additionalInformation?.toJson(),
        'avatarImage': avatarImage,
        'bodyType': bodyType?.toJson(),
        'carId': carId,
        'carName': carName,
        'companyDescription': companyDescription,
        'createdAt': createdAt,
        'description': description,
        'fuelType': fuelType?.toJson(),
        'image': image,
        'likedBy': likedBy,
        'likes': likes,
        'manufacturer': manufacturer?.toJson(),
        'mileage': mileage,
        'model': model,
        'ownerId': ownerId,
        'ownerType': ownerType,
        'postType': postType,
        'quickSale': quickSale,
        'rating': rating,
        'registration': registration,
        'status': status,
        'transmissionType': transmissionType?.toJson(),
        'userExpectedValue': userExpectedValue,
        'userName': userName,
        'userType': userType,
        'companyName': companyName,
        'companyLogo': companyLogo,
        'companyRating': companyRating,
        'wsacValue': wsacValue,
        'yearOfManufacture': yearOfManufacture,
        'analytics': analytics?.toJson(),
      };
}
