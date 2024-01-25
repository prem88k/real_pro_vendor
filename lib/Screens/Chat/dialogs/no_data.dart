
import 'package:flutter/material.dart';
import 'package:real_pro_vendor/Screens/Chat/dialogs/svg_icon.dart';
import '../../../Constants/Colors.dart';

class NoData extends StatelessWidget {
  // Variables
   String ?svgName;
   Widget? icon;
   String ?text;

   NoData(
      {
      this.svgName,
      this.icon,
       this.text});

  @override
  Widget build(BuildContext context) {
    // Handle icon
     Widget _icon;
    // Check svgName
    if (svgName != null) {
        // Get SVG icon
        _icon = SvgIcon("assets/icons/$svgName.svg",
            width: 100, height: 100, color: appColor);
    } else {
      _icon = icon!;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Show icon
          _icon,
          Text(text!,
              style: TextStyle(fontFamily: 'work',
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                  color: darkTextColor), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
