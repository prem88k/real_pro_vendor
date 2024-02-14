import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:real_pro_vendor/Models/GetFollowerData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Constants/Colors.dart';
import '../Constants/Api.dart';


class FollowersListPage extends StatefulWidget {
  const FollowersListPage({Key? key}) : super(key: key);

  @override
  State<FollowersListPage> createState() => _FollowersListPageState();
}

class _FollowersListPageState extends State<FollowersListPage> {

  late GetFollowerData getFollowerData;
  List<FollowerList>? followerList = [];

  bool isloading = false;
  bool catloading = false;

  @override
  void initState() {
   getFollowerData = GetFollowerData();
    // TODO: implement initState
    super.initState();
    getFollower();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: primaryColor),
        bottomOpacity: 0,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Followers",
          style: TextStyle(
            color: primaryColor,
            fontSize: ScreenUtil().setWidth(20),
            fontFamily: 'work',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: followerList!.length==0?Center(
        child: Text("No Data found!", style: TextStyle(
            fontSize: ScreenUtil().setHeight(15),
        fontWeight: FontWeight.w600,
        color: primaryColor,
        fontFamily: 'work',
    ),),
      ):SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(10),
            right: ScreenUtil().setWidth(10),
            top: ScreenUtil().setHeight(15),
            bottom: ScreenUtil().setHeight(15)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                itemCount: followerList!.length,
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                itemBuilder: (context, i) {
                  return _buildProList();
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
  Widget _buildProList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getFollowerData.data?[0].image != null ?
            Container(
              child:  CircleAvatar(
                backgroundImage: NetworkImage(getFollowerData.data![0].image.toString()),
                radius: 20,
              ),
            )
            : Container(
              child:  CircleAvatar(
                backgroundImage: AssetImage("assets/images/dp.png",),
                radius: 20,
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(15),),
            Container(
              child: Text(
                 getFollowerData.data?[0].name != null ?
                 getFollowerData.data![0].name.toString()
                 : "Name",
                style: TextStyle(
                  fontSize: ScreenUtil().setHeight(15),
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                  fontFamily: 'work',
                ),
              ),
            ),
          ],
        ),
        SizedBox(height:  ScreenUtil().setHeight(10),),
        Divider(
          thickness: 0.5,
          color: lightTextColor,
        ),
        SizedBox(height:  ScreenUtil().setHeight(10),)
      ],
    );
  }
  Future<void> getFollower() async {
    followerList!.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      catloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/api/user/user_follower_list',
    );
    final headers = {'Authorization': '${prefs.getString('access_token')}'};

    Map<String, dynamic> body = {
      'user_id':prefs.getString('UserId')!,
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    Response response = await post(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("Follower Resposne::$responseBody");
    if (statusCode == 200) {
      setState(() {
        catloading = false;
      });
      if (mounted == true) {
      }
      if (getdata["status"]) {
        getFollowerData = GetFollowerData.fromJson(jsonDecode(responseBody));
        followerList!.addAll(getFollowerData.data!);
      } else {}
    }
    else
    {
      setState(() {
        catloading = false;
      });
    }
  }
}
