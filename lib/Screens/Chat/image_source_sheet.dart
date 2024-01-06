import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dialogs/svg_icon.dart';

class ImageSourceSheet extends StatelessWidget {
  // Constructor
  ImageSourceSheet({ required this.onImageSelected});

  // Callback function to return image file
  final Function(File) onImageSelected;
  // ImagePicker instance
  final picker = ImagePicker();

  Future<void> selectedImage(BuildContext context, File image) async {
    // init i18n

    // Check file
    if (image != null) {
    /*  final croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          maxWidth: 900,
          maxHeight: 1500,
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: i18n.translate("edit_crop_image"),
            toolbarColor: appColor,
            toolbarWidgetColor: Colors.white,
          ));*/
      onImageSelected(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: ((context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                /// Select image from gallery
                TextButton.icon(
                  icon: Icon(Icons.photo_library, color: Colors.grey, size: 27),
                  label: Text("Galary",
                      style: TextStyle(fontSize: 16)),
                  onPressed: () async {
                    // Get image from device gallery
                    final pickedFile = await picker.getImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile == null) return;
                    selectedImage(context, File(pickedFile.path));
                  },
                ),

                /// Capture image from camera
                TextButton.icon(
                  icon: SvgIcon("assets/hotel/camera_icon.svg",
                      width: 20, height: 20),
                  label: Text("Camera",
                      style: TextStyle(fontSize: 16)),
                  onPressed: () async {
                    // Capture image from camera
                    final pickedFile = await picker.getImage(
                      source: ImageSource.camera,
                    );
                    if (pickedFile == null) return;
                    selectedImage(context, File(pickedFile.path));
                  },
                ),
              ],
            )));
  }
}
