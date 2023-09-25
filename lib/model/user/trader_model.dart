import 'cancel_subscription.dart';
import 'subscription.dart';
import 'subscription_change_req_model.dart';
import 'upgrade_subscription.dart';
import 'user_location_model.dart';

class TraderModel {
  List<Map<String, dynamic>>? payAsYouGoList;
  String? id;
  String? addressLine1;
  String? companyContact;
  String? companyDescription;
  String? companyName;
  String? companyWebsiteUrl;
  String? email;
  String? adminUserId;
  String? logo;
  String? phone;
  int? totalCarLimit;
  int? carsListed;
  SubscriptionModel? subscription;
  SubscriptionChangeReq? traderSubscriptionChangeReq;
  UpgradeSubscription? upgradeSubscription;
  CancelSubscription? cancelSubscription;
  String? town;
  String? status;
  String? updatedAt;
  String? createdAt;
  String? updatedBy;
  UserLocationModel? userLocation;
  num? companyRating;

  TraderModel({
    this.id,
    this.addressLine1,
    this.companyContact,
    this.companyDescription,
    this.companyName,
    this.companyWebsiteUrl,
    this.email,
    this.adminUserId,
    this.logo,
    this.phone,
    this.totalCarLimit,
    this.carsListed,
    this.subscription,
    this.traderSubscriptionChangeReq,
    this.upgradeSubscription,
    this.town,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.updatedBy,
    this.userLocation,
    this.payAsYouGoList,
    this.companyRating,
  });
  TraderModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String?;
    addressLine1 = json['addressLine1'] as String?;
    companyContact = json['companyContact'] as String?;
    companyDescription = json['companyDescription'] as String?;
    companyName = json['companyName'] as String?;
    companyWebsiteUrl = json['companyWebsiteUrl'] as String?;
    email = json['email'] as String?;
    adminUserId = json['adminUserId'] as String?;
    logo = json['logo'] as String?;
    phone = json['phone'] as String?;
    totalCarLimit = json['totalCarLimit'] as int?;
    carsListed = json['carsListed'] as int?;
    status = json['status'] as String?;
    subscription = json['subscription'] != null
        ? SubscriptionModel.fromJson(
            json['subscription'] as Map<String, dynamic>)
        : null;
    traderSubscriptionChangeReq = json['subscriptionChangeReq'] != null
        ? SubscriptionChangeReq.fromJson(
            json['subscriptionChangeReq'] as Map<String, dynamic>)
        : null;
    upgradeSubscription = json['upgradeSubscription'] != null
        ? UpgradeSubscription.fromJson(
            json['upgradeSubscription'] as Map<String, dynamic>)
        : null;
    cancelSubscription = json['cancelSubscription'] != null
        ? CancelSubscription.fromJson(
            json['cancelSubscription'] as Map<String, dynamic>)
        : null;
    town = json['town'] as String?;
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
    updatedBy = json['updatedBy'] as String?;
    userLocation = json['userLocation'] != null
        ? UserLocationModel.fromJson(
            json['userLocation'] as Map<String, dynamic>)
        : null;
    if (json['payAsYouGo'] != null) {
      payAsYouGoList = [];
      for (final item in json['payAsYouGo'] as List) {
        payAsYouGoList!.add(item as Map<String, dynamic>);
      }
    }
    companyRating = json['companyRating'] as num?;
  }
}
