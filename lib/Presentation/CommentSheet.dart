import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/Api.dart';
import '../../Constants/Colors.dart';
import '../Models/GetCommentRes.dart';
import '../Models/GetPropertyData.dart';
import '../Screens/PropertyDetailsPage.dart';
import '../Screens/SearchBarPage.dart';
import 'BottomNavigationBarVendor.dart';


class MyBottomSheet extends StatefulWidget {
  List<Comment>? comment;
  int? productId;
  String navigate;
  String?  video;
  MyBottomSheet(
    this.comment,
    this.productId, this.navigate,this.video, {
    Key? key,
  }) : super(key: key);

  show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => this,
    );
  }

  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet>
    with SingleTickerProviderStateMixin {
  String profileImage = "";
  late GetCommentRes getCommentRes;
  List<Comment>? commentList = [];
  final TextEditingController _commentController = TextEditingController();
  String? productReplyId;
  bool isReply = false;
  FocusNode ?focusNode;

  @override
  void initState() {
    // TODO: implement initState
    getPref();
    focusNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Comments",
          maxLines: 1,
          style: TextStyle(
            color: primaryColor,
            fontSize: ScreenUtil().setHeight(12),
            fontFamily: 'work',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: secondaryColor,
        elevation: 0,
        leading: GestureDetector(
            onTap: (){
              if(widget.navigate=="details")
                {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => PropertyDetailsPage(widget.productId.toString(),widget.video! )),
                  );
                }
              else if(widget.navigate=="home")
              {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => BottomNavigationBarVendor()),
                );
              }
              else if(widget.navigate=="search")
              {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => SearchPage()),
                );
              }
              else
                {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => BottomNavigationBarVendor()),
                  );
                }
         //     Navigator.pop(context, widget.productId!);
            },
            child: Icon(Icons.arrow_back_ios,color: primaryColor,size:ScreenUtil().setHeight(22))),
        iconTheme: IconThemeData(
            color: lineColor,
            size: ScreenUtil().setHeight(22) //change your color here
            ),
      ),
      body: WillPopScope(
        onWillPop: () => _onWillPop(),
        child: SingleChildScrollView(
          child: Container(
            color: secondaryColor,
            child: Column(
              children: [
                Divider(
                  height: 0.1,
                  color: borderColor,
                ),
                Column(
                  children: [
                    _buildCommentList(widget.comment),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          profileImage == ""
                              ? CircleAvatar(
                                  backgroundImage: AssetImage(
                                    "assets/images/user_icon.png",
                                  ),
                                  radius: ScreenUtil().setWidth(20),
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    profileImage,
                                  ),
                                  radius: ScreenUtil().setWidth(20),
                                ),
                          SizedBox(
                            width: ScreenUtil().setWidth(10),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(275),
                            height: ScreenUtil().setHeight(35),
                            child: TextFormField(
                              focusNode: focusNode,
                              controller: _commentController,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setWidth(12.5),
                                  color: darkTextColor,
                                  fontFamily: 'work',
                                  fontWeight: FontWeight.w800),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: lineColor,
                                    width: 0.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(20)),
                                  borderSide: BorderSide(
                                    color: lineColor,
                                    width: 0.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: lineColor, width: 0.5),
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(20)),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    _sendComment();
                                  },
                                  child: Icon(
                                    Icons.send,
                                    color: appColor,
                                  ),
                                ),
                                hintText: 'Enter a Comment',
                                hintStyle: TextStyle(
                                    fontSize: ScreenUtil().setWidth(12.5),
                                    color: darkTextColor,
                                    fontFamily: 'work',
                                    fontWeight: FontWeight.w800),
                                contentPadding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(20),
                                    top: ScreenUtil().setHeight(20)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentList(List<Comment>? comment) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: ScreenUtil().screenHeight - ScreenUtil().setHeight(150),
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
            child: ListView.builder(
              itemCount: comment!.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              itemBuilder: (context, i) {
                return comment.length == 0
                    ? Center(
                        child: Text(
                        "No Comments",
                        style: TextStyle(
                            fontFamily: 'workdark',
                            fontSize: ScreenUtil().setHeight(12),
                            fontWeight: FontWeight.normal,
                            color: primaryColor),
                      ))
                    : Container(
                        width: ScreenUtil().setWidth(300),
                        padding: EdgeInsets.all(8),
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                comment[i].userLogo != null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          comment[i].userLogo!,
                                        ),
                                        radius: ScreenUtil().setWidth(15),
                                      )
                                    : CircleAvatar(
                                        backgroundImage: AssetImage(
                                          "assets/images/user_icon.png",
                                        ),
                                        radius: ScreenUtil().setWidth(15),
                                      ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(10),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: ScreenUtil().setWidth(250),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                comment[i].name!,
                                                style: TextStyle(
                                                    fontFamily: 'work',
                                                    fontSize: ScreenUtil()
                                                        .setHeight(13),
                                                    fontWeight:
                                                        FontWeight.w800,
                                                    color: primaryColor),
                                              ),
                                              SizedBox(
                                                width: ScreenUtil().setWidth(5),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 1.0),
                                                child: Text(
                                                  convertToAgo(
                                                      comment[i].createdAt!),
                                                  style: TextStyle(
                                                      fontFamily: 'work',
                                                      fontSize: ScreenUtil()
                                                          .setHeight(10),
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: primaryColor),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: ScreenUtil().setHeight(7),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                comment[i].comment!,
                                                style: TextStyle(
                                                    fontFamily: 'work',
                                                    fontSize: ScreenUtil()
                                                        .setHeight(11),
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: lineColor),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: ScreenUtil().setHeight(7),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isReply = true;
                                                productReplyId =
                                                    comment[i].id.toString();

                                              });
                                              showKeyboard();

                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Reply",
                                                  style: TextStyle(
                                                      fontFamily: 'workdark',
                                                      fontSize: ScreenUtil()
                                                          .setHeight(9),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: lightTextColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil().setHeight(5),
                                          ),


                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                Column(

                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          isCommentLiked(
                                              comment[i].id, comment[i]);
                                        },
                                        child: Icon(
                                          comment[i].liked == 0
                                              ? Icons.favorite_outline_sharp
                                              : Icons.favorite,
                                          color: comment[i].liked == 0
                                              ? borderColor
                                              : Colors.red,
                                        ),),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(4),
                                    ),
                                    Text(
                                      comment[i]
                                          .countCommentLike
                                          .toString(),
                                      style: TextStyle(
                                          fontFamily: 'work',
                                          fontSize:
                                          ScreenUtil().setHeight(10),
                                          letterSpacing: 0.7,
                                          fontWeight: FontWeight.normal,
                                          color: primaryColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 0),
                              child: ListView.builder(
                                itemCount: comment[i].commentReply!.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.all(0),
                                itemBuilder: (context, i1) {
                                  return comment[i].commentReply!.length == 0
                                      ? Container()
                                      : Container(
                                    width: ScreenUtil().setWidth(250),
                                    padding: EdgeInsets.all(8),
                                    margin:
                                    EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                                    child: Column(
                                      children: [
                                        Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            comment[i].commentReply![i1].userLogo != null
                                                ? CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                comment[i].commentReply![i1].userLogo!,
                                              ),
                                              radius: ScreenUtil().setWidth(13),
                                            )
                                                : CircleAvatar(
                                              backgroundImage: AssetImage(
                                                "assets/images/user_icon.png",
                                              ),
                                              radius: ScreenUtil().setWidth(13),
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setWidth(10),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  width: ScreenUtil().setWidth(250)- ScreenUtil().setWidth(18),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            comment[i].commentReply![i1].name.toString(),
                                                            style: TextStyle(
                                                                fontFamily: 'work',
                                                                fontSize: ScreenUtil()
                                                                    .setHeight(13),
                                                                fontWeight:
                                                                FontWeight.w800,
                                                                color: primaryColor),
                                                          ),
                                                          SizedBox(
                                                            width: ScreenUtil().setWidth(5),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(
                                                                bottom: 1.0),
                                                            child: Text(
                                                              convertToAgo(
                                                                  comment[i].commentReply![i1].createdAt!),
                                                              style: TextStyle(
                                                                  fontFamily: 'work',
                                                                  fontSize: ScreenUtil()
                                                                      .setHeight(10),
                                                                  fontWeight:
                                                                  FontWeight.normal,
                                                                  color: primaryColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: ScreenUtil().setHeight(7),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            comment[i].commentReply![i1].comment!,
                                                            style: TextStyle(
                                                                fontFamily: 'work',
                                                                fontSize: ScreenUtil()
                                                                    .setHeight(11),
                                                                fontWeight:
                                                                FontWeight.w600,
                                                                color: lineColor),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: ScreenUtil().setHeight(7),
                                                      ),
                                                    /*  GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            isReply = true;
                                                            productReplyId =
                                                                comment[i].id.toString();
                                                          });
                                                          showKeyboard();

                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "Reply",
                                                              style: TextStyle(
                                                                  fontFamily: 'workdark',
                                                                  fontSize: ScreenUtil()
                                                                      .setHeight(9),
                                                                  fontWeight:
                                                                  FontWeight.w600,
                                                                  color: lightTextColor),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: ScreenUtil().setHeight(7),
                                                      ),*/
                                                      Divider(height: 0.2,color: backgroundColor,),

                                                    ],
                                                  ),
                                                ),
                                        /*        Column(
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          *//*isCommentLiked(
                                                                            comment[i].commentReply![i1].id, comment[i]);*//*
                                                        },
                                                        child: Icon(
                                                          *//*comment[i].commentReply![i1].liked == 0
                                                                            ? Icons.favorite_border
                                                                            : *//*Icons.favorite,
                                                          color: *//*comment[i].liked == 0
                                                                            ? primaryColor
                                                                            : *//*Colors.red,
                                                        )),
                                                    SizedBox(
                                                      height: ScreenUtil().setHeight(4),
                                                    ),
                                                    Text(
                                                      *//* comment[i].commentReply![i1]
                                                                        .countCommentLike
                                                                        .toString()*//*"1",
                                                      style: TextStyle(
                                                          fontFamily: 'work',
                                                          fontSize:
                                                          ScreenUtil().setHeight(10),
                                                          letterSpacing: 0.7,
                                                          fontWeight: FontWeight.normal,
                                                          color: primaryColor),
                                                    ),
                                                  ],
                                                )*/
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> isCommentLiked(int? id, Comment commentList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var uri = Uri.https(
      apiBaseUrl,
      '/api/user/comment_like',
    );
    Map<String, dynamic> body = {
      'comment_id': id.toString(),
    };
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await post(uri, headers: headers, body: body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("commentLikeResponse::$responseBody");
    if (statusCode == 200) {
      if (mounted == true) {
        setState(() {
          if (commentList.liked == 1) {
            commentList.liked = 0;
            commentList.countCommentLike = commentList.countCommentLike! - 1;
          } else {
            commentList.liked = 1;
            commentList.countCommentLike = commentList.countCommentLike! + 1;
          }
        });
      }
      if (getdata["status"]) {
      } else {}
    }
  }

  String convertToAgo(String dateTime) {
    DateTime input =
        DateFormat('yyyy-MM-DDTHH:mm:ss.SSSSSSZ').parse(dateTime, true);
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays} d';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} h ';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} m ';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} second';
    } else {
      return 'just now';
    }
  }

  Future<void> getPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImage = prefs.getString("profileImage") != null
          ? prefs.getString("profileImage")!
          : "";
    });
  }

  Future<void> _sendComment() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uri = Uri.https(
      apiBaseUrl,
      isReply ? '/api/user/add_comment_reply':'/api/user/add_comment',
    );
    Map<String, dynamic> body = {
      'product_id': widget.productId.toString(),
      'comment': _commentController.text,
    };
    Map<String, dynamic> bodyReply = {
      'comment_id': productReplyId,
      'comment': _commentController.text,
    };
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response =
        await post(uri, headers: headers, body: isReply ? bodyReply : body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("commentAddResponse::$responseBody");
    if (statusCode == 200) {
      if (getdata["status"]) {
        getComment();
      } else {}
    }
  }

  Future<void> getComment() async {
    widget.comment!.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var uri = Uri.https(
      apiBaseUrl,
      '/api/user/get_comment',
    );
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Map<String, dynamic> body = {
      'product_id': widget.productId.toString(),
    };
    Response response = await post(uri,headers: headers, body: body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("commentRes::$responseBody");
    if (statusCode == 200) {
      setState(() {
        isReply = false;
      });
      if (mounted == true) {
        if (getdata["status"]) {
          getCommentRes = GetCommentRes.fromJson(jsonDecode(responseBody));
          commentList!.addAll(getCommentRes.data!);
          setState(() {
            widget.comment = commentList;
          });
          FocusScope.of(context).unfocus();
          _commentController.clear();
        } else {}
      }
    } else {
      setState(() {});
    }
  }
  void showKeyboard() {
    focusNode!.requestFocus();
  }

  _onWillPop() {
      if(widget.navigate=="details")
      {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => PropertyDetailsPage(widget.productId.toString(),widget.video! )),
        );
      }
      else if(widget.navigate=="home")
      {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => BottomNavigationBarVendor()),
        );
      }
      else if(widget.navigate=="search")
      {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => SearchPage()),
        );
      }
      else
      {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => BottomNavigationBarVendor()),
        );
      }
      //     Navigator.pop(context, widget.productId!);

  }
}
