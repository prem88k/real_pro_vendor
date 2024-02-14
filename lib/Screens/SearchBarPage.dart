import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constants/Api.dart';
import '../Constants/Colors.dart';
import '../Models/GetPropertyData.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../Presentation/CommentSheet.dart';
import 'PropertyDetailsPage.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool isloading = false;
  PageController? controller1 =
  PageController(viewportFraction: 0.9, initialPage: 0, keepPage: true);
  List<PropertyList>? proppertyList = [];
  late GetPropertyData getPropertyData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F6F8),

      appBar: AppBar(
        backgroundColor: Color(0xffF5F6F8),
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),

      ),
      body: Container(
        margin: EdgeInsets.only(
            top: ScreenUtil().setHeight(0),
            left: ScreenUtil().setWidth(15),
            right: ScreenUtil().setWidth(15)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: ScreenUtil().setHeight(38),
                  width: ScreenUtil().setWidth(275),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: secondaryColor,
                  ),
                  child: TextFormField(
                    controller: _searchController,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (text){
                      if (text.length > 0) {
                        getPropertyAPI(text);
                      }
                    },
                    style: TextStyle(
                        fontFamily: 'work',
                        fontSize: ScreenUtil().setHeight(12),
                        fontWeight: FontWeight.normal,
                        color: primaryColor),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xff05122B),
                      ),
                      suffixIcon:GestureDetector(
                        onTap: (){
                          _searchController.text="";
                        },
                        child: Icon(
                          Icons.cancel_outlined,
                          color: Color(0xff05122B),
                        ),
                      ) ,
                      hintText: 'Search city, building, location ',
                      hintStyle: TextStyle(
                          fontFamily: 'work',
                          fontSize: ScreenUtil().setHeight(12),
                          fontWeight: FontWeight.normal,
                          color: primaryColor),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: backgroundColor,
                          width: 0.5,

                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: backgroundColor,
                          width: 0.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: backgroundColor, width:0.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.only(left: 30),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height:ScreenUtil().setHeight(15) ,),

            isloading?Center(child: CircularProgressIndicator(color: appColor,)):   _buildPropertyList(),


          ],
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
      onTap: () async {
        final result = await   Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PropertyDetailsPage(proppertyList![i].id.toString(),"");
            },
          ),
        );

        // When a BuildContext is used from a StatefulWidget, the mounted property
        // must be checked after an asynchronous gap.
        if (!mounted) return;
        getPropertyAPI("0",proppertyList!.indexWhere((element) => element.id == result));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(15)),
        decoration: BoxDecoration(
            color: secondaryColor,
            border: Border.all(color: secondaryColor, width: 0.2),
            borderRadius: BorderRadius.circular(20)),
        height: ScreenUtil().setHeight(235),
        child: Column(
          children: [
            Container(
              child: Container(
                decoration: BoxDecoration(
                  //color: Color(0xffFFE500),
                    color: Color(0xffF5F6F8)),
                height: ScreenUtil().setHeight(160),
                child: Stack(
                  children: [
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 1,
                      padding: EdgeInsets.all(0),
                      physics: NeverScrollableScrollPhysics(),
                      controller: controller1,
                      itemBuilder: (BuildContext context, int index1) {
                        return Container(
                          color: Color(0xffF5F6F8),
                          margin: EdgeInsets.only(
                              right: proppertyList![i].images!.length !=
                                  proppertyList![i].images!.length
                                  ? ScreenUtil().setWidth(0)
                                  : ScreenUtil().setWidth(0)),
                          child: Stack(
                            children: [
                              proppertyList![i].thamblain != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                                child: Container(
                                  height:
                                  ScreenUtil().setHeight(250),
                                  width: MediaQuery.of(context)
                                      .size
                                      .width -
                                      ScreenUtil().setWidth(31),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        colorFilter:
                                        new ColorFilter.mode(
                                            Colors.black
                                                .withOpacity(
                                                0.2),
                                            BlendMode.darken),
                                        image:
                                        CachedNetworkImageProvider(
                                            proppertyList![i]
                                                .thamblain!),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              )
                                  : Container(
                                height: ScreenUtil().setHeight(250),
                                width: MediaQuery.of(context)
                                    .size
                                    .width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/property_img.png"),
                                      colorFilter:
                                      new ColorFilter.mode(
                                          Colors.black
                                              .withOpacity(0.2),
                                          BlendMode.darken),
                                      fit: BoxFit.cover),
                                  border: Border.all(
                                      color: secondaryColor,
                                      width: 0.2),
                                ),
                              ),
                              /* Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.9,

                                  padding: EdgeInsets.only(
                                      bottom: ScreenUtil().setWidth(15),left:ScreenUtil().setWidth(15) ),
                                  alignment: Alignment.bottomRight,
                                  child: SmoothPageIndicator(
                                    controller: controller1!,
                                    count:  proppertyList![i].images!.length,
                                    effect: ExpandingDotsEffect(
                                        expansionFactor: 3,strokeWidth: .5,
                                        spacing: 3.0,
                                        radius: 2.0,
                                        dotWidth: 5.0,
                                        dotHeight: 5.0,
                                        dotColor: borderColor,
                                        activeDotColor: secondaryColor),
                                  ))*/
                            ],
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _onShare(
                                  context,
                                  proppertyList![i],
                                  "For ${proppertyList![i].purpose!}: ${proppertyList![i].propertyType!} in ${proppertyList![i].propertyName!} in ${proppertyList![i].area!}, ${proppertyList![i].city!}.",
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(100),
                                  child: Container(
                                      height: ScreenUtil().setHeight(26),
                                      width: ScreenUtil().setHeight(26),
                                      color: appColor,
                                      child: Center(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              "assets/images/share.png",
                                              height:
                                              ScreenUtil().setHeight(22),
                                              width:
                                              ScreenUtil().setHeight(22),
                                            ),
                                          ))),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.only(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left:
                                            ScreenUtil().setWidth(7)),
                                        child: Text(
                                          "AED " +
                                              formatAmount(
                                                  proppertyList![i]
                                                      .price
                                                      .toString()),
                                          style: TextStyle(
                                            color: secondaryColor,
                                            fontSize:
                                            ScreenUtil().setWidth(18),
                                            fontFamily: 'workdark',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(0),
                                  ),
                                  Container(
                                    width: ScreenUtil().screenWidth -
                                        ScreenUtil().setWidth(31),
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(5),
                                        bottom:
                                        ScreenUtil().setHeight(5)),
                                    decoration: BoxDecoration(
                                      color:
                                      Colors.black.withOpacity(0.5),
                                      /*     border: Border.all(
                                                color: inactiveColor,
                                                width: 0.1),*/
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(7)),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              proppertyList![i]
                                                  .propertyAddress !=
                                                  null
                                                  ? "For ${proppertyList![i].purpose!}: ${proppertyList![i].propertyType!} in ${proppertyList![i].propertyName!} in ${proppertyList![i].area!}, ${proppertyList![i].city!}. "
                                                  : "For Rent: Dubai , UAE",
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: secondaryColor,
                                                fontSize: ScreenUtil()
                                                    .setWidth(12),
                                                overflow:
                                                TextOverflow.ellipsis,
                                                fontFamily: 'work',
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                            ),
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
                      SizedBox(
                        width: ScreenUtil().setWidth(4),
                      ),
                      Row(
                        children: [
                          Image.asset("assets/images/bed.png",
                              height: ScreenUtil().setHeight(15),
                              color: Color(0xffA6A6A6),
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
                              color: Color(0xffA6A6A6),
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
                              color: Color(0xffA6A6A6),
                              width: ScreenUtil().setWidth(18)),
                          SizedBox(
                            width: ScreenUtil().setWidth(5),
                          ),
                          Text(
                            proppertyList![i].propertySize != null
                                ? proppertyList![i]
                                .propertySize!
                                .toString() +
                                " sq.ft."
                                : "2300 sq.ft.",
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          isLiked(
                              proppertyList![i].id, proppertyList![i]);
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          width: ScreenUtil().setWidth(95),
                          height: ScreenUtil().setHeight(32),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    height: ScreenUtil().setHeight(26),
                                    width: ScreenUtil().setHeight(26),
                                    child: Icon(
                                      !proppertyList![i].liked!
                                          ? Icons.favorite_border
                                          : Icons.favorite,
                                      color: !proppertyList![i].liked!
                                          ? appColor
                                          : Colors.red,
                                      size: ScreenUtil().setHeight(16),
                                    )),
                                SizedBox(
                                  width: ScreenUtil().setWidth(0),
                                ),
                                Text(
                                  "Likes ( ${proppertyList![i].like!.toString()} ) ",
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
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => MyBottomSheet(
                                    proppertyList![i].comment,
                                    proppertyList![i].id,"search","")),
                          );
                         /* MyBottomSheet(proppertyList![i].comment,
                              proppertyList![i].id);*/
                          //_commentBottomSheet(proppertyList![i].comment);
                          //       new MyBottomSheet(proppertyList![i].comment,proppertyList![i].id).show(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          width: ScreenUtil().setWidth(125),
                          height: ScreenUtil().setHeight(32),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: ScreenUtil().setWidth(6),
                                ),
                                Container(
                                    height: ScreenUtil().setHeight(26),
                                    width: ScreenUtil().setHeight(26),
                                    child: Icon(
                                      Icons.chat_bubble_outline,
                                      color: appColor,
                                      size: ScreenUtil().setHeight(14),
                                    )),
                                Text(
                                  "Comments ( ${proppertyList![i].totalComment} )",
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
  Future<void> getPropertyAPI(String search, [int? indexWhere]) async {
    proppertyList!.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/api/user/searchproperty/$search',
    );
   /* Map<String, dynamic> body = {
      'pagenumber': "1",
      'limit': "20",
      'category_id': id,
    };*/
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await get(uri, headers: headers/*, body: body*/);

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
        if(indexWhere!=null)
        {
          print("indexWhere::$indexWhere");
          proppertyList![indexWhere]=getPropertyData.data![indexWhere];
        }
      } else {}
    }
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
  Future<void> isLiked(int? id, PropertyList propertyList) async {
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


  Future<void> isCollect(int? id, PropertyList propertyList) async {
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
}
