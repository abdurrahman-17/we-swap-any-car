import "package:cloud_firestore/cloud_firestore.dart";

import 'chat_car_model.dart';
import 'chat_user_model.dart';

class ChatGroupModel {
  String? groupId;
  String? groupNameForSearch;
  String? groupAdminUserId;
  List<dynamic> groupUsers = const [];
  ChatUserModel? admin;
  ChatUserModel? receiver;
  ChatCarModel? carDetails;
  String lastMessage = "";
  bool? isChatAvailable;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String> mutedUsers = const [];
  Map<String, dynamic>? clearChat;
  Map<String, dynamic>? deleteChat;
  List<String> blockedUsers = const [];

  ChatGroupModel({
    this.groupId,
    this.groupNameForSearch,
    this.groupAdminUserId,
    this.groupUsers = const [],
    this.admin,
    this.receiver,
    this.carDetails,
    this.isChatAvailable,
    this.lastMessage = "",
    this.createdAt,
    this.updatedAt,
    this.mutedUsers = const [],
    this.clearChat,
    this.deleteChat,
    this.blockedUsers = const [],
  });

  ChatGroupModel.fromJson(Map<String, dynamic> json) {
    groupId = json["groupId"] as String?;
    groupNameForSearch = json["groupNameForSearch"] as String?;
    groupAdminUserId = json["groupAdminUserId"] as String?;
    groupUsers = [];
    for (final item in json["groupUsers"] as List) {
      groupUsers.add(item);
    }
    admin = ChatUserModel.fromJson(json["admin"] as Map<String, dynamic>);
    receiver = ChatUserModel.fromJson(json["receiver"] as Map<String, dynamic>);
    carDetails = ChatCarModel.fromJson(json["car"] as Map<String, dynamic>);
    lastMessage = json["lastMessage"] as String? ?? "";
    isChatAvailable = json["isChatAvailable"] as bool?;
    createdAt = json["createdAt"].toDate() as DateTime;
    updatedAt = json["updatedAt"].toDate() as DateTime;
    if (json['mutedUsers'] != null) {
      mutedUsers = [];
      for (final element in json["mutedUsers"] as List) {
        mutedUsers.add("$element");
      }
    }
    clearChat = json['clearChat'] as Map<String, dynamic>?;
    deleteChat = json['deleteChat'] as Map<String, dynamic>?;
    if (json['blockedUsers'] != null) {
      blockedUsers = [];
      for (final element in json["blockedUsers"] as List) {
        blockedUsers.add("$element");
      }
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "groupId": groupId,
        "groupNameForSearch": groupNameForSearch,
        "groupAdminUserId": groupAdminUserId,
        "groupUsers": groupUsers,
        "lastMessage": lastMessage,
        "isChatAvailable": isChatAvailable,
        if (admin != null) "admin": admin!.toJson(),
        if (receiver != null) "receiver": receiver!.toJson(),
        if (carDetails != null) "car": carDetails!.toJson(),
        "createdAt": Timestamp.fromDate(createdAt!),
        "updatedAt": Timestamp.fromDate(updatedAt!),
      };
}
