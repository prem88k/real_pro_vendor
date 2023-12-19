import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:real_pro_vendor/Presentation/BottomNavigationBarVendor.dart';
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
import 'package:http/http.dart' as http;
import 'LoginPageVendor.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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


  List<AmenitiesList> _selectedAmenities = [];

  void _onJobLanguage(AmenitiesList amenitiesList, int? id) {
    print(_selectedAmenities.map((e) => e.name));
    print(_selectedAmenities.contains(amenitiesList));
    setState(() {
      if (_selectedAmenities.contains(amenitiesList)) {
        _selectedAmenities.remove(amenitiesList);
      } else {
        _selectedAmenities.add(amenitiesList);
      }
    });
    print(_selectedAmenities.map((e) => e.name));
    print(_selectedAmenities.contains(amenitiesList));
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
  bool isVisibleB = true;
  bool isVisibleT = true;
  bool isVisibleS = true;
  bool isVisibleTy = true;
  bool isVisibleP = true;
  bool isVisibleRef = true;
  bool isVisibleAdd = true;
  bool isVisibleAm = true;

  void showFeature(){
    setState(() {
      isVisible = !isVisible;
    });
  }

  void showBedroom(){
    setState(() {
      isVisibleB = !isVisibleB;
    });
  }

  void showToilet(){
    setState(() {
      isVisibleT = !isVisibleT;
    });
  }

  void showSqft(){
    setState(() {
      isVisibleS = !isVisibleS;
    });
  }

  void showType(){
    setState(() {
      isVisibleTy = !isVisibleTy;
    });
  }

  void showPurpose(){
    setState(() {
      isVisibleP = !isVisibleP;
    });
  }

  void showRef(){
    setState(() {
      isVisibleRef = !isVisibleRef;
    });
  }

  void showAddOn(){
    setState(() {
      isVisibleAdd = !isVisibleAdd;
    });
  }

  void showAmount(){
    setState(() {
      isVisibleAm = !isVisibleAm;
    });
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
  void initState() {
    super.initState();
    getCategory();
    getAmenities();
    getTextFormField();
    getPropertyDetailsAPI();
    _locationController.addListener(() {
      /*_onChanged();*/
    });


    // TODO: implement initState
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
          : SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(5),
                  left: ScreenUtil().setWidth(10),
                  right: ScreenUtil().setWidth(10),
                  bottom: ScreenUtil().setHeight(5)),
              child: Column(
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
                           /* SizedBox(
                              width: ScreenUtil().setWidth(10),
                            ),*/
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(10),
                        ),
                        Expanded(
                          child: GridView.builder(
                              padding: EdgeInsets.all(0),
                              itemCount: getPropertyDetails.data![0].images!.length,
                              scrollDirection: Axis.horizontal,
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 0,
                                  crossAxisSpacing: 0,
                                  crossAxisCount: 2),
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  alignment: Alignment.topLeft,
                                  children:  <Widget>[
                                    ClipRRect(
                                       borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
                                      child: Image.network( getPropertyDetails.data![0].images![0].image.toString(),
                                        fit: BoxFit.cover,
                                        height: ScreenUtil().setHeight(84.4),
                                        width: ScreenUtil().setWidth(83),
                                    ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Icon(Icons.delete_outline,
                                              size: ScreenUtil().setHeight(19.7),
                                              color: secondaryColor,),
                                          ),
                                        ),
                                      ],
                                    )
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
                    title:
                    getPropertyDetails.data![0].propertyAddress != null ?
                    getPropertyDetails.data![0].propertyAddress.toString() : "Address",
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
                          isVisibleB ?
                          Container(
                            height: ScreenUtil().setHeight(50),
                            width: ScreenUtil().setWidth(113),
                            decoration: BoxDecoration(
                              color: secondaryColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 5
                            ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      getPropertyDetails.data![0].bedroomCount != null ?
                                      getPropertyDetails.data![0].bedroomCount.toString() : " ",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setHeight(14),
                                      color: primaryColor,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'work',
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showBedroom();
                                    },
                                      child: Icon(Icons.mode_edit_outline_outlined,
                                        color: appColor, size: ScreenUtil().setHeight(18.3),))
                                ],
                              ),
                            ),
                          )
                         : Container(
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
                              isVisibleT ?
                               Container(
                            height: ScreenUtil().setHeight(50),
                            width: ScreenUtil().setWidth(113),
                            decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 20,
                                  right: 5
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getPropertyDetails.data![0].bathroomCount != null ?
                                    getPropertyDetails.data![0].bathroomCount.toString() : "0",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setHeight(14),
                                      color: primaryColor,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'work',
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        showToilet();
                                      },
                                      child: Icon(Icons.mode_edit_outline_outlined,
                                        color: appColor, size: ScreenUtil().setHeight(18.3),))
                                ],
                              ),
                            ),
                          )
                              :Container(
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
                          isVisibleS ?
                                Container(
                            height: ScreenUtil().setHeight(50),
                            width: ScreenUtil().setWidth(113),
                            decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 20,
                                  right: 5
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getPropertyDetails.data![0].propertySize != null ?
                                    getPropertyDetails.data![0].propertySize.toString() : "0",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setHeight(14),
                                      color: primaryColor,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'work',
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        showSqft();
                                      },
                                      child: Icon(Icons.mode_edit_outline_outlined,
                                        color: appColor, size: ScreenUtil().setHeight(18.3),))
                                ],
                              ),
                            ),
                          )
                              : Container(
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
                        height: ScreenUtil().setHeight(10),
                      ),
                      _featureListView(),

                      SizedBox(
                        height: ScreenUtil().setHeight(10),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                              isVisibleTy ?
                              Container(
                                width: ScreenUtil().setWidth(120),
                                child: Row(
                                  children: [
                                    Text(
                                getPropertyDetails.data![0].type != null ?
                                      getPropertyDetails.data![0].type.toString() : "Type",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setHeight(12),
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'work',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : Container(
                                height: ScreenUtil().setHeight(50),
                                width: ScreenUtil().setWidth(120),
                                child: TextFormField(
                                  controller: _typeController,
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
                                    hintText: "Type",
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
                              )
                            ],
                          ),
                          GestureDetector(
                              onTap: () {
                                showType();
                              },
                              child: Icon(Icons.mode_edit_outline_outlined,
                                color: appColor, size: ScreenUtil().setHeight(18.3),))
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
                              isVisibleP ?
                              Container(
                                width: ScreenUtil().setWidth(120),
                                child: Row(
                                  children: [
                                    Text(
                                      getPropertyDetails.data![0].purpose != null ?
                                      getPropertyDetails.data![0].purpose.toString() : "Purpose",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setHeight(12),
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'work',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : Container(
                                height: ScreenUtil().setHeight(50),
                                width: ScreenUtil().setWidth(120),
                                child: TextFormField(
                                  controller: _purposeController,
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
                                    hintText: "Purpose",
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
                              )
                            ],
                          ),
                          GestureDetector(
                              onTap: () {
                                showPurpose();
                              },
                              child: Icon(Icons.mode_edit_outline_outlined,
                                color: appColor, size: ScreenUtil().setHeight(18.3),))
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
                              isVisibleRef ?
                              Container(
                                width: ScreenUtil().setWidth(120),
                                child: Row(
                                  children: [
                                    Text(
                                      getPropertyDetails.data![0].refNum != null ?
                                      getPropertyDetails.data![0].refNum.toString() : "Ref Num",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setHeight(12),
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'work',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : Container(
                                height: ScreenUtil().setHeight(50),
                                width: ScreenUtil().setWidth(120),
                                child: TextFormField(
                                  controller: _realProController,
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
                                    hintText: "Ref No",
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
                              )
                            ],
                          ),
                          GestureDetector(
                              onTap: () {
                                showRef();
                              },
                              child: Icon(Icons.mode_edit_outline_outlined,
                                color: appColor, size: ScreenUtil().setHeight(18.3),))
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
                              isVisibleAdd ?
                              Container(
                                width: ScreenUtil().setWidth(120),
                                child: Row(
                                  children: [
                                    Text(
                                      getPropertyDetails.data![0].addon != null ?
                                      getPropertyDetails.data![0].addon.toString() : "Date",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setHeight(12),
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'work',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : Container(
                                height: ScreenUtil().setHeight(50),
                                width: ScreenUtil().setWidth(120),
                                child: TextFormField(
                                  controller: _dateController,
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
                                    hintText: "Add On",
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
                              )
                            ],
                          ),
                          GestureDetector(
                              onTap: () {
                                showAddOn();
                              },
                              child: Icon(Icons.mode_edit_outline_outlined,
                                color: appColor, size: ScreenUtil().setHeight(18.3),))
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
                        children: amenitiesList!.map((AmenitiesList value) =>
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    _onJobLanguage(value, value.id);
                                  },
                                  child: Chip(
                                    padding: EdgeInsets.all(8.0),
                                    label: Text(
                                      value.name.toString(),
                                      style: TextStyle(
                                          fontFamily: 'work',
                                          fontWeight: FontWeight.normal,
                                          fontSize: ScreenUtil().setHeight(14),
                                          color: _selectedAmenities.contains(value)
                                              ? secondaryColor
                                              : primaryColor ),
                                    ),
                                    avatar: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Icon(
                                        _selectedAmenities.contains(value)
                                            ? Icons.check_circle
                                            : Icons.add_circle,
                                        size: 20,
                                        color: _selectedAmenities.contains(value)
                                            ? secondaryColor
                                            : appColor ,
                                      ),
                                    ),
                                    /* side: BorderSide(color: _selectedLanguage.contains(category)
                                ? appColor
                                : primaryColor, ),*/
                                    backgroundColor:
                                    _selectedAmenities.contains(value)
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
                                      getPropertyDetails.data![0].location.toString():
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

                      isVisibleAm ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                    getPropertyDetails.data![0].price != null ?
                                    getPropertyDetails.data![0].price.toString() : "0",
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
                          GestureDetector(
                              onTap: () {
                                showAmount();
                              },
                              child: Icon(Icons.mode_edit_outline_outlined,
                                color: appColor, size: ScreenUtil().setHeight(18.3),))
                        ],
                      )
                      : TextFieldUpload(
                          title: "Amount",
                          controller: _amountController),

                      SizedBox(
                        height: ScreenUtil().setHeight(7),
                      ),

                      SizedBox(
                        height: ScreenUtil().setHeight(15),
                      ),
                      GestureDetector(
                          onTap: () {
                            propertyEditAPI();

                          },
                          child: RoundedButton(
                            text: 'Save Edit',
                            press: () {},
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: ScreenUtil().setHeight(50),
              width: ScreenUtil().setWidth(290),
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
        setState(() {
          getPropertyDetails.data![0].amenities!.forEach((element) {
            _onJobLanguage(element , element.id);
        });
        });
      } else {}
    }
  }

  Future<void> propertyEditAPI() async {
    List<String> textController = [];
    for(int i = 0; i<_controllers.length; i++)
    {
      textController.add(_controllers[i].text);
    }
    print("Text:: ${textController}");
    setState(() {
      isloading = true;
    });
    String? token = await FirebaseMessaging.instance.getToken();
    print("Tpkoen::$token");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.https(apiBaseUrl, '/realpro/api/user/updateproperty/${widget.property_id}');
    //----------------------------------------------------------
    var request = new http.MultipartRequest("POST", url);
    request.headers['Authorization']=prefs.getString('access_token')!;
    request.fields['property_name'] = _houseTitleController.text;
    request.fields['price'] = _amountController.text;
    request.fields['description'] = "ABC";
    request.fields['category_id'] = selectedCategory;
    request.fields['property_address'] = "Ahmedabad";
    request.fields['bedroom_count'] = _bedroomController.text;
    request.fields['kitchen_count'] = "1";
    request.fields['feature'] = json.encode(textController);
    request.fields['bathroom_count'] = _toiletController.text;
    request.fields['property_type'] = _typeController.text;
    request.fields['property_size'] = _sqftController.text;
    request.fields['purpose'] =  _purposeController.text;
    request.fields['refno'] = _realProController.text;
    request.fields['addedon'] = _dateController.text;
    request.fields['amenities'] = json.encode(_selectedAmenities);
    request.fields['amount_type'] = "";
    request.fields['is_post'] = "1";
    request.fields['type'] = "1";
    request.fields['location'] = _locationController.text;

    for(int i = 0; i<imageFilePathList!.length; i++)
    {
      request.files.add(
          await MultipartFile.fromPath(
              'image[]',
              imageFilePathList![i].path
          ));
    }

    request.send().then((response) {
      if (response.statusCode == 200) {
        print("Uploaded!");
        print("response::$response");
        response.stream.transform(utf8.decoder).listen((value) {
          print("ResponseSellerVerification" + value);
          setState(() {
            isloading = false;
          });
          FocusScope.of(context).requestFocus(FocusNode());
          Message(context, "Edit Property Successfully");

          Future.delayed(const Duration(milliseconds: 1000), () {
            setState(() {
              // todo
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BottomNavigationBarVendor();
                  },
                ),
              );
            });
          });
        });
      } else {
        response.stream.transform(utf8.decoder).listen((value) {
          print("ResponseSellerVerification" + value);
          var getdata = json.decode(value);
          setState(() {
            isloading = false;
          });
          Message(context,getdata['message']);
        });
        /*setState(() {
          isloading = false;
        });
        Message(context,"Something went Wrong");*/
      }
    });
  }

  Widget _featureListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: getPropertyDetails.data![0].vilaFeature!.length,
      itemBuilder: (context, index) {
        return Row(
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
                isVisible ?
                Container(
                  decoration: BoxDecoration(),
                  child: Text(getPropertyDetails.data![0].vilaFeature![index].toString(),
                      style: TextStyle(
                          fontSize: ScreenUtil()
                              .setHeight(12),
                          color: primaryColor,
                          fontFamily: 'work',
                          fontWeight:
                          FontWeight.w400)),
                )
                : Container(
                  width: ScreenUtil().setWidth(260),
                  child: TextFieldUpload(
                    title: 'Villa Feature',
                    controller: _controllers[index],
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                showFeature();
              },
              child: Icon(Icons.edit_outlined,
                size: ScreenUtil().setHeight(18.3),
                color: appColor,),
            ),
          ],
        );
      },
    );
  }

}

/*

Row(
mainAxisAlignment: MainAxisAlignment.start,
crossAxisAlignment: CrossAxisAlignment.center,
children: [
Container(
height: ScreenUtil().setHeight(50),
width: ScreenUtil().setWidth(290),
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
);*/
