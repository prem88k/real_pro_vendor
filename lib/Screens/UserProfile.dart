import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Constants/Api.dart';
import '../Constants/Colors.dart';
import '../Models/GetCaategoryData.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:readmore/readmore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Models/GetProfileData.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final TextEditingController _searchController = TextEditingController();
  late GecategoryData gecategoryData;
  List<CategoryList>? catList = [];
  bool isloading = false;
  bool catloading = false;
  int? selectedIndex = -1;
  late GetProfileData getProfileData;
  List<PostList>? postList = [];

  @override
  void initState() {
    getCategory();
    getProfileData = GetProfileData();
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    getProfile();
  }

  @override
  void dispose() {
    super.dispose();
    tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body:  isloading || catloading
          ? Center(
          child: CircularProgressIndicator(
            color: appColor,
          ))
          :  SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(10),
            right: ScreenUtil().setWidth(10),
            top: ScreenUtil().setHeight(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getProfileData.user?.image != null ?
                  CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(getProfileData.user!.image.toString()) ,radius: 40,)
                 : CircleAvatar(
                    backgroundImage:AssetImage("assets/images/dp.png",),
                    radius: 40,
                  ),
                  Container(
                    width: ScreenUtil().setWidth(180),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                getProfileData.like != null ?
                                getProfileData.like.toString()
                                : '56',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setHeight(16),
                                  fontWeight: FontWeight.w400,
                                  color: primaryColor,
                                  fontFamily: 'work',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(4),
                            ),
                            Container(
                              child: Text(
                                'Likes',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setHeight(12),
                                  fontWeight: FontWeight.w400,
                                  color: lightTextColor,
                                  fontFamily: 'work',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(4),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                '14',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setHeight(16),
                                  fontWeight: FontWeight.w400,
                                  color: primaryColor,
                                  fontFamily: 'work',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(4),
                            ),

                            Container(
                              child: Text(
                                'Followers',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setHeight(12),
                                  fontWeight: FontWeight.w400,
                                  color: lightTextColor,
                                  fontFamily: 'work',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(4),
                        ),
                        CircleAvatar(
                          backgroundColor: secondaryColor,
                          radius: ScreenUtil().setWidth(20),
                          child: Icon(
                            Icons.share_outlined,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: ScreenUtil().setWidth(140),
                        child: Text(
                          getProfileData.user?.name != null ?
                          getProfileData.user!.name.toString()  : "Real Estate",
                          style: TextStyle(
                            fontSize: ScreenUtil().setHeight(20),
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                            fontFamily: 'work',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(4),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(140),
                        child: Text(
                          getProfileData.user?.uid != null ?
                          getProfileData.user!.uid.toString()  : "UID: 9876543210",
                          style: TextStyle(
                            fontSize: ScreenUtil().setHeight(12),
                            fontWeight: FontWeight.w400,
                            color: lightTextColor,
                            fontFamily: 'work',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(14),
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      width: ScreenUtil().setWidth(335),
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Eget blandit euismod netus ornare.',
                        style: TextStyle(
                          fontSize: ScreenUtil().setHeight(12),
                          fontWeight: FontWeight.w400,
                          color: lightTextColor,
                          fontFamily: 'work',
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: lightTextColor,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: ScreenUtil().setHeight(44),
                        width: ScreenUtil().setWidth(225),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: primaryColor)),
                        child: Center(
                          child: Text(
                            'Follow',
                            style: TextStyle(
                              fontSize: ScreenUtil().setHeight(14),
                              fontWeight: FontWeight.w400,
                              color: primaryColor,
                              fontFamily: 'work',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(44),
                        width: ScreenUtil().setWidth(105),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: appColor,
                            border: Border.all(color: Colors.transparent)),
                        child: Center(
                          child: Image(
                            image: AssetImage("assets/images/send.png"),
                            height: ScreenUtil().setHeight(25),
                            color: secondaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(5),
              ),
              Container(
                decoration: BoxDecoration(color: Color(0xffEFEFEF)),
                child: TabBar(
                  controller: tabController,
                  labelColor: primaryColor,
                  unselectedLabelColor: primaryColor,
                  indicatorColor: primaryColor,
                  labelStyle: TextStyle(
                      fontFamily: "Proxima",
                      fontSize: ScreenUtil().setHeight(12),
                      fontWeight: FontWeight.w600),
                  unselectedLabelStyle: TextStyle(
                      fontFamily: "Proxima",
                      fontSize: ScreenUtil().setHeight(12),
                      fontWeight: FontWeight.w400),
                  tabs: [
                    Container(
                        alignment: Alignment.center,
                        child: Tab(
                          text: 'Properties',
                        )),
                    Container(
                        alignment: Alignment.center,
                        child: Tab(
                          text: 'Company Details',
                        )),
                    Container(
                        alignment: Alignment.center,
                        child: Tab(
                          text: 'Agent Details',
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(0),
              ),
              Expanded(
                child: TabBarView(controller: tabController, children: <Widget>[
                  propertyWidget(),
                  companyWidget(),
                  agentWidget(),
                ]),
              ),
              // Profile image
            ],
          ),
        ),
      ),
    );
  }

  propertyWidget() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: ScreenUtil().setHeight(45),
                  width: ScreenUtil().setWidth(335),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: secondaryColor,
                  ),
                  child: TextFormField(
                    controller: _searchController,
                    keyboardType: TextInputType.text,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(
                        fontFamily: 'work',
                        fontSize: ScreenUtil().setHeight(12),
                        fontWeight: FontWeight.normal,
                        color: primaryColor),
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        color: appColor,
                      ),
                      hintText: 'Start Typing',
                      hintStyle: TextStyle(
                          fontFamily: 'work',
                          fontSize: ScreenUtil().setHeight(12),
                          fontWeight: FontWeight.normal,
                          color: primaryColor),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: secondaryColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: secondaryColor,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: secondaryColor, width: 1.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      contentPadding: EdgeInsets.only(left: 30),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            _buildCatList(),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Container(
              child: GridView.builder(
                shrinkWrap: true,
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                //    scrollDirection: Axis.vertical,
                itemCount: postList!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (BuildContext context, i) {
                  return _buildPostList(i);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostList(int i) {
    return Container(
      child: Column(
        children: [
          Container(
            height: ScreenUtil().setHeight(150),
            width: ScreenUtil().setWidth(200),
            child: GestureDetector(
              onTap: () {},
              child: Card(
                semanticContainer: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration:  postList![i].images != null
                          ? BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                postList![i].images.toString()),
                            fit: BoxFit.cover),
                        border: Border.all(color: secondaryColor, width: 0.2),
                      )
                          : BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/bg_image.png'),
                            fit: BoxFit.fill),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(5),
                            right: ScreenUtil().setWidth(5)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                postList![i].price != null
                                    ? postList![i].price.toString()
                                    : "AED 155,000",
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: ScreenUtil().setHeight(12),
                                    fontFamily: 'work',
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(5),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: ScreenUtil().setWidth(150),
                                    // padding: EdgeInsets.only(bottom: 13),
                                    child: Text(
                                      postList![i].propertyName != null
                                          ? postList![i].propertyName.toString()
                                          : "Villa",
                                      /*'For Rent: Villa in Al Majra, '
                                      'Downtown Dubai, Dubai',*/
                                      style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: ScreenUtil().setHeight(10),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'work',
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(5),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  companyWidget() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),

          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffEFEFEF)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                         child: Image(image: AssetImage("assets/images/bg_image.png"),
                             height: ScreenUtil().setHeight(85),
                             width: ScreenUtil().setWidth(105),
                            fit: BoxFit.cover,
                         ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(15),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: ScreenUtil().setWidth(200),
                              child: Text(
                                'REAL ESTATE AGENCY',
                                style: TextStyle(
                                  fontSize:
                                  ScreenUtil().setHeight(12),
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                  fontFamily: 'work',),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(5),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(200),
                              child: Text(
                                'Capital Tower, 401, Floor 4, Business Bay, Dubai',
                                style: TextStyle(
                                  fontSize:
                                  ScreenUtil().setHeight(12),
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                  fontFamily: 'work',),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(5),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(200),
                              child: Text(
                                'ORN: 1234',
                                style: TextStyle(
                                  fontSize:
                                  ScreenUtil().setHeight(12),
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                  fontFamily: 'work',),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    ReadMoreText(
                      "Ryan is a seasoned professional in the world of real estate, "
                          "encompassing eight years in the vibrant UAE market and "
                          "four years in the UK. In 2017, Ryan made a significant move "
                          "to Dubai, where he dedicated his ",
                      style: TextStyle(
                          fontSize: ScreenUtil().setWidth(12),
                          color: Color(0xff979797),
                          fontFamily: 'work',
                          fontWeight: FontWeight.w400),
                      trimLines: 3,
                      colorClickableText: primaryColor,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'more',
                      trimExpandedText: '...less',
                      lessStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'work',
                      ),
                      moreStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'work',
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                  ],
                ),
              )
          ),

          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),

          Text(
            'Listed Properties',
            style: TextStyle(
              fontSize: ScreenUtil().setHeight(14),
              fontWeight: FontWeight.w600,
              color: primaryColor,
              fontFamily: 'work',
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          Container(
            child: GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              //    scrollDirection: Axis.vertical,
              itemCount: postList!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, i) {
                return _buildPostList(i);
              },
            ),
          ),
        ],
      ),
    );
  }

  agentWidget() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),

          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffEFEFEF)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Container(
                      child: Text(
                        'About Me',
                        style: TextStyle(
                          fontSize:
                          ScreenUtil().setHeight(14),
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                          fontFamily: 'work',),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    ReadMoreText(
                      "Ryan is a seasoned professional in the world of real estate, "
                          "encompassing eight years in the vibrant UAE market and "
                          "four years in the UK. In 2017, Ryan made a significant move "
                          "to Dubai, where he dedicated his ",
                      style: TextStyle(
                          fontSize: ScreenUtil().setWidth(12),
                          color: Color(0xff979797),
                          fontFamily: 'work',
                          fontWeight: FontWeight.w400),
                      trimLines: 3,
                      colorClickableText: primaryColor,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'more',
                      trimExpandedText: '...less',
                      lessStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'work',
                      ),
                      moreStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'work',
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                  ],
                ),
              )
          ),

          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),

          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffEFEFEF)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: ScreenUtil().setHeight(5),
                    ),
                    Container(
                      child: Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize:
                          ScreenUtil().setHeight(14),
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                          fontFamily: 'work',),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(130),
                          child: Text(
                            'Nationality :',
                            style: TextStyle(
                              fontSize:
                              ScreenUtil().setHeight(12),
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontFamily: 'work',),
                          ),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(175),
                          child: Text(
                            'United Kingdom',
                            style: TextStyle(
                              fontSize:
                              ScreenUtil().setHeight(12),
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontFamily: 'work',),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(3),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(130),
                          child: Text(
                            'Languages :',
                            style: TextStyle(
                              fontSize:
                              ScreenUtil().setHeight(12),
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontFamily: 'work',),
                          ),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(175),
                          child: Text(
                            'English',
                            style: TextStyle(
                              fontSize:
                              ScreenUtil().setHeight(12),
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontFamily: 'work',),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(3),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(130),
                          child: Text(
                            'BRN# :',
                            style: TextStyle(
                              fontSize:
                              ScreenUtil().setHeight(12),
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontFamily: 'work',),
                          ),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(175),
                          child: Text(
                            '40002',
                            style: TextStyle(
                              fontSize:
                              ScreenUtil().setHeight(12),
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontFamily: 'work',),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(3),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(130),
                          child: Text(
                            'Experience Since :',
                            style: TextStyle(
                              fontSize:
                              ScreenUtil().setHeight(12),
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontFamily: 'work',),
                          ),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(175),
                          child: Text(
                            '2014',
                            style: TextStyle(
                              fontSize:
                              ScreenUtil().setHeight(12),
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontFamily: 'work',),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(3),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(130),
                          child: Text(
                            'Areas :',
                            style: TextStyle(
                              fontSize:
                              ScreenUtil().setHeight(12),
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontFamily: 'work',),
                          ),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(175),
                          child: Text(
                            'Al Barari',
                            style: TextStyle(
                              fontSize:
                              ScreenUtil().setHeight(12),
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontFamily: 'work',),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                  ],
                ),
              )
          ),

          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          Text(
            'Listed Properties',
            style: TextStyle(
              fontSize: ScreenUtil().setHeight(14),
              fontWeight: FontWeight.w600,
              color: primaryColor,
              fontFamily: 'work',
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          Container(
            child: GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              //    scrollDirection: Axis.vertical,
              itemCount: postList!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, i) {
                return _buildPostList(i);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatList() {
    return Container(
      alignment: Alignment.centerLeft,
      height: ScreenUtil().setHeight(25),
      child: ListView.builder(
        itemCount: catList!.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return _buildList(i);
        },
      ),
    );
  }

  Widget _buildList(int i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = i;
        });
        /* getPropertyAPI(catList![i].id.toString());*/
      },
      child: Container(
        margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
        padding: EdgeInsets.only(
            right: ScreenUtil().setWidth(14), left: ScreenUtil().setWidth(14)),
        height: ScreenUtil().setHeight(14),
        decoration: BoxDecoration(
            border: Border.all(
                color: selectedIndex == i ? appColor : borderColor, width: 0.2),
            color: selectedIndex == i ? secondaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(5.0)),
        child: Center(
          child: Text(
            catList![i].name!,
            style: TextStyle(
              color: selectedIndex == i ? lineColor : darkTextColor,
              fontSize: ScreenUtil().setWidth(13),
              fontFamily: 'work',
              fontWeight:
                  selectedIndex == i ? FontWeight.w800 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getCategory() async {
    catList!.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      catloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/getcategory',
    );
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("CategoryResposne::$responseBody");
    if (statusCode == 200) {
      setState(() {
        catloading = false;
      });
      if (mounted == true) {}
      if (getdata["status"]) {
        gecategoryData = GecategoryData.fromJson(jsonDecode(responseBody));
        catList!.addAll(gecategoryData.data!);
      } else {}
    } else {
      setState(() {
        catloading = false;
      });
    }
  }

  Future<void> getProfile() async {
    postList!.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      catloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/user_profile',
    );
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("ProfileResposne::$responseBody");
    if (statusCode == 200) {
      setState(() {
        catloading = false;
      });
      if (mounted == true) {}
      if (getdata["status"]) {
        getProfileData = GetProfileData.fromJson(jsonDecode(responseBody));
        postList!.addAll(getProfileData.post!);
      } else {}
    } else {
      setState(() {
        catloading = false;
      });
    }
  }
}
