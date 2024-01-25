import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../Constants/Api.dart';
import '../../Constants/Colors.dart';
import '../../Constants/constants.dart';
import '../../Models/GetProfile.dart';
import 'chat_message.dart';
import 'dialogs/my_circular_progress.dart';
import 'dialogs/progress_dialog.dart';
import 'image_source_sheet.dart';
import 'messages_api.dart';

class ChatScreenConversation extends StatefulWidget {
  /// Get user object
  String? UserId;
  DocumentSnapshot? user;

  ChatScreenConversation({this.UserId, this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenConversation> {
  // Variables
  late GetUserProfile getUserInformation;

  final _textController = TextEditingController();
  final _messagesController = ScrollController();
  final _messagesApi = MessagesApi();
  late Stream<QuerySnapshot> _messages;
  bool _isComposing = false;
  ProgressDialog? _pr;
  bool isLoading = true;
  bool isCHecked = false;
  bool sendMessage = false;

  void _scrollMessageList() {
    /// Scroll to button
    _messagesController.animateTo(0.0,
        duration: Duration(milliseconds: 500), curve: Curves.easeOut);
  }

  @override
  void initState() {
    super.initState();
    getCurrentProfile();
    _messages = _messagesApi.getMessages(widget.user!.id, widget.UserId!);
  }

  /// Get image from camera / gallery
  Future<void> _getImage() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => ImageSourceSheet(
              onImageSelected: (image) async {
                if (image != null) {
                  await _sendMessage(type: 'image', imgFile: image);
                  // close modal
                  Navigator.of(context).pop();
                }
              },
            ));
  }

  // Send message
  Future<void> _sendMessage({String? type, String? text, File? imgFile}) async {
    String textMsg = '';
    //String imageUrl = '';

    // Check message type
    switch (type) {
      case 'text':
        textMsg = text!;
        setState(() {
          sendMessage = true;
        });
        break;

      case 'image':
        // Show processing dialog
        _pr!.show("Sending");

        /// Upload image file
        /*     imageUrl = await UserModel().uploadFile(
            file: imgFile,
            path: 'uploads/messages',
            userId: getUserInformation?.data.id.toString() );*/

        _pr!.hide();
        setState(() {
          sendMessage = true;
        });
        break;
    }

    /// Save message for current user
    await _messagesApi.saveMessage(
        type: type,
        fromUserId: getUserInformation.user!.id.toString(),
        senderId: getUserInformation.user!.id.toString(),
        receiverId: widget.user!.id,
        userPhotoLink: widget.user![USER_PROFILE_PHOTO],
        // other user photo
        userFullName: widget.user![USER_FULLNAME],
        // other user ful name
        textMsg: textMsg,
        // imgLink: imageUrl,
        isRead: true);

    /// Save copy message for receiver
    await _messagesApi.saveMessage(
        type: type,
        fromUserId: getUserInformation.user!.id.toString(),
        senderId: widget.user![USER_ID],
        receiverId: getUserInformation.user!.id.toString(),
        userPhotoLink: widget.user![USER_PROFILE_PHOTO],
        // current user photo
        userFullName: getUserInformation.user!.name,
        // current user ful name
        textMsg: textMsg,
        //  imgLink: imageUrl,
        isRead: false);

    /// Send push notification
    /*  await _notificationsApi.sendPushNotification(
        nTitle: APP_NAME,
        nBody: '${getUserInformation?.data.name }, '
            '${_i18n.translate("sent_a_message_to_you")}',
        nType: 'message',
        nSenderId: getUserInformation?.data.name ?? "",
        nUserDeviceToken: await _getId());*/
    if (sendMessage) {
      //postMessege(textMsg);
      setState(() {
        sendMessage = false;
      });
    }
  }

  @override
  void dispose() {
    _messages.drain();
    _textController.dispose();
    _messagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Initialization
    _pr = ProgressDialog(context);

    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: appColor,
        // Show User profile info
        title: GestureDetector(
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 0),
            /*  leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.user[USER_PROFILE_PHOTO]),
            ),*/
            title: Text(widget.user![USER_FULLNAME],
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'work',
                    color: secondaryColor)),
          ),
          onTap: () {
            /// Go to profile screen
            /*Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(user: widget.user, showButtons: false)));*/
          },
        ),
        actions: <Widget>[
          /// Actions list

        ],
      ),
      body: isLoading
          ? Center(
            child: CircularProgressIndicator(
                backgroundColor: primaryColor,
              ),
          )
          : Column(
              children: <Widget>[
                /// how message list
                Expanded(child: _showMessages()),

                /// Text Composer
                Container(
                  color: appColor,
                  child: ListTile(
                      leading: IconButton(
                          icon: Icon(Icons.camera,color: secondaryColor,
                              size: 20,),
                          onPressed: () async {
                            /// Send image file
                            await _getImage();

                            /// Update scroll
                            _scrollMessageList();
                          }),
                      title: TextField(
                        controller: _textController,
                        style: TextStyle(
                            fontFamily: 'work',
                            fontSize: 15,
                            color: secondaryColor),
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                            hintText: "Type message",
                            labelStyle: TextStyle(
                                fontFamily: 'work',
                                fontSize: 15,
                                color: secondaryColor),
                            hintStyle: TextStyle(
                                fontFamily: 'work',
                                fontSize: 15,
                                color: secondaryColor),
                            border: InputBorder.none),
                        onChanged: (text) {
                          setState(() {
                            _isComposing = text.isNotEmpty;
                          });
                        },
                      ),
                      trailing: IconButton(
                          icon: Icon(Icons.send,
                              color:
                                  _isComposing ? secondaryColor : appColor),
                          onPressed: _isComposing
                              ? () async {
                                  /// Get text
                                  final text = _textController.text.trim();

                                  /// clear input text
                                  _textController.clear();
                                  setState(() {
                                    _isComposing = false;
                                  });

                                  /// Send text message
                                  await _sendMessage(type: 'text', text: text);

                                  /// Update scroll
                                  _scrollMessageList();
                                }
                              : null)),
                ),
              ],
            ),
    );
  }

  /// Build bubble message
  Widget _showMessages() {
    return StreamBuilder<QuerySnapshot>(
        stream: _messages,
        builder: (context, snapshot) {
          // Check data
          if (!snapshot.hasData)
            return MyCircularProgress();
          else {
            return ListView.builder(
                controller: _messagesController,
                reverse: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  // Get message list
                  final List<DocumentSnapshot> messages =
                      snapshot.data!.docs.reversed.toList();
                  // Get message doc map
                  final msg = messages[index].data() as Map<String, dynamic>;

                  /// Variables
                  bool isUserSender;
                  String userPhotoLink;
                  final bool isImage = msg[MESSAGE_TYPE] == 'image';
                  final String textMessage = msg[MESSAGE_TEXT];
                 // final String imageLink = msg[MESSAGE_IMG_LINK];
                  final String timeAgo =
                      timeago.format(msg[TIMESTAMP].toDate());

                  /// Check user id to get info
                  if (msg[USER_ID] == getUserInformation.user!.id.toString()) {
                    isUserSender = true;
                    userPhotoLink = '';
                  } else {
                    isUserSender = false;
                    userPhotoLink = widget.user![USER_PROFILE_PHOTO];
                  }
                  // Show chat bubble
                  return ChatMessage(
                    isUserSender: isUserSender,
                    isImage: isImage,
                    userPhotoLink: userPhotoLink,
                    textMessage: textMessage,
                  //  imageLink: imageLink,
                    timeAgo: timeAgo,
                  );
                });
          }
        });
  }

  Future<void> getCurrentProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/user_profile',
    );

    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await get(uri, headers: headers);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("PropResposne::$responseBody");
    if (statusCode == 200) {
      if (mounted == true) {
        setState(() {
          getUserInformation = GetUserProfile.fromJson(jsonDecode(responseBody));
          setState(() {
            isLoading = false;
          });

        });
      }
      if (getdata["status"]) {
      } else {}
    }
  }
}
