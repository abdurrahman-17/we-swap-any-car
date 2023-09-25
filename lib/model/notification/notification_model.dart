import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationWithLastData {
  NotificationWithLastData({
    required documentSnapshot,
    required notificationModel,
  });
  DocumentSnapshot? documentSnapshot;
  NotificationModel? notificationModel;
}

class NotificationModel {
  DateTime? createdAt;
  String? createdBy;
  bool? ifRead;
  String? message;
  DateTime? updatedAt;

  NotificationModel({
    this.createdAt,
    this.createdBy,
    this.ifRead,
    this.message,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        createdAt: json['createdAt'].toDate() as DateTime,
        createdBy: json['createdBy'] as String?,
        ifRead: json['ifRead'] as bool?,
        message: json['message'] as String?,
        updatedAt: json['updatedAt'].toDate() as DateTime,
      );

  Map<String, dynamic> toJson() => {
        'createdAt': Timestamp.fromDate(createdAt!),
        'createdBy': createdBy,
        'ifRead': ifRead,
        'message': message,
        'updatedAt': Timestamp.fromDate(updatedAt!),
      };
}
