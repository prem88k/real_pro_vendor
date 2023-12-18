import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/Colors.dart';
import '../Constants/Api.dart';
import '../Presentation/BottomNavigationBarVendor.dart';
import '../Presentation/common_button.dart';
import '../Presentation/common_textfeild.dart';
import 'ForgotPassword.dart';
import 'RegistrationPageVendor.dart';


FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPageVendor extends StatefulWidget {
  const LoginPageVendor({Key? key}) : super(key: key);

  @override
  State<LoginPageVendor> createState() => _LoginPageVendorState();
}

class _LoginPageVendorState extends State<LoginPageVendor> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isVisibleV = false;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late String deviceName = "";

  String? deviceId;
  late String name;
  late String email;
  late String imageUrl;
  late String uId;
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
    _emailController.text = "fk@gmail.com";
    _passwordController.text = "123456";
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
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: ScreenUtil().setWidth(22),
                    fontFamily: 'work',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(8),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Welcome back you’ve been missed',
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: ScreenUtil().setWidth(16),
                    fontFamily: 'work',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(25),
              ),
              Container(
                height: ScreenUtil().setHeight(55),
                child: Column(
                  children: [
                    TextFieldWidget(
                      controller: _emailController,
                      title: "Email",
                    ),
                  ],
                ),
              ),
              Container(
                height: ScreenUtil().setHeight(55),
                child: Column(
                  children: [
                    TextFieldWidget(
                      controller: _passwordController,
                      title: "Password",
                      isPassword: true,
                      obs: true,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              isloading?CircularProgressIndicator(color: appColor,):GestureDetector(
                onTap: () {
                  checkValidation();
                  /*      Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CtaegoryInterestPage();
                      },
                    ),
                  );*/
                },
                child: RoundedButton(
                  text: 'Login',
                  press: () {},
                  color: appColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ForgotPasswordPage();
                      },
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  height: ScreenUtil().setHeight(40),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: appColor,
                      fontSize: ScreenUtil().setWidth(12),
                      fontFamily: 'work',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(8),
              ),
              Container(
                child: Row(children: <Widget>[
                  Expanded(
                      child: Divider(
                        color: primaryColor,
                        height: 0.2,
                      )),
                  SizedBox(
                    width: ScreenUtil().setHeight(15),
                  ),
                  Text(
                    "OR",
                    style: TextStyle(
                        fontFamily: 'work',
                        fontSize: ScreenUtil().setHeight(10),
                        fontWeight: FontWeight.w400,
                        color: primaryColor),
                  ),
                  SizedBox(
                    width: ScreenUtil().setHeight(15),
                  ),
                  Expanded(
                      child: Divider(
                        color: primaryColor,
                        height: 0.2,
                      )),
                ]),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      signInWithGoogle();
                    },
                    child: Container(
                      height: ScreenUtil().setHeight(65),
                      width: ScreenUtil().setWidth(90),
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/google.png",
                            width: ScreenUtil().setHeight(20),
                            height: ScreenUtil().setHeight(20),
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(10),
                          ),
                          Text(
                            'Google',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: ScreenUtil().setWidth(12),
                              fontFamily: 'work',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(5)),
                  GestureDetector(
                    onTap: () {
                      _loginWithFacebook();
                    },
                    child: Container(
                      height: ScreenUtil().setHeight(65),
                      width: ScreenUtil().setWidth(90),
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/facebook.png",
                            width: ScreenUtil().setHeight(20),
                            height: ScreenUtil().setHeight(20),
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(10),
                          ),
                          Text(
                            'Facebook',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: ScreenUtil().setWidth(12),
                              fontFamily: 'work',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(5)),
                  Container(
                    height: ScreenUtil().setHeight(65),
                    width: ScreenUtil().setWidth(90),
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/apple.png",
                          width: ScreenUtil().setHeight(20),
                          height: ScreenUtil().setHeight(20),
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(10),
                        ),
                        Text(
                          'Apple',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: ScreenUtil().setWidth(12),
                            fontFamily: 'work',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(55)),
              GestureDetector(
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
                child: Container(
                  height: ScreenUtil().setHeight(40),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You dont have any account?',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: ScreenUtil().setWidth(12),
                            fontFamily: 'work',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          ' Register',
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
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkValidation() {
    if (_emailController.text.isEmpty) {
      Message(context, "Enter Email Address");
    } else if (_passwordController.text.isEmpty) {
      Message(context, "Enter Password");
    } else {
      Login();
    }
  }

  Future<void> Login() async {
    setState(() {
      isloading = true;
    });
    String? token = await FirebaseMessaging.instance.getToken();
    print("Tpkoen::$token");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/auth/user/login',
    );
    final headers = {'Accept': 'application/json'};
    Map<String, dynamic> body = {
      'password': _passwordController.text,
      'email': _emailController.text,
      'fcm': token,
      'device_type': "IOS",
      'role': "agent",
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
        Message(context, "Login Successfully");
        prefs.setString("access_token",
            "Bearer ${getdata["0"]["original"]["access_token"].toString()}");
        prefs.setString(
            "name", getdata["0"]["original"]["user"]["name"].toString());
        prefs.setString(
            "UserId", "${getdata["0"]["original"]["user"]["id"].toString()}");
        prefs.setString(
            "email", getdata["0"]["original"]["user"]["email"].toString());
        prefs.setString("phone",
            getdata["0"]["original"]["user"]["mobile_number"].toString());
        prefs.setBool("isLogging", true);

        /*bookTable();*/
        Future.delayed(const Duration(milliseconds: 1000), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return BottomNavigationBarVendor();
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
    } else {
      setState(() {
        isloading = false;
      });
      Message(context, getdata["message"]);
    }
  }

  Future<OAuthCredential?> _loginWithFacebook() async {
    print("FBLOgin");
    final fb = FacebookLogin();
    // Log in
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    // Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:
      // The user is suceessfully logged in
      // Send access token to server for validation and auth
        final FacebookAccessToken? accessToken = res.accessToken;
        final AuthCredential authCredential =
        FacebookAuthProvider.credential(accessToken!.token);
        final result =
        await FirebaseAuth.instance.signInWithCredential(authCredential);
        // Get profile data from facebook for use in the app
        final profile = await fb.getUserProfile();
        print('Hello, ${profile!.name}! You ID: ${profile.userId}');
        // Get user profile image url
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        print('Your profile image: $imageUrl');
        // fetch user email
        final email = await fb.getUserEmail();
        // But user can decline permission
        if (email != null) print('And your email is $email');
        postRegisterGoogleData(profile.userId, profile.name!, email!);
        break;
      case FacebookLoginStatus.cancel:
      // In case the user cancels the login process
        break;
      case FacebookLoginStatus.error:
      // Login procedure failed
        print('Error while log in: ${res.error}');
        break;
    }
  }

  Future<String?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
    await GoogleSignIn(scopes: <String>["email"]).signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential authResult =
    await _auth.signInWithCredential(credential);
    final User? user = authResult.user;

    if (user != null) {
      // Checking if email and name is null
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);

      name = user.displayName!;
      email = user.email!;
      imageUrl = user.photoURL!;
      uId = user.uid;
      postRegisterGoogleData(uId, name, email);
      // Only taking the first part of the name, i.e., First Name
      if (name.contains(" ")) {
        name = name.substring(0, name.indexOf(" "));
      }

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User? currentUser = _auth.currentUser;
      assert(user.uid == currentUser!.uid);

      print('signInWithGoogle succeeded: $user');

      return '$user';
    }

    return null;
  }

  Future<void> postRegisterGoogleData(
      String? accessToken, String name, String email) async {
    setState(() {
      isloading = true;
    });
    String? token = await FirebaseMessaging.instance.getToken();
    print("Tpkoen::$token");
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        deviceName = 'android';
        deviceId = androidInfo.id;
        print("DeviceId::$deviceId");
      });
    } else {
      var iosdeviceinfo = await deviceInfo.iosInfo;
      setState(() {
        deviceName = 'ios';
        deviceId = iosdeviceinfo.identifierForVendor!;
      });
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/auth/user/sociallogin',
    );
    final headers = {'Accept': 'application/json'};
    Map<String, dynamic> body = {
      'name': name,
      'social_id': accessToken,
      'device_id': deviceId,
      'platform': deviceName,
      'email': email,
      'fcm_token': token,
      'role': "agent",
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
    print("responseStepSocial::$responseBody");
    if (statusCode == 200) {
      if (getdata["status"]) {
        setState(() {
          isloading = false;
        });

        Message(context, "Login Successfully");
        prefs.setString("access_token",
            "Bearer ${getdata["0"]["original"]["access_token"].toString()}");
        prefs.setString(
            "name", getdata["0"]["original"]["user"]["name"].toString());
        prefs.setString(
            "UserId", "${getdata["0"]["original"]["user"]["id"].toString()}");
        prefs.setString(
            "email", getdata["0"]["original"]["user"]["email"].toString());
        prefs.setString(
            "role", getdata["0"]["original"]["user"]["role@gmail.com"].toString());
        prefs.setString(
            "phone", getdata["0"]["original"]["user"]["mobile_number"].toString());
        prefs.setString("phone",
            getdata["0"]["original"]["user"]["mobile_number"].toString());
        prefs.setBool("isLogging", true);
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BottomNavigationBarVendor()));
        });


        /*bookTable();*/
      } else {
        setState(() {
          isloading = false;
        });
        Message(context, getdata["message"]);
      }
    } else {
      setState(() {
        isloading = false;
      });
      Message(context, getdata["message"]);
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
