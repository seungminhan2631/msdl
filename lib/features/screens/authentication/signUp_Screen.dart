import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/bottomMsdl.dart';
import 'package:msdl/commons/widgets/buttons/CustomButton.dart';
import 'package:msdl/commons/widgets/buttons/CustomTextField.dart';
import 'package:msdl/commons/widgets/toptitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/SignupScreen';

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  List<String> messages = [
    "Welcome",
    "환영합니다",
    "Selamat datang",
    "ស្វាគមន៍",
    "Bienvenue",
    "خوش آمدید",
    "ようこそ",
    "欢迎",
    "Bienvenido & Bienvenida",
    "مرحبًا",
    "Bem-vindo / Bem-vinda",
    "Добро пожаловать",
  ];

  int currentIndex = 0;

  late AnimationController _controller;
  late Animation<double> _animation;

  final TextEditingController emailController =
      TextEditingController(); // ✅ 이메일 입력 컨트롤러 추가
  final TextEditingController passwordController =
      TextEditingController(); // ✅ 비밀번호 입력 컨트롤러 추가
  final TextEditingController confirmPasswordController =
      TextEditingController(); // ✅ 비밀번호 확인 입력 컨트롤러 추가

  bool isEmailValid = true; // ✅ 이메일 유효성 상태 추가
  bool isPasswordValid = true; // ✅ 비밀번호 유효성 상태 추가
  bool isConfirmPasswordValid = true; // ✅ 비밀번호 확인 유효성 상태 추가

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 3.14).animate(_controller);

    _controller.addStatusListener((status) {
      if (_animation.value > 3.14 * 0.8) {
        setState(() {
          currentIndex = (currentIndex + 1) % messages.length;
        });
      }

      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });

    _startTextRotation();
  }

  void _startTextRotation() {
    Future.delayed(
      Duration(milliseconds: 1500),
      () {
        if (mounted) {
          _controller.forward();
          _startTextRotation();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // ✅ 유효성 검사 함수 추가
  void _validateAndSubmit() {
    setState(() {
      isEmailValid = emailController.text.isNotEmpty;
      isPasswordValid = passwordController.text.isNotEmpty;
      isConfirmPasswordValid = confirmPasswordController.text.isNotEmpty &&
          confirmPasswordController.text == passwordController.text;
    });

    if (isEmailValid && isPasswordValid && isConfirmPasswordValid) {
      print("회원가입 성공!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.size52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 130.w),
            Center(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(_animation.value),
                        child: child,
                      );
                    },
                    child: child,
                  );
                },
                child: TopTitle(
                  key: ValueKey<String>(messages[currentIndex]),
                  text: messages[currentIndex],
                ),
              ),
            ),
            SizedBox(height: 70.w),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TopTitle(
                  text: "Email Address",
                  fontSize: Sizes.size16 + Sizes.size1,
                  fontWeight: FontWeight.w700,
                  opacity: 0.8,
                ),
              ],
            ),
            CustomTextField(
              controller: emailController,
              hintText: "Enter your email",
              firstIcon: Icons.mail_outlined,
              lastIcon: Icons.cancel_outlined,
              errorText: isEmailValid ? null : "이메일을 입력하세요.",
              isValid: isEmailValid,
            ),
            Gaps.v44,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TopTitle(
                  text: "Create a Password",
                  fontSize: Sizes.size16 + Sizes.size1,
                  fontWeight: FontWeight.w700,
                  opacity: 0.8,
                ),
              ],
            ),
            CustomTextField(
              controller: passwordController,
              hintText: "Enter a password",
              firstIcon: Icons.lock_outline_rounded,
              lastIcon: Icons.visibility_off_outlined,
              errorText: isPasswordValid ? null : "비밀번호를 입력하세요.",
              isValid: isPasswordValid,
            ),
            Gaps.v44,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TopTitle(
                  text: "Confirm Your Password",
                  fontSize: Sizes.size16 + Sizes.size1,
                  fontWeight: FontWeight.w700,
                  opacity: 0.8,
                ),
              ],
            ),
            CustomTextField(
              controller: confirmPasswordController,
              hintText: "Confirm password",
              firstIcon: Icons.check_rounded,
              lastIcon: Icons.visibility_off_outlined,
              errorText: isConfirmPasswordValid ? null : "비밀번호가 일치하지 않습니다.",
              isValid: isConfirmPasswordValid,
            ),
            Gaps.v72,
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomButton(
                  text: "Next",
                  routeName: "/",
                  onPressed: _validateAndSubmit, // ✅ 유효성 검사 실행
                ),
                Gaps.v10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TopTitle(
                      text: "Already have an account?",
                      fontSize: Sizes.size16 + Sizes.size1,
                      fontWeight: FontWeight.w700,
                      opacity: 0.7,
                    ),
                    SizedBox(width: 20.w),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Log In",
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
                SizedBox(height: 100.h),
                bottomMsdlScreen(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
