import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../Constants/Api.dart';
import '../Constants/Colors.dart';
import '../Presentation/common_button.dart';
import '../Presentation/common_textfeild.dart';
import 'Presentation/BottomNavigationBarVendor.dart';
import 'Screens/AddInfo.dart';


class ContactUs extends StatefulWidget {
  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool isloading=false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isVisibleV = false;
  File? image;
  String profileImage="";

  void showWidget() {
    setState(() {
      isVisibleV = !isVisibleV;
    });
  }

  late String token;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    initData();
    super.initState();
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
          margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(30),
              right: ScreenUtil().setWidth(30)),
          child: Form(
            key: _formKey,

            child: Column(
              children: [

                SizedBox(
                  height: ScreenUtil().setHeight(25),
                ),


                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Name",
                            style:
                            TextStyle(
                              color:
                              primaryColor,
                              fontSize:
                              ScreenUtil().setWidth(12),
                              fontFamily:
                              'work',
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setHeight(8),),
                      TextFieldWidget(
                        controller: _nameController,
                        title: "Name",
                        validator: (value) {

                          if (_nameController.text.isEmpty) {
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Email",
                            style:
                            TextStyle(
                              color:
                              primaryColor,
                              fontSize:
                              ScreenUtil().setWidth(12),
                              fontFamily:
                              'work',
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setHeight(8),),
                      TextFieldWidget(
                        controller: _emailController,
                        title: "Email",
                        validator: (value) {
                          final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(_emailController.text);
                          if (_emailController.text.isEmpty) {
                            return 'This field is required';
                          }
                          else if(!emailValid)
                          {
                            return 'Enter valid Email';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Title",
                            style:
                            TextStyle(
                              color:
                              primaryColor,
                              fontSize:
                              ScreenUtil().setWidth(12),
                              fontFamily:
                              'work',
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setHeight(8),),
                      TextFieldWidget(
                        controller: _titleController,
                        title: "Title",
                        validator: (value) {

                          if (_titleController.text.isEmpty) {
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Description",
                            style:
                            TextStyle(
                              color:
                              primaryColor,
                              fontSize:
                              ScreenUtil().setWidth(12),
                              fontFamily:
                              'work',
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setHeight(8),),
                      TextFieldWidget(
                        controller: _descriptionController,
                        title: "Description",
                        validator: (value) {

                          if (_descriptionController.text.isEmpty) {
                            return 'This field is required';
                          }

                          return null;
                        },
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
                  },
                  child: RoundedButton(
                    text: 'Submit',
                    press: () {},
                    color: appColor,
                  ),
                ),



                SizedBox(height:ScreenUtil().setHeight(15)),

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


  Future<void> callApi() async {
    setState(() {
      isloading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uri = Uri.https(
      apiBaseUrl,
      '/api/user/contact_customer_support',
    );
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    // String? token = await FirebaseMessaging.instance.getToken();

    //  print("token:::$token");
    Map<String, dynamic> body = {
      'name': _nameController.text,
      'email': _emailController.text,
      'title':_titleController.text,
      'description': _descriptionController.text,

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
    print("customerSupport::$responseBody");

    if (getdata["status"] == true) {
      setState(() {
        isloading = false;
      });
      Message(context,"Mail Sent successfully!");
      Future.delayed(const Duration(milliseconds: 2000), () {
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
      Message(context, getdata["data"]["message"]);
    }

  }

  void checkValidation() {
    final bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_emailController.text);
    setState(() {
      if (_formKey.currentState!.validate()) {
        // Check additional conditions, such as non-empty text fields
        if (_emailController.text.isNotEmpty &&emailValid&&
            _nameController.text.isNotEmpty&&_descriptionController.text.isNotEmpty&&_titleController.text.isNotEmpty) {
          // Validation passed, initiate the login
          // Call the login function
          callApi();
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

  Future<void> initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _nameController.text=prefs.getString("name")!;
    _emailController.text=prefs.getString("email")!;

  }

}
