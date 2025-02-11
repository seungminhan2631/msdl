import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/buttons/CustomTextField.dart';
import 'package:msdl/commons/widgets/toptitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/msdl_theme.dart';

class login_Screen extends StatelessWidget {
  login_Screen({super.key});
  static const routeName = 'logIn';
  static const routeUrl = '/';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextStyle? headlineStyle = msdlTheme.textTheme.headlineLarge;

  @override
  Widget build(BuildContext context) {
    // MediaQuery 반응형 스크린 초기화
    SizeConfig.init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: Sizes.size40, vertical: 166.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopTitle(
              title: "Log In",
              fontSize: 37.w,
              fontWeight: FontWeight.w700,
            ),
            Gaps.v12,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TopTitle(
                  title: "No account?",
                  fontSize: Sizes.size16 + Sizes.size1,
                  fontWeight: FontWeight.w700,
                  opacity: 0.7,
                ),
                Gaps.h64,
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Create account",
                    style: TextStyle(
                      color: Color(0xff26539C),
                      fontSize: Sizes.size16 + Sizes.size1,
                      fontFamily: 'Andika',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Gaps.v20,
            CustomTextField(
              hintText: "Email",
              firstIcon: Icons.email_outlined,
              lastIcon: Icons.close,
            ),
            Gaps.v40,
            CustomTextField(
              hintText: "Password",
              firstIcon: Icons.key,
              lastIcon: Icons.visibility,
            ),
            Gaps.v60,
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xff4F6F89),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  minimumSize: const Size(300, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xffAAAAAA), width: 2),
                  ),
                ),
                onPressed: () {
                  // 버튼 클릭 이벤트
                },
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontFamily: 'Andika',
                    fontSize: 22, // 텍스트 크기 조절
                    color: Colors.white, // 텍스트 색상
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
