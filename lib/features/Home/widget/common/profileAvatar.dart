import 'package:flutter/material.dart';
import 'dart:io';

import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/screens/Home/viewModel/home_viewModel.dart';
import 'package:provider/provider.dart';

class ProfileAvatar extends StatefulWidget {
  @override
  _ProfileAvatarState createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File? _image;

  Future<void> _pickImage() async {}

  @override
  Widget build(BuildContext context) {
    final homeData = Provider.of<HomeViewModel>(context).homeData;

    return InkWell(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: Sizes.size40,
        backgroundColor: Color(0xFF935E38).withOpacity(0.8),
        backgroundImage: _image != null ? FileImage(_image!) : null,
        child: _image == null
            ? Text(
                homeData?.name ?? "Image",
                style: TextStyle(
                  fontSize: Sizes.size14,
                  fontFamily: "Andika",
                  fontWeight: FontWeight.bold,
                  color: Color(0xffF1F1F1),
                ),
              )
            : null,
      ),
    );
  }
}
