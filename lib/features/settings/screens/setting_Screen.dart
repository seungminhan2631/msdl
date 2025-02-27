// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:msdl/commons/widgets/buttons/customBottomNavigationbar.dart';
import 'package:msdl/commons/widgets/topTitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/Home/viewModel/home_viewModel.dart';
import 'package:msdl/features/settings/widget/setting_Screen.dart';
import 'package:msdl/features/settings/widget/settings_body_text.dart';
import 'package:msdl/features/settings/widget/settings_profile_text.dart';
import 'package:msdl/msdl_theme.dart';
import 'package:msdl/features/Home/screens/home_Screen.dart';
import 'package:msdl/features/Group/screens/group_Screen.dart';
import 'package:msdl/features/authentication/viewModel/viewModel.dart';
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
  final String _serverUrl = "http://220.69.203.99:5000";

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

  Future<void> _loadProfileImage() async {
    final userId = Provider.of<AuthViewModel>(context, listen: false).userId;
    if (userId == null) return;

    final response =
        await http.get(Uri.parse("$_serverUrl/get_profile_image/$userId"));
    if (response.statusCode == 200) {
      final imageUrl = jsonDecode(response.body)['image_url'];
      setState(() {
        _profileImagePath = "$_serverUrl$imageUrl";
      });
    }
  }

  //프로필 이미지 선택 및 서버 업로드
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final bytes = await imageFile.readAsBytes();

      // ✅ Base64 변환 시 MIME 타입 포함 (확장자 자동 감지)
      String mimeType = pickedFile.mimeType ?? "image/png"; // 기본값: PNG
      String base64Image = "data:$mimeType;base64," + base64Encode(bytes);

      final userId = Provider.of<AuthViewModel>(context, listen: false).userId;
      if (userId == null) return;

      try {
        final response = await http.post(
          Uri.parse("$_serverUrl/upload_profile_image"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(
              {"user_id": userId, "image": base64Image}), // ✅ user_id 수정
        );

        if (response.statusCode == 200) {
          final imageUrl = jsonDecode(response.body)['image_url'];

          // ✅ UI 업데이트 및 로컬 저장
          setState(() {
            _profileImagePath = "$_serverUrl$imageUrl";
          });

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('profile_image', _profileImagePath!);

          print("✅ 프로필 이미지 업로드 성공! URL: $_profileImagePath");
        } else {
          print("❌ 이미지 업로드 실패: ${response.body}");
        }
      } catch (e) {
        print("⚠️ 서버 요청 실패: $e");
      }
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
    Future.delayed(Duration(microseconds: 200), () {
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
                      radius: Sizes.size80,
                      backgroundImage: _profileImagePath != null
                          ? NetworkImage(_profileImagePath!) // 저장된 이미지 표시
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
