import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/Home/viewModel/home_viewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileAvatar extends StatefulWidget {
  @override
  _ProfileAvatarState createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  //로컬에서 프로필 이미지 불러오기
  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath = prefs.getString('profile_image');
    });
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: Sizes.size40,
      backgroundImage: _profileImagePath != null
          ? NetworkImage(_profileImagePath!)
          : AssetImage("assets/images/민교수님.png") as ImageProvider,
    );
  }
}
