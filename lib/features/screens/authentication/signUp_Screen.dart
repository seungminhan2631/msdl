import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/bottomMsdl.dart';
import 'package:msdl/commons/widgets/buttons/CustomTextField.dart';
import 'package:msdl/commons/widgets/buttons/customButton.dart';
import 'package:msdl/commons/widgets/topTitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/screens/authentication/viewModel/viewModel.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final AuthViewModel _authViewModel = AuthViewModel();

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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool isConfirmPasswordValid = true;

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

  void _validateAndSubmit() async {
    print("📌 _validateAndSubmit() 실행됨!");
    print("📌 입력된 이메일: '${emailController.text}'"); // ✅ 이메일 값 확인
    print("📌 입력된 비밀번호: '${passwordController.text}'"); // ✅ 비밀번호 값 확인
    print(
        "📌 입력된 비밀번호 확인: '${confirmPasswordController.text}'"); // ✅ 확인 비밀번호 값 확인

    setState(() {
      isEmailValid = emailController.text.isNotEmpty;
      isPasswordValid = passwordController.text.isNotEmpty;
      isConfirmPasswordValid = confirmPasswordController.text.isNotEmpty &&
          confirmPasswordController.text == passwordController.text;
    });

    print("📌 isEmailValid: $isEmailValid");
    print("📌 isPasswordValid: $isPasswordValid");
    print("📌 isConfirmPasswordValid: $isConfirmPasswordValid");

    if (isEmailValid && isPasswordValid && isConfirmPasswordValid) {
      print("📌 회원가입 요청 시작...");
      bool success = await _authViewModel.signUp(
          emailController.text.trim(), passwordController.text.trim());

      print("📌 회원가입 결과: $success");

      if (success) {
        print("✅ 회원가입 성공! 로그인 화면으로 이동");
        Navigator.pushNamed(context, "/login");
      } else {
        print("❌ 회원가입 실패! 다시 시도해주세요.");
      }
    } else {
      print("❌ 이메일 또는 비밀번호 입력이 올바르지 않음.");
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
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double angle = _flipAnimation.value * pi;
                  bool isFlipped = _flipAnimation.value > 0.5;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(angle),
                    child: SizedBox(
                      width: 250,
                      height: 50,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: isFlipped
                            ? Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(pi),
                                child: TopTitle(
                                  text: messages[_currentIndex],
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
                    errorText: isEmailValid ? null : "이메일을 입력하세요.",
                    controller: emailController,
                    isValid: isEmailValid,
                  ),
                  Gaps.v32,
                  CustomTextField(
                    hintText: "Password",
                    firstIcon: Icons.key,
                    lastIcon: Icons.visibility,
                    helperText: "Create a Password",
                    errorText: isPasswordValid ? null : "비밀번호를 입력하세요.",
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
                    controller: confirmPasswordController,
                  ),
                ],
              ),
              Gaps.v40,
              CustomButton(
                text: "Next",
                routeName: "/",
                onPressed: _validateAndSubmit,
              ),
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
