// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wsac/model/payment/payment_status_response_model.dart';
import '../model/chat_model/chat_group/chat_group_model.dart';
import '../model/chat_model/user_chat_model/user_chat_model.dart';
import '../utility/common_keys.dart';
import '../utility/date_time_utils.dart';

class FirebaseService {
  FirebaseService({required this.firestore});

  final FirebaseFirestore firestore;

  ///fetching recent chat groups
  Stream<List<ChatGroupModel>> retrieveRecentChats({required String userId}) {
    var result = firestore
        .collection(chatInfo)
        .where('groupUsers', arrayContains: userId)
        .where('isChatAvailable', isEqualTo: true)
        .orderBy("updatedAt", descending: true)
        .snapshots()
        .map(
      (snapShot) {
        //removing blocked chats
        List<ChatGroupModel> tempList = [];
        for (final doc in snapShot.docs) {
          final item = ChatGroupModel.fromJson(doc.data());
          if (item.blockedUsers.isEmpty ||
              (item.blockedUsers.isNotEmpty &&
                  !item.blockedUsers.contains(userId))) {
            tempList.add(item);
          }
        }
        return tempList;
      },
    );
    log(result.toString());
    return result;
  }

  ///fetching blocked chat groups
  Stream<List<ChatGroupModel>> retrieveBlockedChats({required String userId}) {
    var result = firestore
        .collection(chatInfo)
        .where('blockedUsers', arrayContains: userId)
        .where('isChatAvailable', isEqualTo: true)
        .orderBy("updatedAt", descending: true)
        .snapshots()
        .map(
          (snapShot) => snapShot.docs
              .map((doc) => ChatGroupModel.fromJson(doc.data()))
              .toList(),
        );
    log(result.toString());
    return result;
  }

  ///creating new chat group
  Future<bool> createChatGroup({required ChatGroupModel chatGroup}) async {
    try {
      await firestore
          .collection(chatInfo)
          .doc(chatGroup.groupId)
          .set(chatGroup.toJson());

      return true;
    } on Exception catch (e) {
      log("createChatGroup:$e");
      return false;
    }
  }

  ///check whether the chatGroup exist or not
  ///based on that calling createChatGroup function
  Future<bool> createGroupOrUpdateGroup(
      {required ChatGroupModel chatGroup}) async {
    try {
      final result =
          await firestore.collection(chatInfo).doc(chatGroup.groupId).get();
      if (result.exists) {
        return true;
      } else {
        return await createChatGroup(chatGroup: chatGroup);
      }
    } catch (e) {
      log("createGroupOrUpdateGroup:$e");
      return false;
    }
  }

  ///fetching chat details
  Stream<QuerySnapshot<Map<String, dynamic>>> retrieveChatInfo(
      {required String groupId}) {
    return firestore
        .collection(chatInfo)
        .doc(groupId)
        .collection(chats)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Future<QuerySnapshot> getChats(
      {required String groupId,
      required int docLimit,
      DocumentSnapshot? lastDoc}) async {
    QuerySnapshot querySnapshot;
    final CollectionReference collectionReference =
        firestore.collection(chatInfo).doc(groupId).collection(chats);
    if (lastDoc == null) {
      querySnapshot = await collectionReference
          .orderBy("createdAt", descending: true)
          .limit(docLimit)
          .get();
    } else {
      querySnapshot = await collectionReference
          .orderBy("createdAt", descending: true)
          .limit(docLimit)
          .startAfterDocument(lastDoc)
          .get();
    }

    return querySnapshot;
  }

  ///updating read status to a particular chat
  Future<void> updateChatReadStatus(
      {required String groupId,
      required String chatDocId,
      required String userId}) async {
    try {
      await firestore
          .collection(chatInfo)
          .doc(groupId)
          .collection(chats)
          .doc(chatDocId)
          .update({
        "readUsers": FieldValue.arrayUnion([userId]),
        "updatedAt": getCurrentTimeStamp()
      });
    } catch (e) {
      log("updateChatReadStatus:$e");
    }
  }

  //update particular offer status
  Future<void> updateOfferStatus(
      {required String groupId,
      required String chatDocId,
      required Map<String, dynamic> data}) async {
    try {
      await firestore
          .collection(chatInfo)
          .doc(groupId)
          .collection(chats)
          .doc(chatDocId)
          .update(data);
    } catch (e) {
      log("updateOfferStatus:$e");
    }
  }

  ///insert chat item
  Future<bool> insertQuery({required UserChatModel chatModel}) async {
    try {
      await firestore
          .collection(chatInfo)
          .doc(chatModel.groupId)
          .collection(chats)
          .doc(chatModel.id)
          .set(chatModel.toJson());

      await firestore.collection(chatInfo).doc(chatModel.groupId).update({
        'updatedAt': getCurrentTimeStamp(),
        'lastMessage': chatModel.payload?.messageModel?.message ?? '',
        'isChatAvailable': true
      });

      return true;
    } catch (e) {
      log("insertQuery:$e");
      return false;
    }
  }

  ///fetching chat details
  Stream<List<UserChatModel>> getUnreadCount({
    required String groupId,
    required String userId,
  }) {
    return firestore
        .collection(chatInfo)
        .doc(groupId)
        .collection(chats)
        .where("createdById", isNotEqualTo: userId)
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((doc) => UserChatModel.fromJson(doc.data()))
            .toList());
  }

  ///update mute chat
  Future<void> updateMute({
    required String groupId,
    required String userId,
  }) async {
    await firestore.collection(chatInfo).doc(groupId).update({
      "mutedUsers": FieldValue.arrayUnion([userId])
    });
  }

  ///update un mute chat
  Future<void> unMuteChat({
    required String groupId,
    required String userId,
  }) async {
    await firestore.collection(chatInfo).doc(groupId).update({
      "mutedUsers": FieldValue.arrayRemove([userId])
    });
  }

  ///update clear chat
  Future<void> clearChat({
    required String groupId,
    required String userId,
  }) async {
    await firestore.collection(chatInfo).doc(groupId).update(
      {"clearChat.$userId": getCurrentTimeStamp()},
    );
  }

  ///update delete chat
  Future<bool> deleteChat({
    required String groupId,
    required String userId,
  }) async {
    try {
      return await firestore
          .collection(chatInfo)
          .doc(groupId)
          .update({"deleteChat.$userId": getCurrentTimeStamp()})
          .then((value) => true)
          .onError((error, stackTrace) => false);
    } catch (e) {
      log("deleteChat:$e");
      return false;
    }
  }

  ///fetching notification
  Future<QuerySnapshot> getNotification(
      {required String userId,
      required int pageLimit,
      DocumentSnapshot? lastDoc}) async {
    final CollectionReference collectionReference = firestore
        .collection(notificationUserKey)
        .doc(userId)
        .collection(notificationListKey);
    QuerySnapshot querySnapshot;
    lastDoc == null
        ? querySnapshot = await collectionReference
            .orderBy("createdAt", descending: true)
            .limit(pageLimit)
            .get()
        : querySnapshot = await collectionReference
            .orderBy("createdAt", descending: true)
            .limit(pageLimit)
            .startAfterDocument(lastDoc)
            .get();
    return querySnapshot;
  }

  ///update block chat
  Future<bool> blockChat({
    required String groupId,
    required String userId,
    required String oppositeUserId,
  }) async {
    try {
      final groups = await firestore
          .collection(chatInfo)
          .where('groupUsers', arrayContains: userId)
          .where('isChatAvailable', isEqualTo: true)
          .get();
      for (var element in groups.docs) {
        if ((element.data()['groupUsers'] as List).contains(oppositeUserId)) {
          //single group block
          await firestore
              .collection(chatInfo)
              .doc(element.id)
              .update({
                "blockedUsers": FieldValue.arrayUnion([userId])
              })
              .then((value) => true)
              .onError((error, stackTrace) => false);
        }
      }
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  ///update unblock chat
  Future<bool> unblockChat({
    required String groupId,
    required String userId,
    required String oppositeUserId,
  }) async {
    try {
      final groups = await firestore
          .collection(chatInfo)
          .where('blockedUsers', arrayContains: userId)
          .where('isChatAvailable', isEqualTo: true)
          .get();
      for (var element in groups.docs) {
        if ((element.data()['groupUsers'] as List).contains(oppositeUserId)) {
          //single group block
          await firestore
              .collection(chatInfo)
              .doc(element.id)
              .update({
                "blockedUsers": FieldValue.arrayRemove([userId]),
              })
              .then((value) => true)
              .onError((error, stackTrace) => false);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  ///listening to new notifications
  Stream<QuerySnapshot<Map<String, dynamic>>> retrieveNotification(
      {required String userId}) {
    return firestore
        .collection(notificationUserKey)
        .doc(userId)
        .collection(notificationListKey)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  ///update Transfer SummaryId
  Future<bool> updateTransferSummaryId({
    required String groupId,
    required String chatDocId,
    required String transferSummaryId,
  }) async {
    try {
      try {
        final data = {
          "payload.offer.transferSummaryId": transferSummaryId,
          "updatedAt": getCurrentTimeStamp(),
        };
        await firestore
            .collection(chatInfo)
            .doc(groupId)
            .collection(chats)
            .doc(chatDocId)
            .update(data);

        return true;
      } catch (e) {
        log("insertQuery:$e");
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  ///get payment statuses
  Stream<PaymentStatusResponseModel> checkPaymentStatus(String transactionId) =>
      firestore.collection(paymentStatuses).doc(transactionId).snapshots().map(
          (doc) => PaymentStatusResponseModel.fromJson(
              doc.data() as Map<String, dynamic>));
}
