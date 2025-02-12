import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/toptitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/msdl_theme.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/SettingsScreen';
  static const routeUrl = '/';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 110.h),
            Center(
              child: TopTitle(
                text: "Settings",
              ),
            ),
            Gaps.v80,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage("assets/image/msdl.jpg"),
                ),
                SizedBox(width: 30.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SettingsProfileText(
                      text: "BS Student",
                    ),
                    SizedBox(height: 20.h),
                    SettingsProfileText(
                      text: "한승민",
                    ),
                  ],
                ),
              ],
            ),
            Gaps.v80,
            SettingsBodyText(
              text: "About",
              onTap: () => _showAboutDialog(context),
            ),
            Gaps.v28,
            SettingsBodyText(
              text: "Edit Profile",
            ),
            Gaps.v28,
            SettingsBodyText(
              text: "Log Out",
              textColor: Color(0xffCF3B28),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xffF1F1F1),
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
              mainAxisAlignment: MainAxisAlignment.center, // ✅ 텍스트 중앙 정렬 추가
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      textAlign: TextAlign.center,
                      "This app is the intellectual property of MSDL. Unauthorized use is prohibited.",
                      style: TextStyle(
                        fontFamily: "Andika",
                        color: msdlTheme.primaryTextTheme.bodySmall?.color,
                        fontSize: Sizes.size16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // ✅ 버튼을 오른쪽 하단으로 정렬
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
                        overlayColor: MaterialStateProperty.all(
                            Colors.transparent), // ✅ 물결 효과 제거
                      ),
                      child: Text(
                        "VIEW LICENSES",
                        style: SettingAboutButtonStyle(),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Colors.transparent), // ✅ 물결 효과 제거
                      ),
                      child: Text(
                        "CANCEL",
                        style: SettingAboutButtonStyle(),
                      ),
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
}

class SettingsBodyText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? opacity;
  final Color? textColor;
  final VoidCallback? onTap; // ✅ 클릭 이벤트 추가
  final TextStyle? headlineLarge = msdlTheme.primaryTextTheme.headlineLarge;

  SettingsBodyText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.opacity,
    this.textColor,
    this.onTap, // ✅ 클릭 이벤트 추가
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // ✅ 클릭 가능하도록 InkWell 추가
      onTap: onTap, // ✅ 사용자가 설정한 클릭 이벤트 실행
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.size36,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: headlineLarge?.copyWith(
                    fontSize: (fontSize ?? 32.w).w,
                    fontWeight: fontWeight ?? FontWeight.w400,
                    color: textColor ??
                        headlineLarge?.color?.withOpacity(opacity ?? 1.0),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: Sizes.size20,
                ),
              ],
            ),
          ),
          SizedBox(height: Sizes.size10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.h),
            child: Container(
              height: 0.7.h,
              width: double.infinity,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsProfileText extends StatelessWidget {
  final String text;

  const SettingsProfileText({
    super.key,
    required this.text,
  });

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
