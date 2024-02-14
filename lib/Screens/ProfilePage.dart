import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_pro_vendor/Models/GetCountData.dart';
import 'package:real_pro_vendor/Screens/AboutUs.dart';
import 'package:real_pro_vendor/Screens/EditCompanyDetailsPage.dart';
import 'package:real_pro_vendor/Screens/EditPeronalDetailsPage.dart';
import 'package:real_pro_vendor/Screens/EditProfileVendorPage.dart';
import 'package:real_pro_vendor/Screens/FollowersListPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/Api.dart';
import '../Constants/Colors.dart';
import '../ContactUs.dart';
import 'ListedPropertyPage.dart';
import 'LoginPageVendor.dart';
import 'NotificationPage.dart';
import 'ResetPasword.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late GetCountData getCountData;

  bool isloading = false;
  bool catloading = false;

  String name = "";
  String email = "";
  String img = "";

  String phone = "";
  File? image;

  @override
  void initState() {
    // TODO: implement initState
    getCountData = GetCountData();
    super.initState();
    getPref();
    getCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        bottomOpacity: 0,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Profile",
          style: TextStyle(
            color: secondaryColor,
            fontSize: ScreenUtil().setWidth(15),
            fontFamily: 'work',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: isloading || catloading || getCountData.user == null
          ? Center(
          child: CircularProgressIndicator(
            color: appColor,
          ))
          : SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(10.0),
                  right: ScreenUtil().setWidth(10.0),
                  top: ScreenUtil().setHeight(10.0),
                  bottom: ScreenUtil().setHeight(10.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Color(0xff005CFF),
                            Color(0xff00389E)
                          ])),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(10),
                        right: ScreenUtil().setWidth(10),
                        bottom: ScreenUtil().setHeight(12),
                        top: ScreenUtil().setHeight(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            selectPhoto();
                          },
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: image != null
                                ? CircleAvatar(
                              backgroundImage: FileImage(image!),
                              radius: 50,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  padding: EdgeInsets.all(05),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: primaryColor),
                                      color: secondaryColor,
                                      borderRadius:
                                      BorderRadius.circular(
                                          100)),
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: appColor,
                                    size:
                                    ScreenUtil().setHeight(17),
                                  ),
                                ),
                              ),
                            )
                                : img != null ||
                                getCountData.user?.image != null
                                ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                  img != null
                                      ? img
                                      : userProfile +
                                      getCountData
                                          .user!.image
                                          .toString()),
                              radius: 50,
                              child: Align(
                                alignment:
                                Alignment.bottomRight,
                                child: Container(
                                  padding: EdgeInsets.all(05),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: primaryColor),
                                      color: secondaryColor,
                                      borderRadius:
                                      BorderRadius.circular(
                                          100)),
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: appColor,
                                    size: ScreenUtil()
                                        .setHeight(17),
                                  ),
                                ),
                              ),
                            )
                                : CircleAvatar(
                              backgroundImage: AssetImage(
                                "assets/images/dp.png",
                              ),
                              radius: 50,
                              child: Align(
                                alignment:
                                Alignment.bottomRight,
                                child: Container(
                                  padding: EdgeInsets.all(05),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: primaryColor),
                                      color: secondaryColor,
                                      borderRadius:
                                      BorderRadius.circular(
                                          100)),
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: appColor,
                                    size: ScreenUtil()
                                        .setHeight(17),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: ScreenUtil().setWidth(200),
                                child: Text(
                                  getCountData.user?.name.toString() !=
                                      null
                                      ? getCountData.user!.name.toString()
                                      : "Name",
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: ScreenUtil().setHeight(14),
                                    fontFamily: 'work',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(2),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(200),
                                child: Text(
                                  getCountData.user?.uid.toString() !=
                                      null
                                      ? "UID: ${getCountData.user!.uid.toString()}"
                                      : "-",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: ScreenUtil().setHeight(12),
                                    fontFamily: 'work',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(2),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(200),
                                child: Divider(
                                  thickness: 0.5,
                                  color: secondaryColor,
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(2),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(200),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        getCountData.user?.email
                                            .toString() !=
                                            null
                                            ? getCountData.user!.email
                                            .toString()
                                            : "-",
                                        style: TextStyle(
                                          color: secondaryColor,
                                          fontSize:
                                          ScreenUtil().setHeight(12),
                                          fontFamily: 'work',
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return EditProfileVendorPage(
                                                  getCountData);
                                              //WelcomeLoginPage();
                                            },
                                          ),
                                        );
                                      },
                                      child: Icon(
                                        Icons.border_color,
                                        color: secondaryColor,
                                        size: ScreenUtil().setHeight(12),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(2),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(200),
                                child: Text(
                                  getCountData.user!.mobileNumber != null
                                      ? "+971 ${getCountData.user!.mobileNumber!}"
                                      : "-",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: ScreenUtil().setHeight(11),
                                    fontFamily: 'work',
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(10),
                    bottom: ScreenUtil().setHeight(15),
                    top: ScreenUtil().setHeight(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(100),
                      height: ScreenUtil().setHeight(75),
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              getCountData.like.toString(),
                              style: TextStyle(
                                color: appColor,
                                fontSize: ScreenUtil().setHeight(20),
                                fontFamily: 'work',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Likes",
                              style: TextStyle(
                                color: darkTextColor,
                                fontSize: ScreenUtil().setHeight(12),
                                fontFamily: 'work',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(100),
                      height: ScreenUtil().setHeight(75),
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              getCountData.views.toString(),
                              style: TextStyle(
                                color: appColor,
                                fontSize: ScreenUtil().setHeight(20),
                                fontFamily: 'work',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Views",
                              style: TextStyle(
                                color: darkTextColor,
                                fontSize: ScreenUtil().setHeight(12),
                                fontFamily: 'work',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return FollowersListPage();
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(100),
                        height: ScreenUtil().setHeight(75),
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                getCountData.following.toString(),
                                style: TextStyle(
                                  color: appColor,
                                  fontSize: ScreenUtil().setHeight(20),
                                  fontFamily: 'work',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Followers",
                                style: TextStyle(
                                  color: darkTextColor,
                                  fontSize: ScreenUtil().setHeight(12),
                                  fontFamily: 'work',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(10),
                    bottom: ScreenUtil().setHeight(10),
                    top: ScreenUtil().setHeight(10)),
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(10),
                    bottom: ScreenUtil().setHeight(15),
                    top: ScreenUtil().setHeight(15)),
                width: ScreenUtil().screenWidth,
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // properties
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ListedProperty();
                                },
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                          left:
                                          ScreenUtil().setWidth(10)),
                                      // width: ScreenUtil().setWidth(200),
                                      child: Icon(Icons.home_work,
                                          color: appColor,
                                          size:
                                          ScreenUtil().setWidth(16))),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(20),
                                  ),
                                  Container(
                                    width: ScreenUtil().setWidth(200),
                                    child: Text(
                                      "Listed Properties",
                                      style: TextStyle(
                                        color: darkTextColor,
                                        fontSize:
                                        ScreenUtil().setHeight(12),
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(5)),
                                  // width: ScreenUtil().setWidth(200),
                                  child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: appColor,
                                      size: ScreenUtil().setWidth(16))),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(45)),
                            child: Divider(
                              color: borderColor,
                              height: 0.2,
                            )),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return EditPeronalDetailsPage(
                                      getCountData);
                                },
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                          left:
                                          ScreenUtil().setWidth(10)),
                                      // width: ScreenUtil().setWidth(200),
                                      child: Icon(Icons.person,
                                          color: appColor,
                                          size:
                                          ScreenUtil().setWidth(16))),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(20),
                                  ),
                                  Container(
                                    width: ScreenUtil().setWidth(200),
                                    child: Text(
                                      "Edit Personal Details",
                                      style: TextStyle(
                                        color: darkTextColor,
                                        fontSize:
                                        ScreenUtil().setHeight(12),
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(5)),
                                  // width: ScreenUtil().setWidth(200),
                                  child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: appColor,
                                      size: ScreenUtil().setWidth(16))),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(45)),
                            child: Divider(
                              color: borderColor,
                              height: 0.2,
                            )),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return EditCompanyDetailsPage(
                                      getCountData);
                                },
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                          left:
                                          ScreenUtil().setWidth(10)),
                                      // width: ScreenUtil().setWidth(200),
                                      child: Icon(Icons.border_color,
                                          color: appColor,
                                          size:
                                          ScreenUtil().setWidth(16))),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(20),
                                  ),
                                  Container(
                                    width: ScreenUtil().setWidth(200),
                                    child: Text(
                                      "Edit Company Details",
                                      style: TextStyle(
                                        color: darkTextColor,
                                        fontSize:
                                        ScreenUtil().setHeight(12),
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(5)),
                                  // width: ScreenUtil().setWidth(200),
                                  child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: appColor,
                                      size: ScreenUtil().setWidth(16))),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(45)),
                            child: Divider(
                              color: borderColor,
                              height: 0.2,
                            )),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                      ],
                    ),

                    /*Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin:
                                    EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                                    // width: ScreenUtil().setWidth(200),
                                    child: Icon(Icons.message,
                                        color: appColor,
                                        size: ScreenUtil().setWidth(16))),
                                SizedBox(
                                  width: ScreenUtil().setWidth(20),
                                ),
                                Container(
                                  width: ScreenUtil().setWidth(200),
                                  child: Text(
                                    "Messages",
                                    style: TextStyle(
                                      color: darkTextColor,
                                      fontSize: ScreenUtil().setHeight(12),
                                      fontFamily: 'work',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Container(
                                margin:
                                EdgeInsets.only(right: ScreenUtil().setWidth(5)),
                                // width: ScreenUtil().setWidth(200),
                                child: Icon(Icons.arrow_forward_ios_outlined,
                                    color: appColor,
                                    size: ScreenUtil().setWidth(16))),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: ScreenUtil().setWidth(45)),
                            child: Divider(
                              color: borderColor,
                              height: 0.2,
                            )),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                      ],
                    ),*/

                    /*    Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return NotificationPage();
                                      },
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(
                                                left:
                                                    ScreenUtil().setWidth(10)),
                                            // width: ScreenUtil().setWidth(200),
                                            child: Icon(Icons.notifications,
                                                color: appColor,
                                                size:
                                                    ScreenUtil().setWidth(16))),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(20),
                                        ),
                                        Container(
                                          width: ScreenUtil().setWidth(200),
                                          child: Text(
                                            "Notification",
                                            style: TextStyle(
                                              color: darkTextColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(5)),
                                        // width: ScreenUtil().setWidth(200),
                                        child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: appColor,
                                            size: ScreenUtil().setWidth(16))),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(12),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(45)),
                                  child: Divider(
                                    color: borderColor,
                                    height: 0.2,
                                  )),
                              SizedBox(
                                height: ScreenUtil().setHeight(12),
                              ),
                            ],
                          ),*/

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ResetPasword();
                                },
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                          left:
                                          ScreenUtil().setWidth(10)),
                                      // width: ScreenUtil().setWidth(200),
                                      child: Icon(Icons.settings,
                                          color: appColor,
                                          size:
                                          ScreenUtil().setWidth(16))),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(20),
                                  ),
                                  Container(
                                    width: ScreenUtil().setWidth(200),
                                    child: Text(
                                      "Settings",
                                      style: TextStyle(
                                        color: darkTextColor,
                                        fontSize:
                                        ScreenUtil().setHeight(12),
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(5)),
                                  // width: ScreenUtil().setWidth(200),
                                  child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: appColor,
                                      size: ScreenUtil().setWidth(16))),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(45)),
                            child: Divider(
                              color: borderColor,
                              height: 0.2,
                            )),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                      ],
                    ),


                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AboutUs("Real Pro");
                                },
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                          left:
                                          ScreenUtil().setWidth(10)),
                                      // width: ScreenUtil().setWidth(200),
                                      child: Icon(Icons.aod,
                                          color: appColor,
                                          size:
                                          ScreenUtil().setWidth(16))),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(20),
                                  ),
                                  Container(
                                    width: ScreenUtil().setWidth(200),
                                    child: Text(
                                      "Real Pro",
                                      style: TextStyle(
                                        color: darkTextColor,
                                        fontSize:
                                        ScreenUtil().setHeight(12),
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(5)),
                                  // width: ScreenUtil().setWidth(200),
                                  child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: appColor,
                                      size: ScreenUtil().setWidth(16))),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(45)),
                            child: Divider(
                              color: borderColor,
                              height: 0.2,
                            )),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ContactUs();
                                  //WelcomeLoginPage();
                                },
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(10)),
                                      // width: ScreenUtil().setWidth(200),
                                      child: Icon(Icons.contact_page_outlined,
                                          color: appColor,
                                          size: ScreenUtil().setWidth(16))),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(20),
                                  ),
                                  Container(
                                    // width: ScreenUtil().setWidth(200),
                                    child: Text(
                                      "Contact Us",
                                      style: TextStyle(
                                        color: darkTextColor,
                                        fontSize: ScreenUtil().setHeight(12),
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(5)),
                                  // width: ScreenUtil().setWidth(200),
                                  child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: appColor,
                                      size: ScreenUtil().setWidth(16))),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(45)),
                            child: Divider(
                              color: borderColor,
                              height: 0.2,
                            )),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showDialog(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10)),
                                  // width: ScreenUtil().setWidth(200),
                                  child: Icon(
                                    Icons.delete,
                                    color: appColor,
                                    size: ScreenUtil().setWidth(16),
                                  )),
                              SizedBox(
                                width: ScreenUtil().setWidth(20),
                              ),
                              Container(
                                // width: ScreenUtil().setWidth(200),
                                child: Text(
                                  "Delete Account",
                                  style: TextStyle(
                                    color: darkTextColor,
                                    fontSize: ScreenUtil().setHeight(12),
                                    fontFamily: 'work',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(45)),
                            child: Divider(
                              color: borderColor,
                              height: 0.2,
                            )),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        _logOut();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(10)),
                              // width: ScreenUtil().setWidth(200),
                              child: Icon(
                                Icons.logout,
                                color: appColor,
                                size: ScreenUtil().setWidth(16),
                              )),
                          SizedBox(
                            width: ScreenUtil().setWidth(20),
                          ),
                          Container(
                            // width: ScreenUtil().setWidth(200),
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                color: darkTextColor,
                                fontSize: ScreenUtil().setHeight(12),
                                fontFamily: 'work',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLogging", false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginPageVendor();
        },
      ),
    );
  }

  Future<void> getPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name")!;
      email = prefs.getString("email")!;
      phone = prefs.getString("phone")!;
      if(prefs.getBool("isSocial")!=null)
      {
        if (prefs.getBool("isSocial")!) {
          img = prefs.getString("socialDP")!;
        }
      }

    });
  }

  Future<void> getCounts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      catloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/api/user/getcounts',
    );
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("Count Response::$responseBody");
    if (statusCode == 200) {
      if (mounted == true) {}
      if (getdata["status"]) {
        getCountData = GetCountData.fromJson(jsonDecode(responseBody));
        setState(() {
          catloading = false;
          if (getdata["user"]["image"] != null) {
            img = userProfile + getdata["user"]["image"];
          }
        });
      } else {}
    } else {
      setState(() {
        catloading = false;
      });
    }
  }

  Future<void> selectPhoto() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );
      final pickedImageFile = File(pickedImage!.path);
      setState(() {
        image = pickedImageFile;
      });
      callApi();
    } catch (error) {
      print("error: $error");
    }
  }

  Future<void> callApi() async {
    setState(() {
      isloading = true;
    });
    final headers = {'Accept': 'application/json'};
    String? token = await FirebaseMessaging.instance.getToken();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.https(
      apiBaseUrl,
      '/api/user/edit_profile',
    );
    var request = new http.MultipartRequest("POST", url);
    request.headers['Authorization'] = prefs.getString('access_token')!;
    request.fields['email'] = prefs.getString('email')!;

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image!.path,
        ),
      );
    }

    request
        .send()
        .then((response) {
      if (response.statusCode == 200) print("Uploaded!");
      print(response.statusCode);

      int statusCode = response.statusCode;
      http.Response.fromStream(response).then((response) {
        print('response.body ' + response.body);

        var getdata = json.decode(response.body);

        if (response.statusCode == 200) {
          if (mounted) ;
          if (getdata["status"]) {
            setState(() {
              isloading = false;
            });
            Message(context, "Profile Image Uploded Successully");
            if (getdata["data"]["user"]["image"] != null) {
              prefs.setString(
                  "profileImage", getdata["data"]["user"]["image"]);
            }
            /*bookTable();*/
            getPref();
          } else {
            setState(() {
              isloading = false;
            });
            Message(context, getdata["message"]);
          }
        } else {
          setState(() {
            isloading = false;
          });
          Message(context, getdata["message"]);
        }

        return response.body;
      });
    })
        .catchError((err) => print('error : ' + err.toString()))
        .whenComplete(() {});
  }
  Future<void> deleteAccount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/api/user/deleteaccount',
    );
    print('${prefs.getString('token')}');

    final encoding = Encoding.getByName('utf-8');

    final headers = {
      'Authorization': 'Bearer ${prefs.getString('access_token')}'
    };

    Response response = await post(
      uri,
      headers: headers,
      encoding: encoding,
    );

    var getdata = json.decode(response.body);
    if(response.statusCode==200)
    {
      setState(() {
        isloading = false;
      });
      if (getdata["success"]) {
        Message(context, "Account Deleted succesfully!");
        Future.delayed(const Duration(milliseconds: 1000), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => LoginPageVendor(
              )));
        });
      } else {

        Message(context, getdata["message"]);

      }
    }
    else
    {
      setState(() {
        isloading = false;
      });
      Message(context, "You reached Maximum limit of edit try after sometime");

    }

  }

  _showDialog(BuildContext ctx) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      builder: (context) => SimpleDialog(
        children: <Widget>[

          Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "do you want to delete\nyour account?"  ,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "work",

                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      fontSize: 15.0),
                ),
              )),
          Container(
            padding: EdgeInsets.only(top: 15.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      deleteAccount();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.all(size.width * 0.01),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: appColor,
                              boxShadow: [
                                BoxShadow(
                                    color: secondaryColor, spreadRadius: 1),
                              ],
                            ),
                            width: size.width * 0.25,
                            height: size.height * 0.05,
                            child: Center(
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                      fontFamily: 'work',
                                      fontSize: size.width * 0.04,
                                      color: secondaryColor),
                                ))),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.all(size.width * 0.01),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: appColor,
                              boxShadow: [
                                BoxShadow(
                                    color: secondaryColor, spreadRadius: 1),
                              ],
                            ),
                            width: size.width * 0.25,
                            height: size.height * 0.05,
                            child: Center(
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                      fontFamily: 'work',
                                      fontSize: size.width * 0.04,
                                      color: secondaryColor),
                                ))),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          )
        ],
      ),
      context: ctx,
      barrierDismissible: true,
    );
  }
}
