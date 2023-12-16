import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Constants/Colors.dart';


class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor,borderColor;
  const RoundedButton({
    required this.text,
    required this.press,
    this.color = appColor,
    this.textColor = Colors.white,
    this.borderColor = Colors.transparent,

  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width ,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor, width: 0.4),
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
            color: color,
          ),
            width: ScreenUtil().setWidth(150),
            height: ScreenUtil().setHeight(45),
            child: Center(child: Text(text,style: TextStyle(
              fontSize: ScreenUtil().setWidth(13),
              color: textColor,
              fontFamily: 'work',
              fontWeight: FontWeight.w600
            ),)))
      ),
    );
  }
}
