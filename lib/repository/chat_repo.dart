import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../core/locator.dart';
import '../model/chat_model/chat_group/chat_group_model.dart';
import '../model/chat_model/user_chat_model/user_chat_model.dart';
import '../model/error_model.dart';
import '../model/transaction/transaction_model.dart';
import '../service/firebase_service.dart';
import '../service/graphQl_service/gq_service.dart';

class ChatRepo {
  //fetching recent chats
  Stream<List<ChatGroupModel>> retrieveRecentChats({required String userId}) {
    return Locator.instance
        .get<FirebaseService>()
        .retrieveRecentChats(userId: userId);
  }

  //fetching blocked chats
  Stream<List<ChatGroupModel>> retrieveBlockedChats({required String userId}) {
    return Locator.instance
        .get<FirebaseService>()
        .retrieveBlockedChats(userId: userId);
  }

  ///fetching chat details
  Stream<QuerySnapshot<Map<String, dynamic>>> retrieveChatInfo(
      {required String groupId}) {
    return Locator.instance
        .get<FirebaseService>()
        .retrieveChatInfo(groupId: groupId);
  }

  Future<QuerySnapshot> getChats(
      {required String groupId,
      required int docLimit,
      DocumentSnapshot? lastDoc}) async {
    return Locator.instance.get<FirebaseService>().getChats(
          groupId: groupId,
          docLimit: docLimit,
          lastDoc: lastDoc,
        );
  }

  //insert chat
  Future<bool> insertChatToDb({required UserChatModel chatModel}) async {
    return Locator.instance
        .get<FirebaseService>()
        .insertQuery(chatModel: chatModel);
  }

  //update read status
  Future<void> updateChatReadStatus(
      {required String groupId,
      required String chatDocId,
      required String userId}) async {
    await Locator.instance.get<FirebaseService>().updateChatReadStatus(
          groupId: groupId,
          chatDocId: chatDocId,
          userId: userId,
        );
  }

  //update offer status
  Future<void> updateOfferStatus(
      {required String groupId,
      required String chatDocId,
      required Map<String, dynamic> data}) async {
    await Locator.instance.get<FirebaseService>().updateOfferStatus(
          groupId: groupId,
          chatDocId: chatDocId,
          data: data,
        );
  }

  ///fetching chat details
  Stream<List<UserChatModel>> getUnreadCount({
    required String groupId,
    required String userId,
  }) {
    return Locator.instance
        .get<FirebaseService>()
        .getUnreadCount(groupId: groupId, userId: userId);
  }

  //UPDATE MUTE CHAT
  Future<void> muteChat(
      {required String userId, required String groupId}) async {
    await Locator.instance
        .get<FirebaseService>()
        .updateMute(groupId: groupId, userId: userId);
  }

  //UPDATE MUTE CHAT
  Future<void> unMuteChat(
      {required String userId, required String groupId}) async {
    await Locator.instance
        .get<FirebaseService>()
        .unMuteChat(groupId: groupId, userId: userId);
  }

  //CLEAR CHAT
  Future<void> clearChat(
      {required String userId, required String groupId}) async {
    await Locator.instance
        .get<FirebaseService>()
        .clearChat(groupId: groupId, userId: userId);
  }

  //DELETE CHAT
  Future<bool> deleteChat(
      {required String userId, required String groupId}) async {
    return await Locator.instance
        .get<FirebaseService>()
        .deleteChat(groupId: groupId, userId: userId);
  }

  ///CREATE OR UPDATE CHAT GROUP
  Future<bool> createGroupOrUpdateGroup(
      {required ChatGroupModel chatGroup}) async {
    return await Locator.instance
        .get<FirebaseService>()
        .createGroupOrUpdateGroup(chatGroup: chatGroup);
  }

  //UPDATE BLOCK CHAT
  Future<bool> blockChat(
      {required String userId,
      required String groupId,
      required String oppositeUserId}) async {
    return await Locator.instance.get<FirebaseService>().blockChat(
          groupId: groupId,
          userId: userId,
          oppositeUserId: oppositeUserId,
        );
  }

  //UPDATE UNBLOCK CHAT
  Future<bool> unblockChat({
    required String userId,
    required String groupId,
    required String oppositeUserId,
  }) async {
    return await Locator.instance.get<FirebaseService>().unblockChat(
          groupId: groupId,
          userId: userId,
          oppositeUserId: oppositeUserId,
        );
  }

  //UPDATE TRANSACTION STATUS
  Future<Either<ErrorModel, TransactionModel>> updateTransactionStatus({
    required Map<String, dynamic> transactionJson,
  }) async {
    return await Locator.instance
        .get<GraphQlServices>()
        .updateTransactionStatus(transactionData: transactionJson);
  }

  //UPDATE TRANSFER SUMMARY ID
  Future<bool> updateTransferSummaryId({
    required String groupId,
    required String chatDocId,
    required String transferSummaryId,
  }) async {
    return await Locator.instance
        .get<FirebaseService>()
        .updateTransferSummaryId(
          groupId: groupId,
          chatDocId: chatDocId,
          transferSummaryId: transferSummaryId,
        );
  }

  // CREATE TRANSACTION
  Future<Either<ErrorModel, TransactionModel>> createTransaction({
    required Map<String, dynamic> transactionJson,
  }) async {
    return await Locator.instance
        .get<GraphQlServices>()
        .createTransaction(transactionData: transactionJson);
  }
}
