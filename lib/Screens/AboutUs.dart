import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Constants/Colors.dart';


class AboutUs extends StatefulWidget {
  String title;
  AboutUs( this.title);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AboutUs>  {
  bool isLoading=true;
  /*DarkThemeProvider themeChange;
  ColorsInf colorsInf;*/


  List<String> jobSeaker = [
    "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)."];

  List<String> jobEmp = [
    "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)."];

  List<String> jobPort = [
    "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)."];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /* themeChange = Provider.of<DarkThemeProvider>(context);
    colorsInf = getColor(context);*/
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: lineColor,
            size: size.height * 0.035 //change your color here
        ),
        centerTitle: true,
        backgroundColor: secondaryColor,
      ),
      body:SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(size.height*0.03),
            child: Column(
              children: [

                Container(
                  alignment: Alignment.topLeft,
                  child:   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset("assets/images/logo.png",width: ScreenUtil().setWidth(100),)),
                    ],
                  ),
                ),

                SizedBox(
                  height: size.height * 0.030,
                ),

                Container(
                  alignment: Alignment.topLeft,
                  child: Text("About Us",
                    style: TextStyle(
                        fontFamily: 'work',
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.04,
                        color: lineColor
                    ),),
                ),

                SizedBox(
                  height: size.height * 0.010,
                ),

                Text(
                  "Real Pro app offers a social platform developed exclusively for Real Estate! Real Estate Agents managing properties for rent or sale in the UAE can showcase the videos and walkthroughs of properties and get instant reaction from the users on the Real Pro app. With are easy to use Agent's app, you can check your followers, likes and comments on your properties, and chat directly with a prospective buyer, tenant, or investor.",
                  style: TextStyle(
                      fontFamily: 'work',
                      fontWeight: FontWeight.normal,
                      fontSize: size.width * 0.03,
                      color: lineColor
                  ),),

                SizedBox(
                  height: size.height * 0.020,
                ),

              /*  Container(
                  alignment: Alignment.topLeft,
                  child: Text("Description",
                    style: TextStyle(
                        fontFamily: 'work',
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.04,
                        color: lineColor
                    ),),
                ),

                SizedBox(
                  height: size.height * 0.010,
                ),
                Text("Showcase the videos and walkthrough of properties in the UAE, check your followers, likes and comments on your properties, and chat directly with a prospective buyer, tenant, or investor.",
                  style: TextStyle(
                      fontFamily: 'work',
                      fontWeight: FontWeight.normal,
                      fontSize: size.width * 0.03,
                      color: lineColor
                  ),),

                SizedBox(
                  height: size.height * 0.020,
                ),*/
                SizedBox(
                  height: size.height * 0.015,
                ),



              ],
            )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

