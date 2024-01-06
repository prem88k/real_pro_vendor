import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';

import 'AppConstants.dart';
import 'BaseService.dart';

class UserService extends BaseService {
 /* UserService() : super();*/
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  UserService() {
    ref = fireStore.collection('user_status');
    ref = fireStore.collection(USER_COLLECTION);
  }

  Future<void> updateDocument(Map<String, dynamic> data, String id) => ref!.doc(id).update(data);

}