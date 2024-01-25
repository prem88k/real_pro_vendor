import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';

class PickerDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PickerDemoState();
}

class PickerDemoState extends State<PickerDemo> {
  String ?lat;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picker Example')),
      body: Center(
        child: MaterialButton(
          child: Text(lat==null?"Pick Delivery location":lat!),
          onPressed: () {
            showPlacePicker();
          },
        ),
      ),
    );
  }

  void showPlacePicker() async {
    LocationResult? result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PlacePicker("AIzaSyCkW__vI2DazIWYjIMigyxwDtc_kyCBVIo"),));
      setState(() {
        lat=result!.latLng.toString();
      });
    // Handle the result in your way
    print(result!.latLng.toString());
  }
}