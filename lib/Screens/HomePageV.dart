import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Constants/Api.dart';
import '../Constants/Colors.dart';
import '../Models/GetProfileData.dart';
import '../Presentation/PagerState.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'EditPropertyOnRentPage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'EnquiryDetailsPage.dart';
import 'UploadPostPage.dart';

class HomePageV extends StatefulWidget {
  const HomePageV({Key? key}) : super(key: key);

  @override
  State<HomePageV> createState() => _HomePageVState();
}

class _HomePageVState extends State<HomePageV> {

  int? selectedOption;
  List<String> bannerList = [];
  late PageController controller1;

  final StreamController<PagerState> pagerStreamController =
      StreamController<PagerState>.broadcast();

  late GetProfileData getProfileData;
  List<PostList>? postList = [];
  bool isloading = false;
  bool catloading = false;
  File? coverPhoto;

  Future<void> selectPhoto() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );
      final pickedImageFile = File(pickedImage!.path);
      setState(() {
        coverPhoto = pickedImageFile;
      });
    } catch (error) {
      print("error: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    controller1 = PageController(initialPage: 0, viewportFraction: 1.0);
    bannerList.add("assets/images/bg_image.png");
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading || catloading
          ? Center(
          child: CircularProgressIndicator(
            color: appColor,
          ))
          : SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                        height: ScreenUtil().setHeight(250),
                        width: ScreenUtil().screenWidth,
                        child: PageView.builder(
                          padEnds: true,
                          itemCount: bannerList.length,
                          pageSnapping: false,
                          controller: controller1,
                          onPageChanged: (int value) {
                            controller1.addListener(() {
                              pagerStreamController
                                  .add(PagerState(controller1.page!.toInt()));
                            });
                          },
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              //  padding: EdgeInsets.only(right: 10.0),
                              child: Column(
                                children: [
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                      child: Container(
                                        width: ScreenUtil().screenWidth,
                                        height: ScreenUtil().setHeight(250),
                                        foregroundDecoration:
                                            const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              Color(0xff000000),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: [0, 1],
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                bannerList[index].toString()),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ); // you forgot this
                          },
                        )),
                    Positioned(
                      height: ScreenUtil().setHeight(230),
                      width: ScreenUtil().screenWidth,
                      child: Container(
                        height: ScreenUtil().setHeight(230),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(5),
                                  left: ScreenUtil().setWidth(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  getProfileData.user!.image == null ?
                                  CircleAvatar(
                                    backgroundImage:AssetImage("assets/images/dp.png",),
                                    radius: 32,
                                  )
                                  : CircleAvatar(
                                    backgroundImage: NetworkImage(getProfileData.user!.image.toString()) ,radius: 32,
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setHeight(10),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: ScreenUtil().setWidth(230),
                                            child: Text(
                                                getProfileData.user!.name != null ?
                                                getProfileData.user!.name.toString()  : "Real Estate",
                                                style: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setHeight(17),
                                                    color: secondaryColor,
                                                    fontFamily: 'work',
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil().setHeight(3),
                                          ),
                                          Container(
                                            width: ScreenUtil().setWidth(230),
                                            child: Text(
                                                "${getProfileData.user!.email != null ? getProfileData.user!.email.toString() : "re@gmail.com"} | ${getProfileData.user!.mobileNumber != null ? getProfileData.user!.mobileNumber.toString() : "+971 0000000000"}",
                                                style: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setHeight(12),
                                                    color: secondaryColor,
                                                    fontFamily: 'work',
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          /*Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return EditProfileVendorPage(getCountData);
                                              }
                                            ),
                                          );*/
                                        },
                                        child: Icon(
                                          Icons.border_color_outlined,
                                          color: secondaryColor,
                                          size: ScreenUtil().setHeight(13.75),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(5),
                    right: ScreenUtil().setWidth(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: ScreenUtil().setHeight(115),
                      width: ScreenUtil().setWidth(170),
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setHeight(5),
                          left: ScreenUtil().setWidth(10),
                          right: ScreenUtil().setWidth(10),
                          bottom: ScreenUtil().setHeight(5)),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: appColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            color: secondaryColor,
                            size: ScreenUtil().setWidth(30),
                          ),
                          
                          SizedBox(
                            height: ScreenUtil().setHeight(5),
                          ),
                          
                          DottedLine(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.center,
                            lineLength: double.infinity,
                            lineThickness: 1.0,
                            dashLength: 4.0,
                            dashColor: secondaryColor,
                            //  dashGradient: [Colors.red, Colors.blue],
                            dashRadius: 0.0,
                            dashGapLength: 4.0,
                            dashGapColor: Colors.transparent,
                            //  dashGapGradient: [Colors.red, Colors.blue],
                            dashGapRadius: 0.0,
                          ),

                          SizedBox(
                            height: ScreenUtil().setHeight(5),
                          ),

                          Container(
                            child: Text("Views",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(17),
                                    color: secondaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w600)),
                          ),

                          SizedBox(
                            height: ScreenUtil().setHeight(10),
                          ),

                          Container(
                            width: ScreenUtil().setWidth(230),
                            child: Text("${getProfileData.post![0].view == null ? "0" : getProfileData.post![0].view.toString()} Ad Views",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(12),
                                    color: secondaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: ScreenUtil().setHeight(115),
                      width: ScreenUtil().setWidth(170),
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setHeight(5),
                          left: ScreenUtil().setWidth(10),
                          right: ScreenUtil().setWidth(10),
                          bottom: ScreenUtil().setHeight(5)),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: secondaryColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.mail_outline,
                            color: appColor,
                            size: ScreenUtil().setWidth(30),
                          ),

                          SizedBox(
                            height: ScreenUtil().setHeight(5),
                          ),

                          DottedLine(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.center,
                            lineLength: double.infinity,
                            lineThickness: 1.0,
                            dashLength: 4.0,
                            dashColor: appColor,
                            //  dashGradient: [Colors.red, Colors.blue],
                            dashRadius: 0.0,
                            dashGapLength: 4.0,
                            dashGapColor: Colors.transparent,
                            //  dashGapGradient: [Colors.red, Colors.blue],
                            dashGapRadius: 0.0,
                          ),

                          SizedBox(
                            height: ScreenUtil().setHeight(5),
                          ),

                          Container(
                            child: Text("Enquiries",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(17),
                                    color: appColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w600)),
                          ),

                          SizedBox(
                            height: ScreenUtil().setHeight(10),
                          ),

                         /* Container(
                            width: ScreenUtil().setWidth(230),
                            child: Text("${getProfileData.post![0].enquiry == null ? "0" : getProfileData.post![0].enquiry.toString()} Enquiries",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(12),
                                    color: appColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w600)),
                          ),*/

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(5),
                    right: ScreenUtil().setWidth(5)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return UploadPostPage(
                          );
                          //WelcomeLoginPage();
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: ScreenUtil().setHeight(44),
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(5),
                        left: ScreenUtil().setWidth(10),
                        right: ScreenUtil().setWidth(10),
                        bottom: ScreenUtil().setHeight(5)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: appColor),
                        color: secondaryColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: appColor,
                          size: ScreenUtil().setWidth(22),
                        ),

                        SizedBox(
                          width: ScreenUtil().setWidth(5),
                        ),

                        Container(
                          child: Text("Add Property",
                              style: TextStyle(
                                  fontSize: ScreenUtil()
                                      .setHeight(12),
                                  color: primaryColor,
                                  fontFamily: 'work',
                                  fontWeight:
                                  FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(5),
                    right: ScreenUtil().setWidth(5)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Text("Your Ads",
                              style: TextStyle(
                                  fontSize: ScreenUtil()
                                      .setHeight(14),
                                  color: darkTextColor,
                                  fontFamily: 'work',
                                  fontWeight:
                                  FontWeight.w600)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    _buildPropertyList(),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(5),
                    right: ScreenUtil().setWidth(5)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Text("Add Packages Available",
                              style: TextStyle(
                                  fontSize: ScreenUtil()
                                      .setHeight(14),
                                  color: darkTextColor,
                                  fontFamily: 'work',
                                  fontWeight:
                                  FontWeight.w600)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: ScreenUtil().setHeight(135),
                          width: ScreenUtil().setWidth(170),
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(5),
                              left: ScreenUtil().setWidth(10),
                              right: ScreenUtil().setWidth(10),
                              bottom: ScreenUtil().setHeight(5)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: appColor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Radio(
                                    value: 1,
                                    activeColor: secondaryColor,
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOption = value!;
                                      });
                                    },),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(0),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(230),
                                child: Text("Package 1",
                                    style: TextStyle(
                                        fontSize: ScreenUtil()
                                            .setHeight(12),
                                        color: secondaryColor,
                                        fontFamily: 'work',
                                        fontWeight:
                                        FontWeight.w400)),
                              ),

                              SizedBox(
                                height: ScreenUtil().setHeight(5),
                              ),

                              Container(
                                child: Text("AED 100",
                                    style: TextStyle(
                                        fontSize: ScreenUtil()
                                            .setHeight(17),
                                        color: secondaryColor,
                                        fontFamily: 'work',
                                        fontWeight:
                                        FontWeight.w600)),
                              ),

                              SizedBox(
                                height: ScreenUtil().setHeight(5),
                              ),

                              Container(
                                width: ScreenUtil().setWidth(230),
                                child: Text("Ad will be for 1 month",
                                    style: TextStyle(
                                        fontSize: ScreenUtil()
                                            .setHeight(12),
                                        color: secondaryColor,
                                        fontFamily: 'work',
                                        fontWeight:
                                        FontWeight.w400)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: ScreenUtil().setHeight(135),
                          width: ScreenUtil().setWidth(170),
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(5),
                              left: ScreenUtil().setWidth(10),
                              right: ScreenUtil().setWidth(10),
                              bottom: ScreenUtil().setHeight(5)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: secondaryColor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Radio(
                                    value: 2,
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOption = value!;
                                      });
                                  },),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(0),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(230),
                                child: Text("Package 2",
                                    style: TextStyle(
                                        fontSize: ScreenUtil()
                                            .setHeight(12),
                                        color: appColor,
                                        fontFamily: 'work',
                                        fontWeight:
                                        FontWeight.w400)),
                              ),

                              SizedBox(
                                height: ScreenUtil().setHeight(5),
                              ),

                              Container(
                                child: Text("AED 250",
                                    style: TextStyle(
                                        fontSize: ScreenUtil()
                                            .setHeight(17),
                                        color: appColor,
                                        fontFamily: 'work',
                                        fontWeight:
                                        FontWeight.w600)),
                              ),

                              SizedBox(
                                height: ScreenUtil().setHeight(5),
                              ),

                              Container(
                                width: ScreenUtil().setWidth(230),
                                child: Text("Ad will be for 3 month",
                                    style: TextStyle(
                                        fontSize: ScreenUtil()
                                            .setHeight(12),
                                        color: appColor,
                                        fontFamily: 'work',
                                        fontWeight:
                                        FontWeight.w400)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
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

  Widget _buildPropertyList() {
    return  isloading
        ? Center(
        child: CircularProgressIndicator(
          color: appColor,
        ))
        : Container(
      height: ScreenUtil().setHeight(245),
      child: ListView.builder(
        itemCount: postList!.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(0),
        itemBuilder: (context, i) {
          return _buildProList(i);
        },
      ),
    );
  }

  Widget _buildProList(int i) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return EnquiryDetailsPage(postList![i].id);
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
        decoration: BoxDecoration(
            color: secondaryColor,
            border: Border.all(color: secondaryColor, width: 0.2),
            borderRadius: BorderRadius.circular(10.0)),
        height: ScreenUtil().setHeight(250),
        child: Column(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.grey.shade100,
                BlendMode.darken,
              ),
              child: Container(
                height: ScreenUtil().setHeight(155),
                width: ScreenUtil().setWidth(325),
                decoration: postList![i].images != null
                    ? BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          postList![i].images.toString()),
                      fit: BoxFit.cover),
                  border: Border.all(color: secondaryColor, width: 0.2),
                )
                    :  BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/property_img.png"),
                      fit: BoxFit.cover),
                  border: Border.all(color: secondaryColor, width: 0.2),
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                        height: ScreenUtil().setHeight(26),
                                        width: ScreenUtil().setWidth(80),
                                        color: Color(0xffFFE500),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                                "assets/images/verified.png",
                                                height:
                                                ScreenUtil().setHeight(14),
                                                width:
                                                ScreenUtil().setWidth(18)),
                                            SizedBox(
                                              width: ScreenUtil().setWidth(5),
                                            ),
                                            Text(
                                              "Verified",
                                              style: TextStyle(
                                                color: appColor,
                                                fontSize:
                                                ScreenUtil().setWidth(12),
                                                fontFamily: 'work',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return EditPropertyOnRentPage(postList![i].id.toString(), postList[i]);
                                        },
                                      ),
                                    );*/
                                /*    isLiked1(proppertyList![i].id,
                                        proppertyList![0]);*/
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                          height: ScreenUtil().setHeight(26),
                                          width: ScreenUtil().setHeight(26),
                                          color: secondaryColor,
                                          child: Icon(
                                            Icons.edit_note_outlined,
                                            color: Color(0xff1C1B1F),
                                            size: ScreenUtil().setHeight(14),
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(30),
                        ),
                        Container(
                          height: ScreenUtil().setHeight(80),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(12),
                                top: ScreenUtil().setWidth(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Text(
                                         postList![i].propertyName != null
                                        ? postList![i].propertyName.toString()
                                        : "Villa",
                                          style: TextStyle(
                                            color: secondaryColor,
                                            fontSize: ScreenUtil().setWidth(12),
                                            fontFamily: 'work',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(5),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          postList![i].price != null
                                              ? postList![i].price.toString()
                                              : "0",
                                          style: TextStyle(
                                            color: secondaryColor,
                                            fontSize: ScreenUtil().setWidth(15),
                                            fontFamily: 'work',
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(5),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          postList![i].propertyAddress != null
                                              ? postList![i].propertyAddress.toString()
                                              : "UAE,Dabai",
                                          style: TextStyle(
                                            color: secondaryColor,
                                            fontSize: ScreenUtil().setWidth(12),
                                            fontFamily: 'work',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(10),
                  right: ScreenUtil().setWidth(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/images/bed.png",
                              height: ScreenUtil().setHeight(15),
                              width: ScreenUtil().setWidth(18)),
                          SizedBox(
                            width: ScreenUtil().setWidth(5),
                          ),
                          Text(
                              postList![i].bedroomCount != null
                                  ? postList![i].bathroomCount.toString()
                                  : "0",
                            style: TextStyle(
                              color: darkTextColor,
                              fontSize: ScreenUtil().setWidth(12),
                              fontFamily: 'work',
                              height: ScreenUtil().setWidth(1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(12),
                      ),
                      Row(
                        children: [
                          Image.asset("assets/images/bath.png",
                              height: ScreenUtil().setHeight(15),
                              width: ScreenUtil().setWidth(18)),
                          SizedBox(
                            width: ScreenUtil().setWidth(5),
                          ),
                          Text(
                              postList![i].kitchenCount != null
                                  ? postList![i].kitchenCount.toString()
                                  : "0",
                            style: TextStyle(
                              color: darkTextColor,
                              fontSize: ScreenUtil().setWidth(12),
                              fontFamily: 'work',
                              height: ScreenUtil().setWidth(1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(12),
                      ),
                      Row(
                        children: [
                          Image.asset("assets/images/crop.png",
                              height: ScreenUtil().setHeight(15),
                              width: ScreenUtil().setWidth(18)),
                          SizedBox(
                            width: ScreenUtil().setWidth(5),
                          ),
                          Text(
                              postList![i].propertySize != null
                                  ? postList![i].propertySize.toString()
                                  : "0",
                            style: TextStyle(
                              color: darkTextColor,
                              fontSize: ScreenUtil().setWidth(12),
                              fontFamily: 'work',
                              height: ScreenUtil().setWidth(1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                        /*  _callENquiryAPI(
                              proppertyList![i].id.toString(), "phone");*/
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Color(0xffF5F6F8),
                          ),
                          width: ScreenUtil().setWidth(95),
                          height: ScreenUtil().setHeight(32),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/call.png",
                                    color: appColor,
                                    height: ScreenUtil().setHeight(15),
                                    width: ScreenUtil().setWidth(18)),
                                SizedBox(
                                  width: ScreenUtil().setWidth(5),
                                ),
                                Text(
                                  "Call",
                                  style: TextStyle(
                                    color: darkTextColor,
                                    fontSize: ScreenUtil().setWidth(12),
                                    fontFamily: 'work',
                                    height: ScreenUtil().setWidth(1),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setHeight(10),
                      ),
                      GestureDetector(
                        onTap: () {
                        /*  _callENquiryAPI(
                              proppertyList![0].id.toString(), "mail");*/
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Color(0xffF5F6F8),
                          ),
                          width: ScreenUtil().setWidth(100),
                          height: ScreenUtil().setHeight(32),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/mail.png",
                                    color: appColor,
                                    height: ScreenUtil().setHeight(15),
                                    width: ScreenUtil().setWidth(18)),
                                SizedBox(
                                  width: ScreenUtil().setWidth(5),
                                ),
                                Text(
                                  "E Mail",
                                  style: TextStyle(
                                    color: darkTextColor,
                                    fontSize: ScreenUtil().setWidth(12),
                                    fontFamily: 'work',
                                    height: ScreenUtil().setWidth(1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setHeight(10),
                      ),
                      GestureDetector(
                        onTap: () {
                         /* _callENquiryAPI(
                              proppertyList![0].id.toString(), "whatsapp");*/
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Color(0xff00CA7D),
                          ),
                          width: ScreenUtil().setWidth(100),
                          height: ScreenUtil().setHeight(32),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/wp.png",
                                    height: ScreenUtil().setHeight(15),
                                    width: ScreenUtil().setWidth(18)),
                                SizedBox(
                                  width: ScreenUtil().setWidth(5),
                                ),
                                Text(
                                  "Whatsapp",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: ScreenUtil().setWidth(12),
                                    fontFamily: 'work',
                                    height: ScreenUtil().setWidth(1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
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
