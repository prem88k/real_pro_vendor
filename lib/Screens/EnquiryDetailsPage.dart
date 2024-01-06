import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Constants/Api.dart';
import '../Constants/Colors.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../Models/GetEnquiryData.dart';

class EnquiryDetailsPage extends StatefulWidget {
  int? property_id;
  EnquiryDetailsPage(this.property_id);

  @override
  State<EnquiryDetailsPage> createState() => _EnquiryDetailsPageState();
}

class _EnquiryDetailsPageState extends State<EnquiryDetailsPage> {
  late GetEnquiryData getEnquiryData;
  List<EnquiryList>? enquiryList = [];
  bool isloading = false;
  bool catloading = false;

  @override
  void initState() {
    getEnquiry();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        bottomOpacity: 0,
        iconTheme: IconThemeData(color: secondaryColor),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Enquiry Details",
          style: TextStyle(
            color: secondaryColor,
            fontSize: ScreenUtil().setWidth(15),
            fontFamily: 'work',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(
              color: appColor,
            ))
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(5),
                    left: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(10),
                    bottom: ScreenUtil().setHeight(5)),
                child: Column(
                  children: [
                    SizedBox(
                      height: ScreenUtil().setHeight(15),
                    ),
                    _serviceWidget(),
                  ],
                ),
              ),
            ),
    );
  }

  _serviceWidget() {
    return enquiryList!.length == 0
        ? Center(
          child: Text("No Enquiry Found",
              style: TextStyle(
                  fontSize: ScreenUtil().setWidth(16),
                  color: lightTextColor,
                  fontFamily: 'work',
                  fontWeight: FontWeight.w400)),
        )
        : SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(5.0),
            bottom: ScreenUtil().setHeight(0.0)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Now",
                      style: TextStyle(
                          fontSize: ScreenUtil().setWidth(17),
                          color: primaryColor,
                          fontFamily: 'work',
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(0.0),
                  bottom: ScreenUtil().setHeight(10.0)),
              child: Container(
                child:  ListView.builder(
                  itemCount: enquiryList!.length,
                  physics: NeverScrollableScrollPhysics(),
                  // scrollDirection: Axis.vertical,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return _buildServiceList(i);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceList(int i) {
    return  Column(
            children: [
              Container(
                width: ScreenUtil().setWidth(340),
                margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(15),
                    bottom: ScreenUtil().setHeight(5)),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  border: Border.all(color: borderPinkColor, width: 1.0),
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: ScreenUtil().setHeight(87.5),
                        width: ScreenUtil().setWidth(95),
                        decoration: enquiryList![i].user![0].image != null
                            ? BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(enquiryList![i]
                                        .user![0]
                                        .image
                                        .toString()),
                                    fit: BoxFit.cover),
                                border: Border.all(
                                    color: secondaryColor, width: 0.2),
                                borderRadius: BorderRadius.circular(5.0))
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/bg_image.png"),
                                    fit: BoxFit.cover)),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(8)),
                        width: ScreenUtil().setWidth(195),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    enquiryList![i].user![0].name != null
                                        ? enquiryList![i]
                                            .user![0]
                                            .name
                                            .toString()
                                        : "Athul Surendran",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setWidth(16),
                                        color: primaryColor,
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w600)),
                                Container(
                                  height: ScreenUtil().setHeight(18),
                                  width: ScreenUtil().setWidth(31),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Color(0xff005CFF)),
                                  child: Center(
                                    child: Text("Buy",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setWidth(10),
                                            color: secondaryColor,
                                            fontFamily: 'work',
                                            fontWeight: FontWeight.w400)),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(4),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    enquiryList![i].user![0].mobileNumber !=
                                            null
                                        ? enquiryList![i]
                                            .user![0]
                                            .mobileNumber
                                            .toString()
                                        : "+971 508580813",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setWidth(12),
                                        color: primaryColor,
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(4),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    enquiryList![i].user![0].email != null
                                        ? enquiryList![i]
                                            .user![0]
                                            .email
                                            .toString()
                                        : "example@gmail.com",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setWidth(12),
                                        color: primaryColor,
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(7),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("Read More",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setWidth(10),
                                            color: appColor,
                                            fontFamily: 'work',
                                            fontWeight: FontWeight.w400)),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(3.0),
                                        right: ScreenUtil().setWidth(3.0),
                                      ),
                                      child: Icon(
                                        Icons.arrow_circle_right,
                                        color: appColor,
                                        size: ScreenUtil().setWidth(10),
                                      ),
                                    )
                                  ],
                                ),
                                Text("2mnts",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setWidth(10),
                                        color: Color(0xffC9C9C9),
                                        fontFamily: 'work',
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(2),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  Future<void> getEnquiry() async {
    enquiryList!.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      catloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/getenquiry/${widget.property_id}',
    );
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("EnquiryResposne::$responseBody");
    if (statusCode == 200) {
      setState(() {
        catloading = false;
      });
      if (mounted == true) {}
      if (getdata["success"]) {
        getEnquiryData = GetEnquiryData.fromJson(jsonDecode(responseBody));
        enquiryList!.addAll(getEnquiryData.data!);
      } else {}
    } else {
      setState(() {
        catloading = false;
      });
    }
  }
}
