import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Constants/Api.dart';
import '../Constants/Colors.dart';
import '../Models/GetCaategoryData.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  @override
  void initState() {
    getCategory();
    super.initState();
    tabController = TabController(length: 3, vsync: this);
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
      body: SafeArea(
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
                  CircleAvatar(
                    backgroundImage: AssetImage(
                      "assets/images/user_logo.png",),
                    radius: ScreenUtil().setWidth(40),
                  ),

                  Container(
                    width: ScreenUtil().setWidth(180),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                '56',
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(16),
                                    fontWeight: FontWeight.w400,
                                    color: primaryColor,
                                     fontFamily: 'work',),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(4),
                            ),
                            Container(
                              child: Text(
                                'Likes',
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(12),
                                    fontWeight: FontWeight.w400,
                                    color: lightTextColor,
                                     fontFamily: 'work',),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(4),
                        ),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                '14',
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(16),
                                    fontWeight: FontWeight.w400,
                                    color: primaryColor,
                                     fontFamily: 'work',),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(4),
                            ),
                            Container(
                              child: Text(
                                'Followers',
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(12),
                                    fontWeight: FontWeight.w400,
                                    color: lightTextColor,
                                     fontFamily: 'work',),
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
                          'John Doe',
                          style: TextStyle(
                              fontSize:
                                  ScreenUtil().setHeight(20),
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                               fontFamily: 'work',),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(4),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(140),
                        child: Text(
                          'UID : 67843590021',
                          style: TextStyle(
                              fontSize:
                                  ScreenUtil().setHeight(12),
                              fontWeight: FontWeight.w400,
                              color: lightTextColor,
                               fontFamily: 'work',),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(14),
                  ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(335),
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Eget blandit euismod netus ornare.',
                            style: TextStyle(
                                fontSize: ScreenUtil().setHeight(12),
                                fontWeight: FontWeight.w400,
                                color: lightTextColor,
                                 fontFamily: 'work',),
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
                                 fontFamily: 'work',),
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
                            color: secondaryColor,),
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
                decoration: BoxDecoration(
                  color: Color(0xffEFEFEF)
                ),
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
                child: TabBarView(
                    controller: tabController, children: <Widget>[
                    PostsWidget(),
                    PostsWidget(),
                    PostsWidget(),
                ]),
              ),
              // Profile image

            ],
          ),
        ),
      ),
    );
  }

  PostsWidget() {
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
                  height:ScreenUtil().setHeight(45),
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
                        fontFamily: 'poppins',
                        fontSize: ScreenUtil().setHeight(12),
                        fontWeight: FontWeight.normal,
                        color: primaryColor),
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search, color: appColor,),
                      hintText: 'Start Typing',
                      hintStyle: TextStyle(
                          fontFamily: 'poppins',
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
                        borderSide: BorderSide(color: secondaryColor, width: 1.0),
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
                scrollDirection: Axis.vertical,
                itemCount: 5,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return _buildPostList();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostList() {
    return Container(
      child: Column(
        children: [
          Container(
            height: ScreenUtil().setHeight(140),
            width: ScreenUtil().setWidth(200),
            child: GestureDetector(
              onTap: () {

              },
              child: Card(
                semanticContainer: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/bg_image.png'),
                                fit: BoxFit.fill),
                          ),
                        )),

                    Positioned(
                      top: 100,
                      child:  Padding(
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
                                "AED 155,000",
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: ScreenUtil().setHeight(12),
                                     fontFamily: 'work',
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(5),),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: ScreenUtil().setWidth(150),
                                    // padding: EdgeInsets.only(bottom: 13),
                                    child: Text('For Rent: Villa in Al Majra, '
                                        'Downtown Dubai, Dubai',
                                      style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: ScreenUtil().setHeight(10),
                                        fontWeight: FontWeight.w400,
                                         fontFamily: 'work',),)),
                              ],
                            ),
                            SizedBox(height: ScreenUtil().setHeight(5),),
                          ],
                        ),
                      ),
                    )
                  ],
                ),),
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
}
