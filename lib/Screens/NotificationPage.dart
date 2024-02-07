import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Constants/Colors.dart';


class NotificationPage extends StatefulWidget{
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _switchValue = false;
  bool _switchValue1= false;
  bool _switchValue2= false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(10.0),
                right: ScreenUtil().setWidth(10.0),
                top: ScreenUtil().setHeight(0.0),
                bottom: ScreenUtil().setHeight(10.0),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Notifications",
                    maxLines: 2,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: ScreenUtil().setHeight(15),
                      fontFamily: 'work',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(10),
                  right: ScreenUtil().setWidth(10),
                  bottom: ScreenUtil().setHeight(10),
                  top: ScreenUtil().setHeight(10)),
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(10),
                  right: ScreenUtil().setWidth(10),
                  bottom: ScreenUtil().setHeight(15),
                  top: ScreenUtil().setHeight(15)),
              width: ScreenUtil().screenWidth,
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Container(
                        padding:  EdgeInsets.only(left:ScreenUtil().setWidth(16.0)),
                        width: ScreenUtil().setWidth(200),
                        child: Text(
                          "Push Notifications",
                          style: TextStyle(
                            color: darkTextColor,
                            fontSize: ScreenUtil().setHeight(12),
                            fontFamily: 'work',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: CupertinoSwitch(
                          activeColor: appColor,
                          value: _switchValue2,
                          onChanged: (value) {
                            setState(() {
                              _switchValue2 = value;
                            });
                          },
                        ),
                      )

                    ],
                  ),


                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(10),
                  right: ScreenUtil().setWidth(10),
                  bottom: ScreenUtil().setHeight(10),
                  top: ScreenUtil().setHeight(10)),
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(10),
                  right: ScreenUtil().setWidth(0),
                  bottom: ScreenUtil().setHeight(15),
                  top: ScreenUtil().setHeight(15)),
              width: ScreenUtil().screenWidth,
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return NotificationPage();
                            //WelcomeLoginPage();
                          },
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                            // width: ScreenUtil().setWidth(200),
                            child: Icon(Icons.email,
                                color: appColor,
                                size: ScreenUtil().setWidth(16))),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(200),
                          child: Text(
                            "Email",
                            style: TextStyle(
                              color: darkTextColor,
                              fontSize: ScreenUtil().setHeight(12),
                              fontFamily: 'work',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: CupertinoSwitch(
                            activeColor: appColor,
                            value: _switchValue1,
                            onChanged: (value) {
                              setState(() {
                                _switchValue1 = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),                  SizedBox(
                    height: ScreenUtil().setHeight(12),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(45)),
                      child: Divider(
                        color: backgroundColor,
                        height: 0.2,
                      )),
                  SizedBox(
                    height: ScreenUtil().setHeight(12),
                  ),


                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return NotificationPage();
                            //WelcomeLoginPage();
                          },
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                            // width: ScreenUtil().setWidth(200),
                            child: Icon(Icons.notifications,
                                color: appColor,
                                size: ScreenUtil().setWidth(16))),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(200),
                          child: Text(
                            "Notification Center",
                            style: TextStyle(
                              color: darkTextColor,
                              fontSize: ScreenUtil().setHeight(12),
                              fontFamily: 'work',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: CupertinoSwitch(
                            activeColor: appColor,
                            value: _switchValue,
                            onChanged: (value) {
                              setState(() {
                                _switchValue = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(12),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
