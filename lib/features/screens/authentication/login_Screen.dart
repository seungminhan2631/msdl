import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/bottomMsdl.dart';
import 'package:msdl/commons/widgets/buttons/CustomButton.dart';
import 'package:msdl/commons/widgets/buttons/CustomTextField.dart';
import 'package:msdl/commons/widgets/toptitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/msdl_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController =
      TextEditingController(); // ✅ 이메일 입력 컨트롤러 추가
  final TextEditingController passwordController =
      TextEditingController(); // ✅ 비밀번호 입력 컨트롤러 추가
  bool isEmailValid = true; // ✅ 이메일 유효성 상태 추가
  bool isPasswordValid = true; // ✅ 비밀번호 유효성 상태 추가

  // ✅ 유효성 검사 함수
  void _validateAndSubmit() {
    setState(() {
      isEmailValid = emailController.text.isNotEmpty; // 입력값이 없으면 false
      isPasswordValid = passwordController.text.isNotEmpty;
    });

    if (isEmailValid && isPasswordValid) {
      Navigator.pushNamed(context, "/homeScreen");
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context); // 반응형 크기 설정

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
            // ✅ 이메일 입력 필드 (유효성 검사 적용)
            CustomTextField(
              controller: emailController,
              hintText: "Email",
              firstIcon: Icons.email_outlined,
              lastIcon: Icons.close,
              helperText: "이메일 입력",
              errorText: isEmailValid ? null : "이메일을 입력하세요.", // 유효성 검사 결과 반영
              isValid: isEmailValid,
            ),
            Gaps.v36,
            CustomTextField(
              controller: passwordController,
              hintText: "Password",
              firstIcon: Icons.key,
              lastIcon: Icons.visibility,
              helperText: "비밀번호 입력",
              errorText:
                  isPasswordValid ? null : "비밀번호를 입력하세요.", // 유효성 검사 결과 반영
              isValid: isPasswordValid,
            ),
            Gaps.v52,
            // ✅ Next 버튼 클릭 시 유효성 검사 실행
            CustomButton(
              text: "Next",
              onPressed: _validateAndSubmit,
              routeName: "/homeScreen", // 클릭 시 유효성 검사 실행
            ),
            Spacer(),
            bottomMsdlScreen()
          ],
        ),
      ),
    );
  }
}
