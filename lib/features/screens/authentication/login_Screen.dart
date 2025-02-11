import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/toptitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/msdl_theme.dart';

class login_Screen extends StatelessWidget {
  login_Screen({super.key});
  static const routeName = 'logIn';
  static const routeUrl = '/';
  final TextStyle? headlineStyle = msdlTheme.textTheme.headlineLarge;

  @override
  Widget build(BuildContext context) {
    //MediaQuery 반응형 스크린 초기화
    SizeConfig.init(context);

    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: Sizes.size40, vertical: 180.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬

          children: [
            TopTitle(
              title: "Log In",
              fontSize: 40.w,
              fontWeight: FontWeight.w700,
            ),
            Gaps.v12,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TopTitle(
                  title: "No account?",
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w700,
                  opacity: 0.7,
                ),
                Gaps.h56,
                Text(
                  "Create account",
                  style: TextStyle(
                      color: Color(0xff26539C),
                      fontSize: Sizes.size18,
                      fontFamily: 'Andika',
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
