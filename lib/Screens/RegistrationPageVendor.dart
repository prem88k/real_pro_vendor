import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Constants/Api.dart';
import '../Constants/Colors.dart';
import '../Presentation/upload_textfeild.dart';
import 'package:http/http.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'RegistrationOtpVendor.dart';

class RegistrationPageVendor extends StatefulWidget {
  const RegistrationPageVendor({Key? key}) : super(key: key);

  @override
  State<RegistrationPageVendor> createState() => _RegistrationPageVendorState();
}

class _RegistrationPageVendorState extends State<RegistrationPageVendor> {

  int _activeCurrentStep = 0;
  bool isloading=false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _refNumController = TextEditingController();
  final TextEditingController _ornController = TextEditingController();
  final TextEditingController _brnController = TextEditingController();
  final TextEditingController _dldController = TextEditingController();

  List<Step> stepList() => [
    Step(
      state: _activeCurrentStep <= 0 ? StepState.editing : StepState.complete,
      isActive: _activeCurrentStep >= 0,
      title: const Text('Profile Deetails'),
      content: Container(
        child: Column(
          children: [

            TextFieldUpload(
              title: 'Email',
              controller: _emailController,
            ),

            TextFieldUpload(
              title: 'Password',
              controller: _passwordController,
            ),


            TextFieldUpload(
              title: 'Name',
              controller: _nameController,
            ),


            TextFieldUpload(
              title: 'Phone Number',
              controller: _phoneController,
            ),


            TextFieldUpload(
              title: 'Address',
              controller: _addressController,
            ),


            TextFieldUpload(
              title: 'Postal Code',
              controller: _postalCodeController,
            ),
          ],
        ),
      ),
    ),
    Step(
        state: StepState.complete,
        isActive: _activeCurrentStep >= 1,
        title: const Text('Property Details'),
        content: Container(
          child: Column(
            children: [

              TextFieldUpload(
                title: 'Reference Number',
                controller: _refNumController,
              ),

              TextFieldUpload(
                title: 'Broker ORN',
                controller: _ornController,
              ),

              TextFieldUpload(
                title: 'Agent BRN',
                controller: _brnController,
              ),

              TextFieldUpload(
                title: 'DLD Permit Number',
                controller: _dldController,
              ),
            ],
          ),
        )),
  ];

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
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Column(
        children: [
          Container(
            height: ScreenUtil().setHeight(90),
            alignment: Alignment.center,
            child: Image(
              image: AssetImage("assets/images/login_bg.png"),
              fit: BoxFit.fill,
              height: ScreenUtil().setHeight(90),
              width: double.infinity,
            ),
          ),
          Expanded(
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: _activeCurrentStep,
              steps: stepList(),
              onStepContinue: () {
                if (_activeCurrentStep < (stepList().length - 1)) {
                  setState(() {
                    _activeCurrentStep += 1;
                  });
                }
                else if(_activeCurrentStep == 1){
                  setState(() {
                    checkValidation();
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return BottomNavigationBarVendor();
                        },
                      ),
                    );*/
                  });
                }
              },

              onStepCancel: () {
                if (_activeCurrentStep == 0) {
                  return;
                }
                setState(() {
                  _activeCurrentStep -= 1;
                });
              },

              onStepTapped: (int index) {
                setState(() {
                  _activeCurrentStep = index;
                });
              },

            ),
          ),
        ],
      ),
    );
  }

  void checkValidation() {
    if (_emailController.text.isEmpty) {
      Message(context, "Enter Email Address");
    }
    else if (_phoneController.text.isEmpty) {
      Message(context, "Enter Phone");
    }
    else if (_nameController.text.isEmpty) {
      Message(context, "Enter Name");
    }
    else if (_passwordController.text.isEmpty) {
      Message(context, "Enter Password");
    }
    else if (_addressController.text.isEmpty) {
      Message(context, "Enter Address");
    }
    else if (_postalCodeController.text.isEmpty) {
      Message(context, "Enter Postal Code");
    }
    else if(_refNumController.text.isEmpty) {
      Message(context, "Enter Reference Number");
    }
    else if(_ornController.text.isEmpty) {
      Message(context, "Enter Broker ORN");
    }
    else if(_brnController.text.isEmpty) {
      Message(context, "Enter Agent BRN");
    }
    else if(_dldController.text.isEmpty) {
      Message(context, "Enter DLD Permit Number");
    }
    else {
      RegisterAPI();
    }
  }

  Future<void> RegisterAPI() async {
    setState(() {
      isloading = true;
    });
    String? token = await FirebaseMessaging.instance.getToken();
    print("Tpkoen::$token");
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/auth/user/registerotp',
    );
    final headers = {'Accept': 'application/json'};
    Map<String, dynamic> body = {
      'fcm':token,
      'role': "agent",
      'name': _nameController.text,
      'password': _passwordController.text,
      'email': _emailController.text,
      'mobile_number': _phoneController.text,
      'location': _addressController.text,
      'country_code': "+971",
      'agent_ref': _refNumController.text,
      'broker_orn': _ornController.text,
      'agent_brn': _brnController.text,
      'dld_no': _dldController.text
    };
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return  RegistrationOtpVendor(_passwordController.text,_emailController.text, _nameController.text,_phoneController.text);
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
