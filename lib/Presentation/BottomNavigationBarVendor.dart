import 'package:flutter/material.dart';
import 'package:real_pro_vendor/Screens/Chat/ConversationsTab.dart';
import '../Constants/Colors.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Screens/HomePage.dart';
import '../Screens/ProfilePage.dart';
import '../Screens/UploadPostPage.dart';
import 'package:flutter/services.dart';
import 'dart:io';

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
        return new ConversationsTab();
      case 3:
        return new ProfilePage();
      default:
        return HomePage();
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Build BottomNavigationBar Widget
  @override
  Widget build(BuildContext context) {
    return  isloading
        ? Center(
        child: CircularProgressIndicator(
          color: appColor,
        ))
        : WillPopScope(
      onWillPop: _onWillPop,
          child: Scaffold(
      key: _formKey,
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
              icon: Icon(Icons.add,color: currentIndex == 1?appColor:borderColor,),
              title: Text("Upload",style:  TextStyle(
                  fontFamily: 'work',
                  fontSize: ScreenUtil().setHeight(13),
                  fontWeight: FontWeight.bold,
                  color:  currentIndex == 1?darkTextColor:borderColor)),
              selectedColor:primaryColor,
            ),

            SalomonBottomBarItem(
              icon: Icon(Icons.message,color: currentIndex == 1?appColor:borderColor,),
              title: Text("Message",style:  TextStyle(
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
    ),
        );

  }

  Future<bool> _onWillPop() async {
    Size size = MediaQuery.of(context).size;

    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryColor,
        shape: Border.all(color: secondaryColor),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          /*Image.asset(
            'assets/images/logo.jpeg',
            width: size.height * 0.085,
            height: size.height * 0.065,
            fit: BoxFit.contain,
          ),*/
          Text('Real Pro',
              style: TextStyle(
                  fontFamily: 'railway',
                  fontSize: size.height * 0.02,
                  color: appColor,
                  fontWeight: FontWeight.bold))
        ]),
        content: Text("Are You Sure, You Want To Exit the App?",
            style: TextStyle(
                fontFamily: 'railway',
                fontSize: size.height * 0.022,
                color: appColor,
                fontWeight: FontWeight.normal)),
        actions: <Widget>[
          MaterialButton(
            child: Container(
              height: size.height * 0.050,
              width:size.width * 0.25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: appColor),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: appColor
              ),
              child: Text(
                "YES",
                style: TextStyle(
                    fontFamily: 'railway',
                    fontSize: size.height * 0.015,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            onPressed: () {
              //Put your code here which you want to execute on Yes button click.
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            },
          ),
          MaterialButton(
            child: Container(
              height: size.height * 0.050,
              width:size.width * 0.25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: appColor),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: appColor
              ),
              child: Text(
                "CANCEL",
                style: TextStyle(
                    fontFamily: 'railway',
                    fontSize: size.height * 0.015,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            onPressed: () {
              //Put your code here which you want to execute on Cancel button click.
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    )) ??
        false;
  }
}
