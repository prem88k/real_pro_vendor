import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Constants/Colors.dart';
import '../Constants/Api.dart';
import '../Models/GetProfileData.dart';
import '../Presentation/BottomNavigationBarVendor.dart';
import '../Presentation/common_button.dart';
import '../Presentation/upload_textfeild.dart';
import 'LoginPageVendor.dart';


class EditProfileVendorPage extends StatefulWidget {
  GetProfileData getProfileData;
  EditProfileVendorPage(this.getProfileData);


  @override
  State<EditProfileVendorPage> createState() => _EditProfileVendorPageState();
}

class _EditProfileVendorPageState extends State<EditProfileVendorPage> {


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _refNumController = TextEditingController();
  final TextEditingController _ornController = TextEditingController();
  final TextEditingController _brnController = TextEditingController();
  final TextEditingController _dldController = TextEditingController();
  bool isloading=false;


  bool isVisibleV = false;
  File? image;
  String profileImage="";

  void showWidget() {
    setState(() {
      isVisibleV = !isVisibleV;
    });
  }

  late String token;

  @override
  void initState() {
    profileImage = widget.getProfileData.user!.image.toString();
    _nameController.text = widget.getProfileData.user!.name.toString();
    _phoneController.text = widget.getProfileData.user!.mobileNumber.toString();
   _refNumController.text = widget.getProfileData.user!.agentRef.toString();
   _ornController.text = widget.getProfileData.user!.brokerOrn.toString();
   _brnController.text = widget.getProfileData.user!.agentBrn.toString();
   _dldController.text = widget.getProfileData.user!.dldNo.toString();
   // getToken();
    // TODO: implement initState
    super.initState();
  }

  /*getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _phoneController.text=prefs.getString("phone")!;
      _nameController.text=prefs.getString("name")!;
      profileImage=prefs.getString("profileImage")!;

    });
  }*/

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
          child: Column(
            children: [

              Container(
                alignment: Alignment.center,
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: ScreenUtil().setWidth(22),
                    fontFamily: 'work',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(25),
              ),
              GestureDetector(
                onTap: (){
                  selectPhoto();

                },
                child: Container(
                  alignment: Alignment.center,
                  child:profileImage!=null?CircleAvatar(
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
                  ): image==null?CircleAvatar(
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
                  ):CircleAvatar(
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

              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              isloading?CircularProgressIndicator(color: appColor,):GestureDetector(
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
    request.fields['mobile_number'] =_phoneController.text;
    request.fields['name'] = _nameController.text;
    request.fields['location'] =_addressController.text;
    request.fields['agent_ref'] =_refNumController.text;
    request.fields['broker_orn'] = _ornController.text;
    request.fields['agent_brn'] =_brnController.text;
    request.fields['dld_no'] = _dldController.text;
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
            if (getdata["data"]["user"]["image"] != null) {
              prefs.setString("profileImage", getdata["data"]["user"]["image"]);
            }
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

