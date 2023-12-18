import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import '../Constants/Api.dart';
import '../Constants/Colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import '../Models/GetAmenitiesData.dart';
import '../Models/GetCaategoryData.dart';
import '../Models/GetPropertyDetailsData.dart';
import '../Presentation/common_button.dart';
import '../Presentation/upload_textfeild.dart';

class EditPropertyOnRentPage extends StatefulWidget {
  String property_id;
  EditPropertyOnRentPage(this.property_id);


  @override
  State<EditPropertyOnRentPage> createState() => _EditPropertyOnRentPageState();
}

class _EditPropertyOnRentPageState extends State<EditPropertyOnRentPage> {

  int? selectedOption;
  final TextEditingController _houseTitleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bedroomController = TextEditingController();
  final TextEditingController _toiletController = TextEditingController();
  final TextEditingController _sqftController = TextEditingController();
  final TextEditingController _feature1Controller = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _realProController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  late String placeid;
  String googleApikey = "AIzaSyCkW__vI2DazIWYjIMigyxwDtc_kyCBVIo";
  GoogleMapController? mapController; //contrller for Google map
  LatLng? showLocation;
  String location = "Select Leaving from Location..";
  double? pickUpLat;
  double? pickUpLong;

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  List<File>? imageFilePathList = [];
  List<String>? imageFilePathString = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await
    imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
      imageFilePathList = imageFileList!.map<File>((xfile) => File(xfile.path)).toList();
      imageFilePathString = imageFilePathList!.map<String>((file) => (file.path)).toList();
    }
    print("Image List Length:" + imageFileList!.length.toString());
    setState((){});
  }

  late GecategoryData gecategoryData;
  List<CategoryList>? catList = [];
  String selectedCategory = "";
  var dropdownCategoryValue;


  List<String> _selectedLanguage = [];

  void _onJobLanguage(AmenitiesList amenitiesList) {
    setState(() {
      if (_selectedLanguage.contains(amenitiesList)) {
        _selectedLanguage.remove(amenitiesList);
      } else {
        _selectedLanguage.add(amenitiesList.toString());
      }
    });
  }

  late GetAmenitiesData getAmenitiesData;
  List<AmenitiesList>? amenitiesList = [];
  bool isloading = false;
  bool catloading = false;

  late GetPropertyDetails getPropertyDetails;
  List<PropertyDetails>? details = [];

  static List<TextEditingController> _controllers = [];
  List<Widget> _fields = [];

  bool isVisible = true;

  void showWidget(){
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    getCategory();
    getAmenities();
    getPropertyDetailsAPI();
    getTextFormField();
    _locationController.addListener(() {
      /*_onChanged();*/
    });
    // TODO: implement initState
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
              hintText: "Feature",
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
                hintText: "Feature ${_controllers.length + 1}",
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
      ],
    );
    _controllers.add(_feature1Controller);
    _fields.add(field);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0,
        iconTheme: IconThemeData(color: primaryColor),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Edit Post",
          style: TextStyle(
            color: primaryColor,
            fontSize: ScreenUtil().setWidth(20),
            fontFamily: 'work',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body:  isloading || catloading
          ? Center(
          child: CircularProgressIndicator(
            color: appColor,
          ))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: ScreenUtil().setHeight(7),
              ),
              Container(
                height: ScreenUtil().setHeight(280),
                width: ScreenUtil().screenWidth,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {

                          },
                          child: Container(
                            height: ScreenUtil().setHeight(83),
                            width: ScreenUtil().setWidth(83),
                            decoration: DottedDecoration(
                                color: appColor,
                                shape: Shape.box,
                                borderRadius: BorderRadius.circular(10)
                            ),// color of grid items
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_to_queue,
                                  size: 34,
                                  color: appColor,),
                                SizedBox(
                                  height: ScreenUtil().setHeight(10),
                                ),
                                Text(
                                  "Upload Video",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setHeight(8),
                                      color: appColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        GestureDetector(
                          onTap: () {
                            selectImages();
                          },
                          child: Container(
                            height: ScreenUtil().setHeight(83),
                            width: ScreenUtil().setWidth(83),
                            decoration: DottedDecoration(
                                color: appColor,
                                shape: Shape.box,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 34,
                                  color: appColor,),
                                SizedBox(
                                  height: ScreenUtil().setHeight(10),
                                ),
                                Text(
                                  "Upload Image",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setHeight(8),
                                      color: appColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Expanded(
                      child: GridView.builder(
                          itemCount: imageFileList!.length,
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 0,
                              crossAxisSpacing: 0,
                              crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.file(
                                  File(imageFileList![index].path),
                                  height: ScreenUtil().setHeight(83),
                                  width: ScreenUtil().setWidth(83),
                                  fit: BoxFit.fill,),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(5),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    /* padding: EdgeInsets.only(
                      left: size.width * 0.025,
                      right: size.width * 0.05,
                    ),*/
                    //  margin: EdgeInsets.only(left: ScreenUtil().setWidth(5)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: secondaryColor
                    ),
                    height: ScreenUtil().setHeight(50),
                    width: ScreenUtil().setWidth(340),
                    child: DropdownButtonHideUnderline(
                      child:
                      Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(20),
                            right: ScreenUtil().setWidth(10)
                        ),
                        child: DropdownButton<String>(
                          iconSize: 30,
                          style: TextStyle(
                            color: primaryColor,
                          ),
                          dropdownColor: secondaryColor,
                          isExpanded: true,
                          value: dropdownCategoryValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownCategoryValue = newValue;
                              print("Cart Id::$newValue");
                              selectedCategory = newValue!;
                            });
                          },
                          hint: Row(
                            children: [
                              Text(
                                "House Category",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontSize: ScreenUtil().setHeight(12.5),
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          icon: Icon(
                            // Add this
                            Icons.arrow_drop_down, // Add this
                            color: primaryColor, // Add this
                          ),
                          items: catList!.map((CategoryList value) {
                            return DropdownMenuItem<String>(
                              value: value.id.toString(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    value.name!,
                                    style: TextStyle(
                                        fontFamily: 'work',
                                        color: primaryColor,
                                        fontSize: ScreenUtil().setHeight(12.5),
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: ScreenUtil().setHeight(5),
              ),
              TextFieldUpload(
                title: 'Address',
                controller: _addressController,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/images/bed.png",
                              height: ScreenUtil().setHeight(15),
                              width: ScreenUtil().setWidth(18)),
                          SizedBox(
                            width: ScreenUtil().setWidth(5),
                          ),
                          Text(
                           "Bedroom",
                            style: TextStyle(
                              color: darkTextColor,
                              fontSize: ScreenUtil().setWidth(12),
                              fontFamily: 'work',
                              height: ScreenUtil().setWidth(1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(7),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(50),
                        width: ScreenUtil().setWidth(113),
                        child: TextFormField(
                          controller: _bedroomController,
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
                            hintText: "Bedroom",
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
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/images/bath.png",
                              height: ScreenUtil().setHeight(15),
                              width: ScreenUtil().setWidth(18)),
                          SizedBox(
                            width: ScreenUtil().setWidth(5),
                          ),
                          Text(
                            "Toilet",
                            style: TextStyle(
                              color: darkTextColor,
                              fontSize: ScreenUtil().setWidth(12),
                              fontFamily: 'work',
                              height: ScreenUtil().setWidth(1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(7),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(50),
                        width: ScreenUtil().setWidth(113),
                        child: TextFormField(
                          controller: _toiletController,
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
                            hintText: "Toilet",
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
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/images/crop.png",
                              height: ScreenUtil().setHeight(15),
                              width: ScreenUtil().setWidth(18)),
                          SizedBox(
                            width: ScreenUtil().setWidth(5),
                          ),
                          Text(
                            "Sqft",
                            style: TextStyle(
                              color: darkTextColor,
                              fontSize: ScreenUtil().setWidth(12),
                              fontFamily: 'work',
                              height: ScreenUtil().setWidth(1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(7),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(50),
                        width: ScreenUtil().setWidth(113),
                        child: TextFormField(
                          controller: _sqftController,
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
                            hintText: "Sqft",
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              // villa feature
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text("Villa Feature",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_circle_right,
                              size: ScreenUtil().setHeight(18),
                              color: appColor,),
                           SizedBox(
                             width: ScreenUtil().setWidth(7),
                           ),
                          Container(
                            decoration: BoxDecoration(),
                            child: Text("Villa Feature",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(12),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w400)),
                          ),
                        ],
                      ),
                     Icon(Icons.edit_outlined,
                          size: ScreenUtil().setHeight(18),
                          color: appColor,),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Icon(Icons.arrow_circle_right,
                              size: ScreenUtil().setHeight(18),
                              color: appColor,),
                          SizedBox(
                            width: ScreenUtil().setWidth(7),
                          ),
                          Container(
                            child: Text("Villa Feature",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(12),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w400)),
                          ),
                        ],
                      ),
                      Icon(Icons.edit_outlined,
                          size: ScreenUtil().setHeight(18),
                          color: appColor,),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         Icon(Icons.arrow_circle_right,
                              size: ScreenUtil().setHeight(18),
                              color: appColor,),
                          SizedBox(
                            width: ScreenUtil().setWidth(7),
                          ),
                          Container(
                            child: Text("Villa Feature",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(12),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w400)),
                          ),
                        ],
                      ),
                     GestureDetector(
                       onTap: () {
                         showWidget();
                       },
                       child: Icon(Icons.edit_outlined,
                            size: ScreenUtil().setHeight(18),
                            color: appColor,),
                     ),
                    ],
                  ),

                  SizedBox(
                    height: ScreenUtil().setHeight(7),
                  ),
                   _listView(),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              // property info
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Text("Property Information",
                        style: TextStyle(
                            fontSize: ScreenUtil()
                                .setHeight(14),
                            color: primaryColor,
                            fontFamily: 'work',
                            fontWeight:
                            FontWeight.w600)),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(7),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(95),
                            child: Text("Type",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(12),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w400)),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(7),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(120),
                            child: Text("Villa",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(12),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w600)),
                          ),
                        ],
                      ),
                      Icon(Icons.edit_outlined,
                        size: ScreenUtil().setHeight(18),
                        color: appColor,),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(7),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(95),
                            child: Text("Purpose",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(12),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w400)),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(7),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(120),
                            child: Text("For Rent",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(12),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w600)),
                          ),
                        ],
                      ),
                      Icon(Icons.edit_outlined,
                        size: ScreenUtil().setHeight(18),
                        color: appColor,),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(7),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(95),
                            child: Text("Reference No.",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(12),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w400)),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(7),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(120),
                            child: Text("RealPro-PR12387",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(12),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w600)),
                          ),
                        ],
                      ),
                      Icon(Icons.edit_outlined,
                        size: ScreenUtil().setHeight(18),
                        color: appColor,),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(7),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(95),
                            child: Text("Added on",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(12),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w400)),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(7),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(120),
                            child: Text("17 August 2023",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(12),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w600)),
                          ),
                        ],
                      ),
                      Icon(Icons.edit_outlined,
                        size: ScreenUtil().setHeight(18),
                        color: appColor,),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(7),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              // amenities
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text("Amenities",
                            style: TextStyle(
                                fontSize: ScreenUtil()
                                    .setHeight(14),
                                color: primaryColor,
                                fontFamily: 'work',
                                fontWeight:
                                FontWeight.w600)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(7),
                  ),
                  // choice chips
                  Wrap(
                    spacing: 12.0,
                    children: amenitiesList!.map((AmenitiesList value) => Container(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            _onJobLanguage(AmenitiesList());
                          },
                          child: Chip(
                            padding: EdgeInsets.all(8.0),
                            label: Text(
                              value.name.toString(),
                              style: TextStyle(
                                  fontFamily: 'work',
                                  fontWeight: FontWeight.normal,
                                  fontSize: ScreenUtil().setHeight(14),
                                  color: _selectedLanguage.contains(amenitiesList)
                                      ? secondaryColor
                                      : primaryColor ),
                            ),
                            avatar: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                _selectedLanguage.contains(amenitiesList)
                                    ? Icons.check_circle
                                    : Icons.add_circle,
                                size: 20,
                                color: _selectedLanguage.contains(amenitiesList)
                                    ? secondaryColor
                                    : secondaryColor ,
                              ),
                            ),
                            /* side: BorderSide(color: _selectedLanguage.contains(category)
                                ? appColor
                                : primaryColor, ),*/
                            backgroundColor:
                            _selectedLanguage.contains(amenitiesList)
                                ? appColor
                                : Color(0xffb8c8e3),

                          ),
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(7),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              // location
              Column(
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                    height: ScreenUtil().setHeight(50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: secondaryColor
                    ),
                    child: Center(
                      child: InkWell(
                          onTap: () async {
                            var place = await PlacesAutocomplete.show(
                                context: context,
                                apiKey: googleApikey,
                                mode: Mode.overlay,
                                types: [],
                                strictbounds: false,
                                components: [Component(Component.country, 'in')],
                                //google_map_webservice package
                                onError: (err){
                                  print(err);
                                }
                            );
                            if(place != null){
                              final plist = GoogleMapsPlaces(
                                apiKey:googleApikey,
                                apiHeaders: await GoogleApiHeaders().getHeaders(),
                                //from google_api_headers package
                              );
                              placeid = place.placeId ?? "0";
                              final detail = await plist.getDetailsByPlaceId(placeid);
                              final geometry = detail.result.geometry!;
                              final lat = geometry.location.lat;
                              final lang = geometry.location.lng;
                              setState(() {
                                _locationController.text = place.description.toString();
                                pickUpLat=lat;
                                pickUpLong=lang;
                                print(place.description);

                                var newlatlang = LatLng(lat, lang);
                                //move map camera to selected place with animation
                                mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                              });
                            }
                          },
                          child:Padding(
                            padding: EdgeInsets.all(0),
                            child: Container(
                              padding: EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width - 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_locationController.text.isEmpty ?
                                  "Location":
                                  _locationController.text,
                                    style: TextStyle(
                                        fontFamily: 'work',
                                        fontSize: ScreenUtil().setHeight(14),
                                        fontWeight: FontWeight.normal,
                                        color: primaryColor),),

                                  Icon(Icons.my_location,
                                      color: appColor, size: ScreenUtil().setHeight(14)),
                                ],
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(7),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text("Amount",
                            style: TextStyle(
                                fontSize: ScreenUtil()
                                    .setHeight(14),
                                color: primaryColor,
                                fontFamily: 'work',
                                fontWeight:
                                FontWeight.w600)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(7),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Text("155,000",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(30),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w600)),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(7),
                          ),
                          Container(
                            child: Text("AED/month",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(12),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w400)),
                          ),
                        ],
                      ),
                      Icon(Icons.edit_outlined,
                        size: ScreenUtil().setHeight(18),
                        color: appColor,),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(7),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(15),
                  ),
                  GestureDetector(
                      onTap: () {
                   //     checkValidation();
                        /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return BottomNavigationPage();
                        },
                      ),
                    );*/
                      },
                      child: RoundedButton(
                        text: 'Save Edit',
                        press: () {
                        },
                        color: appColor,
                      )
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _fields.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: ScreenUtil().setHeight(50),
                width: ScreenUtil().setWidth(280),
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
                    hintText: "Feature",
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
                ),
              ),
              IconButton(
                icon: Icon( index == 0 ? Icons.add_circle_outline  : Icons.remove_circle_outline),
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
                      hintText: "Feature ${_controllers.length + 1}",
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
                    if(index == 0) {
                      _controllers.add(controller);
                      _fields.add(field);
                    }
                    else{
                      _controllers.removeAt(index);
                      _fields.removeAt(index);
                    }

                  });
                },)
            ],
          ),
        );
      },
    );
  }

  Future<void> getCategory() async {
    catList!.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      catloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/getcategory',
    );
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("CategoryResposne::$responseBody");
    if (statusCode == 200) {
      setState(() {
        catloading = false;
      });
      if (mounted == true) {
      }
      if (getdata["status"]) {
        gecategoryData = GecategoryData.fromJson(jsonDecode(responseBody));
        catList!.addAll(gecategoryData.data!);
      } else {}
    }
    else
    {
      setState(() {
        catloading = false;
      });
    }
  }

  Future<void> getAmenities() async {
    catList!.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      catloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/get_amenities',
    );
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("AmenitiesResposne::$responseBody");
    if (statusCode == 200) {
      setState(() {
        catloading = false;
      });
      if (mounted == true) {
      }
      if (getdata["status"]) {
        getAmenitiesData = GetAmenitiesData.fromJson(jsonDecode(responseBody));
        amenitiesList!.addAll(getAmenitiesData.data!);
      } else {}
    }
    else
    {
      setState(() {
        catloading = false;
      });
    }
  }

  Future<void> getPropertyDetailsAPI() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/property_by_id',
    );
    Map<String, dynamic> body = {
      'property_id': widget.property_id,
    };
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await post(uri, headers: headers, body: body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("PropertyResposne::$responseBody");
    if (statusCode == 200) {
      if (mounted == true) {
        setState(() {
          isloading = false;
        });
      }
      if (getdata["status"]) {
        getPropertyDetails =
            GetPropertyDetails.fromJson(jsonDecode(responseBody));
        details!.addAll(getPropertyDetails.data!);
      } else {}
    }
  }
}
