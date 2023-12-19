import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import '../Constants/Api.dart';
import '../Constants/Colors.dart';
import '../Models/GetAmenitiesData.dart';
import '../Models/GetCaategoryData.dart';
import '../Presentation/common_button.dart';
import '../Presentation/upload_textfeild.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';

import 'HomePageV.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({Key? key}) : super(key: key);

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {

  String? amountType;
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

  late GecategoryData gecategoryData;
  List<CategoryList>? catList = [];
  String selectedCategory = "";
  var dropdownCategoryValue;

  String dropdownvalue = 'Buy';
  var items = [
    'Buy',
    'Rent',
  ];

  late GetAmenitiesData getAmenitiesData;
  List<AmenitiesList>? amenitiesList = [];

  bool isloading = false;
  bool catloading = false;

  static List<TextEditingController> _controllers = [];
  List<Widget> _fields = [];

  @override
  void initState() {
    getCategory();
    getAmenities();
    getTextFormField();
    _locationController.addListener(() {
      /*_onChanged();*/
    });
    // TODO: implement initState
    super.initState();
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
          "Upload Post",
          style: TextStyle(
            color: primaryColor,
            fontSize: ScreenUtil().setWidth(20),
            fontFamily: 'work',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                  mainAxisSize: MainAxisSize.min,
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
              //Dropdown
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
                                "Select Category",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: secondaryColor
                    ),
                    height: ScreenUtil().setHeight(50),
                    width: ScreenUtil().setWidth(340),
                    child: DropdownButtonHideUnderline(
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(20),
                              right: ScreenUtil().setWidth(10)
                          ),
                        child: DropdownButton<String>(
                          iconSize: ScreenUtil().setWidth(22),
                          style: TextStyle(
                              color: primaryTextColor,
                              fontFamily: 'work',
                              fontSize: ScreenUtil().setHeight(12),
                              fontWeight: FontWeight.w400),
                          dropdownColor: secondaryColor,
                          isExpanded: true,
                          value: dropdownvalue,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                              /* print("category id::$newValue");
                                                                  selectedCategory = newValue!;*/
                            });
                          },
                          hint: Text(
                            "Select Property Type",
                            style: TextStyle(
                                color: primaryTextColor,
                                fontFamily: 'work',
                                fontSize: ScreenUtil().setHeight(12),
                                fontWeight: FontWeight.w400),
                          ),
                          icon: Icon(
                            // Add this
                            Icons.arrow_drop_down, // Add this
                            color: primaryColor,
                          ),
                          items: items.map((_languages) {
                            return DropdownMenuItem<String>(
                              value: _languages,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    _languages,
                                    style: TextStyle(
                                        fontFamily: 'work',
                                        color: primaryColor,
                                        fontSize:
                                        ScreenUtil().setHeight(12.5),
                                        fontWeight: FontWeight.w400),
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
                title: 'House Title',
                controller: _houseTitleController,
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
                        width: ScreenUtil().setWidth(100),
                        child: TextFormField(
                          controller: _bedroomController,
                          keyboardType: TextInputType.text,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                            fontSize: ScreenUtil().setHeight(13),
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
                                fontSize: ScreenUtil().setHeight(13),
                                fontWeight: FontWeight.w400,
                                color: primaryColor),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: ScreenUtil().setWidth(10),),
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
                        width: ScreenUtil().setWidth(100),
                        child: TextFormField(
                          controller: _toiletController,
                          keyboardType: TextInputType.text,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                            fontSize: ScreenUtil().setHeight(13),
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
                                fontSize: ScreenUtil().setHeight(13),
                                fontWeight: FontWeight.w400,
                                color: primaryColor),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: ScreenUtil().setWidth(10),),
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
                        width: ScreenUtil().setWidth(100),
                        child: TextFormField(
                          controller: _sqftController,
                          keyboardType: TextInputType.text,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                            fontSize: ScreenUtil().setHeight(13),
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
                                fontSize: ScreenUtil().setHeight(13),
                                fontWeight: FontWeight.w400,
                                color: primaryColor),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
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

                  _listView(),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(
                    height: ScreenUtil().setHeight(7),
                  ),
                  TextFieldUpload(
                    title: 'Type',
                    controller: _typeController,
                  ),
                  TextFieldUpload(
                    title: 'Purpose',
                    controller: _purposeController,
                  ),
                  TextFieldUpload(
                    title: 'RealPro-PR12387',
                    controller: _realProController,
                  ),
                  TextFieldUpload(
                    title: 'Date',
                    controller: _dateController,
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(0), vertical:ScreenUtil().setWidth(5)),
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
                          child:Container(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(20),
                                  right: ScreenUtil().setWidth(20)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_locationController.text.isEmpty ?
                                    "Location":
                                    _locationController.text,
                                      style: TextStyle(
                                          fontFamily: 'work',
                                          fontSize: ScreenUtil().setHeight(12.5),
                                          fontWeight: FontWeight.w400,
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
                  Container(
                    child: Text("Amount Type",
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                            value: "Monthly",
                            activeColor: appColor,
                            groupValue: amountType,
                            onChanged: (value) {
                              setState(() {
                                amountType = value.toString();
                              });
                            },
                          ),
                          Container(
                            child: Text("Monthly",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(10),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w400)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                            value: "Yearly",
                            activeColor: appColor,
                            groupValue: amountType,
                            onChanged: (value) {
                              setState(() {
                                amountType = value.toString();
                              });
                            },
                          ),
                          Container(
                            child: Text("Yearly",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(10),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w400)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                            value: "Daily",
                            activeColor: appColor,
                            groupValue: amountType,
                            onChanged: (value) {
                              setState(() {
                                amountType = value.toString();
                              });
                            },
                          ),
                          Container(
                            child: Text("Daily",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(10),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w400)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                            value: "Weekly",
                            activeColor: appColor,
                            groupValue: amountType,
                            onChanged: (value) {
                              setState(() {
                                amountType = value.toString();
                              });
                            },
                          ),
                          Container(
                            child: Text("Weekly",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(10),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w400)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextFieldUpload(
                    title: 'Amount',
                    controller: _amountController,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(7),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
              GestureDetector(
                  onTap: () {
                    checkValidation();
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
                    text: 'Submit Property',
                    press: () {
                      checkValidation();
                    },
                    color: appColor,
                  )
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
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

  void checkValidation() {
    if (_houseTitleController.text.isEmpty) {
      Message(context, "Enter House Name");
    }
    else if (_addressController.text.isEmpty) {
      Message(context, "Enter House Address");
    }
    else if (_bedroomController.text.isEmpty) {
      Message(context, "Enter Bedroom Count");
    }
    else if (_toiletController.text.isEmpty) {
      Message(context, "Enter Bathroom Count");
    }
    else if (_sqftController.text.isEmpty) {
      Message(context, "Enter Property Size");
    }
    else if (_feature1Controller.text.isEmpty) {
      Message(context, "Enter Vila Feature");
    }
    else if(_typeController.text.isEmpty) {
      Message(context, "Enter Property Type");
    }
    else if(_purposeController.text.isEmpty) {
      Message(context, "Enter Property Purpose");
    }
    else if(_realProController.text.isEmpty) {
      Message(context, "Enter Property Refs");
    }
    else if(_dateController.text.isEmpty) {
      Message(context, "Enter Property Date");
    }
    else if(_locationController.text.isEmpty) {
      Message(context, "Enter Location");
    }
    else if(_amountController.text.isEmpty) {
      Message(context, "Enter Amount");
    }
    else {
      RegisterAPI();
    }
  }

  Future<void> RegisterAPI() async {
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
    var url = Uri.https(apiBaseUrl, '/realpro/api/user/addproperty');
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
    request.fields['amount_type'] = amountType!;
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
        int statusCode = response.statusCode;
        print("response::$response");
        response.stream.transform(utf8.decoder).listen((value) {
          print("ResponseSellerVerification" + value);
          setState(() {
            isloading = false;
          });
          FocusScope.of(context).requestFocus(FocusNode());
          Message(context, "Add Property Successfully");

          Future.delayed(const Duration(milliseconds: 1000), () {
            setState(() {
              // todo
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return HomePageV();
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
