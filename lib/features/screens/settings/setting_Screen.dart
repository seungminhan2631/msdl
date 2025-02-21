import 'package:flutter/material.dart';
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
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 2;
  @override
  void initState() {
    super.initState();
    _loadUserData();
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

  @override
  Widget build(BuildContext context) {
    final homeData = Provider.of<HomeViewModel>(context).homeData;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopTitle(text: "Settings"),
              Gaps.v80,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage("assets/images/박보영.jpg"),
                  ),
                  SizedBox(width: 30.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SettingsProfileText(
                        text: homeData?.role ?? "이쁜이",
                      ),
                      SizedBox(height: 20.h),
                      SettingsProfileText(
                        text: homeData?.name ?? "박보영",
                      ),
                    ],
                  ),
                ],
              ),
              Gaps.v80,
              SettingsBodyText(
                  text: "About", onTap: () => _showAboutDialog(context)),
              Gaps.v28,
              SettingsBodyText(text: "Edit Profile"),
              Gaps.v28,
              SettingsBodyText(
                text: "Sign Out",
                textColor: Color(0xffCF3B28),
              ),
              Gaps.v28,
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
        fontWeight: FontWeight.w400,
        color: Color(0xFFF1F1F1),
      ),
    );
  }
}
