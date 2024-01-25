import 'package:flutter/material.dart';

import '../../../Constants/Colors.dart';

class MyCircularProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(valueColor:
      AlwaysStoppedAnimation<Color>(appColor)),
    );
  }
}
