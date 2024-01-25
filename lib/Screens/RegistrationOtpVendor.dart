import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/Colors.dart';
import '../Constants/Api.dart';
import '../Presentation/common_button.dart';
import 'LoginPageVendor.dart';

class RegistrationOtpVendor extends StatefulWidget {
  String password;
  String email;
  String name;
  String phone;

  RegistrationOtpVendor(this.password, this.email, this.name, this.phone);

  @override
  State<RegistrationOtpVendor> createState() => _RegistrationOtpVendorState();
}

class _RegistrationOtpVendorState extends State<RegistrationOtpVendor> {
  final TextEditingController _otpController = TextEditingController();
  bool isloading = false;
  Timer ?_timer;
  int _start = 59;
  bool isVisibleV = false;

  void showWidget() {
    setState(() {
      isVisibleV = !isVisibleV;
    });
  }

  late String token;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }
  @override
  void initState() {
    getToken();
    startTimer();

    // TODO: implement initState
    super.initState();
  }

  getToken() async {
    //token = (await FirebaseMessaging.instance.getToken())!;
    //print("token $token");
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(30),
              right: ScreenUtil().setWidth(30)),
          child: Column(
            children: [
              Container(
                height: ScreenUtil().setHeight(100),
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage("assets/images/login_bg.png"),
                  fit: BoxFit.fill,
                  height: ScreenUtil().setHeight(120),
                  width: double.infinity,
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(40),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'OTP',
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: ScreenUtil().setWidth(24),
                    fontFamily: 'work',
                    letterSpacing: 1.5,
                    height: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
              Container(
                height: ScreenUtil().setHeight(50),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Enter the OTP sent to ${widget.email}',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: ScreenUtil().setWidth(13),
                            fontFamily: 'work',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

/*
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Enter a different Email Address',
                            style: TextStyle(
                              color: appColor,
                              fontSize: ScreenUtil().setWidth(12),
                              fontFamily: 'work',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
*/
                  ],
                ),
              ),

              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: inactiveColor,
                ),
                child: OtpTextField(
                    mainAxisAlignment: MainAxisAlignment.center,
                    numberOfFields: 4,
                    borderRadius: BorderRadius.circular(20.0),
                    disabledBorderColor: inactiveColor,
                    enabledBorderColor: inactiveColor,
                    focusedBorderColor: appColor,
                    borderColor: inactiveColor,
                    cursorColor: appColor,
                    textStyle: TextStyle(
                      color: primaryColor,
                      fontSize: ScreenUtil().setWidth(12),
                      fontFamily: 'work',
                      fontWeight: FontWeight.w400,
                    ),
                    fillColor: inactiveColor,
                    filled: true,
                    borderWidth: 0,
                    fieldWidth: ScreenUtil().setWidth(50),
                    onSubmit: (code) {
                      setState(() {
                        _otpController.text = code;
                      });
                    }),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
              GestureDetector(
                onTap: (){
                  if(_start==0)
                    {
                      startTimer();
                    }
                },
                child: Container(
                  height: ScreenUtil().setHeight(40),
                  child: Center(
                    child: Text(
                      _start==0?'Resend OTP':"0:"+_start.toString(),
                      style: TextStyle(
                        color: darkTextColor,
                        fontSize: ScreenUtil().setWidth(12),
                        fontFamily: 'work',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
              GestureDetector(
                  onTap: () {
                    RegisterAPI();
                  },
                  child: RoundedButton(
                    text: 'Submit',
                    press: () {},
                    color: appColor,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialoge() {
    Size size = MediaQuery.of(context).size;

    Widget okButton = TextButton(
      child: Text("OK",
          style: TextStyle(
              fontFamily: 'work',
              fontWeight: FontWeight.bold,
              fontSize: size.width * 0.05,
              color: primaryColor)),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding: EdgeInsets.all(ScreenUtil().setWidth(30)),
      content: Container(
        height: ScreenUtil().setHeight(210),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: iconColor,
                      size: ScreenUtil().setHeight(18),
                    )),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setHeight(16),
            ),
            Container(
              width: ScreenUtil().setWidth(350),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Your password should contain:",
                          style: TextStyle(
                              fontFamily: 'work',
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil().setWidth(14),
                              color: primaryColor)),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/icons/arrow.png",
                        width: ScreenUtil().setHeight(13),
                        height: ScreenUtil().setHeight(13),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(11),
                      ),
                      Text("Between 8 to 20 characters",
                          style: TextStyle(
                              fontFamily: 'work',
                              fontWeight: FontWeight.w300,
                              fontSize: ScreenUtil().setWidth(12),
                              color: primaryColor)),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(8),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/icons/arrow.png",
                        width: ScreenUtil().setHeight(13),
                        height: ScreenUtil().setHeight(13),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(11),
                      ),
                      Text("At least 1 lowercase",
                          style: TextStyle(
                              fontFamily: 'work',
                              fontWeight: FontWeight.w300,
                              fontSize: ScreenUtil().setWidth(12),
                              color: primaryColor)),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(8),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/icons/arrow.png",
                        width: ScreenUtil().setHeight(13),
                        height: ScreenUtil().setHeight(13),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(11),
                      ),
                      Text("At least 1 uppercase",
                          style: TextStyle(
                              fontFamily: 'work',
                              fontWeight: FontWeight.w300,
                              fontSize: ScreenUtil().setWidth(12),
                              color: primaryColor)),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(8),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/icons/arrow.png",
                        width: ScreenUtil().setHeight(13),
                        height: ScreenUtil().setHeight(13),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(11),
                      ),
                      Text("At least 1 number",
                          style: TextStyle(
                              fontFamily: 'work',
                              fontWeight: FontWeight.w300,
                              fontSize: ScreenUtil().setWidth(12),
                              color: primaryColor)),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(8),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/icons/arrow.png",
                        width: ScreenUtil().setHeight(13),
                        height: ScreenUtil().setHeight(13),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(11),
                      ),
                      Text("At least 1 special characters(Eg.@ &)",
                          style: TextStyle(
                              fontFamily: 'work',
                              fontWeight: FontWeight.w300,
                              fontSize: ScreenUtil().setWidth(12),
                              color: primaryColor)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
          ],
        ),
      ),
      /*  actions: [
        okButton,
      ],*/
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> RegisterAPI() async {
    setState(() {
      isloading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/auth/user/register',
    );
    final headers = {'Accept': 'application/json'};
    Map<String, dynamic> body = {
      'otp': _otpController.text,
      'password': widget.password,
      'email': widget.email,
      'mobile_number': widget.phone,
      'fcm': "aa",
      'name': widget.name,
      'role': "agent",
      'country_code': "+971",
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    var getdata = json.decode(response.body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print("responseStep1::$responseBody");
    if (statusCode == 200) {
      if (getdata["status"]) {
        setState(() {
          isloading = false;
        });
        Message(context, "Registered Successfully");
        /* prefs.setString("access_token", "Bearer ${getdata["0"]["original"]["access_token"].toString()}");
        prefs.setString("name", getdata["0"]["original"]["user"]["name"].toString());
        prefs.setString("UserId", "${getdata["0"]["original"]["user"]["id"].toString()}");
        prefs.setString("email", getdata["0"]["original"]["user"]["email"].toString());
        prefs.setString("phone", getdata["0"]["original"]["user"]["mobile_number"].toString());
        prefs.setBool("isLogging", true);*/

        /*bookTable();*/
        Future.delayed(const Duration(milliseconds: 1000), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginPageVendor();
              },
            ),
          );
        });
      } else {
        setState(() {
          isloading = false;
        });
        ErrorMessage(context, getdata["message"]);
      }
    } else {
      setState(() {
        isloading = false;
      });
      ErrorMessage(context, getdata["message"]);
    }
  }
}
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> Message(
    BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 800),
    ),
  );
}