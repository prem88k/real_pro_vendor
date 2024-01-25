
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Constants/Colors.dart';
import '../../Constants/constants.dart';
import 'ConversationsApi.dart';
import 'chat_screen_fromConversation.dart';
import 'dialogs/no_data.dart';
import 'dialogs/processing.dart';
import 'dialogs/progress_dialog.dart';


class ConversationsTab extends StatefulWidget {
  @override
  _ConversationsTabState createState() => _ConversationsTabState();
}

class _ConversationsTabState extends State<ConversationsTab> {
  final _conversationsApi = ConversationsApi();
  SharedPreferences ?prefs;
  bool isChecked=false;
  @override
  void initState() {
    // TODO: implement initState
    getPreference();
    super.initState();
  }
  Future<void> getPreference() async {
    print("--------call Prefeernece----------");
    prefs = await SharedPreferences.getInstance();
    print("--------${prefs!.getString("UserId")}----------");
    setState(() {
      isChecked=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    /// Initialization
    final pr = ProgressDialog(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        bottomOpacity: 0,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Messages",
          style: TextStyle(
            color: secondaryColor,
            fontSize: ScreenUtil().setWidth(15),
            fontFamily: 'work',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        padding  : EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0),
        color: secondaryColor,
        child: Column(
          children: [
            isChecked? Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _conversationsApi.getConversations(prefs!.getString("UserId")??""),
                  builder: (context, snapshot) {
                    /// Check data
                    if (!snapshot.hasData) {
                      return Processing(text: "loading");
                    } else if (snapshot.data!.docs.isEmpty) {
                      /// No conversation
                      return NoData(
                          svgName: 'message_icon',
                          text: "No Conversation");
                    } else {
                      return ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => Divider(height: 1,color: appColor,),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          /// Get conversation DocumentSnapshot
                          final DocumentSnapshot conversation =
                          snapshot.data!.docs[index];

                          /// Show conversation
                          return Container(
                            margin: EdgeInsets.only(bottom: 4,top: 4),
                            padding: EdgeInsets.only(bottom: 3,top: 3),

                           /* decoration: BoxDecoration(
                              color: Color(0xECECEC),
                              border: Border.all(
                                  color: borderColors, width: 0.1, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(0),
                            ),*/
                            child: Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: borderColor,
                                    /* backgroundImage:
                                        NetworkImage(conversation[USER_PROFILE_PHOTO]),*/
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(conversation[USER_FULLNAME].split(" ")[0],
                                        style: TextStyle(
                                            fontSize: 15,color: borderColor,fontWeight: FontWeight.bold, fontFamily: 'work'),),
                                      Text("${timeago.format(conversation[TIMESTAMP].toDate())}", style: TextStyle(
                                          fontSize: 14,color: borderColor, fontFamily: 'work'))

                                    ],
                                  ),
                                  subtitle: conversation[MESSAGE_TYPE] == 'text'
                                      ? Text(
                                    "${conversation[LAST_MESSAGE]}"
                                    ,
                                    style: TextStyle(
                                        fontSize: 14,color: borderColor, fontFamily: 'work'),
                                  )
                                      : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(Icons.photo_camera,
                                          color: secondaryColor),
                                      SizedBox(width: 5),
                                      Text("photo"),
                                    ],
                                  ),
                                  trailing: !conversation[MESSAGE_READ]
                                      ? Badge(label: Text("New"))
                                      : null,
                                  onTap: () async {
                                    /// Show progress dialog
                                    pr.show("Processing");

                                    /// 1.) Set conversation read = true
                                    await conversation.reference
                                        .update({MESSAGE_READ: true});

                                    /// 2.) Get updated user info


                                    /// 3.) Get user object
                                    //     final User user = User.fromDocument(userDoc.data()!);

                                    /// Hide progrees
                                    pr.hide();

                                    /// Go to chat screen
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => ChatScreenConversation(
                                          UserId: prefs!.getString("UserId")!,
                                          user: conversation,
                                        )));
                                  },
                                ),
                                Divider(
                                  thickness: 0.3,
                                  color: lightGreyColor,),
                                SizedBox(height: ScreenUtil().setHeight(10),)
                              ],
                            ),
                          );
                        }),
                      );
                    }
                  }),
            ):CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }


}
