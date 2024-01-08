import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:real_pro_vendor/Models/GetAreaData.dart';
import 'package:real_pro_vendor/Models/GetCityData.dart';
import 'package:real_pro_vendor/Models/GetTowerData.dart';
import 'package:real_pro_vendor/Presentation/BottomNavigationBarVendor.dart';
import 'package:real_pro_vendor/Presentation/common_textfeild.dart';
import '../Constants/Api.dart';
import '../Constants/Colors.dart';
import '../Models/GetAmenitiesData.dart';
import '../Models/GetAmountTypeData.dart';
import '../Models/GetCaategoryData.dart';
import '../Models/GetPropertyTypeData.dart';
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
import 'package:video_player/video_player.dart';
import 'HomePageV.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({Key? key}) : super(key: key);

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {

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

  final TextEditingController _houseTitleController = TextEditingController();
  final TextEditingController _bedroomController = TextEditingController();
  final TextEditingController _toiletController = TextEditingController();
  final TextEditingController _sqftController = TextEditingController();
  final TextEditingController _feature1Controller = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();

  late String placeid;
  String googleApikey = "AIzaSyCkW__vI2DazIWYjIMigyxwDtc_kyCBVIo";
  GoogleMapController? mapController; //contrller for Google map
  String location = "Select Leaving from Location..";
  double? pickUpLat;
  double? pickUpLong;
  var newlatlang;
  late LatLng _currentPosition;

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
      isloading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  late VideoPlayerController _videoPlayerController;
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

  File? thumbnailImage;

  Future<void> selectPhoto() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );
      final pickedImageFile = File(pickedImage!.path);
      setState(() {
        thumbnailImage = pickedImageFile;
      });
    } catch (error) {
      print("error: $error");
    }
  }

   XFile? _video;
   String? _path;

  _pickVideo() async {
    XFile? video = await imagePicker.pickVideo(source: ImageSource.gallery);
    _video = video!;
     _path = await VideoThumbnail.thumbnailFile(
      video: _video!.path,
      thumbnailPath: (await getTemporaryDirectory()).path, /// path_provider
      imageFormat: ImageFormat.PNG,
      maxWidth: 320,
      maxHeight: 620,
      quality: 120,
    );
    print(File(_path!));
    _videoPlayerController = VideoPlayerController.file(File(_video!.path))..initialize().then((_) {
      setState(() { });
      _videoPlayerController.play();
    });
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

  late GetAmountTypeData getAmountTypeData;
  List<AmountTypeList>? amountTypeList = [];

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

  static List<TextEditingController> _controllers = [];
  List<Widget> _fields = [];

  static List<TextEditingController> _furnishingControllers = [];
  List<Widget> _furnishingList = [];

  @override
  void initState() {
    getCity();
    getAmount();
    getAmenities();
    getProperty();
    getTextFormField();
    _locationController.addListener(() {
      /*_onChanged();*/
    });
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        bottomOpacity: 0,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Upload Property",
          style: TextStyle(
            color: secondaryColor,
            fontSize: ScreenUtil().setWidth(15),
            fontFamily: 'work',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: isloading || catloading
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
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(7),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    if(_video != null)
                      _videoPlayerController.value.isInitialized
                          ? Container(
                        height: ScreenUtil().setHeight(83),
                        width: ScreenUtil().setWidth(83),
                            margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(10),
                              right: ScreenUtil().setWidth(10),
                            ),
                            child:  VideoPlayer(_videoPlayerController),
                          )
                          : Container()
                    else
                      Container(),
                    GestureDetector(
                      onTap: () {
                        _pickVideo();
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
                  ],
                ),

                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("Video Thumbnail",
                          style: TextStyle(
                              fontSize: ScreenUtil()
                                  .setHeight(12),
                              color: primaryColor,
                              fontFamily: 'work',
                              fontWeight:
                              FontWeight.w400)),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Theme(
                          data: ThemeData(
                            unselectedWidgetColor: appColor,
                          ),
                          child: Radio(
                            value: "Auto",
                            activeColor: appColor,
                            groupValue: thumbnailType,
                            onChanged: (value) {
                              setState(() {
                                thumbnailType = value.toString();
                              });
                            },
                          ),
                        ),
                        Container(
                          child: Text("Auto",
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
                        Theme(
                          data: ThemeData(
                            unselectedWidgetColor: appColor,
                          ),
                          child: Radio(
                            value: "Upload manually",
                            activeColor: appColor,
                            groupValue: thumbnailType,
                            onChanged: (value) {
                              setState(() {
                                thumbnailType = value.toString();
                              });
                            },
                          ),
                        ),
                        Container(
                          child: Text("Upload manually",
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

                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),

                thumbnailType == "Upload manually" ?
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        GestureDetector(
                          onTap: () {
                            selectPhoto();
                          },
                          child: Container(
                            height: ScreenUtil().setHeight(83),
                            width: ScreenUtil().setWidth(83),
                            decoration: DottedDecoration(
                                color: appColor,
                                shape: Shape.box,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child:  thumbnailImage == null ?
                            Column(
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
                            ) :
                            Container(
                              height: ScreenUtil().setHeight(83),
                              width: ScreenUtil().setWidth(83),
                              decoration: DottedDecoration(
                                color: appColor,
                                shape: Shape.box,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image(
                                image: new FileImage(thumbnailImage!),
                                fit: BoxFit.fill,
                              ),),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),

                  ],
                ) :
                Container(),

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),

                    _gridImageView(),

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
                      child: Text(
                        "Property type",
                        style: TextStyle(
                            color: primaryColor,
                            fontFamily: 'work',
                            fontSize: ScreenUtil().setHeight(14),
                            fontWeight: FontWeight.w500),
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
                        fontWeight: FontWeight.w500),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an option';
                          }
                          return null;
                        },

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
                              "",
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an option';
                          }
                          return null;
                        },
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
                              "",
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
                Column(
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an option';
                          }
                          return null;
                        },
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
                              "",
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
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: textFieldBorderColor)
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

                                   newlatlang = LatLng(lat, lang);
                                  print("LatLong ${pickUpLat} ${pickUpLong}");
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
                                    Text(_locationController.text,
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

               /* Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Plot on map*",
                        style: TextStyle(
                            color: primaryColor,
                            fontFamily: 'work',
                            fontSize: ScreenUtil().setHeight(12.5),
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(5),
                    ),
                    Container(
                      height: ScreenUtil().setHeight(188),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        initialCameraPosition:
                        _currentPosition != null ?
                        CameraPosition(
                          target: _currentPosition,
                          zoom: 16.0,
                        ) :
                        CameraPosition(
                          target: LatLng(0.0, 0.0), // Default location if _currentPosition is null
                          zoom: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),*/

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
                              FontWeight.w400)),
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

                        propertyType == "2" ?
                        Container(
                          color: Colors.amber,
                        ) :
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                    fontWeight: FontWeight.w400,
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
                                validator: (value) {
                                  if (value == null || _bedroomController.text.isEmpty) {
                                    return 'This field is required';
                                  }
                                  return null;
                                },
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

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                    fontWeight: FontWeight.w400,
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
                                validator: (value) {
                                  if (value == null || _toiletController.text.isEmpty) {
                                    return 'This field is required';
                                  }
                                  return null;
                                },
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

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                    fontWeight: FontWeight.w400,
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
                                validator: (value) {
                                  if (value == null || _sqftController.text.isEmpty) {
                                    return 'This field is required';
                                  }
                                  return null;
                                },
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
                      validator: (value) {
                        if (value == null || _houseTitleController.text.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: false,
                        hintText: "Example: 3 BR villa with private pool",
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

                Column(
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
                      validator: (value) {
                        if (value == null || _amountController.text.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
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
                              FontWeight.w400)),
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
                              _onJobLanguage(value, value.id);
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
                        _amountListWidget(),
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
                    Container(
                      child: Text(
                          commercialType == "Rent" ?
                          "Rent Amount (in AED)"
                              : "Price (in AED)",
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
                      controller: _amountController,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        fontSize: ScreenUtil().setHeight(13),
                        color: primaryColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'work',
                      ),
                      validator: (value) {
                        if (_amountController.text.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
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
                  height: ScreenUtil().setHeight(7),
                ),

                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),

                GestureDetector(
                    onTap: () {

                      setState(() {
                        if (_formKey.currentState!.validate()) {
                          // Check additional conditions, such as non-empty text fields
                          if (_houseTitleController.text.isNotEmpty &&
                              _bedroomController.text.isNotEmpty) {
                            // Validation passed, initiate the login
                            setState(() {
                              isloading = true;
                            });
                            // Call the login function
                            uploadPropertyAPI();
                          } else {
                            // Show an error message for empty text fields
                          }
                        } else {
                          // Validation failed, show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill in the required field.'),
                            ),
                          );
                        }
                      });

                    /*  if (_formKey.currentState!.validate()) {
                        // Validation passed, navigate to the next page
                        uploadPropertyAPI();
                      } else {
                        // Validation failed, show an error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill in the required field.'),
                          ),
                        );
                      }*/
                    },
                    child: RoundedButton(
                      text: 'Submit',
                      press: () {},
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
                    hintText: "Feature",
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


  _amountListWidget() {
    return  Expanded(
      child: ListView.builder(
        itemCount: amountTypeList!.length,
        shrinkWrap: true,
        primary: false,
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return _buildAmountTypeList(i);
        },
      ),
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

  Widget _buildAmountTypeList(int i) {
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
                value:  amountTypeList![i].id.toString(),
                groupValue: amountType,
                title: Transform(
                  transform:
                  Matrix4.translationValues(-10.0, 0.0, 0.0),
                  child: Text(amountTypeList![i].name!,
                      style: TextStyle(
                        color: darkTextColor,
                        fontSize: ScreenUtil().setHeight(12),
                        fontFamily: 'work',
                        fontWeight: FontWeight.w400,
                      )),
                ),
                onChanged: (newValue) {
                  setState(() {
                    amountType = newValue.toString();
                    amountName = amountTypeList![i].name!.toString();
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
                hintText: "Feature ${_controllers.length + 1}",
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

  Widget _gridImageView() {
    return  Container(
        child:  GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          childAspectRatio: 1.8,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
              imageFileList!.length,
                  (index) => Column(
                children: [
                  Image.file(
                    File(imageFileList![index].path),
                    height: ScreenUtil().setHeight(83),
                    width: ScreenUtil().setWidth(83),
                    fit: BoxFit.fill,),
                ],
              )
          ),
        ));
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

  Future<void> getAmount() async {
    amountTypeList!.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      catloading = true;
    });
    var uri = Uri.https(
      apiBaseUrl,
      '/realpro/api/user/get_packages',
    );
    final headers = {'Authorization': '${prefs.getString('access_token')}'};
    Response response = await get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var getdata = json.decode(response.body);

    print("Amount Resposne::$responseBody");
    if (statusCode == 200) {
      setState(() {
        catloading = false;
      });
      if (mounted == true) {
      }
      if (getdata["status"]) {
        getAmountTypeData = GetAmountTypeData.fromJson(jsonDecode(responseBody));
        amountTypeList!.addAll(getAmountTypeData.data!);
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

  void checkValidation() {
    if (_houseTitleController.text.isEmpty) {
      Message(context, "Enter House Name");
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
    else if(_amountController.text.isEmpty) {
      Message(context, "Enter Amount");
    }
    else {
      uploadPropertyAPI();
    }
  }

  Future<void> uploadPropertyAPI() async {
    List<String> textController = [];
    for(int i = 0; i<_controllers.length; i++)
    {
      textController.add(_controllers[i].text);
    }
    print("Text:: ${textController}");
    print("image :: ${imageFilePathList!}");
    print("Video :: ${_video!.path}");
    print("city : ${selectedCity}");
    print(pickUpLat.toString());
    print(pickUpLong.toString());
    print(thumbnailType);
    print("thumImage ${thumbnailImage}");
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
    request.fields['property_type'] = categoryName!;
    request.fields['category_id'] = categoryType!;
    request.fields['property_id'] = propertyType!;
    request.fields['purpose'] = commercialType!;
    request.fields['city_id'] = selectedCity;
    request.fields['area_id'] = selectedArea;
    request.fields['tower_id'] = selectedTower;
    request.fields['bedroom_count'] = _bedroomController.text;
    request.fields['bathroom_count'] = _toiletController.text;
    request.fields['property_size'] = _sqftController.text;
    request.fields['property_name'] = _houseTitleController.text;
    request.fields['floor'] = _floorController.text;
    request.fields['feature'] = json.encode(textController);
    request.fields['furniture'] = furnishType!;
    request.fields['amenities'] = json.encode(_selectedAmenities);
    request.fields['amount_type'] = amountName!;
    request.fields['price'] = _amountController.text;
    request.fields['is_post'] = "1";
    request.fields['type'] = "1";
    request.fields['location'] = _locationController.text;
    request.fields['lat'] = pickUpLat.toString();
    request.fields['lang'] = pickUpLong.toString();
    request.files.add(
        await MultipartFile.fromPath(
            'thamblain',
            thumbnailImage!.path
        ));
   /* if(thumbnailType == "Upload manually")
    {
      request.files.add(
          await MultipartFile.fromPath(
              'thamblain',
              thumbnailImage!.path
          ));
    }
    else{
      request.files.add(
          await MultipartFile.fromPath(
              'thamblain',
              _path!
          ));
    }*/

    if(_video == null)
     {
       Message(context, "Upload Video");
     }
    else {
      request.files.add(
          await MultipartFile.fromPath(
              'video',
              _video!.path
          ));
    }

    if(imageFilePathList != null)
    {
      for(int i = 0; i<imageFilePathList!.length; i++)
      {
        request.files.add(
            await MultipartFile.fromPath(
                'image[]',
                imageFilePathList![i].path
            ));
      }
    }

    request.send().then((response) {
      if (response.statusCode == 200) {
        print("Uploaded!");
        int statusCode = response.statusCode;
        print("response::$response");
        response.stream.transform(utf8.decoder).listen((value) {
          print("ResponseSellerVerification" + value);
          var getdata = json.decode(value);
          if (getdata["status"]) {
            setState(() {
              isloading = false;
            });
            FocusScope.of(context).requestFocus(FocusNode());
            Message(context, "Add Property Successfully");
            _showSaveJobDialog(context);
           /* Future.delayed(const Duration(milliseconds: 1000), () {
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
            });*/
          }
        });
      }
      else {
        response.stream.transform(utf8.decoder).listen((value) {
          print("ResponseSellerVerification" + value);
          var getdata = json.decode(value);
          setState(() {
            isloading = false;
          });
          Message(context,getdata['message']);
        });
      }
    });
  }

  _showSaveJobDialog(BuildContext ctx) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      builder: (context) => SimpleDialog(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
            color: Colors.white,
            child: Image.asset(
              "assets/images/checklist.png",
              color: appColor,
              height: 110.0,
            ),
          ),
          Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "Property Upload Successfully.",
                  style: TextStyle(
                      fontFamily: "railway",
                      fontWeight: FontWeight.w700,
                      color: appColor,
                      letterSpacing: 0.5,
                      fontSize: 15.0),
                ),
              )),
          Container(
            padding: EdgeInsets.only(top: 15.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.035,
                  ),
                  isloading
                      ? CircularProgressIndicator(
                    backgroundColor: appColor,
                  )
                      : GestureDetector(
                    onTap: () {
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
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(size.width * 0.01),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: appColor,
                              /* boxShadow: [
                                      BoxShadow(
                                          color: buttonTextColor,
                                          spreadRadius: 1),
                                    ],*/
                            ),
                            width: size.width * 0.25,
                            height: size.height * 0.05,
                            child: Center(
                                child: Text(
                                  "Ok",
                                  style: TextStyle(
                                      fontFamily: 'railway',
                                      fontSize: size.width * 0.04,
                                      color: appColor),
                                ))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )

        ],
      ),
      context: ctx,
      barrierDismissible: true,
    );
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
