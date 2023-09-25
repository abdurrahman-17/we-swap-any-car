import 'phone_number_change_status_model.dart';
import 'trader_model.dart';
import 'upgrade_to_dealer.dart';
import 'user_location_model.dart';

class UserModel {
  String? userId;
  String? cognitoId;
  String? addressLine1;
  String? avatarImage;
  String? contract;
  String? createdAt;
  String? dateOfBirth;
  String? email;
  bool? emailVerified;
  String? firstName;
  String? gender;
  String? lastName;
  String? notificationStatus;
  String? notifications;
  String? phone;
  bool? phoneVerified;
  String? slug;
  String? socialMediaID;
  String? socialMediaType;
  String? town;
  String? updatedAt;
  String? updatedBy;
  String? userName;
  String? userPurpose;
  String? userType;
  String? status;
  String? postCode;
  UserLocationModel? userLocation;
  String? traderId;
  UpgradeToDealer? upgradeToDealer;
  TraderModel? trader;
  PhoneNumberChangeStatusModel? phoneNumberChange;

  UserModel({
    this.userId,
    this.cognitoId,
    this.addressLine1,
    this.avatarImage,
    this.contract,
    this.createdAt,
    this.dateOfBirth,
    this.email,
    this.emailVerified,
    this.firstName,
    this.gender,
    this.lastName,
    this.notificationStatus,
    this.phone,
    this.phoneVerified,
    this.slug,
    this.socialMediaID,
    this.socialMediaType,
    this.town,
    this.updatedAt,
    this.updatedBy,
    this.userName,
    this.userPurpose,
    this.userType,
    this.status,
    this.postCode,
    this.trader,
    this.userLocation,
    this.traderId,
    this.phoneNumberChange,
    this.notifications,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['_id'] as String?;
    cognitoId = json['cognitoId'] as String?;
    addressLine1 = json['addressLine1'] as String?;
    avatarImage = json['avatarImage'] as String?;
    contract = json['contract'] as String?;
    createdAt = json['createdAt'] as String?;
    dateOfBirth = json['dateOfBirth'] as String?;
    email = json['email'] as String?;
    emailVerified = json['emailVerified'] as bool?;
    firstName = json['firstName'] as String?;
    gender = json['gender'] as String?;
    lastName = json['lastName'] as String?;
    notificationStatus = json['notificationStatus'] as String?;
    phone = json['phone'] as String?;
    phoneVerified = json['phoneVerified'] as bool?;
    slug = json['slug'] as String?;
    socialMediaID = json['socialMediaID'] as String?;
    socialMediaType = json['socialMediaType'] as String?;
    town = json['town'] as String?;
    updatedAt = json['updatedAt'] as String?;
    updatedBy = json['updatedBy'] as String?;
    userName = json['userName'] as String?;
    userPurpose = json['userPurpose'] as String?;
    userType = json['userType'] as String?;
    status = json['status'] as String?;
    postCode = json['postCode'] as String?;
    traderId = json['traderId'] as String?;
    userLocation = json['userLocation'] != null
        ? UserLocationModel.fromJson(
            json['userLocation'] as Map<String, dynamic>)
        : null;
    notifications = json['notificationSettings'] != null
        ? json['notificationSettings']["notifications"] as String?
        : null;
    trader = json['trader'] != null
        ? TraderModel.fromJson(json['trader'] as Map<String, dynamic>)
        : null;
    upgradeToDealer = json['upgradeToTrader'] != null
        ? UpgradeToDealer.fromJson(
            json['upgradeToTrader'] as Map<String, dynamic>)
        : null;
    phoneNumberChange = json['phoneNumberChange'] != null
        ? PhoneNumberChangeStatusModel.fromJson(
            json['phoneNumberChange'] as Map<String, dynamic>)
        : null;
  }
}
