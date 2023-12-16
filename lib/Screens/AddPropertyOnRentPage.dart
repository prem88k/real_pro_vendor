import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Constants/Colors.dart';
import '../Presentation/common_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_decoration/dotted_decoration.dart';

import 'UploadPostPage.dart';


class AddPropertyOnRentPage extends StatefulWidget {
  const AddPropertyOnRentPage({Key? key}) : super(key: key);

  @override
  State<AddPropertyOnRentPage> createState() => _AddPropertyOnRentPageState();
}

class _AddPropertyOnRentPageState extends State<AddPropertyOnRentPage> {
  int? selectedOption;
  final TextEditingController _searchController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await
    imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    print("Image List Length:" + imageFileList!.length.toString());
    setState((){});
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
        /*title: GestureDetector(
          onTap: () {
            // add your code here.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SearchPage();
                  //WelcomeLoginPage();
                },
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(12)),
            height: ScreenUtil().setHeight(38),
            width: ScreenUtil().setWidth(275),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: secondaryColor,
            ),
            child: Center(
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Color(0xff05122B),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(12),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(4)),
                    child: Text(
                      "Search city, building, location ",
                      style: TextStyle(
                          fontFamily: 'work',
                          fontSize: ScreenUtil().setHeight(12),
                          fontWeight: FontWeight.normal,
                          color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),*/
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(10),
            right: ScreenUtil().setWidth(10),
            top: ScreenUtil().setHeight(10),
            bottom: ScreenUtil().setHeight(10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Text("Add Property on Rent",
                        style: TextStyle(
                            fontSize: ScreenUtil().setHeight(20),
                            color: primaryColor,
                            fontFamily: 'work',
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(12),
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
                height: ScreenUtil().setHeight(12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Text("Add Description",
                        style: TextStyle(
                            fontSize: ScreenUtil().setHeight(14),
                            color: primaryColor,
                            fontFamily: 'work',
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(12),
              ),
              TextFormField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  fontSize: 14,
                  color: primaryColor,
                  fontFamily: 'work',
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: secondaryColor,
                  hintText: "Search city, building, location",
                  hintStyle: TextStyle(
                      fontFamily: 'work',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: lightTextColor),
                  suffixIcon: InkWell(
                      child: Icon(Icons.border_color_outlined,
                          color: appColor, size: 14),
                      onTap: () {}),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: EdgeInsets.only(left: 20),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Add More Details ",
                        style: TextStyle(
                            fontSize: ScreenUtil().setHeight(14),
                            color: appColor,
                            fontFamily: 'work',
                            fontWeight: FontWeight.w600)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return UploadPostPage(
                            );
                            //WelcomeLoginPage();
                          },
                        ),
                      );
                    },
                    child: Container(
                      child: Text("Tap Here",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: ScreenUtil().setHeight(14),
                              color: appColor,
                              fontFamily: 'work',
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Text("Add Packages Available",
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
                height: ScreenUtil().setHeight(20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: ScreenUtil().setHeight(135),
                    width: ScreenUtil().setWidth(160),
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(5),
                        left: ScreenUtil().setWidth(10),
                        right: ScreenUtil().setWidth(10),
                        bottom: ScreenUtil().setHeight(5)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: appColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Radio(
                              value: 1,
                              activeColor: secondaryColor,
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(0),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(230),
                          child: Text("Package 1",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setHeight(12),
                                  color: secondaryColor,
                                  fontFamily: 'work',
                                  fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(5),
                        ),
                        Container(
                          child: Text("AED 100",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setHeight(20),
                                  color: secondaryColor,
                                  fontFamily: 'work',
                                  fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(5),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(230),
                          child: Text("Ad will be for 1 month",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setHeight(12),
                                  color: secondaryColor,
                                  fontFamily: 'work',
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setHeight(135),
                    width: ScreenUtil().setWidth(160),
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(5),
                        left: ScreenUtil().setWidth(10),
                        right: ScreenUtil().setWidth(10),
                        bottom: ScreenUtil().setHeight(5)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: secondaryColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Radio(
                              value: 2,
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(0),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(230),
                          child: Text("Package 2",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setHeight(12),
                                  color: appColor,
                                  fontFamily: 'work',
                                  fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(5),
                        ),
                        Container(
                          child: Text("AED 250",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setHeight(20),
                                  color: appColor,
                                  fontFamily: 'work',
                                  fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(5),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(230),
                          child: Text("Ad will be for 3 month",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setHeight(12),
                                  color: appColor,
                                  fontFamily: 'work',
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(30),
              ),

              GestureDetector(
                  onTap: () {
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
                    press: () {},
                    color: Color(0xff05122B),
                  )),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
