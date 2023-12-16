import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Constants/Colors.dart';
import '../Constants/Api.dart';
import '../Presentation/common_button.dart';
import '../Presentation/common_textfeild.dart';
import 'LoginPageVendor.dart';


class ForgotPasswordChangePage extends StatefulWidget {
  String email;
  ForgotPasswordChangePage(this.email);


  @override
  State<ForgotPasswordChangePage> createState() => _ForgotPasswordChangePageState();
}

class _ForgotPasswordChangePageState extends State<ForgotPasswordChangePage> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();

  bool isVisibleV = false;
  bool isloading=false;

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
        iconTheme: IconThemeData(
            color: primaryColor
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),

      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left:ScreenUtil().setWidth(30),right:ScreenUtil().setWidth(30)  ),
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
                height: ScreenUtil().setHeight(195),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Enter registered email address', style: TextStyle(
                          color: darkTextColor  ,
                          fontSize: ScreenUtil().setWidth(12),
                          fontFamily: 'work',
                          fontWeight: FontWeight.w100,
                        ),),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(5),
                    ),
                    TextFieldWidget(
                      controller: _otpController,
                      title: "OTP",
                    ),
                    TextFieldWidget(
                      controller: _passwordController,
                      title: "Password",
                      isPassword: true,
                      obs: true,
                    ),
                    TextFieldWidget(
                      controller: _cPasswordController,
                      title: "Re Enter Password",
                      isPassword: true,
                      obs: true,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
              isloading?CircularProgressIndicator(color: appColor,): GestureDetector(
                  onTap: (){
                    CheckValidation();
                  },
                  child: RoundedButton(text: 'Reset Password', press: (){},color: appColor,)),
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
    if (_otpController.text.isEmpty) {
      Message(context, "Enter OTP");
    } else if (_passwordController.text.isEmpty) {
      Message(context, "Enter Password");
    } else if (_passwordController.text.length < 5) {
      Message(context, "Password will max 5 letter");
    }
    else if (_cPasswordController.text.isEmpty) {
      Message(context, "Enter Confirm Password");
    }
    else if(_passwordController.text!=_cPasswordController.text)
      {
        Message(context, "Password not matched!");
      }
    else {
         ForgotPassword();
    }
  }
  Future<void> ForgotPassword() async {
    setState(() {
      isloading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/auth/user/resetpassword',
    );
    final headers = {'Accept': 'application/json'};
    // String? token = await FirebaseMessaging.instance.getToken();

    //  print("token:::$token");
    Map<String, dynamic> body = {
      'email': widget.email,
      'otp': _otpController.text,
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
      Message(context,"Password changed successfully!");
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
    }
    else {
      setState(() {
        isloading = false;
      });
      Message(context, getdata["data"]["message"]);
    }
  }

}