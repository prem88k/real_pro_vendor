import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Constants/Colors.dart';
import 'package:readmore/readmore.dart';

class VendorProfilePage extends StatefulWidget {
  const VendorProfilePage({Key? key}) : super(key: key);

  @override
  State<VendorProfilePage> createState() => _VendorProfilePageState();
}

class _VendorProfilePageState extends State<VendorProfilePage>
    with SingleTickerProviderStateMixin {

  bool isloading = false;
  bool catloading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                        "assets/images/profile_img.png",),
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
                          Container(
                            height: ScreenUtil().setHeight(44),
                            width: ScreenUtil().setWidth(51),
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
                          height: ScreenUtil().setHeight(5),
                        ),
                        Container(
                          child: Text(
                            'Senior Property Consultant',
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
                      height: ScreenUtil().setHeight(30),
                    ),
                    Divider(
                      thickness: 1,
                      color: lightTextColor,
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
                              height: ScreenUtil().setHeight(5),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Nationality :',
                                    style: TextStyle(
                                        fontSize:
                                        ScreenUtil().setHeight(12),
                                        fontWeight: FontWeight.w400,
                                        color: primaryColor,
                                         fontFamily: 'work',),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'United Kingdom',
                                    style: TextStyle(
                                        fontSize:
                                        ScreenUtil().setHeight(12),
                                        fontWeight: FontWeight.w400,
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
                                  child: Text(
                                    'Languages :',
                                    style: TextStyle(
                                        fontSize:
                                        ScreenUtil().setHeight(12),
                                        fontWeight: FontWeight.w400,
                                        color: primaryColor,
                                         fontFamily: 'work',),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'English',
                                    style: TextStyle(
                                        fontSize:
                                        ScreenUtil().setHeight(12),
                                        fontWeight: FontWeight.w400,
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
                                  child: Text(
                                    'BRN# :',
                                    style: TextStyle(
                                        fontSize:
                                        ScreenUtil().setHeight(12),
                                        fontWeight: FontWeight.w400,
                                        color: primaryColor,
                                         fontFamily: 'work',),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '40002',
                                    style: TextStyle(
                                        fontSize:
                                        ScreenUtil().setHeight(12),
                                        fontWeight: FontWeight.w400,
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
                                  child: Text(
                                    'Experience Since :',
                                    style: TextStyle(
                                        fontSize:
                                        ScreenUtil().setHeight(12),
                                        fontWeight: FontWeight.w400,
                                        color: primaryColor,
                                         fontFamily: 'work',),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '2014',
                                    style: TextStyle(
                                        fontSize:
                                        ScreenUtil().setHeight(12),
                                        fontWeight: FontWeight.w400,
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
                                  child: Text(
                                    'Areas :',
                                    style: TextStyle(
                                        fontSize:
                                        ScreenUtil().setHeight(12),
                                        fontWeight: FontWeight.w400,
                                        color: primaryColor,
                                         fontFamily: 'work',),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'Al Barari',
                                    style: TextStyle(
                                        fontSize:
                                        ScreenUtil().setHeight(12),
                                        fontWeight: FontWeight.w400,
                                        color: primaryColor,
                                         fontFamily: 'work',),
                                  ),
                                ),
                              ],
                            )
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
                                height: ScreenUtil().setHeight(5),
                              ),
                              ReadMoreText(
                                "Ryan is a seasoned professional in the world of real estate, "
                                    "encompassing eight years in the vibrant UAE market and "
                                    "four years in the UK. In 2017, Ryan made a significant move "
                                    "to Dubai, where he dedicated his ",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setWidth(12),
                                    color: Color(0xff979797),
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w400),
                                trimLines: 3,
                                colorClickableText: primaryColor,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'more',
                                trimExpandedText: '...less',
                                lessStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppins',
                                ),
                                moreStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppins',
                                ),
                              ),
                            ],
                          ),
                        )
                    ),

                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),

                    Container(
                      width: ScreenUtil().screenWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: appColor
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  'Awwards',
                                  style: TextStyle(
                                      fontSize:
                                      ScreenUtil().setHeight(14),
                                      fontWeight: FontWeight.w600,
                                      color: secondaryColor,
                                       fontFamily: 'work',),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(5),
                              ),

                              Container(
                                height: ScreenUtil().setHeight(40),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: secondaryColor
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: ScreenUtil().setWidth(10),
                                    ),
                                    Image(
                                        image: AssetImage("assets/images/editor_choice.png"),
                                        height: ScreenUtil().setHeight(20),
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(10),
                                    ),
                                    Container(
                                      width: ScreenUtil().setWidth(225),
                                      child: Text(
                                        'Outstanding Super Agent',
                                        style: TextStyle(
                                          fontSize:
                                          ScreenUtil().setHeight(14),
                                          fontWeight: FontWeight.w500,
                                          color: appColor,
                                          fontFamily: 'work',),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        '2023',
                                        style: TextStyle(
                                          fontSize:
                                          ScreenUtil().setHeight(18),
                                          fontWeight: FontWeight.w600,
                                          color: appColor,
                                          fontFamily: 'work',),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              
                            ],
                          ),
                        )
                    ),

                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            'My Properties',
                            style: TextStyle(
                              fontSize:
                              ScreenUtil().setHeight(14),
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontFamily: 'work',),
                          ),
                        ),
                      ],
                    ),

                    postsWidget(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  postsWidget() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return _buildPostList();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPostList() {
    return Column(
      children: [
        Container(
          height: ScreenUtil().setHeight(150),
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
    );
  }
}
