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
        ), // 좌우 여백 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // 전체 가운데 정렬
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
                SizedBox(width: 30.w), // 프로필 이미지와 텍스트 사이 간격
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

class SettingsBodyText extends StatelessWidget {
  final String text; // 표시할 텍스트
  final double? fontSize; // 폰트 크기 (선택 사항)
  final FontWeight? fontWeight; // 폰트 두께 (선택 사항)
  final double? opacity; // 불투명도 (선택 사항)
  final Color? textColor; // 텍스트 색상 (추가)
  final TextStyle? headlineLarge = msdlTheme.primaryTextTheme.headlineLarge;

  SettingsBodyText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.opacity,
    this.textColor, // 텍스트 색상 추가
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.size36,
          ), // 좌우 여백 추가
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // 텍스트 왼쪽, 아이콘 오른쪽 정렬
            children: [
              Text(
                text,
                style: headlineLarge?.copyWith(
                  fontSize: (fontSize ?? 32.w).w,
                  fontWeight: fontWeight ?? FontWeight.w400,
                  color: textColor ?? // 사용자가 설정한 색상이 있으면 적용
                      headlineLarge?.color
                          ?.withOpacity(opacity ?? 1.0), // 기본 색상 유지
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: Sizes.size20,
              ), // 오른쪽 화살표 아이콘
            ],
          ),
        ),
        SizedBox(height: Sizes.size10), // 텍스트와 구분선 사이 간격 추가
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.h), // 양쪽 여백 30px 추가
          child: Container(
            height: 0.7.h, // 얇은 실선
            width: double.infinity, // Padding 때문에 자동 조정됨
            color: Colors.grey, // 선 색상
          ),
        ),
      ],
    );
  }
}
