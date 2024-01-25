import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_pro_vendor/Models/GetCountData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Constants/Colors.dart';
import '../Constants/Api.dart';
import '../Presentation/BottomNavigationBarVendor.dart';
import '../Presentation/common_button.dart';
import '../Presentation/upload_textfeild.dart';
import 'LoginPageVendor.dart';


class EditPeronalDetailsPage extends StatefulWidget {
  GetCountData getCountData;
  EditPeronalDetailsPage(this.getCountData);

  @override
  State<EditPeronalDetailsPage> createState() => _EditPeronalDetailsPageState();
}

class _EditPeronalDetailsPageState extends State<EditPeronalDetailsPage> {

  final TextEditingController _aboutCompanyeController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _feature1Controller = TextEditingController();


  bool isloading=false;

  bool isVisibleV = false;
  File? image;
  String aboutCompany = "";
  String language = "";
  String nationality = "";
  String experience = "";
  String location = "";

  void showWidget() {
    setState(() {
      isVisibleV = !isVisibleV;
    });
  }

  late String token;

  static List<TextEditingController> _controllers = [];
  List<Widget> _fields = [];

  @override
  void initState() {
    aboutCompany = widget.getCountData.user!.aboutCompany.toString();
    language = widget.getCountData.user!.language.toString();
    nationality = widget.getCountData.user!.nationality.toString();
    experience = widget.getCountData.user!.experience!=null?widget.getCountData.user!.experience!:"";
    location = widget.getCountData.user!.location.toString();
    print(aboutCompany);
    getTextFormField();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: secondaryColor
        ),
        backgroundColor: appColor,
        elevation: 0,
        centerTitle: true,
        title:
        Container(
          child: Text(
            'Edit Personal Details',
            style: TextStyle(
              color: secondaryColor,
              fontSize: ScreenUtil().setWidth(15),
              fontFamily: 'work',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(10),
              right: ScreenUtil().setWidth(10)),
          child: Column(
            children: [

              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),

              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'About Company',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: ScreenUtil().setWidth(12),
                          fontFamily: 'work',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextFieldUpload(
                      title:widget.getCountData.user!.aboutCompany != null ?  widget.getCountData.user!.aboutCompany.toString() : "Add About Company",
                      controller: _aboutCompanyeController,
                    ),
                  ],
                ),
              ),


              SizedBox(
                height: ScreenUtil().setHeight(7),
              ),


              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'Language',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: ScreenUtil().setWidth(12),
                          fontFamily: 'work',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextFieldUpload(
                      title: widget.getCountData.user!.language != null ? widget.getCountData.user!.language.toString() : "Add Language",
                      controller: _languageController,
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: ScreenUtil().setHeight(7),
              ),

              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'Nationality',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: ScreenUtil().setWidth(12),
                          fontFamily: 'work',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextFieldUpload(
                      title: widget.getCountData.user!.nationality != null ? widget.getCountData.user!.nationality.toString() : 'Add Nationality',
                      controller: _nationalityController,
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: ScreenUtil().setHeight(7),
              ),


              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'Experience',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: ScreenUtil().setWidth(12),
                          fontFamily: 'work',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextFieldUpload(
                      title:  widget.getCountData.user!.experience != null ? widget.getCountData.user!.experience.toString() : 'Add Experience',
                      controller: _experienceController,
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: ScreenUtil().setHeight(7),
              ),



              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text("Location",
                        style: TextStyle(
                            fontSize: ScreenUtil()
                                .setHeight(14),
                            color: primaryColor,
                            fontFamily: 'work',
                            fontWeight:
                            FontWeight.w600)),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(7),
                  ),

                  _listView(),
                ],
              ),

              SizedBox(
                height: ScreenUtil().setHeight(25),
              ),

              isloading?CircularProgressIndicator(color: appColor,):
              GestureDetector(
                onTap: () {
                  callApi();

                },
                child: RoundedButton(
                  text: 'Edit Profile',
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
    );
  }


  void getTextFormField() {
    final field = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: ScreenUtil().setHeight(50),
          width: ScreenUtil().setWidth(280),
          child: TextFormField(
            controller: _feature1Controller,
            keyboardType: TextInputType.text,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
              fontSize: ScreenUtil().setHeight(14),
              color: primaryColor,
              fontWeight: FontWeight.w400,
              fontFamily: 'work',
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: secondaryColor,
              hintText: "Add Location",
              hintStyle: TextStyle(
                  fontFamily: 'work',
                  fontSize: ScreenUtil().setHeight(14),
                  fontWeight: FontWeight.w400,
                  color: primaryColor),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: textFieldBorderColor),
                  borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.only(left: 20),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.exposure_minus_1),
          color: appColor,
          onPressed: () async {
            final controller = TextEditingController();
            final field = TextFormField(
              controller: controller,
              keyboardType: TextInputType.text,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                fontSize: ScreenUtil().setHeight(14),
                color: primaryColor,
                fontWeight: FontWeight.w400,
                fontFamily: 'work',
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: secondaryColor,
                hintText: "Location ${_controllers.length + 1}",
                hintStyle: TextStyle(
                    fontFamily: 'work',
                    fontSize: ScreenUtil().setHeight(14),
                    fontWeight: FontWeight.w400,
                    color: primaryColor),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: textFieldBorderColor),
                    borderRadius: BorderRadius.circular(10)),
                contentPadding: EdgeInsets.only(left: 20),
              ),
            );
            setState(() {
              _controllers.add(controller);
              _fields.add(field);
            });
          },)
      ],
    );
    _controllers.add(_feature1Controller);
    _fields.add(field);
  }

  Widget _listView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _fields.length,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(5),
                  bottom: ScreenUtil().setHeight(5)
              ),
              child: Container(
                height: ScreenUtil().setHeight(34),
                width: ScreenUtil().setWidth(250),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: textFieldBorderColor)
                ),
                child: TextFormField(
                  controller: _controllers[index],
                  keyboardType: TextInputType.text,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    fontSize: ScreenUtil().setHeight(14),
                    color: primaryColor,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'work',
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: secondaryColor,
                    hintText: "Location",
                    hintStyle: TextStyle(
                        fontFamily: 'work',
                        fontSize: ScreenUtil().setHeight(14),
                        fontWeight: FontWeight.w400,
                        color: lightTextColor),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.only(left: 20),
                  ),
                ),
              ),
            ),

            index == 0 ?
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              color: appColor,
              onPressed: () async {
                final controller = TextEditingController();
                final field = TextFormField(
                  controller: _controllers[index],
                  keyboardType: TextInputType.text,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    fontSize: ScreenUtil().setHeight(14),
                    color: primaryColor,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'work',
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: secondaryColor,
                    hintText: "Location",
                    hintStyle: TextStyle(
                        fontFamily: 'work',
                        fontSize: ScreenUtil().setHeight(14),
                        fontWeight: FontWeight.w400,
                        color: primaryColor),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.only(left: 20),
                  ),
                );
                setState(() {
                  _controllers.add(controller);
                  _fields.add(field);
                });
              },)
                : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  color: appColor,
                  onPressed: () async {
                    final controller = TextEditingController();
                    final field = TextFormField(
                      controller: _controllers[index],
                      keyboardType: TextInputType.text,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        fontSize: ScreenUtil().setHeight(14),
                        color: primaryColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'work',
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: secondaryColor,
                        hintText: "Location",
                        hintStyle: TextStyle(
                            fontFamily: 'work',
                            fontSize: ScreenUtil().setHeight(14),
                            fontWeight: FontWeight.w400,
                            color: primaryColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.only(left: 20),
                      ),
                    );
                    setState(() {
                      _controllers.add(controller);
                      _fields.add(field);
                    });
                  },),
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  color: appColor,
                  onPressed: () async {
                    final controller = TextEditingController();
                    final field = TextFormField(
                      controller: _controllers[index],
                      keyboardType: TextInputType.text,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        fontSize: ScreenUtil().setHeight(14),
                        color: primaryColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'work',
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: secondaryColor,
                        hintText: "Location",
                        hintStyle: TextStyle(
                            fontFamily: 'work',
                            fontSize: ScreenUtil().setHeight(14),
                            fontWeight: FontWeight.w400,
                            color: primaryColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.only(left: 20),
                      ),
                    );
                    setState(() {
                      _controllers.removeAt(index);
                      _fields.removeAt(index);
                    });
                  },),
              ],
            ),

          ],
        );
      },
    );
  }

  Future<void> selectPhoto() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );
      final pickedImageFile = File(pickedImage!.path);
      setState(() {
        image = pickedImageFile;
      });
    } catch (error) {
      print("error: $error");
    }
  }

  Future<void> callApi() async {
    List<String> textController = [];
    for(int i = 0; i<_controllers.length; i++)
    {
      textController.add(_controllers[i].text);
    }
    print("Text:: ${textController}");
    setState(() {
      isloading = true;
    });
    final headers = {'Accept': 'application/json'};
    //String? token = await FirebaseMessaging.instance.getToken();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/edit_profile',
    );
    var request = new http.MultipartRequest("POST", url);
    request.headers['Authorization']=prefs.getString('access_token')!;
    request.fields['email'] =prefs.getString('email')!;
    request.fields['about_company'] =_aboutCompanyeController.text;
    request.fields['nationality'] = _nationalityController.text;
    request.fields['language'] =_languageController.text;
    request.fields['experience'] =_experienceController.text;
    request.fields['location'] = json.encode(textController);
    request.fields['country_code'] ="+971";

    request
        .send()
        .then((response) {
      if (response.statusCode == 200) print("Uploaded!");
      print(response.statusCode);

      int statusCode = response.statusCode;
      http.Response.fromStream(response).then((response) {
        print('response.body ' + response.body);

        var getdata = json.decode(response.body);

        if (response.statusCode == 200) {
          if (getdata["status"]) {
            setState(() {
              isloading = false;
            });
            Message(context, "Edit Profile Successfully");
            /* if (getdata["data"]["user"]["company_logo"] != null) {
              prefs.setString("company_logo", getdata["data"]["user"]["company_logo"]);
            }*/
           /* if (getdata["data"]["user"]["about_company"] != null) {
              prefs.setString("company_logo", getdata["data"]["user"]["about_company"]);
            }*/
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
            Message(context, getdata["message"]);
          }
        } else {
          setState(() {
            isloading = false;
          });
          Message(context, getdata["message"]);
        }

        return response.body;
      });
    })
        .catchError((err) => print('error : ' + err.toString()))
        .whenComplete(() {});
  }
}

