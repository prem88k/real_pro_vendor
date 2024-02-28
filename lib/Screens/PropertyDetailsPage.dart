import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';

import '../Constants/Api.dart';
import '../Constants/Colors.dart';
import '../Models/GetPropertyData.dart';
import '../Models/GetPropertyDetailsData.dart';
import '../Presentation/CommentSheet.dart';
import '../Presentation/PagerState.dart';

enum UrlType { IMAGE, VIDEO, UNKNOWN }

class PropertyDetailsPage extends StatefulWidget {
  PropertyDetailsPage(this.property_id, this.video);

  String property_id;
  String video;

  @override
  State<PropertyDetailsPage> createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  bool isloading = false;
  bool isLoadingD = false;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late GetPropertyDetails getPropertyDetails;
  List<PropertyDetails>? details = [];
  List<ImagesList>? images = [];
  List<String>? imagesList = [];
  Completer<GoogleMapController> _controller11 = Completer();

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  late BitmapDescriptor customIcon;

  // list of locations to display polylines

  List<LatLng> latLenCo = [];
  List<LatLng> latLengates = [];
  List<PropertyList>? proppertyList = [];
  late GetPropertyData getPropertyData;
  PageController? controller1;
  final StreamController<PagerState> pagerStreamController =
  StreamController<PagerState>.broadcast();

  @override
  void initState() {
    // TODO: implement initState
    getPropertyDetailsAPI();
    latLenCo.add(LatLng(23.5, 25.5));
    _markers.add(
      // added markers
      Marker(
        markerId: MarkerId("1"),
        position: LatLng(23.5, 25.5),
        infoWindow: InfoWindow(
          title: 'RealPro',
          snippet: 'Property',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    getPropertyAPI("0");
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.video,
      ),
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    controller1 =
        PageController(viewportFraction: 0.9, initialPage: 0, keepPage: true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: isLoadingD && details!.length < 0
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
                    color: primaryColor,
                    height: ScreenUtil().setHeight(250),
                    child: Stack(
                      children: [
                        details != null || details!.length != 0
                            ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imagesList!.length,
                          controller: controller1,
                          itemBuilder:
                              (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(10)),
                              child: Stack(
                                children: [
                                  if (getUrlType(imagesList![index]) ==
                                      UrlType.IMAGE) images != null
                                      ? Container(

                                    height: ScreenUtil()
                                        .setHeight(250),
                                    width: MediaQuery.of(
                                        context)
                                        .size
                                        .width,
                                    decoration:
                                    BoxDecoration(
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              imagesList![
                                              index]),
                                          fit: BoxFit
                                              .fill),
                                    ),
                                  )
                                      : Container(
                                    height: ScreenUtil()
                                        .setHeight(250),
                                    width: MediaQuery.of(
                                        context)
                                        .size
                                        .width,
                                    decoration:
                                    BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/property_img.png"),
                                          fit: BoxFit
                                              .cover),
                                      border: Border.all(
                                          color:
                                          secondaryColor,
                                          width: 0.2),
                                    ),
                                  ) else Container(
                                    width:  ScreenUtil().setWidth(360),
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: [
                                        FutureBuilder(
                                          future:
                                          _initializeVideoPlayerFuture,
                                          builder: (context,
                                              snapshot) {
                                            if (snapshot
                                                .connectionState ==
                                                ConnectionState
                                                    .done) {
                                              return FittedBox(
                                                fit: BoxFit.cover,
                                                child: SizedBox(
                                                  height:  _controller.value.size.height ?? 0,
                                                  width: _controller.value.size.width ?? 0,
                                                  child: Stack(
                                                    children: [
                                                      VideoPlayer( _controller),
                                                      Center(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(
                                                                    () {
                                                                  // pause
                                                                  if (_controller
                                                                      .value
                                                                      .isPlaying) {
                                                                    _controller
                                                                        .pause();
                                                                  } else {
                                                                    // play
                                                                    _controller
                                                                        .play();
                                                                  }
                                                                });
                                                          },
                                                          child: Container(
                                                              width: ScreenUtil().screenWidth,
                                                              alignment: Alignment.center,
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets.all(8.0),
                                                                child:
                                                                ClipRRect(
                                                                  borderRadius:
                                                                  BorderRadius.circular(100),
                                                                  child: Container(
                                                                      height: ScreenUtil().setHeight(100),
                                                                      width: ScreenUtil().setHeight(100),
                                                                      color: Colors.black.withOpacity(0.5),
                                                                      child: Center(
                                                                          child: Icon(
                                                                            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                                                            color: secondaryColor,
                                                                            size: ScreenUtil().setHeight(50),
                                                                          ))),
                                                                ),
                                                              )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Center(
                                                  child:
                                                  CircularProgressIndicator());
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                            : Container(),
                        Container(
                            width:
                            MediaQuery.of(context).size.width * 0.9,
                            padding: EdgeInsets.only(
                                bottom: ScreenUtil().setWidth(15),
                                left: ScreenUtil().setWidth(15)),
                            alignment: Alignment.bottomLeft,
                            child: SmoothPageIndicator(
                              controller: controller1!,
                              count: imagesList!.length,
                              effect: ExpandingDotsEffect(
                                  expansionFactor: 3,
                                  strokeWidth: .5,
                                  spacing: 3.0,
                                  radius: 2.0,
                                  dotWidth: 5.0,
                                  dotHeight: 5.0,
                                  dotColor: borderColor,
                                  activeDotColor: secondaryColor),
                            )),
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
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(
                                                          context);
                                                      _controller.pause();
                                                      _controller.dispose();

                                                    },
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .all(8.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            100),
                                                        child: Container(
                                                            height: ScreenUtil()
                                                                .setHeight(
                                                                30),
                                                            width: ScreenUtil()
                                                                .setHeight(
                                                                30),
                                                            color:
                                                            secondaryColor,
                                                            child: Center(
                                                                child:
                                                                Icon(
                                                                  Icons
                                                                      .arrow_back_ios_new,
                                                                  color:
                                                                  lineColor,
                                                                  size: ScreenUtil()
                                                                      .setHeight(
                                                                      11),
                                                                ))),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: ScreenUtil()
                                                        .setWidth(5),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _onShare1(
                                                context,
                                                details![0],
                                                "For ${details![0].purpose!}: ${details![0].propertyType!} in ${details![0].propertyName!} in ${details![0].area!}, ${details![0].city!}.",
                                              );
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
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    child: Center(
                                                      child: Image.asset(
                                                        "assets/images/share.png",
                                                        height:
                                                        ScreenUtil()
                                                            .setHeight(
                                                            22),
                                                        width: ScreenUtil()
                                                            .setHeight(
                                                            22),
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          ),

                                          //fav
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                        ScreenUtil().setHeight(30),
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
                          bottom: ScreenUtil().setHeight(0),
                          left: ScreenUtil().setWidth(15),
                          right: ScreenUtil().setWidth(15)),
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              isLiked(details![0].id, details![0]);
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: secondaryColor,
                              ),
                              width: ScreenUtil().setWidth(95),
                              height: ScreenUtil().setHeight(32),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        height:
                                        ScreenUtil().setHeight(26),
                                        width: ScreenUtil().setHeight(26),
                                        child: Icon(
                                          !details![0].liked!
                                              ? Icons.favorite_border
                                              : Icons.favorite,
                                          color: !details![0].liked!
                                              ? appColor
                                              : Colors.red,
                                          size:
                                          ScreenUtil().setHeight(16),
                                        )),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(0),
                                    ),
                                    Text(
                                      "Likes ( ${details![0].like!.toString()} ) ",
                                      style: TextStyle(
                                        color: darkTextColor,
                                        fontSize:
                                        ScreenUtil().setWidth(12),
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(15),),
                          GestureDetector(
                            onTap: () {
                              /*     MyBottomSheet(
                                            details![0].comment, details![0].id).show(context);*/

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => MyBottomSheet(
                                        details![0].comment,
                                        details![0].id,"details",widget.video)),
                              );

                              //_commentBottomSheet(proppertyList![i].comment);
                              //       new MyBottomSheet(proppertyList![i].comment,proppertyList![i].id).show(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: secondaryColor,
                              ),
                              width: ScreenUtil().setWidth(125),
                              height: ScreenUtil().setHeight(32),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: ScreenUtil().setWidth(6),
                                    ),
                                    Container(
                                        height:
                                        ScreenUtil().setHeight(26),
                                        width: ScreenUtil().setHeight(26),
                                        child: Icon(
                                          Icons.chat_bubble_outline,
                                          color: appColor,
                                          size:
                                          ScreenUtil().setHeight(14),
                                        )),
                                    Text(
                                      "Comments ( ${details![0].totalComment} )",
                                      style: TextStyle(
                                        color: darkTextColor,
                                        fontSize:
                                        ScreenUtil().setWidth(10),
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: ScreenUtil().setWidth(0),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(15),
                        right: ScreenUtil().setWidth(15),
                        bottom: ScreenUtil().setHeight(10),
                        top: ScreenUtil().setHeight(10)),
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(15),
                        right: ScreenUtil().setWidth(8),
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
                                  top: ScreenUtil().setHeight(4),
                                  left: ScreenUtil().setWidth(10)),
                              // width: ScreenUtil().setWidth(200),
                              child: Row(
                                children: [
                                  Text(
                                    "AED ${formatAmount(details![0].price.toString())}",
                                    style: TextStyle(
                                      color: darkTextColor,
                                      fontSize:
                                      ScreenUtil().setHeight(15),
                                      fontFamily: 'workdark',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  details![0].purpose == "Rent" ||
                                      details![0].purpose == "rent"
                                      ? Text(
                                    "  Monthly",
                                    style: TextStyle(
                                      color: darkTextColor,
                                      fontSize: ScreenUtil()
                                          .setHeight(12),
                                      fontFamily: 'work',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                      : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(8),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: ScreenUtil().screenWidth -
                                  ScreenUtil().setWidth(64),
                              margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(10)),
                              // width: ScreenUtil().setWidth(200),
                              child: Text(
                                "For ${details![0].purpose!}: ${details![0].propertyType!} in ${details![0].tower!=null?details![0].tower!:""}, ${details![0].area!}, ${details![0].city!} ",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: ScreenUtil().setHeight(11),
                                  fontFamily: 'work',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        /*                              SizedBox(
                                height: ScreenUtil().setHeight(2.5),
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
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),*/
                        SizedBox(
                          height: ScreenUtil().setHeight(8),
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
                                  Container(
                                    height: ScreenUtil().setHeight(22),
                                    child: Center(
                                      child: Image.asset("assets/images/bed.png",
                                          height: ScreenUtil().setHeight(20),
                                          width: ScreenUtil().setWidth(25)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(5),
                                  ),
                                  Container(
                                    height: ScreenUtil().setHeight(22),
                                    child: Center(
                                      child: Text(
                                        details![0].bedroomCount.toString(),
                                        style: TextStyle(
                                          color: darkTextColor,
                                          fontSize: ScreenUtil().setWidth(12),
                                          fontFamily: 'work',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
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
                                Container(
                                  height: ScreenUtil().setHeight(22),
                                  child: Center(
                                    child: Image.asset("assets/images/bath.png",
                                        height: ScreenUtil().setHeight(17),
                                        width: ScreenUtil().setWidth(19)),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(5),
                                ),
                                Container(
                                  height: ScreenUtil().setHeight(22),
                                  child: Center(
                                    child: Text(
                                      details![0].bathroomCount.toString(),
                                      style: TextStyle(
                                        color: darkTextColor,
                                        fontSize: ScreenUtil().setWidth(12),
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(12),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: ScreenUtil().setHeight(22),
                                  child: Center(
                                    child: Image.asset("assets/images/crop.png",
                                        height: ScreenUtil().setHeight(17),
                                        width: ScreenUtil().setWidth(19)),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(5),
                                ),
                                Container(
                                  height: ScreenUtil().setHeight(22),
                                  child: Center(
                                    child: Text(
                                      details![0].propertySize != null
                                          ? "${details![0].propertySize} sq.ft."
                                          : "2300 sq.ft.",
                                      style: TextStyle(
                                        color: darkTextColor,
                                        fontSize: ScreenUtil().setWidth(12),
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(12),
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
                                details![0].propertyName != null
                                    ? details![0].propertyName!
                                    : "2 BR single row villa | ready to occupy | Book for viewing",
                                style: TextStyle(
                                  color: lineColor,
                                  fontSize: ScreenUtil().setHeight(15),
                                  letterSpacing: 0.4,
                                  fontFamily: 'workdark',
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
                                  top: ScreenUtil().setHeight(10),
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
                                  fontSize: ScreenUtil().setHeight(15),
                                  letterSpacing: 0.2,
                                  fontFamily: 'workdark',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(13),
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

                              details![0].type!="Villa" ? SizedBox(
                                height: ScreenUtil().setHeight(5),
                              ):Container(),

                              details![0].type == "Villa" ||
                                  details![0].type == "Townhouse" ||
                                  details![0].type == "Bungalow"?Container(): Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: ScreenUtil().setHeight(100),
                                    child: Text(
                                      "Floor",
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
                                      details![0].floor!=null?details![0].floor!:"-",
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
                                      "Property Name",
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
                                      details![0].propertyName!,
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
                                      "Area",
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
                                      details![0].area!,
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
                                      "City",
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
                                      details![0].city!,
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
                                      DateFormat('dd-MM-yyyy').format( DateTime.parse(details![0].createdAt!)),
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
                                  fontFamily: 'workdark',
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


                  /* Container(
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
                        ),*/
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
                                "Agent Information",
                                style: TextStyle(
                                  color: lineColor,
                                  fontSize: ScreenUtil().setHeight(14),
                                  letterSpacing: 0.4,
                                  fontFamily: 'workdark',
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
                                      "Agent Name",
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
                                      details![0].createdBy!.name!,
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
                                      details![0].createdBy!.agentBrn !=
                                          null
                                          ? details![0]
                                          .createdBy!
                                          .agentBrn!
                                          : "-",
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
                                      "Company Name",
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
                                      details![0]
                                          .createdBy!
                                          .companyName !=
                                          null
                                          ? details![0]
                                          .createdBy!
                                          .companyName!
                                          : "-",
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
                                      details![0].createdBy!.brokerOrn !=
                                          null
                                          ? details![0]
                                          .createdBy!
                                          .brokerOrn!
                                          : "-",
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

                              /*SizedBox(
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
*/
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //add floting
        ],
      ),
    );
  }

  Widget _buildList(int i) {
    return details![0].vilaFeature![i] != ""
        ? Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(1),
                left: ScreenUtil().setWidth(8)),
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        : Container();
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




  Future<void> getPropertyDetailsAPI() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoadingD = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/api/user/property_by_id',
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
          imagesList!.add(element.thamblain!);
          images!.addAll(element.images!);
          element.images!.forEach((element) {
            imagesList!.add(element.image!);
          });
          images!.forEach((element) {
            print("----images----");
            print(getUrlType(element.image!));
          });
        });
      } else {}
    }
  }

  Future<void> isLiked(int? id, PropertyDetails propertyList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var uri = Uri.https(
      apiBaseUrl,
      '/api/user/property_like',
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
            propertyList.like = propertyList.like! - 1;
          } else {
            propertyList.liked = true;
            propertyList.like = propertyList.like! + 1;
          }
        });
      }
      if (getdata["status"]) {
      } else {}
    }
  }

  Future<void> isLiked1(
      int? id,
      PropertyList propertyList,
      ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var uri = Uri.https(
      apiBaseUrl,
      '/api/user/property_like',
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
            propertyList.like = propertyList.like! - 1;
          } else {
            propertyList.liked = true;
            propertyList.like = propertyList.like! + 1;
          }
        });
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
      '/api/user/getproperty',
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
        getPropertyData = GetPropertyData.fromJson(jsonDecode(responseBody));
        proppertyList!.addAll(getPropertyData.data!);
      } else {}
    }
  }

  Future<void> isCollect(int? id, PropertyDetails propertyList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var uri = Uri.https(
      apiBaseUrl,
      '/api/user/property_add_collect',
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
          if (propertyList.collected!) {
            propertyList.collected = false;
          } else {
            propertyList.collected = true;
          }
        });
      }
      if (getdata["status"]) {
      } else {}
    }
  }

  Future<void> isCollect1(int? id, PropertyList propertyList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var uri = Uri.https(
      apiBaseUrl,
      '/api/user/property_add_collect',
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
          if (propertyList.collected!) {
            propertyList.collected = false;
          } else {
            propertyList.collected = true;
          }
        });
      }
      if (getdata["status"]) {
      } else {}
    }
  }

  void _onShare(
      BuildContext context, PropertyList reelsList, String title) async {
    final response = await get(Uri.parse(reelsList.images![0].image!));
    final directory = await getTemporaryDirectory();
    File file = await File('${directory.path}/Image.png')
        .writeAsBytes(response.bodyBytes);

    await Share.shareXFiles([XFile(file.path)], text: title);
    /*   final box = context.findRenderObject() as RenderBox?;
    await Share.share(title,
        subject: file.path,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);*/
  }

  void _onShare1(
      BuildContext context, PropertyDetails reelsList, String title) async {
    final response = await get(Uri.parse(reelsList.images![0].image!));
    final directory = await getTemporaryDirectory();
    File file = await File('${directory.path}/Image.png')
        .writeAsBytes(response.bodyBytes);

    await Share.shareXFiles([XFile(file.path)], text: title);
    /*   final box = context.findRenderObject() as RenderBox?;
    await Share.share(title,
        subject: file.path,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);*/
  }

  String formatAmount(String id) {
    String price = id;
    String priceInText = "";
    int counter = 0;
    for (int i = (price.length - 1); i >= 0; i--) {
      counter++;
      String str = price[i];
      if ((counter % 3) != 0 && i != 0) {
        priceInText = "$str$priceInText";
      } else if (i == 0) {
        priceInText = "$str$priceInText";
      } else {
        priceInText = ",$str$priceInText";
      }
    }
    return priceInText.trim();
  }
}

UrlType getUrlType(String url) {
  Uri uri = Uri.parse(url);
  String typeString = uri.path.substring(uri.path.length - 3).toLowerCase();
  if (typeString == "jpg") {
    return UrlType.IMAGE;
  }
  if (typeString == "mp4") {
    return UrlType.VIDEO;
  } else {
    return UrlType.UNKNOWN;
  }
}
