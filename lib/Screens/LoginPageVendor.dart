import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:real_pro_vendor/Screens/AddInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/Colors.dart';
import '../Constants/Api.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
  bool isSocial = false;

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
  FocusNode _textFocus = FocusNode();

  @override
  void initState() {
    getToken();
    /*  _emailController.text = "fk@gmail.com";
    _passwordController.text = "123456";*/
    // TODO: implement initState
    super.initState();
  }

  getToken() async {
    //token = (await FirebaseMessaging.instance.getToken())!;
    //print("token $token");
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                Container(
                  height: ScreenUtil().setHeight(85),
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
           /*     SizedBox(
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
                )*/
                SizedBox(
                  height: ScreenUtil().setHeight(25),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Email',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: ScreenUtil().setWidth(12),
                            fontFamily: 'work',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      TextFieldWidget(
                        controller: _emailController,
                        title: "Email",
                        validator: (value) {
                          if(!isSocial) {
                            if (_emailController.text.isEmpty) {
                              return 'This field is required';
                            }
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Password',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: ScreenUtil().setWidth(12),
                            fontFamily: 'work',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      TextFieldWidget(
                        controller: _passwordController,
                        title: "Password",
                        isPassword: true,
                        validator: (value) {
                          if(!isSocial) {
                            if (_passwordController.text.isEmpty) {
                              return 'This field is required';
                            }
                          }
                          return null;
                        },
                        obs: true,
                      ),
                    ],
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
                    height: ScreenUtil().setHeight(30),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: appColor,
                        fontSize: ScreenUtil().setWidth(12),
                        fontFamily: 'work',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                isloading
                    ? CircularProgressIndicator(
                        color: appColor,
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_formKey.currentState!.validate()) {
                              // Check additional conditions, such as non-empty text fields
                              if (_emailController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty) {
                                // Validation passed, initiate the login
                                // Call the login function
                                Login();
                              } else {
                                // Show an error message for empty text fields
                              }
                            } else {
                              // Validation failed, show an error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                  Text('Please fill in the required field.'),
                                ),
                              );
                            }
                          });

                          /*setState(() {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                // Set loading state if needed
                                isloading = true;
                              });

                              // Call the login function
                              Login();
                              // Validation passed, navigate to the next page
                            } else {
                              // Validation failed, show an error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Please fill in the required field.'),
                                ),
                              );
                            }
                          });*/
                          // checkValidation();
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


                SizedBox(height: ScreenUtil().setHeight(10)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RegistrationPageVendor("","");
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
                            ' Register Now',
                            style: TextStyle(
                              color: appColor,
                              fontSize: ScreenUtil().setWidth(14),
                              fontFamily: 'work',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),

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
                Column(
                  mainAxisAlignment: !Platform.isIOS?MainAxisAlignment.center:MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {

                        signInWithGoogle();
                      },
                      child: Container(
                        height: ScreenUtil().setHeight(45),
                        width: ScreenUtil().setWidth(200),
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: ScreenUtil().setWidth(25),
                            ),
                            Image.asset(
                              "assets/images/google.png",
                              width: ScreenUtil().setHeight(20),
                              height: ScreenUtil().setHeight(20),
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(25),
                            ),
                            Text(
                              'Sign in with Google',
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
                  /*  SizedBox(width: ScreenUtil().setWidth(5)),
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
                    ),*/
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    !Platform.isIOS?Container():  GestureDetector(
                      onTap: () {

                        _appleLogin();
                      },
                      child: Container(
                        height: ScreenUtil().setHeight(45),
                        width: ScreenUtil().setWidth(200),
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: ScreenUtil().setWidth(25),
                            ),
                            Image.asset(
                              "assets/images/apple.png",
                              width: ScreenUtil().setHeight(20),
                              height: ScreenUtil().setHeight(20),
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(25),
                            ),
                            Text(
                              'Sign in with Apple',
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


                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(2)),

                /*   Container(
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
                ),*/

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


  Future<void> Login() async {
    setState(() {
      isloading = true;
    });
    String? token = await FirebaseMessaging.instance.getToken();
    print("Tpkoen::$token");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uri = Uri.https(
      apiBaseUrl,
      '/api/auth/user/login',
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
        if(getdata["status"])

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
        ErrorMessage(context, getdata["data"]["message"]);
      }
    } else {
      setState(() {
        isloading = false;
      });
      ErrorMessage(context, getdata["message"]);
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
        postRegisterGoogleData(profile.userId, profile.name!, email!,"",imageUrl);
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
    final googleCurrentUser =
        GoogleSignIn().currentUser ?? await GoogleSignIn().signIn();
    if (googleCurrentUser != null)
      await GoogleSignIn().disconnect().catchError((e, stack) {
        print("Error");
      });
    await _auth.signOut();
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
      postRegisterGoogleData(uId, name, email,user.phoneNumber!=null?user.phoneNumber!:"",imageUrl);
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
      String? accessToken, String name, String email, String phone, String? imageUrl) async {
    setState(() {
      isloading = true;
      isSocial = true;

    });
    /*String? token = await FirebaseMessaging.instance.getToken();
    print("Tpkoen::$token");*/
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
      '/api/auth/user/sociallogin',
    );
    final headers = {'Accept': 'application/json'};
    Map<String, dynamic> body = {
      'name': name,
      'social_id': accessToken,
      'device_id': deviceId,
      'platform': deviceName,
      'email': email,
      'mobile_number': phone,

      // 'fcm_token': token,
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
        Message(context,getdata["message"]);
        prefs.setString("access_token",
            "Bearer ${getdata["0"]["original"]["access_token"].toString()}");
        prefs.setString(
            "name", getdata["0"]["original"]["user"]["name"].toString());
        prefs.setString(
            "UserId", "${getdata["0"]["original"]["user"]["id"].toString()}");
        prefs.setString(
            "email", getdata["0"]["original"]["user"]["email"].toString());
        prefs.setString("role",
            getdata["0"]["original"]["user"]["role@gmail.com"].toString());
        prefs.setString("phone",
            getdata["0"]["original"]["user"]["mobile_number"].toString());
        prefs.setString("profileImage",
            getdata["0"]["original"]["user"]["image"].toString());
        prefs.setBool("isLogging", true);
        prefs.setBool("isSocial", true);
        prefs.setString("socialDP",imageUrl!);
        if(getdata["isLogin"])
        {
          print(getdata["isLogin"]);
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
        }
        else
        {
          print("--false---");
          print(getdata["isLogin"]);

          Future.delayed(const Duration(milliseconds: 2000), () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddInfo(name,email)));
          });
        }
        /*bookTable();*/
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
      ErrorMessage(context, "This Email is registerd with us please try another one");
    }
  }

  Future<void> _appleLogin() async {

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        clientId:
        'de.lunaone.flutter.signinwithappleexample.service',

        redirectUri:
        // For web your redirect URI needs to be the host of the "current page",
        // while for Android you will be using the API server that redirects back into your app via a deep link
        Uri.parse(
          'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
        ),
      ),
      // TODO: Remove these if you have no need for them
      nonce: 'example-nonce',
      state: 'example-state',
    );

    // ignore: avoid_print
    print("abc::${credential.userIdentifier}");
    print("abc::${credential.authorizationCode}");
    print("abc::${credential.givenName}");
    print("abc::${credential.identityToken}");

    appleLoginAPI(credential.userIdentifier,credential.givenName!=null?credential.givenName!:"anonymous",credential.email!=null?credential.email!:"anonymous@gmail.com");
    // This is the endpoint that will convert an authorization code obtained
    // via Sign in with Apple into a session in your system
    final signInWithAppleEndpoint = Uri(
      scheme: 'https',
      host: 'flutter-sign-in-with-apple-example.glitch.me',
      path: '/sign_in_with_apple',
      queryParameters: <String, String>{
        'code': credential.authorizationCode,
        if (credential.givenName != null)
          'firstName': credential.givenName!,
        if (credential.familyName != null)
          'lastName': credential.familyName!,
        'useBundleId':
        !kIsWeb && (Platform.isIOS || Platform.isMacOS)
            ? 'true'
            : 'false',
        if (credential.state != null) 'state': credential.state!,
      },
    );

    final session = await http.Client().post(
      signInWithAppleEndpoint,
    );

    // If we got this far, a session based on the Apple ID credential has been created in your system,
    // and you can now set this as the app's session
    // ignore: avoid_print
    print(session);

  }

  Future<void> appleLoginAPI(
      String? accessToken, String? name, String? email) async {
    setState(() {
      isloading = true;
      isSocial = true;

    });
    /*   String? token = await FirebaseMessaging.instance.getToken();
    print("Tpkoen::$token");*/
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
      '/api/auth/user/apple/login',
    );
    final headers = {'Accept': 'application/json'};
    Map<String, dynamic> body = {
      'name': name,
      'social_id': accessToken,
      'device_id': deviceId,
      'platform': deviceName,
      'email': email,
      'fcm': "dkjsdksldks",
      'role':"user"
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
            "phone", getdata["0"]["original"]["user"]["mobile_number"].toString());
        prefs.setString("phone",
            getdata["0"]["original"]["user"]["mobile_number"].toString());
        prefs.setString("profileImage",
            getdata["0"]["original"]["user"]["image"].toString());
        prefs.setBool("isLogging", true);
        bool? isLogging = prefs.getBool("isHome");

        print("=-----$isLogging");
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
        }
      else {
        setState(() {
          isloading = false;
        });
        ErrorMessage(context, getdata["message"]);
      }
        /*bookTable();*/
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

Future ErrorMessage(
    BuildContext context, String message) {
  Size size = MediaQuery.of(context).size;

  return showDialog(
    builder: (context) => SimpleDialog(
      children: <Widget>[
        Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                width: size.width*0.6,
                child: Text(
                  message,
                  style: TextStyle(
                      fontFamily: "work",
                      fontWeight: FontWeight.w700,
                      color: appColor,
                      letterSpacing: 0.5,
                      fontSize: 15.0),
                ),
              ),
            )),
        Container(
          padding: EdgeInsets.only(top: 15.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.035,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(size.width * 0.01),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: appColor,
                          ),
                          width: size.width * 0.25,
                          height: size.height * 0.05,
                          child: Center(
                              child: Text(
                                "Ok",
                                style: TextStyle(
                                    fontFamily: 'work',
                                    fontSize: size.width * 0.04,
                                    color: secondaryColor),
                              ))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )

      ],
    ),
    context: context,
    barrierDismissible: true,
  );
}