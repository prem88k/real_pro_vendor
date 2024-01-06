import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  // Variables
   String? assetName;
   double? width;
   double? height;
   Color? color;

   SvgIcon(this.assetName, {this.width, this.height, this.color});
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(assetName!,
        width: width ?? 23, height: height ?? 23, color: color ?? Colors.grey);
  }
}
