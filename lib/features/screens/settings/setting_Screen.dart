// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:msdl/commons/widgets/buttons/customBottomNavigationbar.dart';
import 'package:msdl/commons/widgets/topTitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/screens/Home/viewModel/home_viewModel.dart';
import 'package:msdl/msdl_theme.dart';
import 'package:msdl/features/screens/Home/home_Screen.dart';
import 'package:msdl/features/screens/Group/group_Screen.dart';
import 'package:msdl/features/screens/authentication/viewModel/viewModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 2;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadProfileImage();
  }

//로그인한 userId를
  void _loadUserData() {
    final userId = Provider.of<AuthViewModel>(context, listen: false).userId;
    if (userId != null) {
      Provider.of<HomeViewModel>(context, listen: false).fetchHomeData(context);
    } else {
      print("❌ 로그인된 사용자 ID 없음!");
    }
  }

  // 저장된 프로필 이미지 경로 불러오기
  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath = prefs.getString('profile_image'); // 저장된 이미지 경로 불러오기
    });
  }

  // 📸 갤러리에서 이미지 선택 및 저장
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path); // 선택한 파일 가져오기
      final directory =
          await getApplicationDocumentsDirectory(); // 앱 내 저장 폴더 가져오기
      final String newPath =
          '${directory.path}/profile_image.jpg'; // 파일 저장 경로 설정

      final savedImage = await imageFile.copy(newPath); // 선택한 이미지를 새로운 경로에 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', savedImage.path); // 저장된 이미지 경로 저장

      setState(() {
        _profileImagePath = savedImage.path; // UI 업데이트
      });
    }
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      if (index == 0) {
        Navigator.pushReplacementNamed(context, "/groupScreen");
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, "/homeScreen");
      } else if (index == 2) {
        Navigator.pushReplacementNamed(context, "/settingsScreen");
      }
    }
  }

  void _signOut(BuildContext context) {
    // AuthViewModel을 통해 사용자 정보 초기화
    Provider.of<AuthViewModel>(context, listen: false).logout();
    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to log out?"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _signOut(context);
              },
              child: Text("Sign out"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeData = Provider.of<HomeViewModel>(context).homeData;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopTitle(text: "Settings"),
              Gaps.v40,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: _profileImagePath != null
                          ? FileImage(File(_profileImagePath!)) // 저장된 이미지 표시
                          : AssetImage("assets/images/민교수님.png") // 기본 이미지 표시
                              as ImageProvider,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          backgroundColor: Color(0xFF151515),
                          radius: 18,
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Color(0xFF90CAF9),
                            size: Sizes.size20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SettingsProfileText(
                        text: homeData?.role ?? "Role",
                      ),
                      SizedBox(height: 20.h),
                      SettingsProfileText(
                        text: homeData?.name ?? "Name",
                      ),
                    ],
                  ),
                ],
              ),
              Gaps.v40,
              SettingsBodyText(
                  text: "About", onTap: () => _showAboutDialog(context)),
              Gaps.v28,
              SettingsBodyText(
                text: "Edit Profile",
                onTap: () {
                  Navigator.pushNamed(context, "/editYourProfileScreen");
                },
              ),
              Gaps.v28,
              SettingsBodyText(
                text: "Sign Out",
                textColor: Color(0xffCF3B28),
                onTap: () => _confirmSignOut(context),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          onItemTapped: _onItemTapped,
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }
}

void _showAboutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xff353535),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: Color(0xFFF1F1F1),
            width: 1.0,
          ),
        ),
        title: Center(
          child: Text(
            "MSDL",
            style: TextStyle(
              fontFamily: "Andika",
              color: msdlTheme.primaryTextTheme.headlineLarge?.color,
              fontSize: Sizes.size40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Container(
          width: double.maxFinite,
          height: 130.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    "This app is the intellectual property of MSDL. Unauthorized use is prohibited.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Andika",
                      color: Color(0xFFF1F1F1).withOpacity(0.75),
                      fontSize: Sizes.size16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      showLicensePage(
                        context: context,
                        applicationName: "Msdl App",
                        applicationVersion: "1.0.0",
                      );
                    },
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    child:
                        Text("VIEW LICENSES", style: SettingAboutButtonStyle()),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: Text("CANCEL", style: SettingAboutButtonStyle()),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

TextStyle SettingAboutButtonStyle() {
  return TextStyle(
    fontFamily: "Andika",
    color: Color(0xFF90CAF9),
    fontSize: Sizes.size14,
    fontWeight: FontWeight.bold,
  );
}

class SettingsBodyText extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? textColor;
  final TextStyle? headlineLarge = msdlTheme.primaryTextTheme.headlineLarge;

  SettingsBodyText({
    super.key,
    required this.text,
    this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.size36),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: headlineLarge?.copyWith(
                    fontSize: 32.w,
                    fontWeight: FontWeight.w400,
                    color: textColor ?? headlineLarge?.color,
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white, size: Sizes.size20),
              ],
            ),
          ),
          SizedBox(height: Sizes.size10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.h),
            child: Divider(color: Colors.grey, thickness: 0.7.h),
          ),
        ],
      ),
    );
  }
}

class SettingsProfileText extends StatelessWidget {
  final String text;

  const SettingsProfileText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: Sizes.size24,
        fontFamily: "Andika",
        fontWeight: FontWeight.w700,
        color: Color(0xFFF1F1F1),
      ),
    );
  }
}
