import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constants/Api.dart';
import '../Constants/Colors.dart';
import '../Models/GetCaategoryData.dart';
import '../Models/GetPropertyData.dart';
import 'LoginPageVendor.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  int? selectedIndex = -1;
  late GecategoryData gecategoryData;
  List<CategoryList>? catList = [];
  bool isloading = false;
  List<PropertyList>? proppertyList = [];
  late GetPropertyData getPropertyData;
  bool catloading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
    getPropertyAPI("0");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F6F8),
      body: isloading || catloading?Center(child: CircularProgressIndicator(color: appColor,)):Container(
        margin: EdgeInsets.only(
            top: ScreenUtil().setHeight(45),
            left: ScreenUtil().setWidth(15),
            right: ScreenUtil().setWidth(15)),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                      // add your code here.
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SearchPage(
                              );
                            //WelcomeLoginPage();
                          },
                        ),
                      );*/

                  },
                  child: Container(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                    height: ScreenUtil().setHeight(38),
                    width: ScreenUtil().setWidth(275),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: secondaryColor,
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Color(0xff05122B),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(12),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: ScreenUtil().setWidth(4)),
                            child: Text(
                              "Search city, building, location ",
                              style: TextStyle(
                                  fontFamily: 'work',
                                  fontSize: ScreenUtil().setHeight(12),
                                  fontWeight: FontWeight.normal,
                                  color: primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(12),
                ),
                Container(
                  height: ScreenUtil().setHeight(38),
                  width: ScreenUtil().setHeight(38),
                  child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: primaryColor,
                      ),
                      width: ScreenUtil().setHeight(30),
                      height: ScreenUtil().setHeight(30),
                      child: Image.asset("assets/images/filter.png")),
                )
              ],
            ),
            SizedBox(
              height: ScreenUtil().setHeight(15),
            ),
            _buildCatList(),
            SizedBox(
              height: ScreenUtil().setHeight(15),
            ),
            _buildPropertyList(),
          ],
        ),
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
        getPropertyAPI(catList![i].id.toString());
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

  Widget _buildPropertyList() {
    return Expanded(
      child: ListView.builder(
        itemCount: proppertyList!.length,
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        itemBuilder: (context, i) {
          return _buildProList(i);
        },
      ),
    );
  }

  Widget _buildProList(int i) {
    return proppertyList!.length == 0
        ? Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(55)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/nodata.png",
                  height: ScreenUtil().setHeight(130),
                  width: ScreenUtil().setWidth(130),
                  fit: BoxFit.contain,
                ),
                Text(
                  "No Property Data found",
                  style: TextStyle(
                    color: lineColor,
                    fontSize: ScreenUtil().setWidth(14),
                    fontFamily: 'work',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        : GestureDetector(
            onTap: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PropertyDetailsPage(proppertyList![i].id.toString());
                  },
                ),
              );*/
            },
            child: Container(
              margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(15)),
              decoration: BoxDecoration(
                  color: secondaryColor,
                  border: Border.all(color: secondaryColor, width: 0.2),
                  borderRadius: BorderRadius.circular(10.0)),
              height: ScreenUtil().setHeight(235),
              child: Column(
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.grey.shade100,
                      BlendMode.darken,
                    ),
                    child: Container(
                      height: ScreenUtil().setHeight(160),
                      decoration: proppertyList![i].images != null
                          ? BoxDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(proppertyList![i].images![0].image!,),
                                  fit: BoxFit.cover),
                              border:
                                  Border.all(color: secondaryColor, width: 0.2),
                              borderRadius: BorderRadius.circular(5.0))
                          : BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/property_img.png"),
                                  fit: BoxFit.cover),
                              border:
                                  Border.all(color: secondaryColor, width: 0.2),
                              borderRadius: BorderRadius.circular(5.0)),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Container(
                                              height:
                                                  ScreenUtil().setHeight(26),
                                              width: ScreenUtil().setWidth(80),
                                              color: Color(0xffFFE500),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      "assets/images/verified.png",
                                                      height: ScreenUtil()
                                                          .setHeight(14),
                                                      width: ScreenUtil()
                                                          .setWidth(18)),
                                                  SizedBox(
                                                    width: ScreenUtil()
                                                        .setWidth(5),
                                                  ),
                                                  Text(
                                                    "Verified",
                                                    style: TextStyle(
                                                      color: appColor,
                                                      fontSize: ScreenUtil()
                                                          .setWidth(12),
                                                      fontFamily: 'work',
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          isLiked(proppertyList![i].id,
                                              proppertyList![i]);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Container(
                                                height:
                                                    ScreenUtil().setHeight(26),
                                                width:
                                                    ScreenUtil().setHeight(26),
                                                color: secondaryColor,
                                                child: Icon(
                                                  !proppertyList![i].liked!
                                                      ? Icons.favorite_border
                                                      : Icons.favorite,
                                                  color:
                                                      !proppertyList![i].liked!
                                                          ? Color(0xff1C1B1F)
                                                          : Colors.red,
                                                  size: ScreenUtil()
                                                      .setHeight(14),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                proppertyList![i].propertyName!,
                                                style: TextStyle(
                                                  color: secondaryColor,
                                                  fontSize:
                                                      ScreenUtil().setWidth(12),
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
                                                  fontSize:
                                                      ScreenUtil().setWidth(15),
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
                                                proppertyList![i]
                                                            .propertyAddress !=
                                                        null
                                                    ? proppertyList![i]
                                                        .propertyAddress!
                                                    : "Dubai , UAE",
                                                style: TextStyle(
                                                  color: secondaryColor,
                                                  fontSize:
                                                      ScreenUtil().setWidth(12),
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
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(10),
                        right: ScreenUtil().setWidth(10)),
                    child: Column(
                      children: [
                        Row(
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
                                    color: appColor,
                                    width: ScreenUtil().setWidth(18)),
                                SizedBox(
                                  width: ScreenUtil().setWidth(5),
                                ),
                                Text(
                                  proppertyList![i].propertySize != null
                                      ? proppertyList![i].propertySize!.toString() +
                                          " SQFT"
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
                        SizedBox(
                          height: ScreenUtil().setHeight(10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _callENquiryAPI(proppertyList![0], "phone");
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
                            GestureDetector(
                              onTap: () {
                                _callENquiryAPI(proppertyList![0], "mail");
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
                            GestureDetector(
                              onTap: () {
                                _callENquiryAPI(proppertyList![0], "Whatsapp");
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
      if (mounted == true) {

      }
      if (getdata["status"]) {
        gecategoryData = GecategoryData.fromJson(jsonDecode(responseBody));
        catList!.addAll(gecategoryData.data!);
      } else {}
    }
    else
      {
        setState(() {
          catloading = false;
        });
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
        getPropertyData = GetPropertyData.fromJson(jsonDecode(responseBody));
        proppertyList!.addAll(getPropertyData.data!);
      } else {}
    }
  }

  Future<void> isLiked(int? id, PropertyList propertyList) async {
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

  whatsapp(CreatedBy? createdBy, PropertyList propertyList) async {
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

  Future<void> _callENquiryAPI(PropertyList propertyList, String type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/addenquiry',
    );
    Map<String, dynamic> body = {
      'property_id': propertyList.id.toString(),
      'type': type
    };
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
          _launchCall(propertyList.createdBy!);
        } else if (type == "mail") {
          _launchMail(propertyList.createdBy!);
        } else {
          whatsapp(propertyList.createdBy!, propertyList);
        }
      }
      if (getdata["status"]) {
      } else {}
    }
  }
}
