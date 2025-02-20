import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/bottomMsdl.dart';
import 'package:msdl/commons/widgets/buttons/CustomButton.dart';
import 'package:msdl/commons/widgets/buttons/CustomTextField.dart';
import 'package:msdl/commons/widgets/topTitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/screens/Home/viewModel/home_viewModel.dart';
import 'package:msdl/features/screens/authentication/viewModel/viewModel.dart';
import 'package:msdl/msdl_theme.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthViewModel _authViewModel = AuthViewModel();

  bool? isEmailValid; // ✅ 초기에는 null 상태 (테두리 기본 유지)
  bool? isPasswordValid;
  bool loginFailed = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateEmail); // ✅ 입력 변경 감지
    passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(
      () {
        if (emailController.text.isEmpty) {
          isEmailValid = null; // ✅ 입력이 없으면 기본 상태 유지
        } else {
          // ✅ 엄격한 이메일 유효성 검사 적용 (RFC 5322 기반)
          final RegExp emailRegex = RegExp(
              r'^(?=.{1,64}@.{1,255}$)(?=[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,63}$)(?!.*\.\.)[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,63}$');
          isEmailValid = emailRegex.hasMatch(emailController.text);
        }
      },
    );
  }

  void _validatePassword() {
    setState(() {
      if (passwordController.text.isEmpty) {
        isPasswordValid = null; // ✅ 입력이 없으면 기본 상태 유지
      } else {
        isPasswordValid = passwordController.text.length >= 4; // 최소 4자 이상
      }
    });
  }

  void _validateAndSubmit() async {
    setState(() {
      isEmailValid =
          emailController.text.isNotEmpty && emailController.text.contains("@");
      isPasswordValid = passwordController.text.isNotEmpty &&
          passwordController.text.length >= 4;
      loginFailed = false;
    });

    if ((isEmailValid ?? false) && (isPasswordValid ?? false)) {
      bool success = await _authViewModel.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (success) {
        // ✅ 로그인 성공 여부 확인
        print("✅ 로그인 성공!");

        // ✅ 로그인한 사용자 정보 가져오기
        final user = _authViewModel.currentUser;
        if (user != null) {
          print(
              "👤 사용자 정보: ID: ${user.id}, Name: ${user.name}, Role: ${user.role}");
          Provider.of<HomeViewModel>(context, listen: false)
              .fetchHomeData(user.id);
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, "/homeScreen");
        });
      } else {
        setState(() {
          loginFailed = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context); // 반응형 크기 설정
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 바탕을 터치하면 키보드 내려감
      },
      child: Scaffold(
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
              // ✅ 이메일 입력 필드 (실시간 유효성 검사 적용)
              CustomTextField(
                controller: emailController,
                hintText: "Email",
                firstIcon: Icons.email_outlined,
                lastIcon: Icons.close,
                helperText: "Enter your email",
                errorText: isEmailValid == false
                    ? "Enter a valid email address"
                    : null,
                isValid: isEmailValid ?? true, // ✅ null이면 기본 테두리 유지
              ),
              Gaps.v36,
              // ✅ 비밀번호 입력 필드 (실시간 유효성 검사 적용)
              CustomTextField(
                controller: passwordController,
                hintText: "Password",
                firstIcon: Icons.key,
                lastIcon: Icons.visibility,
                helperText: "Enter your password",
                errorText:
                    isPasswordValid == false ? "Enter your password" : null,
                isValid: isPasswordValid ?? true, // ✅ null이면 기본 테두리 유지
              ),
              Gaps.v52,
              CustomButton(
                text: "Next",
                onPressed: _validateAndSubmit,
                routeName: "/homeScreen",
              ),
              Spacer(),
              bottomMsdl()
            ],
          ),
        ),
      ),
    );
  }
}
