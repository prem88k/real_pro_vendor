import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Constants/Api.dart';
import '../Constants/Colors.dart';
import '../Presentation/BottomNavigationBarVendor.dart';
import '../Presentation/common_button.dart';
import '../Presentation/common_textfeild.dart';
import 'package:http/http.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'RegistrationOtpVendor.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class AddInfo extends StatefulWidget {
  String name;
  String email;
  AddInfo(this. name, this. email);


  @override
  State<AddInfo> createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late String deviceName = "";
  late String name;
  late String email;
  late String imageUrl;
  late String uId;
  String? deviceId;
  bool isloading=false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _agencyNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _brnController = TextEditingController();

  late String token;

  @override
  void initState() {
    getToken();
    _nameController.text=widget.name;
    _emailController.text=widget.email;
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
              bottom:ScreenUtil().setHeight(30) ,
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
                    'Additional Details',
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
                        isEnable: false,
                        validator: (value) {
                          if (_emailController.text.isEmpty) {
                            return 'This field is required';
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
                        isEnable: false,
                        validator:(value) {
                          if (_nameController.text.isEmpty) {
                            return "This field is required";
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
                        validator:(value) {
                          if (_agencyNameController.text.isEmpty) {
                            return "This field is required";
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
                          if (_brnController.text.isEmpty) {
                            return "This field is required";
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
                        title: "Mobile",
                        validator: (value) {
                          if (_mobileController.text.isEmpty) {
                            return "This field is required";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),

                isloading?CircularProgressIndicator(color: appColor,):GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_formKey.currentState!.validate()) {
                        // Validation passed, navigate to the next page
                        checkValidation();
                      } else {
                        // Validation failed, show an error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill in the required field.'),
                          ),
                        );
                      }
                    });
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
                    text: 'Submit',
                    press: () {},
                    color: appColor,
                  ),
                ),

                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkValidation() {
    if (_emailController.text.isEmpty) {
  //    print('Entered Text: ${_emailController.text}');
     // Message(context, "Enter Email Address");
    }
    else if (_mobileController.text.isEmpty) {
      Message(context, "Enter Mobile Number");
    }
    else if (_nameController.text.isEmpty) {
      Message(context, "Enter Agent Name");
    }

    else if (_agencyNameController.text.isEmpty) {
      Message(context, "Enter Agency Name");
    }
    else if (_brnController.text.isEmpty) {
      Message(context, "Enter BRN");
    }
    else {
      RegisterAPI();
    }
  }

  Future<void> RegisterAPI() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isloading = true;
    });
    String? token = await FirebaseMessaging.instance.getToken();
    print("Tpkoen::$token");
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/edit_profile',
    );
    final headers = {'Authorization': '${prefs.getString('access_token')}'};

    Map<String, dynamic> body = {
      'fcm':token,
      'role': "agent",
      'name': _nameController.text,
      'email': _emailController.text,
      'agent_brn': _brnController.text,
      'company_name': _agencyNameController.text,
      'mobile_number': _mobileController.text,
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

        Message(context, "Info Added Successfully!");
        /* prefs.setString("access_token", "Bearer ${getdata["0"]["original"]["access_token"].toString()}");
        prefs.setString("name", getdata["0"]["original"]["user"]["name"].toString());
        prefs.setString("UserId", "${getdata["0"]["original"]["user"]["id"].toString()}");
        prefs.setString("email", getdata["0"]["original"]["user"]["email"].toString());
        prefs.setString("phone", getdata["0"]["original"]["user"]["mobile_number"].toString());
        prefs.setBool("isLogging", true);*/

        /*bookTable();*/
        Future.delayed(const Duration(milliseconds: 1000), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return  BottomNavigationBarVendor();
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
