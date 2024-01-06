import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/Colors.dart';
import '../Constants/Api.dart';
import '../Presentation/common_button.dart';
import '../Presentation/common_textfeild.dart';
import 'ForgotPasswordChange.dart';
import 'LoginPageVendor.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isVisibleV = false;
  bool isloading = false;

  void showWidget() {
    setState(() {
      isVisibleV = !isVisibleV;
    });
  }


  late String token;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    getToken();
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
          child: Form(

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
                  height: ScreenUtil().setHeight(20),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: ScreenUtil().setWidth(22),
                      fontFamily: 'work',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(35),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Enter registered email address',
                            style: TextStyle(
                              color: darkTextColor,
                              fontSize: ScreenUtil().setWidth(12),
                              fontFamily: 'work',
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(5),
                      ),
                      TextFieldWidget(
                        controller: _emailController,
                        title: "Email",
                        validator: (value) {
                          if (_emailController.text.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(3),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Password reset OTP shared to your Email',
                            style: TextStyle(
                              color: Color(0xff979797),
                              fontSize: ScreenUtil().setWidth(12),
                              fontFamily: 'work',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
                isloading
                    ? CircularProgressIndicator(
                        color: appColor,
                      )
                    : GestureDetector(
                        onTap: () {
                          final bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(_emailController.text);
                          if (_emailController.text.isEmpty) {
                            Message(context, "Enter Email");
                          } else if (!emailValid) {
                            Message(context, "Enter valid Email");
                          } else {
                            ForgotPassword();
                          }
                        },
                        child: RoundedButton(
                          text: 'Sent',
                          press: () {},
                          color: appColor,
                        )),
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> ForgotPassword() async {
    setState(() {
      isloading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/auth/user/forgetpassword',
    );
    final headers = {'Accept': 'application/json'};
    // String? token = await FirebaseMessaging.instance.getToken();

    //  print("token:::$token");
    Map<String, dynamic> body = {
      'email': _emailController.text,
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

    int status = response.statusCode;
    String responseBody = response.body;
    print("responseLogin::$responseBody");

    if (getdata["status"] == true) {
      setState(() {
        isloading = false;
      });
      Message(context,
          "Change password Otp sent successfully to your registered E-mail");

      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ForgotPasswordChangePage(_emailController.text);
            },
          ),
        );
      });
    } else {
      setState(() {
        isloading = false;
      });
      Message(context, getdata["message"]);
    }
  }
}
