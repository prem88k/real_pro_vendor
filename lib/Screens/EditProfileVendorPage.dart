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

class EditProfileVendorPage extends StatefulWidget {
  GetCountData getCountData;
  EditProfileVendorPage(this.getCountData);

  @override
  State<EditProfileVendorPage> createState() => _EditProfileVendorPageState();
}

class _EditProfileVendorPageState extends State<EditProfileVendorPage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _agencyNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _brnController = TextEditingController();
  bool isloading=false;

  bool isVisibleV = false;
  File? image;
  String profileImage = "";
  String agencyName = "";

  void showWidget() {
    setState(() {
      isVisibleV = !isVisibleV;
    });
  }

  late String token;

  @override
  void initState() {
    getToken();
     profileImage = widget.getCountData.user!.image.toString();
    _nameController.text = widget.getCountData.user!.name.toString();
    _mobileController.text = widget.getCountData.user!.mobileNumber.toString();
   _emailController.text = widget.getCountData.user!.email.toString();
   _brnController.text = widget.getCountData.user!.agentBrn.toString();

   // getToken();
    // TODO: implement initState
    super.initState();
    agencyName = widget.getCountData.user!.agencyName.toString();
  }

  getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImage=prefs.getString("profileImage")!;
    });
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
            'Edit Profile',
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
              left: ScreenUtil().setWidth(30),
              right: ScreenUtil().setWidth(30)),
          child: Column(
            children: [

              SizedBox(
                height: ScreenUtil().setHeight(25),
              ),

              GestureDetector(
                onTap: (){
                  selectPhoto();
                },
                child: Container(
                  alignment: Alignment.center,
                  child:
                  profileImage!=null?
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                     profileImage,
                    ),
                    radius: 50,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          //  getImage1();
                        },
                        child: Container(
                          padding: EdgeInsets.all(05),
                          decoration: BoxDecoration(
                              border: Border.all(color: primaryColor),
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            Icons.add_a_photo,
                            color: appColor,
                            size: ScreenUtil().setHeight(17),
                          ),
                        ),
                      ),
                    ),
                  ): image==null?
                  CircleAvatar(
                    backgroundImage: AssetImage(
                      "assets/images/dp.png",
                    ),
                    radius: 50,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          //  getImage1();
                        },
                        child: Container(
                          padding: EdgeInsets.all(05),
                          decoration: BoxDecoration(
                              border: Border.all(color: primaryColor),
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            Icons.add_a_photo,
                            color: appColor,
                            size: ScreenUtil().setHeight(17),
                          ),
                        ),
                      ),
                    ),
                  ):
                  CircleAvatar(
                    backgroundImage: FileImage(
                      image!,
                    ),
                    radius: 50,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          //  getImage1();
                        },
                        child: Container(
                          padding: EdgeInsets.all(05),
                          decoration: BoxDecoration(
                              border: Border.all(color: primaryColor),
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            Icons.add_a_photo,
                            color: appColor,
                            size: ScreenUtil().setHeight(17),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),

              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'Email',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: ScreenUtil().setWidth(12),
                          fontFamily: 'work',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextFieldUpload(
                      title: 'Agent Name',
                      controller: _nameController,
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
                        'Mobile Number',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: ScreenUtil().setWidth(12),
                          fontFamily: 'work',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextFieldUpload(
                      title: 'Mobile Number',
                      controller: _mobileController,
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
                        'Agent BRN',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: ScreenUtil().setWidth(12),
                          fontFamily: 'work',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextFieldUpload(
                      title: 'Agent BRN',
                      controller: _brnController,
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
                        'Agency Name',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: ScreenUtil().setWidth(12),
                          fontFamily: 'work',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextFieldUpload(
                      title: widget.getCountData.user!.agencyName != null ? widget.getCountData.user!.agencyName.toString() : "Add Agency Name",
                      controller: _agencyNameController,
                    ),
                  ],
                ),
              ),

              /*  TextFieldUpload(
                title: 'Agency Name',
                controller: _dldController,
              ),*/

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
    setState(() {
      isloading = true;
    });
    final headers = {'Accept': 'application/json'};
    String? token = await FirebaseMessaging.instance.getToken();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/edit_profile',
    );
    var request = new http.MultipartRequest("POST", url);
    request.headers['Authorization']=prefs.getString('access_token')!;
    request.fields['email'] =prefs.getString('email')!;
    request.fields['mobile_number'] =_mobileController.text;
    request.fields['name'] = _nameController.text;
    request.fields['agent_brn'] =_brnController.text;
    request.fields['agency_name'] = _agencyNameController.text;
    request.fields['country_code'] ="+971";

    if(image!=null)
    {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image!.path,
        ),
      );
    }
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
            /*if (getdata["data"]["user"]["image"] != null) {
              prefs.setString("profileImage", getdata["data"]["user"]["image"]);
            }
            if (getdata["data"]["user"]["agency_name"] != null) {
              prefs.setString("agencyName", getdata["data"]["user"]["agency_name"]);
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

