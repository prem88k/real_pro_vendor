import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constants/Api.dart';
import '../Constants/Colors.dart';
import '../Models/GetPropertyDetailsData.dart';
import '../Models/GetTredingPropertyData.dart';
import '../Presentation/PagerState.dart';
import '../Presentation/common_button.dart';
import 'LoginPageVendor.dart';

class PropertyDetailsPage extends StatefulWidget {
  PropertyDetailsPage(this.property_id);

  String property_id;

  @override
  State<PropertyDetailsPage> createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  bool isloading = false;
  bool isLoadingD = false;

  late GetPropertyDetails getPropertyDetails;
  List<PropertyDetails>? details = [];
  List<ImagesList>? images=[];

  List<TredingPropertyList>? proppertyList = [];
  late GetTredingPropertyData getPropertyData;
  PageController? controller1;
  final StreamController<PagerState> pagerStreamController =
  StreamController<PagerState>.broadcast();
  @override
  void initState() {
    // TODO: implement initState
    getPropertyDetailsAPI();
    getPropertyAPI("0");
    controller1 =
        PageController(viewportFraction: 0.9, initialPage: 0, keepPage: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: isLoadingD&&details!.length==0
          ? Center(
              child: CircularProgressIndicator(
              color: appColor,
            ))
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          height: ScreenUtil().setHeight(250),
                          child: Stack(
                            children: [
                              details!=null || details!.length!=0 ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: images!.length,
                                controller: controller1,

                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin:
                                    EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                                    child: Stack(
                                      children: [
                                        images!=null?Container(
                                          height: ScreenUtil().setHeight(250),
                                          width:
                                          MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: CachedNetworkImageProvider(
                                                    images![index].image!),
                                                fit: BoxFit.fill),
                                          ),
                                        ):Container(
                                          height: ScreenUtil().setHeight(250),
                                          width:
                                          MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage("assets/images/property_img.png"),
                                                fit: BoxFit.cover),
                                            border: Border.all(color: secondaryColor, width: 0.2),
                                          ),
                                        ),
                                        Container(
                                            width: MediaQuery.of(context).size.width *
                                                0.9,

                                            padding: EdgeInsets.only(
                                                bottom: ScreenUtil().setWidth(15),left:ScreenUtil().setWidth(15) ),
                                            alignment: Alignment.bottomLeft,
                                            child: SmoothPageIndicator(
                                              controller: controller1!,
                                              count:  images!.length,
                                              effect: ExpandingDotsEffect(
                                                  expansionFactor: 3,strokeWidth: .5,
                                                  spacing: 3.0,
                                                  radius: 2.0,
                                                  dotWidth: 5.0,
                                                  dotHeight: 5.0,
                                                  dotColor: borderColor,
                                                  activeDotColor: secondaryColor),
                                            ))
                                      ],
                                    ),
                                  );
                                },
                              ):Container(),

                              Container(

                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(26)),
                                    child: Column(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  100),
                                                              child: Container(
                                                                  height: ScreenUtil()
                                                                      .setHeight(30),
                                                                  width: ScreenUtil()
                                                                      .setHeight(30),
                                                                  color: secondaryColor,
                                                                  child: Center(
                                                                      child: Icon(
                                                                        Icons
                                                                            .arrow_back_ios_new,
                                                                        color: lineColor,
                                                                        size: ScreenUtil()
                                                                            .setHeight(11),
                                                                      ))),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                          ScreenUtil().setWidth(8),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.all(8.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                5),
                                                            child: Container(
                                                                height: ScreenUtil()
                                                                    .setHeight(26),
                                                                width: ScreenUtil()
                                                                    .setWidth(80),
                                                                color:
                                                                Color(0xffFFE500),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    Image.asset(
                                                                        "assets/images/verified.png",
                                                                        height:
                                                                        ScreenUtil()
                                                                            .setHeight(
                                                                            14),
                                                                        width: ScreenUtil()
                                                                            .setWidth(
                                                                            18)),
                                                                    SizedBox(
                                                                      width:
                                                                      ScreenUtil()
                                                                          .setWidth(
                                                                          5),
                                                                    ),
                                                                    Text(
                                                                      "Verified",
                                                                      style: TextStyle(
                                                                        color: appColor,
                                                                        fontSize:
                                                                        ScreenUtil()
                                                                            .setWidth(
                                                                            12),
                                                                        fontFamily:
                                                                        'work',
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        isLiked(details![0].id,
                                                            details![0]);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(8.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                          child: Container(
                                                              height: ScreenUtil()
                                                                  .setHeight(30),
                                                              width: ScreenUtil()
                                                                  .setHeight(30),
                                                              color: secondaryColor,
                                                              child: Icon(
                                                                  !details![0].liked!
                                                                      ? Icons
                                                                      .favorite_border
                                                                      : Icons.favorite,
                                                                  size: ScreenUtil()
                                                                      .setHeight(15),
                                                                  color:
                                                                  details![0].liked!
                                                                      ? Colors.red
                                                                      : lineColor)),
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
                                          ],
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),

                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(12),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(15),
                              right: ScreenUtil().setWidth(15),
                              bottom: ScreenUtil().setHeight(10),
                              top: ScreenUtil().setHeight(10)),
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(15),
                              right: ScreenUtil().setWidth(15),
                              bottom: ScreenUtil().setHeight(10),
                              top: ScreenUtil().setHeight(10)),
                          width: ScreenUtil().screenWidth,
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(10)),
                                    // width: ScreenUtil().setWidth(200),
                                    child: Text(
                                      details![0].propertyName!,
                                      style: TextStyle(
                                        color: appColor,
                                        fontSize: ScreenUtil().setHeight(11),
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setWidth(2.5),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(1),
                                        left: ScreenUtil().setWidth(10)),
                                    // width: ScreenUtil().setWidth(200),
                                    child: Text(
                                      "${details![0].price} AED yearly",
                                      style: TextStyle(
                                        color: darkTextColor,
                                        fontSize: ScreenUtil().setHeight(14),
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setWidth(2.5),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(1),
                                        left: ScreenUtil().setWidth(10)),
                                    // width: ScreenUtil().setWidth(200),
                                    child: Text(
                                      details![0].propertyAddress!,
                                      style: TextStyle(
                                        color: lineColor,
                                        fontSize: ScreenUtil().setHeight(11),
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setWidth(5),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(1),
                                        left: ScreenUtil().setWidth(8)),
                                    child: Row(
                                      children: [
                                        Image.asset("assets/images/bed.png",
                                            height: ScreenUtil().setHeight(15),
                                            width: ScreenUtil().setWidth(18)),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(5),
                                        ),
                                        Text(
                                          details![0].bedroomCount.toString(),
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
                                        details![0].bathroomCount.toString(),
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
                                        details![0].propertySize != null
                                            ? "${details![0].propertySize} SQFT"
                                            : "2300 SQFT",
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
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(15),
                              right: ScreenUtil().setWidth(15),
                              bottom: ScreenUtil().setHeight(10),
                              top: ScreenUtil().setHeight(5)),
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(15),
                              right: ScreenUtil().setWidth(15),
                              bottom: ScreenUtil().setHeight(10),
                              top: ScreenUtil().setHeight(10)),
                          width: ScreenUtil().screenWidth,
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: ScreenUtil().setWidth(250),
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(10)),
                                    // width: ScreenUtil().setWidth(200),
                                    child: Text(
                                      details![0].description != null
                                          ? details![0].description!
                                          : "2 BR single row villa | ready to occupy | Book for viewing",
                                      style: TextStyle(
                                        color: lineColor,
                                        fontSize: ScreenUtil().setHeight(14),
                                        letterSpacing: 1.0,
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setWidth(5),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(1),
                                        left: ScreenUtil().setWidth(10)),
                                    // width: ScreenUtil().setWidth(200),
                                    child: Text(
                                      "Villa Features :",
                                      style: TextStyle(
                                        color: lineColor,
                                        fontSize: ScreenUtil().setHeight(11),
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setWidth(5),
                              ),
                              ListView.builder(
                                itemCount: details![0].vilaFeature!.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.all(0),
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, i) {
                                  return _buildList(i);
                                },
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(14),
                              ),
                              //property INfo

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: ScreenUtil().setWidth(250),
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(10)),
                                    // width: ScreenUtil().setWidth(200),
                                    child: Text(
                                      "Property Information",
                                      style: TextStyle(
                                        color: lineColor,
                                        fontSize: ScreenUtil().setHeight(14),
                                        letterSpacing: 1.0,
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(1),
                                    left: ScreenUtil().setWidth(10)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: ScreenUtil().setHeight(100),
                                          child: Text(
                                            "Type",
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setHeight(12),
                                        ),
                                        Container(
                                          width: ScreenUtil().setHeight(100),
                                          child: Text(
                                            details![0].type != null
                                                ? details![0].type!
                                                : "Villa",
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.bold,
                                            ),
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
                                        Container(
                                          width: ScreenUtil().setHeight(100),
                                          child: Text(
                                            "Purpose",
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setHeight(12),
                                        ),
                                        Container(
                                          width: ScreenUtil().setHeight(100),
                                          child: Text(
                                            details![0].purpose!,
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.bold,
                                            ),
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
                                        Container(
                                          width: ScreenUtil().setHeight(100),
                                          child: Text(
                                            "Reference No.",
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setHeight(12),
                                        ),
                                        Container(
                                          width: ScreenUtil().setWidth(150),
                                          child: Text(
                                            details![0].refNum!,
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.bold,
                                            ),
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
                                        Container(
                                          width: ScreenUtil().setHeight(100),
                                          child: Text(
                                            "Added on",
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setHeight(12),
                                        ),
                                        Container(
                                          width: ScreenUtil().setWidth(150),
                                          child: Text(
                                            details![0].addon!,
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(15),
                              right: ScreenUtil().setWidth(15),
                              bottom: ScreenUtil().setHeight(10),
                              top: ScreenUtil().setHeight(5)),
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(15),
                              right: ScreenUtil().setWidth(15),
                              bottom: ScreenUtil().setHeight(10),
                              top: ScreenUtil().setHeight(10)),
                          width: ScreenUtil().screenWidth,
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //property INfo

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: ScreenUtil().setWidth(250),
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(10)),
                                    // width: ScreenUtil().setWidth(200),
                                    child: Text(
                                      "Amenities",
                                      style: TextStyle(
                                        color: lineColor,
                                        fontSize: ScreenUtil().setHeight(14),
                                        letterSpacing: 1.0,
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(1),
                                    left: ScreenUtil().setWidth(10)),
                                child: GridView.builder(
                                  padding: EdgeInsets.all(5),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 5.5,
                                    crossAxisCount:
                                        2, // number of items in each row
                                    mainAxisSpacing: 2, // spacing between rows
                                    crossAxisSpacing:
                                        2, // spacing between columns
                                  ),
                                  itemCount: details![0].amenities!.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  //    scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    return _buildAmenititesList(i);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(15),
                              right: ScreenUtil().setWidth(15),
                              bottom: ScreenUtil().setHeight(10),
                              top: ScreenUtil().setHeight(10)),
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(15),
                              right: ScreenUtil().setWidth(15),
                              bottom: ScreenUtil().setHeight(20),
                              top: ScreenUtil().setHeight(20)),
                          width: ScreenUtil().screenWidth,
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(10)),
                                    // width: ScreenUtil().setWidth(200),
                                    child: Text(
                                      "Own this property from just",
                                      style: TextStyle(
                                        color: lineColor,
                                        fontSize: ScreenUtil().setHeight(13),
                                        fontFamily: 'work',
                                        letterSpacing: .5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setWidth(5),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(1),
                                        left: ScreenUtil().setWidth(10)),
                                    // width: ScreenUtil().setWidth(200),
                                    child: Row(
                                      children: [
                                        Text(
                                          "AED 155,000",
                                          style: TextStyle(
                                            color: darkTextColor,
                                            fontSize:
                                                ScreenUtil().setHeight(16),
                                            fontFamily: 'work',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(10),
                                        ),
                                        Text(
                                          "AED/month",
                                          style: TextStyle(
                                            color: darkTextColor,
                                            fontSize:
                                                ScreenUtil().setHeight(13),
                                            fontFamily: 'work',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setWidth(4),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(1),
                                        left: ScreenUtil().setWidth(10)),
                                    // width: ScreenUtil().setWidth(200),
                                    child: Text(
                                      "Fixed rates from 4.24%",
                                      style: TextStyle(
                                        color: lineColor,
                                        fontSize: ScreenUtil().setHeight(11),
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(5),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(175),
                                height: ScreenUtil().setHeight(35),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: RoundedButton(
                                    text: 'Get pre-approved',
                                    press: () {},
                                    color: appColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(15),
                              right: ScreenUtil().setWidth(15),
                              bottom: ScreenUtil().setHeight(10),
                              top: ScreenUtil().setHeight(5)),
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(15),
                              right: ScreenUtil().setWidth(15),
                              bottom: ScreenUtil().setHeight(10),
                              top: ScreenUtil().setHeight(10)),
                          width: ScreenUtil().screenWidth,
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //property INfo

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: ScreenUtil().setWidth(250),
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(10)),
                                    // width: ScreenUtil().setWidth(200),
                                    child: Text(
                                      "Key Information",
                                      style: TextStyle(
                                        color: lineColor,
                                        fontSize: ScreenUtil().setHeight(14),
                                        letterSpacing: 1.0,
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(1),
                                    left: ScreenUtil().setWidth(10)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: ScreenUtil().setHeight(100),
                                          child: Text(
                                            "Reference",
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setHeight(12),
                                        ),
                                        Container(
                                          width: ScreenUtil().setHeight(100),
                                          child: Text(
                                            "ES-1003747",
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.bold,
                                            ),
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
                                        Container(
                                          width: ScreenUtil().setHeight(100),
                                          child: Text(
                                            "Listed",
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setHeight(12),
                                        ),
                                        Container(
                                          width: ScreenUtil().setHeight(100),
                                          child: Text(
                                            "11 JUL 2023",
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.bold,
                                            ),
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
                                        Container(
                                          width: ScreenUtil().setHeight(100),
                                          child: Text(
                                            "Broker ORN",
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setHeight(12),
                                        ),
                                        Container(
                                          width: ScreenUtil().setWidth(150),
                                          child: Text(
                                            "936",
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.bold,
                                            ),
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
                                        Container(
                                          width: ScreenUtil().setHeight(100),
                                          child: Text(
                                            "Agent BRN",
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setHeight(12),
                                        ),
                                        Container(
                                          width: ScreenUtil().setWidth(150),
                                          child: Text(
                                            "53032",
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.bold,
                                            ),
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
                                        Container(
                                          width: ScreenUtil().setHeight(100),
                                          child: Text(
                                            "DLD Permit Number",
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setHeight(12),
                                        ),
                                        Container(
                                          width: ScreenUtil().setWidth(150),
                                          child: Text(
                                            "530325656",
                                            style: TextStyle(
                                              color: lineColor,
                                              fontSize:
                                                  ScreenUtil().setHeight(12),
                                              letterSpacing: .2,
                                              fontFamily: 'work',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(15),
                              right: ScreenUtil().setWidth(15),
                              bottom: ScreenUtil().setHeight(10),
                              top: ScreenUtil().setHeight(5)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Recommended properties",
                                    style: TextStyle(
                                      color: lineColor,
                                      fontSize: ScreenUtil().setHeight(14),
                                      letterSpacing: 1.0,
                                      fontFamily: 'work',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setWidth(12),
                              ),
                              _buildPropertyList(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(
                        bottom: ScreenUtil().setHeight(135),
                        right: ScreenUtil().setWidth(15)),
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /* GestureDetector(
                      onTap: () {
                        isLiked(details![0].id, details![0]);
                      },
                      child:   Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                              height: ScreenUtil().setHeight(30),
                              width: ScreenUtil().setHeight(30),
                              color: appColor,
                              child: Icon(
                                  !details![0].liked!
                                      ? Icons.favorite_border
                                      : Icons.favorite,
                                  size: ScreenUtil().setHeight(15),
                                  color: details![0].liked!
                                      ? Colors.red
                                      : secondaryColor)),
                        ),
                      )),*/
                        SizedBox(
                          height: ScreenUtil().setHeight(30),
                        ),
                        GestureDetector(
                          onTap: () {
                            _callENquiryAPI(details![0].id.toString(), "phone");
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                  height: ScreenUtil().setHeight(40),
                                  width: ScreenUtil().setHeight(40),
                                  color: appColor,
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setHeight(13)),
                                    child: Image.asset("assets/images/call.png",
                                        height: ScreenUtil().setHeight(15),
                                        width: ScreenUtil().setHeight(15),
                                        color: secondaryColor),
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(5),
                        ),
                        GestureDetector(
                          onTap: () {
                            _callENquiryAPI(details![0].id.toString(), "mail");
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                  height: ScreenUtil().setHeight(40),
                                  width: ScreenUtil().setHeight(40),
                                  color: appColor,
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setHeight(13)),
                                    child: Image.asset("assets/images/mail.png",
                                        height: ScreenUtil().setHeight(15),
                                        width: ScreenUtil().setHeight(15),
                                        color: secondaryColor),
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(5),
                        ),
                        GestureDetector(
                          onTap: () {
                            _callENquiryAPI(
                                details![0].id.toString(), "whatsapp");
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                  height: ScreenUtil().setHeight(40),
                                  width: ScreenUtil().setHeight(40),
                                  color: Color(0xff00CA7D),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setHeight(13)),
                                    child: Image.asset(
                                        "assets/images/whatsapp.png",
                                        height: ScreenUtil().setHeight(15),
                                        width: ScreenUtil().setHeight(15),
                                        color: secondaryColor),
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(30),
                        ),
                      ],
                    ))
              ],
            ),
    );
  }

  Widget _buildList(int i) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(1), left: ScreenUtil().setWidth(8)),
            padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(5),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_circle_right,
                  color: appColor,
                  size: ScreenUtil().setHeight(18),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(5),
                ),
                Container(
                  width: ScreenUtil().setWidth(155),
                  child: Text(
                    details![0].vilaFeature![i],
                    style: TextStyle(
                      color: lineColor,
                      fontSize: ScreenUtil().setWidth(12),
                      fontFamily: 'work',
                      letterSpacing: .7,
                      height: ScreenUtil().setWidth(1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenititesList(int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(2)),
          height: ScreenUtil().setHeight(25),
          child: Row(
            children: [
              Icon(
                Icons.arrow_circle_right,
                color: appColor,
                size: ScreenUtil().setHeight(14),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(5),
              ),
              Text(
                details![0].amenities![i].name!,
                style: TextStyle(
                  color: lineColor,
                  fontSize: ScreenUtil().setHeight(12),
                  letterSpacing: .2,
                  fontFamily: 'work',
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyList() {
    return Container(
      height: ScreenUtil().setHeight(255),
      child: ListView.builder(
        itemCount: proppertyList!.length,
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
      onTap: () {},
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
                decoration: proppertyList![i].images != null
                    ? BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                proppertyList![i].images![0].image!),
                            fit: BoxFit.cover),
                        border: Border.all(color: secondaryColor, width: 0.2),
                      )
                    : BoxDecoration(
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
                                    isLiked1(proppertyList![i].id,
                                        proppertyList![0]);
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
                                              !proppertyList![i].liked!
                                                  ? Icons
                                                  .favorite_border
                                                  : Icons.favorite,
                                              size: ScreenUtil()
                                                  .setHeight(15),
                                              color:
                                              proppertyList![i].liked!
                                                  ? Colors.red
                                                  : lineColor)),
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
                                          proppertyList![i].propertyName!,
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
                                          "C203",
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
                                          proppertyList![i].propertyAddress!=null?proppertyList![i].propertyAddress!:"UAE,Dabai",
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
                              color: appColor,
                              width: ScreenUtil().setWidth(18)),
                          SizedBox(
                            width: ScreenUtil().setWidth(5),
                          ),
                          Text(
                            proppertyList![i].bedroomCount.toString(),
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
                              color: appColor,
                              width: ScreenUtil().setWidth(18)),
                          SizedBox(
                            width: ScreenUtil().setWidth(5),
                          ),
                          Text(
                            proppertyList![i].bathroomCount.toString(),
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
                            "${proppertyList![i].propertySize.toString()} sqft",
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
                          _callENquiryAPI(
                              proppertyList![i].id.toString(), "phone");
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
                                    height: ScreenUtil().setHeight(15),
                                    color: appColor,
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
                          _callENquiryAPI(
                              proppertyList![0].id.toString(), "mail");
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
                                    height: ScreenUtil().setHeight(15),
                                    color: appColor,
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
                          _callENquiryAPI(
                              proppertyList![0].id.toString(), "whatsapp");
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

  Future<void> getPropertyDetailsAPI() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoadingD = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/property_by_id',
    );
    Map<String, dynamic> body = {
      'property_id': widget.property_id,
    };
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await post(uri, headers: headers, body: body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("PropResposne::$responseBody");
    if (statusCode == 200) {
      if (mounted == true) {
        setState(() {
          isLoadingD = false;
        });
      }
      if (getdata["status"]) {
        getPropertyDetails =
            GetPropertyDetails.fromJson(jsonDecode(responseBody));
        details!.addAll(getPropertyDetails.data!);
        details!.forEach((element) {
          images!.addAll(element.images!);

        });
      } else {}
    }
  }

  Future<void> isLiked(int? id, PropertyDetails propertyList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();


    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/property_like',
    );
    Map<String, dynamic> body = {
      'property_id': id.toString(),
    };
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await post(uri, headers: headers, body: body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("PropResposne::$responseBody");
    if (statusCode == 200) {
      if (mounted == true) {
        setState(() {
          if (propertyList.liked!) {
            propertyList.liked = false;
          } else {
            propertyList.liked = true;
          }
        });
      }
      if (getdata["status"]) {
      } else {}
    }
  }

  Future<void> isLiked1(
    int? id,
      TredingPropertyList propertyList,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();


    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/property_like',
    );
    Map<String, dynamic> body = {
      'property_id': id.toString(),
    };
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await post(uri, headers: headers, body: body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("PropResposne::$responseBody");
    if (statusCode == 200) {
      if (mounted == true) {
        setState(() {
          if (propertyList.liked!) {
            propertyList.liked = false;
          } else {
            propertyList.liked = true;
          }
        });
      }
      if (getdata["status"]) {
      } else {}
    }
  }

  void _launchCall(CreatedBy? createdBy) {
    launch("tel://${createdBy!.mobileNumber!}");
  }

  void _launchMail(CreatedBy? createdBy) {
    launch("mailto:${createdBy!.email!}");
  }

  whatsapp(CreatedBy? createdBy, PropertyDetails propertyList) async {
    var contact = "${createdBy!.mobileNumber!}";
    var androidUrl =
        "whatsapp://send?phone=$contact&text=Hi, I need To know More about ${propertyList.propertyName} this property and its Location is ${propertyList.propertyAddress}";
    var iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Hi,  I need To know More about ${propertyList.propertyName} this property and its Location is ${propertyList.propertyAddress}')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      Message(context, "oops! you didn't install whatsapp yet");
    }
  }

  Future<void> _callENquiryAPI(String id, String type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/addenquiry',
    );
    Map<String, dynamic> body = {'property_id': id.toString(), 'type': type};
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await post(uri, headers: headers, body: body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("EnquiryResposne::$responseBody");
    if (statusCode == 200) {
      if (mounted == true) {
        setState(() {
          isloading = false;
        });
        if (type == "phone") {
          _launchCall(details![0].createdBy!);
        } else if (type == "mail") {
          _launchMail(details![0].createdBy!);
        } else {
          whatsapp(details![0].createdBy!, details![0]);
        }
      }
      if (getdata["status"]) {
      } else {}
    }
  }

  Future<void> getPropertyAPI(String id) async {
    proppertyList!.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/getproperty',
    );
    Map<String, dynamic> body = {
      'pagenumber': "1",
      'limit': "20",
      'category_id': id,
    };
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await post(uri, headers: headers, body: body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("PropResposne::$responseBody");
    if (statusCode == 200) {
      if (mounted == true) {
        setState(() {
          isloading = false;
        });
      }
      if (getdata["status"]) {
        getPropertyData =
            GetTredingPropertyData.fromJson(jsonDecode(responseBody));
        proppertyList!.addAll(getPropertyData.data!);
      } else {}
    }
  }
}
