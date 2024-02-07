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
  int position;
  BottomNavigationBarVendor([this.position=0]);


  @override
  _BottomNavigationBarVendorState createState() => _BottomNavigationBarVendorState();
}

class _BottomNavigationBarVendorState extends State<BottomNavigationBarVendor> {
  int? currentIndex;
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
    currentIndex = widget.position;
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
      body: callPage(currentIndex!),
      bottomNavigationBar: SizedBox(
        height: ScreenUtil().setHeight(60),
        child: SalomonBottomBar(
            backgroundColor: secondaryColor,
            currentIndex: currentIndex!,
            onTap: (i) => setState(() => currentIndex = i),
            itemShape: StadiumBorder(side: BorderSide.none),
            items: [
              /// Home
              SalomonBottomBarItem(
                icon: Icon(Icons.home_work_outlined,color: currentIndex == 0?appColor:borderColor,),
                title: Text("Properties",style:  TextStyle(
                    fontFamily: 'work',
                    fontSize: ScreenUtil().setWidth(12),
                    fontWeight: FontWeight.bold,
                    color:  currentIndex == 0?darkTextColor:borderColor),),
                selectedColor: primaryColor,

              ),

              /// ADD
              SalomonBottomBarItem(
                icon: Icon(Icons.drive_folder_upload,color: currentIndex == 1?appColor:borderColor,),
                title: Text("Upload",style:  TextStyle(
                    fontFamily: 'work',
                    fontSize: ScreenUtil().setWidth(12),
                    fontWeight: FontWeight.bold,
                    color:  currentIndex == 1?darkTextColor:borderColor)),
                selectedColor:primaryColor,
              ),

              SalomonBottomBarItem(
                icon: Icon(Icons.forum_outlined,color: currentIndex == 2?appColor:borderColor,),
                title: Text("Message",style:  TextStyle(
                    fontFamily: 'work',
                    fontSize: ScreenUtil().setWidth(12),
                    fontWeight: FontWeight.bold,
                    color:  currentIndex == 1?darkTextColor:borderColor)),
                selectedColor:primaryColor,
              ),

              /// Profile
              SalomonBottomBarItem(
                icon: Icon(Icons.person,color: currentIndex == 3?appColor:borderColor,),
                title: Text("Profile",style:  TextStyle(
                    fontFamily: 'work',
                    fontSize: ScreenUtil().setWidth(12),
                    fontWeight: FontWeight.bold,
                    color:  currentIndex == 2?darkTextColor:borderColor)),
                selectedColor:primaryColor,
              ),
            ],
        ),
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
                  fontFamily: 'work',
                  fontSize: size.height * 0.02,
                  color: appColor,
                  fontWeight: FontWeight.bold))
        ]),
        content: Text("Do you want to exit from the app?",
            style: TextStyle(
                fontFamily: 'work',
                fontSize: size.height * 0.022,
                color: appColor,
                fontWeight: FontWeight.normal)),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                        fontFamily: 'work',
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
                        fontFamily: 'work',
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
        ],
      ),
    )) ??
        false;
  }
}
