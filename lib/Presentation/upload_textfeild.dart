import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Constants/Colors.dart';


class TextFieldUpload extends StatefulWidget {
  final String title;
  bool obs;
  bool isPassword;
  bool isReadOnly;

  final TextEditingController controller;
  Color borderColor;
  TextFieldUpload({
    required this.title,
    required this.controller,
    this.obs = false,
    this.isPassword=false,
    this.isReadOnly=false,

    this.borderColor=inactiveColor,
  });
  @override
  State<TextFieldUpload> createState() => _TextFieldUploadState();
}

class _TextFieldUploadState extends State<TextFieldUpload> {



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(0), vertical:ScreenUtil().setWidth(5)),
      child: Container(
        height:  widget.title=="What is your concern?"? ScreenUtil().setHeight(85):ScreenUtil().setHeight(45),
        child: TextFormField(
          maxLines: widget.title=="What is your concern?"?5:1,
          minLines: widget.title=="What is your concern?"?5:1,
          textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
              fontSize: ScreenUtil().setWidth(12.5),
              color: widget.title=="Search Here"?secondaryColor: darkTextColor,
              fontFamily: 'work',
              fontWeight: FontWeight.w400
            ),
            inputFormatters: [
          ],
          obscureText: widget.obs,
          controller: widget.controller,
          keyboardType: widget.title.toLowerCase() == "email"
              ? TextInputType.emailAddress
              : widget.title.toLowerCase() == "password"
              ? TextInputType.visiblePassword
              : widget.title == "Enter Mobile Number" || widget.title =="Enter OTP" || widget.title=="Company/Business Pincode" || widget.title=="Bank Number"?TextInputType.number: TextInputType.text,
          readOnly: widget.isReadOnly,
          onTap: () async {
            if(widget.isReadOnly)
              {
             /*   DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1940),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2100));

                if (pickedDate != null) {
                  print(
                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
                  print(
                      formattedDate); //formatted date output using intl package =>  2021-03-16
                  setState(() {
                    widget.controller.text =
                        formattedDate; //set output date to TextField value.
                  });
                } else {}*/
              }

          },
          decoration: !widget.isPassword?InputDecoration(
            fillColor: widget.title=="Search Here"?Colors.transparent:Colors.transparent,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.title=="Search Here"?secondaryColor: lineColor,
                width: 0.5,

              ),
            ),
            enabledBorder: OutlineInputBorder(

              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
              borderSide: BorderSide(
                color: widget.title=="Search Here"?secondaryColor: lineColor,
                width: 0.5,

              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:  BorderSide(
                  color:  lineColor, width: 0.5),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
            ),
            hintText: widget.title,
            counterText: '',
            hintStyle: TextStyle(
                fontSize: ScreenUtil().setWidth(12.5),
              color: widget.title=="Search Here"?secondaryColor: primaryTextColor,
              fontFamily: 'work',
                fontWeight: FontWeight.w400

            ),
            contentPadding: EdgeInsets.only(left:  ScreenUtil().setWidth(20),top:  ScreenUtil().setHeight(20)),
          ):InputDecoration(
            suffixIcon:  GestureDetector(
              onTap: () {
                setState(() {
                  widget.obs = !widget.obs;
                });
              },
              child: widget.isPassword? Icon(
                widget.obs
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: lightTextColor,
              ):Container(),
            ),
            fillColor: secondaryColor,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.title=="Search Here"?secondaryColor: lineColor,
                width: 0.5,

              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
              borderSide: BorderSide(
                color: widget.title=="Search Here"?secondaryColor: lineColor,
                width: 0.5,

              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:  BorderSide(
                  color:  lineColor, width: 0.5),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
            ),
            hintText: widget.title,
            counterText: '',
            hintStyle: TextStyle(
              fontSize: ScreenUtil().setWidth(12.5),
              color: darkTextColor,
              fontWeight: FontWeight.w400,
              fontFamily: 'work',
            ),
            contentPadding: EdgeInsets.only(left:  ScreenUtil().setWidth(20)),
          ),
        ),
      ),
    );
  }
}