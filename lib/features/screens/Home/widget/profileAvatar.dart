import 'package:flutter/material.dart';
import 'dart:io';

import 'package:msdl/constants/sizes.dart';

class ProfileAvatar extends StatefulWidget {
  @override
  _ProfileAvatarState createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File? _image;

  Future<void> _pickImage() async {}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 32,
        backgroundColor: Color(0xffF1F1F1).withOpacity(0.8),
        backgroundImage: _image != null ? FileImage(_image!) : null,
        child: _image == null
            ? Text(
                "Click",
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontFamily: "Andika",
                  fontWeight: FontWeight.bold,
                  color: Color(0xff935E38),
                ),
              )
            : null,
      ),
    );
  }
}
