import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:place_picker/place_picker.dart';
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
import '../Models/GetAmountTypeData.dart';
import '../Models/GetAreaData.dart';
import '../Models/GetCaategoryData.dart';
import '../Models/GetCityData.dart';
import '../Models/GetPropertyDetailsData.dart';
import '../Models/GetPropertyTypeData.dart';
import '../Models/GetTowerData.dart';
import '../Presentation/common_button.dart';
import '../Presentation/upload_textfeild.dart';
import 'package:http/http.dart' as http;
import 'LoginPageVendor.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class EditPropertyOnRentPage extends StatefulWidget {
  String property_id;
  EditPropertyOnRentPage(this.property_id);


  @override
  State<EditPropertyOnRentPage> createState() => _EditPropertyOnRentPageState();
}

class _EditPropertyOnRentPageState extends State<EditPropertyOnRentPage> {

  int? selectedOption;
  String? thumbnailType;
  String? propertyType;
  String? categoryType;
  String? categoryName;
  String? commercialType;
  String? amountType;
  String? amountName;
  String? furnishType;

  bool isloading = false;
  bool catloading = false;
  String ?locationName;

  final TextEditingController _houseTitleController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _bedroomController = TextEditingController();
  final TextEditingController _toiletController = TextEditingController();
  final TextEditingController _sqftController = TextEditingController();
  final TextEditingController _feature1Controller = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _configController = TextEditingController();

  late String placeid;
  String googleApikey = "AIzaSyCkW__vI2DazIWYjIMigyxwDtc_kyCBVIo";
  GoogleMapController? mapController; //contrller for Google map
  LatLng? showLocation;
  String location = "Select Leaving from Location..";
  var newlatlang;
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



  void _onAmenititesLanguage(AmenitiesList amenitiesList, int? id) {
    print(_selectedAmenities.map((e) => e.name));

    print(_selectedAmenities.contains(amenitiesList));
    final List<int?> selectedIds = getPropertyDetails.data![0].amenities!.map((amenity) => amenity.id).toList();

    setState(() {
      print("IDS:: ${selectedIds}");
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

  var items = [
    'Sale',
    'Rent',
  ];

  var furnishItem = [
    'Furnished',
    'Un-furnished',
    'Partially furnished'
  ];
  late GetAmenitiesData getAmenitiesData;
  List<AmenitiesList>? amenitiesList = [];

  late GetPropertyTypeData getPropertyTypeData;
  List<PropertyTypeList>? propertyTypeList = [];
  String selectedProperty = "";
  var dropdownPropertyValue;

  late GetCityData getCityData;
  List<CityList>? cityList = [];
  String selectedCity = "";
  var dropdownCityValue;

  late GetAreaData getAreaData;
  List<AreaList>? areaList = [];
  String selectedArea = "";
  var dropdownAreaValue;

  late GetTowerData getTowerData;
  List<TowerList>? towerList = [];
  String selectedTower = "";
  var dropdownTowerValue;

  late GetPropertyDetails getPropertyDetails;
  List<PropertyDetails>? details = [];

  static List<TextEditingController> _controllers = [];
  List<Widget> _fields = [];


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
    getPropertyDetailsAPI();
    getPropertyDetails = GetPropertyDetails();
    getCity();
    getAmenities();
    getProperty();
    getTextFormField();

    _locationController.addListener(() {
      /*_onChanged();*/
    });

    // TODO: implement initState
  }

  void getPostData() {

    getPropertyDetails.data![0].location == null ?
    _locationController.text :
    _locationController.text = getPropertyDetails.data![0].location.toString();
    print("---"+getPropertyDetails.data![0].propertyTypeId!.toString());
    propertyType= getPropertyDetails.data![0].propertyTypeId!.toString();
    getPropertyDetails.data?[0].floor == null ?
    " " : _floorController.text = getPropertyDetails.data![0].floor.toString();

    getPropertyDetails.data?[0].bedroomCount == null ?
     " " : _bedroomController.text = getPropertyDetails.data![0].bedroomCount.toString();

    getPropertyDetails.data?[0].propertySize == null ?
    " " : _sqftController.text = getPropertyDetails.data![0].propertySize.toString();

    getPropertyDetails.data?[0].bathroomCount == null ?
    " " : _toiletController.text = getPropertyDetails.data![0].bathroomCount.toString();

    getPropertyDetails.data?[0].propertyName  == null ?
    " " : _houseTitleController.text =  getPropertyDetails.data![0].propertyName.toString() ;

    getPropertyDetails.data?[0].price == null ?
    " " : _amountController.text = getPropertyDetails.data![0].price.toString();

    if(getPropertyDetails.data![0].propertyTypeId != null)
      {
        getCategory(getPropertyDetails.data![0].propertyTypeId!.toString());

      }
    getPropertyDetails.data![0].category!.id == null ?
     categoryType : categoryType = getPropertyDetails.data![0].category!.id.toString();
    if(getPropertyDetails.data![0].category!.id!=null)
      {
        catList!.where((element) => element.id==getPropertyDetails.data![0].category!.id).forEach((element) {
          setState(() {
            categoryName=element.name;
          });
        });
      }

    commercialType = getPropertyDetails.data![0].purpose.toString();

    getPropertyDetails.data![0].cityId == null ?
    "City" :
    dropdownCityValue = getPropertyDetails.data![0].cityId.toString();
    if(getPropertyDetails.data![0].cityId != null)
      {
        getArea(getPropertyDetails.data![0].cityId.toString());
      }
    if(getPropertyDetails.data![0].areaId != null)
      {
        getTower(getPropertyDetails.data![0].areaId.toString());
      }
    getPropertyDetails.data![0].areaId == null ?
     "Area" :
    dropdownAreaValue = getPropertyDetails.data![0].areaId.toString();

    getPropertyDetails.data![0].towerId == null ?
    "Tower" :
    dropdownTowerValue = getPropertyDetails.data![0].towerId.toString();
    furnishType=getPropertyDetails.data![0].furniture.toString();
    setState(() {
      _selectedAmenities.addAll(getPropertyDetails.data![0].amenities!);
    });
    print(_selectedAmenities!.map((e) => e.name));
  /*  _controllers = _fields.map((item) => TextEditingController(text: )).toList();*/

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        bottomOpacity: 0,
        iconTheme: IconThemeData(color: secondaryColor),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Edit Post",
          style: TextStyle(
            color: secondaryColor,
            fontSize: ScreenUtil().setWidth(15),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Property type",
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'work',
                              fontSize: ScreenUtil().setHeight(14),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Category*",
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'work',
                              fontSize: ScreenUtil().setHeight(12),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(5),
                      ),
                      _propertyListWidget(),
                    ],
                  ),

                  propertyType == null ?
                  Container() :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Property type*",
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'work',
                              fontSize: ScreenUtil().setHeight(12),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(5),
                      ),
                      _catListWidget(),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Property available for*",
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'work',
                              fontSize: ScreenUtil().setHeight(12),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(5),
                      ),
                      _commercialListWidget(),
                    ],
                  ),

                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),

                  Divider(
                    thickness: 0.5,
                    color: lightTextColor,
                  ),

                  SizedBox(
                    height: ScreenUtil().setHeight(6),
                  ),

                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Property Location",
                      style: TextStyle(
                          color: primaryColor,
                          fontFamily: 'work',
                          fontSize: ScreenUtil().setHeight(14),
                          fontWeight: FontWeight.w600),
                    ),
                  ),

                  SizedBox(
                    height: ScreenUtil().setHeight(12),
                  ),
                  //city
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "City",
                        style: TextStyle(
                            color: primaryColor,
                            fontFamily: 'work',
                            fontSize: ScreenUtil().setHeight(12.5),
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(5),
                      ),
                      Container(
                        //  height: ScreenUtil().setHeight(45),
                        width: ScreenUtil().setWidth(340),
                        child: DropdownButtonFormField<String>(
                          iconDisabledColor: Colors.transparent,
                          iconEnabledColor: Colors.transparent,
                          iconSize: 34,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            // Set height and width constraints
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: textFieldBorderColor)
                            ),
                            suffixIcon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: appColor,
                              size: ScreenUtil().setHeight(22),
                            ),// You can add a border here if needed
                          ),
                          style: TextStyle(
                            color: primaryColor,
                          ),
                          dropdownColor: secondaryColor,
                          isExpanded: true,
                          value: dropdownCityValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownCityValue = newValue;
                              print("City Id::$newValue");
                              selectedCity = newValue!;
                              getArea(selectedCity);
                            });
                          },
                          hint: Row(
                            children: [
                              Text(
                                "City",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontSize: ScreenUtil().setHeight(12.5),
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          items: cityList!.map((CityList value) {
                            return DropdownMenuItem<String>(
                              value: value.id.toString(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    value.cityName!,
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
                    ],
                  ),

                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),

                  //area
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Area*",
                        style: TextStyle(
                            color: primaryColor,
                            fontFamily: 'work',
                            fontSize: ScreenUtil().setHeight(12.5),
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(5),
                      ),
                      Container(
                        // height: ScreenUtil().setHeight(35),
                        width: ScreenUtil().setWidth(340),
                        child: DropdownButtonFormField<String>(
                          iconDisabledColor: Colors.transparent,
                          iconEnabledColor: Colors.transparent,
                          iconSize: 34,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            // Set height and width constraints
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: textFieldBorderColor)
                            ),
                            suffixIcon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: appColor,
                              size: ScreenUtil().setHeight(22),
                            ),// You can add a border here if needed
                          ),
                          style: TextStyle(
                            color: primaryColor,
                          ),
                          dropdownColor: secondaryColor,
                          isExpanded: true,
                          value: dropdownAreaValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownAreaValue = newValue;
                              print("Area Id::$newValue");
                              selectedArea = newValue!;
                              getTower(selectedArea);
                            });
                          },
                          hint: Row(
                            children: [
                              Text(
                                "Area",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontSize: ScreenUtil().setHeight(12.5),
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          items: areaList!.map((AreaList value) {
                            return DropdownMenuItem<String>(
                              value: value.id.toString(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    value.area!,
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
                    ],
                  ),

                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),

                  //tower
                  categoryName=="Villa"||categoryName=="Townhouse"||categoryName=="Bungalow"||categoryName==null?Container():Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tower",
                        style: TextStyle(
                            color: primaryColor,
                            fontFamily: 'work',
                            fontSize: ScreenUtil().setHeight(12.5),
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(5),
                      ),
                      Container(
                        // height: ScreenUtil().setHeight(35),
                        width: ScreenUtil().setWidth(340),
                        child: DropdownButtonFormField<String>(
                          iconDisabledColor: Colors.transparent,
                          iconEnabledColor: Colors.transparent,
                          iconSize: 34,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            // Set height and width constraints
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: textFieldBorderColor)
                            ),
                            suffixIcon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: appColor,
                              size: ScreenUtil().setHeight(22),
                            ),// You can add a border here if needed
                          ),
                          style: TextStyle(
                            color: primaryColor,
                          ),
                          dropdownColor: secondaryColor,
                          isExpanded: true,
                          value: dropdownTowerValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownTowerValue = newValue;
                              print("Tower Id::$newValue");
                              selectedTower = newValue!;
                            });
                          },
                          hint: Row(
                            children: [
                              Text(
                                "Tower",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontSize: ScreenUtil().setHeight(12.5),
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          items: towerList!.map((TowerList value) {
                            return DropdownMenuItem<String>(
                              value: value.id.toString(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    value.towerName!,
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
                    ],
                  ),

                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),

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
                                FontWeight.w400)),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(7),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                        height: ScreenUtil().setHeight(50),
                        decoration: BoxDecoration(
                            border: Border.all(color: textFieldBorderColor),
                            borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: InkWell(
                              onTap: () {
                                showPlacePicker();
                              },
                              child:Padding(
                                padding: EdgeInsets.all(0),
                                child: Container(
                                  padding: EdgeInsets.all(0),
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          /*_locationController.text.isEmpty != null ?
                                          getPropertyDetails.data![0].location.toString():*/
                                          _locationController.text,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontFamily: 'work',
                                              fontSize: ScreenUtil().setHeight(14),
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.normal,
                                              color: primaryColor),),
                                      ),

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
                  categoryName=="Apartments"||categoryName=="Penthouse"||categoryName=="Hotel Apartments"||categoryName==null?Container(): Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text("Configuration",
                            style: TextStyle(
                                fontSize: ScreenUtil()
                                    .setHeight(12),
                                color: primaryColor,
                                fontFamily: 'work',
                                fontWeight:
                                FontWeight.w400)),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(5),
                      ),
                      TextFormField(
                        controller: _configController,
                        keyboardType: TextInputType.text,
                        textAlignVertical: TextAlignVertical.center,

                        style: TextStyle(
                          fontSize: ScreenUtil().setHeight(13),
                          color: primaryColor,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'work',
                        ),
                        validator: (value) {

                          if (value == null || _configController.text.isEmpty) {
                            return 'This field is required';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          filled: false,
                          hintText: "Example - G +1",
                          hintStyle: TextStyle(
                              fontFamily: 'work',
                              fontSize: ScreenUtil().setHeight(13),
                              fontWeight: FontWeight.w400,
                              color: lightTextColor),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: textFieldBorderColor),
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20), top: ScreenUtil().setHeight(10)),
                        ),
                      ),
                    ],
                  ),

                  Divider(
                    thickness: 0.5,
                    color: lightTextColor,
                  ),

                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text("Property Details",
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
                    height: ScreenUtil().setHeight(10),
                  ),

                  Container(
                    decoration: BoxDecoration(
                        color: boxBackgroundColor,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                             /* isVisibleB ?
                              Container(
                                height: ScreenUtil().setHeight(42),
                                width: ScreenUtil().setWidth(100),
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
                                          getPropertyDetails.data?[0].bedroomCount != null ?
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
                             :*/ Container(
                                height: ScreenUtil().setHeight(50),
                                width: ScreenUtil().setWidth(100),
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
                                    filled: false,
                                    fillColor: secondaryColor,
                                    hintText: "",
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
                                  /*isVisibleT ?
                                   Container(
                                height: ScreenUtil().setHeight(42),
                                width: ScreenUtil().setWidth(100),
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
                                        getPropertyDetails.data?[0].bathroomCount != null ?
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
                                  :*/Container(
                                height: ScreenUtil().setHeight(50),
                                width: ScreenUtil().setWidth(100),
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
                                    filled: false,
                                    fillColor: secondaryColor,
                                    hintText:  " ",
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
                              /*isVisibleS ?
                                    Container(
                                height: ScreenUtil().setHeight(42),
                                width: ScreenUtil().setWidth(100),
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
                                        getPropertyDetails.data?[0].propertySize != null ?
                                        getPropertyDetails.data![0].propertySize.toString() : " ",
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
                                  :*/ Container(
                                height: ScreenUtil().setHeight(50),
                                width: ScreenUtil().setWidth(100),
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
                                    filled: false,
                                    fillColor: secondaryColor,
                                    hintText: " ",
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title",
                        style: TextStyle(
                            color: primaryColor,
                            fontFamily: 'work',
                            fontSize: ScreenUtil().setHeight(12.5),
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(5),
                      ),
                      TextFormField(
                        controller: _houseTitleController,
                        keyboardType: TextInputType.text,
                        textAlignVertical: TextAlignVertical.center,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: ScreenUtil().setHeight(13),
                          color: primaryColor,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'work',
                        ),
                        decoration: InputDecoration(
                          filled: false,
                          hintText: " ",
                          hintStyle: TextStyle(
                              fontFamily: 'work',
                              fontSize: ScreenUtil().setHeight(13),
                              fontWeight: FontWeight.w400,
                              color: lightTextColor),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: textFieldBorderColor),
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20), top: ScreenUtil().setHeight(10)),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),

                  categoryName=="Villa"||categoryName=="Townhouse"||categoryName=="Bungalow"||categoryName==null?Container():  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text("Floor",
                            style: TextStyle(
                                fontSize: ScreenUtil()
                                    .setHeight(12),
                                color: primaryColor,
                                fontFamily: 'work',
                                fontWeight:
                                FontWeight.w400)),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(5),
                      ),
                      TextFormField(
                        controller: _floorController,
                        keyboardType: TextInputType.text,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          fontSize: ScreenUtil().setHeight(13),
                          color: primaryColor,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'work',
                        ),
                        decoration: InputDecoration(
                          filled: false,
                          hintText: "",
                          hintStyle: TextStyle(
                              fontFamily: 'work',
                              fontSize: ScreenUtil().setHeight(13),
                              fontWeight: FontWeight.w400,
                              color: lightTextColor),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: textFieldBorderColor),
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20), top: ScreenUtil().setHeight(10)),
                        ),
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
                        child: Text("Property Feature",
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
                      _listView(),

                      _featureListView()
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
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Furnishings",
                          style: TextStyle(
                              color: darkTextColor,
                              fontFamily: 'work',
                              fontSize: ScreenUtil().setHeight(12),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(5),
                      ),
                      _furnishListWidget(),
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
                                    FontWeight.w400)),
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
                                    _onAmenititesLanguage(value, value.id);
                                  },
                                  child: Chip(
                                    padding: EdgeInsets.all(5.0),
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
                                    side: BorderSide(color: _selectedAmenities.contains(value)
                                        ? appColor
                                        : appColor, ),
                                    backgroundColor: _selectedAmenities.contains(value)
                                        ? appColor
                                        : secondaryColor,
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

                  Divider(
                    thickness: 0.5,
                    color: lightTextColor,
                  ),

                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),

                  commercialType == "Rent" ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text("Commercials",
                            style: TextStyle(
                                fontSize: ScreenUtil()
                                    .setHeight(14),
                                color: primaryColor,
                                fontFamily: 'work',
                                fontWeight:
                                FontWeight.w500)),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(7),
                      ),
                      Container(
                        child: Text("Rent",
                            style: TextStyle(
                                fontSize: ScreenUtil()
                                    .setHeight(12),
                                color: primaryColor,
                                fontFamily: 'work',
                                fontWeight:
                                FontWeight.w400)),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(7),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("Monthly",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(12),
                                    color: appColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w400)),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                    ],
                  )
                      :Container(),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Container(
                            child: Text( commercialType == "Rent" ?
                  "Rent Amount (in AED)"
                      : "Price (in AED)",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setHeight(14),
                                    color: primaryColor,
                                    fontFamily: 'work',
                                    fontWeight:
                                    FontWeight.w400)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(7),
                      ),

                    /*  isVisibleAm ?
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
                                    getPropertyDetails.data?[0].price != null ?
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
                      :*/ TextFieldUpload(
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
          ));

  }

  Widget _listView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: getPropertyDetails.data?[0].vilaFeature?.length ?? 0,
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
                  controller: TextEditingController(
                    text: getPropertyDetails.data![0].vilaFeature![index].toString() ?? '',
                  ),
                  keyboardType: TextInputType.text,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    fontSize: ScreenUtil().setHeight(14),
                    color: primaryColor,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'work',
                  ),
                  decoration: InputDecoration(
                    filled: false,
                    fillColor: secondaryColor,
                    hintText: getPropertyDetails.data![0].vilaFeature![index].toString() ?? '',
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
            ),

            /*index == 0 ?
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
                      _controllers.removeAt(index);
                      _fields.removeAt(index);
                    });
                  },),
              ],
            ),*/

          ],
        );
      },
    );
  }

  _propertyListWidget() {
    return  ListView.builder(
      itemCount: propertyTypeList!.length,
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.all(0.0),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return _buildPropertyList(i);
      },
    );
  }

  _catListWidget() {
    return   ListView.builder(
      itemCount: catList!.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return _buildCategoryList(i);
      },
    );
  }

  _commercialListWidget() {
    return  ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return _buildCommercialList(i);
      },
    );
  }

  _furnishListWidget() {
    return   ListView.builder(
      itemCount: furnishItem.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return _buildFurnishList(i);
      },
    );
  }



  Widget _buildPropertyList(int i) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 0,
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: appColor,
            ),
            child: SizedBox(
              width: ScreenUtil().setWidth(250),
              child: ListTileTheme(
                contentPadding: EdgeInsets.zero,
                dense: true,
                child: RadioListTile(
                  dense: true,
                  visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity),
                  contentPadding: EdgeInsets.zero,
                  value:  propertyTypeList![i].id.toString(),
                  groupValue: propertyType,
                  title: Transform(
                    transform:
                    Matrix4.translationValues(-12.0, 0.0, 0.0),
                    child: Text(propertyTypeList![i].propertyName!,
                        style: TextStyle(
                          color: darkTextColor,
                          fontSize: ScreenUtil().setHeight(12),
                          fontFamily: 'work',
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      propertyType = newValue.toString();
                      print(propertyType);
                      getCategory(propertyType!);
                    });
                  },
                  activeColor: appColor,
                  selected: false,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryList(int i) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 0,
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: appColor,
            ),
            child: SizedBox(
              width: ScreenUtil().setWidth(250),
              child: RadioListTile(
                dense: true,
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                contentPadding: EdgeInsets.zero,
                value:  catList![i].id.toString(),
                groupValue: categoryType,
                title: Transform(
                  transform:
                  Matrix4.translationValues(-12.0, 0.0, 0.0),
                  child: Text(catList![i].name!,
                      style: TextStyle(
                        color: darkTextColor,
                        fontSize: ScreenUtil().setHeight(12),
                        fontFamily: 'work',
                        fontWeight: FontWeight.w400,
                      )),
                ),
                onChanged: (newValue) {
                  setState(() {
                    categoryType = newValue.toString();
                    categoryName = catList![i].name!.toString();

                  });
                },
                activeColor: appColor,
                selected: false,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommercialList(int i) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 0,
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: appColor,
            ),
            child: SizedBox(
              width: ScreenUtil().setWidth(250),
              child: RadioListTile(
                dense: true,
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                contentPadding: EdgeInsets.zero,
                value: items[i],
                groupValue: commercialType,
                title: Transform(
                  transform:
                  Matrix4.translationValues(-12.0, 0.0, 0.0),
                  child: Text(items[i],
                      style: TextStyle(
                        color: darkTextColor,
                        fontSize: ScreenUtil().setHeight(12),
                        fontFamily: 'work',
                        fontWeight: FontWeight.w400,
                      )),
                ),
                onChanged: (newValue) {
                  setState(() {
                    commercialType = newValue.toString();
                  });
                },
                activeColor: appColor,
                selected: false,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFurnishList(int i) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 0,
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: appColor,
            ),
            child: SizedBox(
              width: ScreenUtil().setWidth(250),
              child: RadioListTile(
                dense: true,
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                contentPadding: EdgeInsets.zero,
                value: furnishItem[i],
                groupValue: furnishType,
                title: Transform(
                  transform:
                  Matrix4.translationValues(-12.0, 0.0, 0.0),
                  child: Text(furnishItem[i],
                      style: TextStyle(
                        color: darkTextColor,
                        fontSize: ScreenUtil().setHeight(12),
                        fontFamily: 'work',
                        fontWeight: FontWeight.w400,
                      )),
                ),
                onChanged: (newValue) {
                  setState(() {
                    furnishType = newValue.toString();
                  });
                },
                activeColor: appColor,
                selected: false,
              ),
            ),
          ),
        ),
      ],
    );
  }



  Future<void> getCategory(String id) async {
    catList!.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/getcategory/${id}',
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
        catList!.removeWhere((element) => element.id==0);
        setState(() {

        });
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

  Future<void> getProperty() async {
    propertyTypeList!.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      catloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/get_propertytype',
    );
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("Property Resposne::$responseBody");
    if (statusCode == 200) {
      setState(() {
        catloading = false;
      });
      if (mounted == true) {
      }
      if (getdata["success"]) {
        getPropertyTypeData = GetPropertyTypeData.fromJson(jsonDecode(responseBody));
        propertyTypeList!.addAll(getPropertyTypeData.data!);
        setState(() {
     //     categoryType = getPropertyDetails.data![0].category!.id.toString();
        });
      } else {}
    }
    else
    {
      setState(() {
        catloading = false;
      });
    }
  }

  Future<void> getCity() async {
    cityList!.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      catloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/getcity',
    );
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("City Resposne::$responseBody");
    if (statusCode == 200) {
      setState(() {
        catloading = false;
      });
      if (mounted == true) {
      }
      if (getdata["success"]) {
        getCityData = GetCityData.fromJson(jsonDecode(responseBody));
        cityList!.addAll(getCityData.data!);
      } else {}
    }
    else
    {
      setState(() {
        catloading = false;
      });
    }
  }

  Future<void> getArea(String id) async {
    areaList!.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      catloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/getarea/${id}',
    );
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("Area Resposne::$responseBody");
    if (statusCode == 200) {
      setState(() {
        catloading = false;
      });
      if (mounted == true) {
      }
      if (getdata["success"]) {
        getAreaData = GetAreaData.fromJson(jsonDecode(responseBody));
        areaList!.addAll(getAreaData.data!);
      } else {}
    }
    else
    {
      setState(() {
        catloading = false;
      });
    }
  }

  Future<void> getTower(String id) async {
    towerList!.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      catloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/gettower/${id}',
    );
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("Tower Resposne::$responseBody");
    if (statusCode == 200) {
      setState(() {
        catloading = false;
      });
      if (mounted == true) {
      }
      if (getdata["success"]) {
        getTowerData = GetTowerData.fromJson(jsonDecode(responseBody));
        towerList!.addAll(getTowerData.data!);
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
        getPostData();

        setState(() {
        });
      } else {}
    }
  }

  Future<void> deleteImage(String id, String product_id, ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/delete_image_by_property',
    );
    Map<String, dynamic> body = {
      'product_id': product_id,
      'image_id' : id
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
    request.fields['city_id'] = selectedCity;
    request.fields['area_id'] = selectedArea;
    request.fields['tower_id'] = selectedTower;
    request.fields['bedroom_count'] = _bedroomController.text;
    request.fields['bathroom_count'] = _toiletController.text;
    request.fields['property_size'] = _sqftController.text;
    request.fields['property_name'] = _houseTitleController.text;
    request.fields['floor'] = _floorController.text;
    request.fields['feature'] = json.encode(textController);
    request.fields['amenities'] = json.encode(_selectedAmenities);
    request.fields['price'] = _amountController.text;
    request.fields['is_post'] = "1";
    request.fields['type'] = "1";
    request.fields['location'] = _locationController.text;
    request.fields['lat'] = pickUpLat.toString();
    request.fields['lang'] = pickUpLong.toString();
    request.fields['thamblain'] = " ";
    request.fields['video'] = " ";
    request.fields['image[]'] = " ";


    if (categoryName != null){
      request.fields['property_type'] = categoryName!;
    }

    if (categoryType != null){
      request.fields['category_id'] = categoryType!;
    }

    if (propertyType != null){
      request.fields['property_id'] = propertyType!;
    }

    if (commercialType != null){
      request.fields['purpose'] = commercialType!;
    }

    if (furnishType != null){
      request.fields['furniture'] = furnishType!;
    }

    if (amountName != null){
      request.fields['amount_type'] = amountName!;
    }

    /*request.files.add(
        await MultipartFile.fromPath(
            'thamblain',
           ""
        ));

    request.files.add(
        await MultipartFile.fromPath(
            'video',
           ""
        ));
    request.files.add(
        await MultipartFile.fromPath(
            'image[]',
            ""
        ));
*/

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
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      itemCount: _fields.length,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(0),
                  bottom: ScreenUtil().setHeight(5)
              ),
              child: Container(
                height: ScreenUtil().setHeight(34),
                width: ScreenUtil().setWidth(240),
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
                    filled: false,
                    fillColor: secondaryColor,
                    hintText: "Add Feature",
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

  void showPlacePicker() async {
    LocationResult? result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PlacePicker("AIzaSyCkW__vI2DazIWYjIMigyxwDtc_kyCBVIo",defaultLocation: LatLng(25.2048, 55.2708),displayLocation:LatLng(25.2048, 55.2708) ,),));
    setState(() {
      locationName=result!.formattedAddress;
      _locationController.text=result.formattedAddress!;
      pickUpLong=result.latLng!.longitude;
      pickUpLat=result.latLng!.latitude;

    });
    // Handle the result in your way
    print(result!.formattedAddress.toString());
    print(result.latLng!.longitude);
    print(result.latLng!.latitude);

  }
}

