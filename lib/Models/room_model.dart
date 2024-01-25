
import 'package:real_pro_vendor/Models/user_model.dart';

import 'group_model.dart';

class RoomModel {
  String? id;
  String? lastMessage;
  List<String>? membersId;
  List<String>? membersName;
  List<String>? membersImage;
  String? createdBy;
  String? fcmToken;
  DateTime? lastMessageTime;
  bool? isGroup;
  GroupModel? groupModel;
  UserModel? userModel;

  RoomModel(
      {this.id,
      this.lastMessage,
      this.lastMessageTime,
      this.isGroup,
      this.membersImage,
      this.membersId,
      this.fcmToken,
      this.membersName});

  factory RoomModel.fromMap(Map<String, dynamic> data) => RoomModel(
      id: data['id'],
      lastMessageTime: data['lastMessageTime'].toDate(),
      lastMessage: data['lastMessage'],
      isGroup: data['isGroup'],
      membersId: data['membersId'].cast<String>(),
      membersName: data['membersName'].cast<String>(),
      membersImage: data['membersImage'].cast<String>(),
      fcmToken: data['fcmToken']);
}
