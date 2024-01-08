import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Constants/Colors.dart';
import '../Presentation/common_button.dart';
import 'LoginPageVendor.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  State<IntroductionScreen> createState() => _SplashScreenTwoState();
}

class _SplashScreenTwoState extends State<IntroductionScreen> {
  List<String> bannerList = [];
  late PageController controller1;

  @override
  void initState() {
    // TODO: implement initState
    controller1 = PageController(initialPage: 0, viewportFraction: 1.0);
    bannerList.add("assets/images/splash_image.png");
    bannerList.add("assets/images/splash_image.png");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    ScreenUtil.init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: secondaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top:ScreenUtil().setHeight(70) ),
              height: ScreenUtil().setHeight(475),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/intro.jpeg'),
                    fit: BoxFit.fill),
              ),
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Real",
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: ScreenUtil().setWidth(30),
                            fontFamily: 'work',
                            height: ScreenUtil().setWidth(1) ,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "Pro",
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: ScreenUtil().setWidth(30),
                            fontFamily: 'work',
                            height: ScreenUtil().setWidth(1) ,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                    Text(
                      "Showcase the walkthrough of your properties on RealPro\nthe Social Platform for real estate",
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: ScreenUtil().setWidth(20),
                        height: ScreenUtil().setWidth(1.2) ,

                        fontFamily: 'work',
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    /*Text(
                      "In publishing and graphic design, Lorem ipsum is a\nplaceholder text commonly used to ",
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: ScreenUtil().setWidth(10),
                        fontFamily: 'work',
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),*/
                  ],
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setHeight(15),right: ScreenUtil().setHeight(15)),
              child: Column(
                children: [
                 /* GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return RegistrationPageVendor();
                            },
                          ),
                        );
                      },
                      child: RoundedButton(
                        text: 'Vendor',
                        press: () {},
                        color: appColor,
                      )),*/
                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginPageVendor();
                            },
                          ),
                        );
                      },
                      child: RoundedButton(
                        text: 'Login',
                        press: () {},
                        color: appColor,
                      )),

                  SizedBox(
                    height: ScreenUtil().setHeight(10),
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
