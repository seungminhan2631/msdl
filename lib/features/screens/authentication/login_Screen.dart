import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/bottomMsdl.dart';
import 'package:msdl/commons/widgets/buttons/CustomButton.dart';
import 'package:msdl/commons/widgets/buttons/CustomTextField.dart';
import 'package:msdl/commons/widgets/toptitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/msdl_theme.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
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
            EdgeInsets.symmetric(horizontal: Sizes.size40, vertical: 150.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopTitle(
              text: "Log In",
              fontSize: 37.w,
              fontWeight: FontWeight.w700,
            ),
            Gaps.v12,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TopTitle(
                  text: "No account?",
                  fontSize: Sizes.size16 + Sizes.size1,
                  fontWeight: FontWeight.w700,
                  opacity: 0.7,
                ),
                Gaps.h64,
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/chooseRole_Screen");
                  },
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
              helperText: "이메일 오류",
              errorText: "다시 입력",
            ),
            Gaps.v40,
            CustomTextField(
              hintText: "Password",
              firstIcon: Icons.key,
              lastIcon: Icons.visibility,
              errorText: "다시입력",
              helperText: "비밀번호 규칙",
            ),
            Gaps.v52,
            CustomButton(
              text: "Next",
              routeName: "",
            ),
            Spacer(),
            bottomMsdlScreen()
          ],
        ),
      ),
    );
  }
}
