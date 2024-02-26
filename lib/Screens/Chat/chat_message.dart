import 'package:flutter/material.dart';

import '../../Constants/Colors.dart';

class ChatMessage extends StatelessWidget {
  // Variables
   bool? isUserSender;
   String? userPhotoLink;
   bool? isImage;
   String? imageLink;
   String? textMessage;
   String? timeAgo;

  ChatMessage(
      { this.isUserSender,
       this.userPhotoLink,
       this.timeAgo,
      this.isImage = false,
      this.imageLink,
      this.textMessage});

  @override
  Widget build(BuildContext context) {
    /// User profile photo
    final _userProfilePhoto = userPhotoLink!=null||userPhotoLink!=""?CircleAvatar(
      backgroundColor: appColor,
      backgroundImage: NetworkImage(userPhotoLink!),
    ):CircleAvatar(
      backgroundColor: appColor,
      backgroundImage: AssetImage("assets/images/user_icon.png"),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        children: <Widget>[
          /// User receiver photo Left
         // !isUserSender! ? _userProfilePhoto : Container(width: 0, height: 0),

          SizedBox(width: 10),

          /// User message
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: isUserSender!
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                /// Message container
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: !isUserSender!

                          /// Color for receiver
                          ? Color(0xffF5F6F8)

                          /// Color for sender
                          : appColor,
                      borderRadius: BorderRadius.circular(25)),
                  child: isImage!
                      ? GestureDetector(
                          onTap: () {
                            // Show full image
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                builder: (context) => _ShowFullImage(imageLink!))
                            );
                          },
                          child: Card(
                            /// Image
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            margin: const EdgeInsets.all(0),
                            color: Colors.grey.withAlpha(70),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
             /*               child: Container(
                                width: 200,
                                height: 200,
                                child: Hero(
                                  tag: imageLink,
                                  child: Image.network(imageLink))),*/
                          ),
                        )

                      /// Text message
                      : Text(
                          textMessage ?? "",
                          style: TextStyle(
                              fontFamily: 'work',
                              fontSize: 18,
                              color:
                                  isUserSender! ? Colors.white : darkTextColor),
                          textAlign: TextAlign.center,
                        ),
                ),

                SizedBox(height: 5),

                /// Message time ago
                Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(timeAgo!, style: TextStyle(
                        fontFamily: 'work',
                        fontSize: 14,
                        color: primaryTextColor))),
              ],
            ),
          ),
          SizedBox(width: 10),

          /// Current User photo right
       //   isUserSender! ? _userProfilePhoto : Container(width: 0, height: 0),
        ],
      ),
    );
  }
}

// Show chat image on full screen
class _ShowFullImage extends StatelessWidget {
  // Param
  final String imageUrl;

  _ShowFullImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}
