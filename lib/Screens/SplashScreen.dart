import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_pro_vendor/Screens/LoginPageVendor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/Colors.dart';
import '../Presentation/BottomNavigationBarVendor.dart';
import 'InttroductionPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation;
  double beginAnim = 0.0;

  double endAnim = 1.0;

  @override
  void initState() {
    startTime();
    controller =
        AnimationController(duration: const Duration(seconds: 4), vsync: this);
    animation = Tween(begin: beginAnim, end: endAnim).animate(controller!)
      ..addListener(() {
        setState(() {
          // Change here any Animation object value.
        });
      });
    startProgress();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller!.stop();
    super.dispose();
  }

  startProgress() {
    controller!.forward();
  }

  stopProgress() {
    controller!.stop();
  }

  resetProgress() {
    controller!.reset();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage("assets/images/intro.jpeg"),
              // colorFilter: ColorFilter.mode(Colors.black, BlendMode.color),
              fit: BoxFit.cover,
            ),
          ),
          /*child: new BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
            child: new Container(
              decoration: new BoxDecoration(color: Colors.black.withOpacity(0.0)),
            ),
          ),*/
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              height: size.height,
              margin: EdgeInsets.only(top: size.height * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "RealPro",
                                style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: ScreenUtil().setWidth(18),
                                  fontFamily: 'work',
                                  fontWeight: FontWeight.w800,
                                ),
                              )),
                          SizedBox(
                            height: size.height * 0.035,
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                  left: size.height * 0.16,
                                  right: size.height * 0.16),
                              child: LinearProgressIndicator(
                                value: animation!.value,
                                color: appColor,
                                backgroundColor: secondaryColor,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  startTime() async {
    return new Timer(Duration(milliseconds: 3500), NavigatorPage);
  }

  Future<void> NavigatorPage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLogging = prefs.getBool("isLogging");
    print("=-----$isLogging");
    if (isLogging == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LoginPageVendor();
          },
        ),
      );
    } else {
      if (isLogging) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return BottomNavigationBarVendor();
            },
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoginPageVendor();
            },
          ),
        );
      }
    }
  }
}
