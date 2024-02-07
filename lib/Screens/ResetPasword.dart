import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/Colors.dart';
import '../Constants/Api.dart';
import '../Presentation/common_button.dart';
import '../Presentation/common_textfeild.dart';
import 'LoginPageVendor.dart';

class ResetPasword extends StatefulWidget {
  @override
  State<ResetPasword> createState() => _ResetPaswordState();
}

class _ResetPaswordState extends State<ResetPasword> {
  final TextEditingController _OldPasswoord = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isVisibleV = false;
  bool isloading = false;

  void showWidget() {
    setState(() {
      isVisibleV = !isVisibleV;
    });
  }

  late String token;

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
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Container(
                  height: ScreenUtil().setHeight(100),
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage("assets/images/login_bg.png"),
                    fit: BoxFit.fill,
                    height: ScreenUtil().setHeight(120),
                    width: double.infinity,
                  ),
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
                height: ScreenUtil().setHeight(195),
                child: Column(
                  children: [
                    TextFieldWidget(
                      controller: _OldPasswoord,
                      title: "Old Password",
                      isPassword: true,
                      obs: true,
                      validator: (value) {
                        if (_OldPasswoord.text.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    TextFieldWidget(
                      controller: _passwordController,
                      title: "New Password",
                      isPassword: true,
                      obs: true,
                      validator: (value) {
                        if (_passwordController.text.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    TextFieldWidget(
                      controller: _cPasswordController,
                      title: "Re Enter Password",
                      isPassword: true,
                      obs: true,
                      validator: (value) {
                        if (_cPasswordController.text.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
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
                        CheckValidation();
                      },
                      child: RoundedButton(
                        text: 'Reset Password',
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
    );
  }

  void CheckValidation() {
    if (_OldPasswoord.text.isEmpty) {
    } else if (_passwordController.text.isEmpty) {
    } else if (_passwordController.text.length < 5) {
    } else if (_cPasswordController.text.isEmpty) {
    } else if (_passwordController.text != _cPasswordController.text) {
    } else {
      if (_formKey.currentState!.validate()) {
        ForgotPassword();
      }
    }
  }

  Future<void> ForgotPassword() async {
    setState(() {
      isloading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/auth/user/resetpassword1',
    );
    final headers = {'Accept': 'application/json'};
    // String? token = await FirebaseMessaging.instance.getToken();

    //  print("token:::$token");
    Map<String, dynamic> body = {
      'email': prefs.getString("email"),
      'password': _OldPasswoord.text,
      'new_password': _passwordController.text,
      'confirm_new_password': _cPasswordController.text,
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
      Message(context, "Password changed successfully!");
      prefs.setBool("isLogging", false);
      Future.delayed(const Duration(milliseconds: 2000), () {
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
      Message(context, getdata["data"]["message"]);
    }
  }
}
