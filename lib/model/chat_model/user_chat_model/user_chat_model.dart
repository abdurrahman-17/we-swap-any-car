import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utility/enums.dart';
import 'payload_model.dart';

class UserChatModel {
  String? id;
  String? groupId;
  String? type;
  String? createdUserId;
  List<String> readUsers = [];
  PayloadModel? payload;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool isUploadChat = false;
  String? status;

  UserChatModel({
    this.id,
    this.groupId,
    this.type,
    this.createdUserId,
    this.readUsers = const [],
    this.payload,
    this.createdAt,
    this.updatedAt,
    this.isUploadChat = false,
    this.status,
  });

  UserChatModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] as String?;
    groupId = json["groupId"] as String?;
    type = json["type"] as String?;
    createdUserId = json["createdById"] as String?;
    if (json['readUsers'] != null) {
      for (final item in json['readUsers'] as List) {
        readUsers.add("$item");
      }
    }

    if (json['payload'] != null) {
      payload = PayloadModel.fromJson(json['payload'] as Map<String, dynamic>);
    }
    createdAt = json["createdAt"].toDate() as DateTime;
    updatedAt = json["updatedAt"].toDate() as DateTime;
    status = json["status"] as String? ?? ChatStatus.active.name;
  }
//toJson
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "groupId": groupId,
      "type": type,
      "createdById": createdUserId,
      "readUsers": readUsers,
      "payload": payload!.toJson(),
      if (payload != null) "payload": payload!.toJson(),
      "createdAt": Timestamp.fromDate(createdAt!),
      "updatedAt": Timestamp.fromDate(updatedAt!),
      "status": ChatStatus.active.name
    };
  }
}
