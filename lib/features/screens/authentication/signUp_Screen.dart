import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/bottomMsdl.dart';
import 'package:msdl/commons/widgets/buttons/CustomTextField.dart';
import 'package:msdl/commons/widgets/buttons/customButton.dart';
import 'package:msdl/commons/widgets/toptitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final List<String> messages = [
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

  int _currentIndex = 0;
  late Timer _timer;
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

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
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      _changeMessage();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
    _timer.cancel();
    _controller.dispose();
  }

  void _changeMessage() {
    _controller.forward().then((_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % messages.length;
      });
      _controller.reverse();
    });
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
    SizeConfig.init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.size40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ 카드 뒤집기 애니메이션 적용
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double angle = _flipAnimation.value * pi; // ✅ 0 ~ π (180도)
                  bool isFlipped =
                      _flipAnimation.value > 0.5; // 중간 이후일 때 뒤집힌 상태

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(angle),
                    child: SizedBox(
                      width: 250, // ✅ 텍스트 박스의 고정 너비 (조정 가능)
                      height: 50, // ✅ 텍스트 박스의 고정 높이 (조정 가능)
                      child: FittedBox(
                        fit: BoxFit.scaleDown, // ✅ 긴 텍스트가 자동으로 크기 조절됨
                        child: isFlipped
                            ? Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(pi), // ✅ 거울 효과
                                child: TopTitle(
                                  text: messages[_currentIndex], // ✅ 변경된 인덱스 반영
                                ),
                              )
                            : TopTitle(text: messages[_currentIndex]),
                      ),
                    ),
                  );
                },
              ),

              Gaps.v64,
              Column(
                children: [
                  CustomTextField(
                    hintText: "Email Address",
                    firstIcon: Icons.email_outlined,
                    lastIcon: Icons.close,
                    helperText: "Please enter your email",
                    errorText:
                        isEmailValid ? null : "이메일을 입력하세요.", // 유효성 검사 결과 반영
                    controller: emailController,
                    isValid: isEmailValid,
                  ),
                  Gaps.v32,
                  CustomTextField(
                    hintText: "Password",
                    firstIcon: Icons.key,
                    lastIcon: Icons.visibility,
                    helperText: "Create a Password",
                    errorText:
                        isPasswordValid ? null : "비밀번호를 입력하세요.", // 유효성 검사 결과 반영
                    isValid: isPasswordValid,
                    controller: passwordController,
                  ),
                  Gaps.v32,
                  CustomTextField(
                    hintText: "Confirm Password",
                    firstIcon: Icons.key,
                    lastIcon: Icons.visibility,
                    helperText: "Confirm your Password",
                    errorText: isPasswordValid ? null : "비밀번호를 입력하세요.",
                    isValid: isPasswordValid,
                    controller: passwordController,
                  ),
                ],
              ),
              Gaps.v40,
              CustomButton(text: "Next", routeName: "/homeScreen"),
              Gaps.v12,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontSize: Sizes.size16 + Sizes.size1,
                      color: Color(0xffF1F1F1).withOpacity(0.7),
                      fontFamily: "Andika",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.h10,
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/");
                    },
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: Sizes.size16 + Sizes.size1,
                        color: Color(0xff26539C),
                        fontFamily: "Andika",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Gaps.v72,
              bottomMsdlScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
