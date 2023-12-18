import 'package:flutter/material.dart';
import '../Constants/Colors.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Screens/HomePage.dart';
import '../Screens/HomePageV.dart';
import '../Screens/UploadPostPage.dart';

class BottomNavigationBarVendor extends StatefulWidget {

  @override
  _BottomNavigationBarVendorState createState() => _BottomNavigationBarVendorState();
}

class _BottomNavigationBarVendorState extends State<BottomNavigationBarVendor> {
  int currentIndex = 0;
  bool isloading = false;


  /// Set a type current number a layout class
  Widget callPage(int current) {
    switch (current) {
      case 0:
        return new HomePage();
      case 1:
        return new UploadPostPage();
      case 2:
        return new HomePageV();
      default:
        return HomePage();
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  /// Build BottomNavigationBar Widget
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
    return  isloading
        ? Center(
        child: CircularProgressIndicator(
          color: appColor,
        ))
        : Scaffold(
      key: _scaffoldKey,
      body: callPage(currentIndex),
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: secondaryColor,
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        itemShape: StadiumBorder(side: BorderSide.none),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home,color: currentIndex == 0?appColor:borderColor,),
            title: Text("Home",style:  TextStyle(
                fontFamily: 'work',
                fontSize: ScreenUtil().setHeight(13),
                fontWeight: FontWeight.bold,
                color:  currentIndex == 0?darkTextColor:borderColor),),
            selectedColor: primaryColor,

          ),

          /// ADD
          SalomonBottomBarItem(
            icon: Icon(Icons.grid_view,color: currentIndex == 1?appColor:borderColor,),
            title: Text("Upload",style:  TextStyle(
                fontFamily: 'work',
                fontSize: ScreenUtil().setHeight(13),
                fontWeight: FontWeight.bold,
                color:  currentIndex == 1?darkTextColor:borderColor)),
            selectedColor:primaryColor,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.person,color: currentIndex == 2?appColor:borderColor,),
            title: Text("Profile",style:  TextStyle(
                fontFamily: 'work',
                fontSize: ScreenUtil().setHeight(13),
                fontWeight: FontWeight.bold,
                color:  currentIndex == 2?darkTextColor:borderColor)),
            selectedColor:primaryColor,
          ),
        ],
      ),
    );

  }
}
