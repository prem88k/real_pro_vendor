import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:real_pro_vendor/Screens/AddInfo.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/Api.dart';
import '../Constants/Colors.dart';
import '../Presentation/BottomNavigationBarVendor.dart';
import '../Presentation/common_button.dart';
import '../Presentation/common_textfeild.dart';
import 'LoginPageVendor.dart';
import 'RegistrationOtpVendor.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class RegistrationPageVendor extends StatefulWidget {
  String name;
  String email;

  RegistrationPageVendor(this.name, this.email);

  @override
  State<RegistrationPageVendor> createState() => _RegistrationPageVendorState();
}

class _RegistrationPageVendorState extends State<RegistrationPageVendor> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late String deviceName = "";
  late String name;
  late String email;
  late String imageUrl;
  late String uId;
  String? deviceId;
  bool isSocial = false;

  bool isloading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _agencyNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _brnController = TextEditingController();

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      /* appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Sign Up",
          style: TextStyle(
            color: primaryColor,
            fontSize: ScreenUtil().setWidth(20),
            fontFamily: 'work',
            fontWeight: FontWeight.w800,
          ),
        ),
      ),*/
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(30),
              bottom: ScreenUtil().setHeight(30),
              right: ScreenUtil().setWidth(30)),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                Container(
                  height: ScreenUtil().setHeight(75),
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
                    'Sign Up',
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
                          final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(_emailController.text);
                          if(!isSocial) {
                            if (_emailController.text.isEmpty) {
                              return 'This field is required';
                            }
                            if (!emailValid) {
                              return "Enter a valid email address";
                            }
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(8)),
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
                        title: 'Password',
                        controller: _passwordController,
                        isPassword: true,
                        obs: true,
                        validator: (value) {
                          final bool passValid = RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#&*~]).{6,}$')
                              .hasMatch(_passwordController.text);
                          if (!isSocial) {
                            if (_passwordController.text.isEmpty) {
                              return "This field is required";
                            }
                            else if (!passValid) {
                              return 'Password should be 8-12 character, contain 1 capital letter, 1 number and 1 special character';
                            }
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(8)),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Re-enter password',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: ScreenUtil().setWidth(12),
                            fontFamily: 'work',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      TextFieldWidget(
                        title: 'Re-enter password',
                        controller: _confirmPasswordController,
                        isPassword: true,
                        obs: true,
                        validator: (value) {
                          final bool emailValid = RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#&*~]).{6,}$')
                              .hasMatch(_confirmPasswordController.text);
                          if (!isSocial) {
                            if (_confirmPasswordController.text.isEmpty) {
                              return 'This field is required';
                            } else if (_confirmPasswordController.text.length < 5) {
                              return '5 Character required';
                            }
                            else if(!emailValid)
                            {
                              return 'Password should be 8-12 character, contain 1 capital letter, 1 number and 1 special character';
                            }
                            else if (_confirmPasswordController.text !=
                                _passwordController.text) {
                              return 'Password and confirm password does not matched';
                            }
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                                SizedBox(height: ScreenUtil().setHeight(8)),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Agent Name',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: ScreenUtil().setWidth(12),
                            fontFamily: 'work',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      TextFieldWidget(
                        controller: _nameController,
                        title: "Agent Name",
                        validator: (value) {
                          if(!isSocial) {
                            if (_nameController.text.isEmpty) {
                              return "This field is required";
                            }
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                                SizedBox(height: ScreenUtil().setHeight(8)),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Agency Name',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: ScreenUtil().setWidth(12),
                            fontFamily: 'work',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      TextFieldWidget(
                        controller: _agencyNameController,
                        title: "Agency Name",
                        validator: (value) {
                          if(!isSocial) {
                            if (_agencyNameController.text.isEmpty) {
                              return "This field is required";
                            }
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                                SizedBox(height: ScreenUtil().setHeight(8)),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'BRN',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: ScreenUtil().setWidth(12),
                            fontFamily: 'work',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      TextFieldWidget(
                        controller: _brnController,
                        title: "BRN",
                        validator: (value) {
                          if(!isSocial) {
                            if (_brnController.text.isEmpty) {
                              return "This field is required";
                            }
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                                SizedBox(height: ScreenUtil().setHeight(8)),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Mobile',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: ScreenUtil().setWidth(12),
                            fontFamily: 'work',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      TextFieldWidget(
                        controller: _mobileController,
                        title: "Mobile (Optional)",
                        validator: (value) {
                          /*if (_mobileController.text.isEmpty) {
                            return "This field is required";
                          }*/
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                isloading
                    ? CircularProgressIndicator(
                        color: appColor,
                      )
                    : GestureDetector(
                        onTap: () {
                            if (_formKey.currentState!.validate()) {
                              // Validation passed, navigate to the next page
                              checkValidation();
                            } else {
                              // Validation failed, show an error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Please fill in the required field.'),
                                ),
                              );
                            }
                          //    checkValidation();
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
                          text: 'Register Now',
                          press: () {},
                          color: appColor,
                        ),
                      ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
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
           /*     Row(
                  mainAxisAlignment: !Platform.isIOS?MainAxisAlignment.center:MainAxisAlignment.spaceEvenly,
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
                        Message(context, "Something went wrong");
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
                    !Platform.isIOS?Container():  Container(
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

              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkValidation() {
    final bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_emailController.text);
    setState(() {
      isSocial = false;

      if (_formKey.currentState!.validate()) {
        // Check additional conditions, such as non-empty text fields
        if (_emailController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty&&emailValid&&_confirmPasswordController.text.isNotEmpty&&_agencyNameController.text.isNotEmpty&&_agencyNameController.text.isNotEmpty&&_brnController.text.isNotEmpty) {
          // Validation passed, initiate the login
          // Call the login function
          RegisterAPI();
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

  }

  Future<void> RegisterAPI() async {
    setState(() {
      isloading = true;
    });
    String? token = await FirebaseMessaging.instance.getToken();
    print("Tpkoen::$token");
    var uri = Uri.https(
      apiBaseUrl,
      '/api/auth/user/registerotp',
    );
    final headers = {'Accept': 'application/json'};
    Map<String, dynamic> body = {
      'fcm': token,
      'role': "agent",
      'name': _nameController.text,
      'password': _passwordController.text,
      'email': _emailController.text,
      'agent_brn': _brnController.text,
      'company_name': _agencyNameController.text,
      'mobile_number': _mobileController.text.isNotEmpty?_mobileController.text:"",
      'agency_name': _agencyNameController.text
    };

    /* 'location': _addressController.text,
    'country_code': "+971",
    'agent_ref': _refNumController.text,
    'broker_orn': _ornController.text,

    'dld_no': _dldController.text,
    'description': _descriptionController.text,

    'company_address': _companyAddressController.text,
    'about_company': _aboutCompanyController.text,
    'about_me': "",
    'language': _languageController.text,
    'experience': _experienceController.text,
    'nationality': _nationalityController.text
*/
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

        Message(context, "Sent OTP Successfully");
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
                return RegistrationOtpVendor(
                    _passwordController.text,
                    _emailController.text,
                    _nameController.text,
                    _mobileController.text);
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
        postRegisterGoogleData(profile.userId, profile.name!, email!,"",imageUrl!);
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
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddInfo(name!,email!)));
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
  }}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> Message(
    BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 800),
    ),
  );
}
