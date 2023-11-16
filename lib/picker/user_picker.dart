import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class user_image_picker extends StatefulWidget {
  user_image_picker({required this.imagepikedfn});
  final void Function(XFile image) imagepikedfn;
  @override
  State<user_image_picker> createState() => _user_image_pickerState();
}

class _user_image_pickerState extends State<user_image_picker> {
  XFile? pickimage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxHeight: 150);

    if (pickedFile != null) {
      setState(() {
        pickimage = pickedFile;
      });
      widget.imagepikedfn(pickimage!);
    } else {
      // Handle if the user canceled the image picking.
      print('Image picking canceled.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage:
              pickimage != null ? FileImage(File(pickimage!.path)) : null,
          child: pickimage == null
              ? Icon(
                  Icons.account_circle,
                  size: 70,
                )
              : null,
        ),
        ElevatedButton.icon(
            onPressed: pickImage,
            icon: Icon(Icons.image),
            label: Text('choose image')),
      ],
    );
  }
}
