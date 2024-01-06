import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Constants/constants.dart';

class ConversationsApi {
  /// Get firestore instance
  ///
  final _firestore = FirebaseFirestore.instance;

  /// Save last conversation in database
  Future<void> saveConversation({
    String ?type,
    String ?senderId,
    String ?receiverId,
    String? userPhotoLink,
    String? userFullName,
    String? textMsg,
    bool ?isRead,
  }) async {
    await _firestore
        .collection(C_CONNECTIONS)
        .doc(senderId)
        .collection(C_CONVERSATIONS)
        .doc(receiverId)
        .set(<String, dynamic>{
      USER_ID: receiverId,
      USER_PROFILE_PHOTO: userPhotoLink,
      USER_FULLNAME: userFullName,
      MESSAGE_TYPE: type,
      LAST_MESSAGE: textMsg,
      MESSAGE_READ: isRead,
      TIMESTAMP: DateTime.now(),
    }).then((value) {
      debugPrint('saveConversation() -> succes');
    }).catchError((e) {
      print('saveConversation() -> error: $e');
    });
  }

  /// Get stream conversations for current user
  Stream<QuerySnapshot> getConversations(String id) {
    print("--------ID----------::$id");
    return _firestore
        .collection(C_CONNECTIONS)
        .doc(id)
        .collection(C_CONVERSATIONS)
        .orderBy(TIMESTAMP, descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getConversations1() {
    print("--------call GetConversations----------");
    return _firestore
        .collection(C_CONNECTIONS)
        .doc("14")
        .collection(C_CONVERSATIONS)
        .orderBy(TIMESTAMP, descending: true)
        .snapshots();
  }

  /// Delete current user conversation
  Future<void> deleteConverce(String withUserId, String myId,
      {bool isDoubleDel = false}) async {
    // For current user
    await _firestore
        .collection(C_CONNECTIONS)
        .doc(myId)
        .collection(C_CONVERSATIONS)
        .doc(withUserId)
        .delete();
    // Delete the current user id from onother user conversation list
    if (isDoubleDel) {
      await _firestore
          .collection(C_CONNECTIONS)
          .doc(withUserId)
          .collection(C_CONVERSATIONS)
          .doc(myId)
          .delete();
    }
  }
}
