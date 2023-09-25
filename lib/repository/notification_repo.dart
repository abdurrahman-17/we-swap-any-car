import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/locator.dart';
import '../service/firebase_service.dart';

class NotificationRepo {
  ///fetching Notification details
  Future<QuerySnapshot> getNotificationList(
      {required String userId,
      required int pageLimit,
      DocumentSnapshot? lastDoc}) async {
    return await Locator.instance.get<FirebaseService>().getNotification(
        userId: userId, pageLimit: pageLimit, lastDoc: lastDoc);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> retrieveNotificationInfo(
      {required String userId}) {
    return Locator.instance
        .get<FirebaseService>()
        .retrieveNotification(userId: userId);
  }
}
