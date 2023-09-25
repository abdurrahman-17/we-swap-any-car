import 'car_hpi_history_check.dart';

class HpiAndMot {
  HPIHistoryCheck? historyCheck;
  String? registration;
  String? vin;
  String? keeperStartDate;
  String? firstRegisted;
  String? lastMotDate;
  num? previousOwner;
  num? numberOfKeys;
  String? onFinance;
  bool? privatePlate;
  bool? sellerKeepingPlate;
  bool? isPreOwnerNotDisclosed;

  HpiAndMot({
    this.historyCheck,
    this.registration,
    this.vin,
    this.keeperStartDate,
    this.firstRegisted,
    this.lastMotDate,
    this.previousOwner,
    this.numberOfKeys,
    this.onFinance,
    this.privatePlate,
    this.sellerKeepingPlate,
    this.isPreOwnerNotDisclosed,
  });

  HpiAndMot.fromJson(Map<String, dynamic> json) {
    if (json['historyCheck'] != null) {
      historyCheck = HPIHistoryCheck.fromJson(
          json['historyCheck'] as Map<String, dynamic>);
    }
    registration = json['registration'] as String?;
    vin = json['vin'] as String?;
    keeperStartDate = json['keeperStartDate'] as String?;
    firstRegisted = json['firstRegisted'] as String?;
    lastMotDate = json['lastMotDate'] as String?;
    previousOwner = json['previousOwner'] as num?;
    numberOfKeys = json['numberOfKeys'] as num?;
    onFinance = json['onFinance'] as String?;
    privatePlate = json['privatePlate'] as bool?;
    sellerKeepingPlate = json['sellerKeepingPlate'] as bool?;
    isPreOwnerNotDisclosed = json['isPreOwnerNotDisclosed'] as bool? ?? false;
  }

  Map<String, dynamic> toJson() => {
        'historyCheck': historyCheck != null ? historyCheck!.toJson() : null,
        'registration': registration,
        'vin': vin,
        'keeperStartDate': keeperStartDate,
        'firstRegisted': firstRegisted,
        'lastMotDate': lastMotDate,
        'previousOwner': previousOwner,
        'numberOfKeys': numberOfKeys,
        'onFinance': onFinance,
        'privatePlate': privatePlate,
        'sellerKeepingPlate': sellerKeepingPlate,
        'isPreOwnerNotDisclosed': isPreOwnerNotDisclosed ?? false,
      };
}
