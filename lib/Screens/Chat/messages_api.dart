import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Constants/constants.dart';
import 'ConversationsApi.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MessagesApi {
  /// FINAL VARIABLES
  ///
  final _firestore = FirebaseFirestore.instance;
  final _conversationsApi = ConversationsApi();

  /// Get stream messages for current user
  Stream<QuerySnapshot> getMessages(String receiverId, String SenderId) {
    print("------------------------------------");
    print("senderId::$SenderId");
    print("receiverId::$receiverId");

    return _firestore
        .collection(C_MESSAGES)
        .doc(SenderId)
        .collection(receiverId)
        .orderBy(TIMESTAMP)
        .snapshots();
  }

  /// Save chat message
  Future<void> saveMessage({
     String? type,
     String ?senderId,
     String ?receiverId,
     String ?fromUserId,
     String ?userPhotoLink,
     String ?userFullName,
     String ?textMsg,
     String ?imgLink,
     bool ?isRead,
  }) async {
    print(
        "--------senderId::-----$senderId::::----------ReceiverId------$receiverId");

    /// Save message
    await _firestore
        .collection(C_MESSAGES)
        .doc(senderId)
        .collection(receiverId!)
        .doc()
        .set(<String, dynamic>{
      USER_ID: fromUserId,
      MESSAGE_TYPE: type,
      MESSAGE_TEXT: textMsg,
      MESSAGE_IMG_LINK: imgLink,
      TIMESTAMP: DateTime.now(),
    });

    /// Save last conversation
    await _conversationsApi.saveConversation(
        type: type,
        senderId: senderId,
        receiverId: receiverId,
        userPhotoLink: userPhotoLink,
        userFullName: userFullName,
        textMsg: textMsg,
        isRead: isRead);
  }

  /// Delete current user chat
  Future<void> deleteChat(String withUserId, String myId, {bool isDoubleDel = false}) async {
    /// Get Chat for current user
    ///
    print("----------withUserId----------::$withUserId");
    print("---------myId-------::$myId");
    final List<DocumentSnapshot> _messages01 = (await _firestore
        .collection(C_MESSAGES)
        .doc(withUserId)
        .collection(myId)
        .get())
        .docs;

    // Check messages sent by current user to be deleted
    if (_messages01.isNotEmpty) {
      // Loop messages to be deleted
      _messages01.forEach((msg) async {
        // Check msg type
        if (msg[MESSAGE_TYPE] == 'image' &&
            msg[USER_ID] == withUserId) {
          /// Delete uploaded images by current user
          await FirebaseStorage.instance
              .ref()
              .delete();
        }
        await msg.reference.delete();
      });

      // Delete current user conversation
      if (!isDoubleDel) {
        _conversationsApi.deleteConverce(withUserId,myId);
      }
    }

    /// Check param
    if (isDoubleDel) {
      /// Get messages sent by onother user to be deleted
      final List<DocumentSnapshot> _messages02 = (await _firestore
          .collection(C_MESSAGES)
          .doc(withUserId)
          .collection(myId)
          .get())
          .docs;

      // Check messages
      if (_messages02.isNotEmpty) {
        // Loop messages to be deleted
        _messages02.forEach((msg) async {
          // Check msg type
          if (msg[MESSAGE_TYPE] == 'image' && msg[USER_ID] == withUserId) {
            /// Delete uploaded images by onother user
            await FirebaseStorage.instance
                .ref()
                .delete();
          }
          await msg.reference.delete();
        });
      }
    }
  }
}
