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

class EditCompanyDetailsPage extends StatefulWidget {
  GetCountData getCountData;
  EditCompanyDetailsPage(this.getCountData);

  @override
  State<EditCompanyDetailsPage> createState() => _EditCompanyDetailsPageState();
}

class _EditCompanyDetailsPageState extends State<EditCompanyDetailsPage> {

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyAddressController = TextEditingController();
  final TextEditingController _brokerOrnController = TextEditingController();
  final TextEditingController _companyDetailsController = TextEditingController();

  bool isloading=false;

  bool isVisibleV = false;
  File? image;
  void showWidget() {
    setState(() {
      isVisibleV = !isVisibleV;
    });
  }

  late String token;

  @override
  void initState() {
  //  _companyNameController.text = widget.getCountData.user!.companyName.toString();
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
            'Edit Company Details',
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
                height: ScreenUtil().setHeight(20),
              ),

              GestureDetector(
                onTap: (){
                  selectPhoto();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company Logo',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: ScreenUtil().setWidth(12),
                        fontFamily: 'work',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(15),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child:widget.getCountData.user?.companyLogo !=null ? CircleAvatar(
                        backgroundImage: NetworkImage(
                          userProfile+widget.getCountData.user!.companyLogo.toString(),
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
                      ):  image==null?
                      Container(
                        height: ScreenUtil().setHeight(85),
                        width: ScreenUtil().setWidth(85),
                        padding: EdgeInsets.all(05),
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor),
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                         //   image: DecorationImage(image: AssetImage("assets/images/property_img.png",), fit: BoxFit.cover)
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(05),
                            decoration: BoxDecoration(
                           //     border: Border.all(color: primaryColor),
                                color: secondaryColor,
                             //   borderRadius: BorderRadius.circular(100)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  color: appColor,
                                  size: ScreenUtil().setHeight(22),
                                ),
                                Text(
                                  'Add Logo',
                                  style: TextStyle(
                                    color: primaryTextColor,
                                    fontSize: ScreenUtil().setHeight(12),
                                    fontFamily: 'work',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ): Container(
                        height: ScreenUtil().setHeight(85),
                        width: ScreenUtil().setWidth(85),
                        padding: EdgeInsets.all(05),
                        decoration: BoxDecoration(
                          //  border: Border.all(color: primaryColor),
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(image: FileImage(image!), fit: BoxFit.cover)),
                      ),
                    ),
                  ],
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
                        'Company Name',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: ScreenUtil().setWidth(12),
                          fontFamily: 'work',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextFieldUpload(
                      title: widget.getCountData.user!.companyName != null ? widget.getCountData.user!.companyName.toString() : "Add Company Name",
                      controller: _companyNameController,
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
                        'Company Address',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: ScreenUtil().setWidth(12),
                          fontFamily: 'work',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextFieldUpload(
                      title:  widget.getCountData.user!.companyAddress != null ? widget.getCountData.user!.companyAddress.toString() : "Add Company Address",
                      controller: _companyAddressController,
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
                        'ORN',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: ScreenUtil().setWidth(12),
                          fontFamily: 'work',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextFieldUpload(
                      title: widget.getCountData.user!.brokerOrn != null ? widget.getCountData.user!.brokerOrn.toString() : "Add ORN",
                      controller: _brokerOrnController,
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
                        'Description',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: ScreenUtil().setWidth(12),
                          fontFamily: 'work',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(15),
                    ),

                    TextFormField(
                      controller: _companyDetailsController,
                      keyboardType: TextInputType.text,
                      textAlignVertical: TextAlignVertical.center,
                      maxLines: 5,
                      maxLength: 250,
                      style: TextStyle(
                        fontSize:  ScreenUtil().setWidth(12.5),
                        color: primaryColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'work',
                      ),

                      validator: (value) {
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: false,
                        hintText: "Description",
                        hintStyle: TextStyle(
                            fontFamily: 'work',
                            fontSize:   ScreenUtil().setWidth(12.5),
                            fontWeight: FontWeight.w400,
                            color: lightTextColor),
                        border: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: textFieldBorderColor),
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(20),
                            top: ScreenUtil().setHeight(15),
                            bottom: ScreenUtil().setHeight(15)),
                      ),
                    ),

                  ],
                ),
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
                  text: 'Update',
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
   // String? token = await FirebaseMessaging.instance.getToken();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/edit_profile',
    );
    var request = new http.MultipartRequest("POST", url);
    request.headers['Authorization']=prefs.getString('access_token')!;
    request.fields['email'] =prefs.getString('email')!;
    request.fields['company_name'] =_companyNameController.text;
    request.fields['company_address'] = _companyAddressController.text;
    request.fields['broker_orn'] =_brokerOrnController.text;
    request.fields['country_code'] ="+971";
    request.fields['about_company'] =_companyDetailsController.text;

    if(image!=null)
    {
      request.files.add(
        await http.MultipartFile.fromPath(
          'company_logo',
          image!.path,
        ),
      );
    }

    request.send().then((response) {
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
              prefs.setString("companyLogo", getdata["data"]["user"]["company_logo"]);
            }
            if (getdata["data"]["user"]["company_name"] != null) {
              prefs.setString("companyName", getdata["data"]["user"]["company_name"]);
            }
            print(" ${prefs.setString("companyName", getdata["data"]["user"]["company_name"])}");
            if (getdata["data"]["user"]["company_address"] != null) {
              prefs.setString("companyAddress", getdata["data"]["user"]["company_address"]);
            }
            if (getdata["data"]["user"]["broker_orn"] != null) {
              prefs.setString("brokerORN", getdata["data"]["user"]["broker_orn"]);
            }*/

            Future.delayed(const Duration(milliseconds: 1000), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BottomNavigationBarVendor(3);
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

