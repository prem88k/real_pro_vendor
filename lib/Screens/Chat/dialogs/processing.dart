

import 'package:flutter/material.dart';

import '../../../Constants/Colors.dart';
import 'my_circular_progress.dart';


class Processing extends StatelessWidget {
   String ?text;

   Processing({this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          MyCircularProgress(),
          SizedBox(height: 10),
          Text(text ?? "processing",
              style: TextStyle(
                  fontSize: 18,
                  color: secondaryColor,
                  fontFamily: 'work',
                  fontWeight: FontWeight.w500)),
          SizedBox(height: 5),
          Text("please_wait", style: TextStyle(fontSize: 16,                  color: secondaryColor,
            fontFamily: 'work',)),
        ],
      ),
    );
  }
}
