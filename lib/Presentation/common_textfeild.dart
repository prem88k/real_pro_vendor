import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Constants/Colors.dart';


class TextFieldWidget extends StatefulWidget {
  final String title;
  bool obs;
  bool isEnable;

  bool isPassword;
  bool isReadOnly;
  final String? Function(String?) validator;
  final TextEditingController controller;
  Color borderColor;
  TextFieldWidget({
    required this.title,
    required this.controller,
    this.obs = false,
    this.isEnable = true,
    this.isPassword=false,
    this.isReadOnly=false,
    required this.validator,
    this.borderColor=inactiveColor,
  });
  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(0), vertical:ScreenUtil().setWidth(5)),
      child: Form(
        key: _formKey,
      autovalidateMode: AutovalidateMode.always,
        child: Container(
          child: TextFormField(
            maxLines: widget.title=="Description"?5:1,
            minLines: widget.title=="Description"?5:1,
            enabled: widget.isEnable,
            textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                fontSize: ScreenUtil().setWidth(12.5),
                color: widget.title=="Search Here"?secondaryColor: darkTextColor,
                fontFamily: 'work',
                fontWeight: FontWeight.w800
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
            validator: widget.validator,
            decoration: !widget.isPassword?InputDecoration(
              errorMaxLines: 2,
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
                color: widget.title=="Search Here"?secondaryColor: darkTextColor,
                fontFamily: 'work',
                  fontWeight: FontWeight.w800

              ),
              contentPadding: EdgeInsets.only(left:  ScreenUtil().setWidth(20),top:  ScreenUtil().setHeight(20)),
            ):InputDecoration(
              errorMaxLines: 2,
                isDense: true,
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
                color: darkTextColor,
                fontWeight: FontWeight.w800,
                fontFamily: 'work',
              ),
              contentPadding: EdgeInsets.only(left:  ScreenUtil().setWidth(20),top:  ScreenUtil().setHeight(20)),
            ),
          ),
        ),
      ),
    );
  }
}