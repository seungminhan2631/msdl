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
import 'package:msdl/features/authentication/viewModel/viewModel.dart';
import 'package:provider/provider.dart';

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
    "Bienvenido / Bienvenida",
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

  bool? isPasswordValid;
  bool? isConfirmPasswordValid;
  bool? isEmailValid;

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

    emailController.addListener(_validateEmail);
    passwordController.addListener(_validatePassword);
    confirmPasswordController.addListener(_validateConfirmPassword);
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

  // ✅ 이메일 유효성 검사 (입력 전에는 null 유지)
  void _validateEmail() {
    setState(() {
      if (emailController.text.isEmpty) {
        isEmailValid = null; // 입력 없을 때 기본 상태 유지
      } else {
        // ✅ 엄격한 이메일 유효성 검사 적용 (RFC 5322 기반)
        final RegExp emailRegex = RegExp(
            r'^(?=.{1,64}@.{1,255}$)(?=[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,63}$)(?!.*\.\.)[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,63}$');
        isEmailValid = emailRegex.hasMatch(emailController.text);
      }
    });
  }

  // ✅ 비밀번호 유효성 검사 (입력 전에는 null 유지)
  void _validatePassword() {
    setState(() {
      if (passwordController.text.isEmpty) {
        isPasswordValid = null; // 입력 없을 때 기본 상태 유지
      } else {
        isPasswordValid = passwordController.text.length >= 4; // 최소 4자 이상
      }
    });
  }

  // ✅ 비밀번호 확인 유효성 검사 (입력 전에는 null 유지)
  void _validateConfirmPassword() {
    setState(() {
      if (confirmPasswordController.text.isEmpty) {
        isConfirmPasswordValid = null; // 입력 없을 때 기본 상태 유지
      } else {
        isConfirmPasswordValid = confirmPasswordController.text ==
            passwordController.text; // 비밀번호 일치 여부 검사
      }
    });
  }

  void _validateAndSubmit() async {
    final authViewModel = context.read<AuthViewModel>();

    setState(() {
      isEmailValid =
          emailController.text.isNotEmpty && emailController.text.contains("@");
      isPasswordValid = passwordController.text.isNotEmpty &&
          passwordController.text.length >= 4;
      isConfirmPasswordValid = confirmPasswordController.text.isNotEmpty &&
          confirmPasswordController.text == passwordController.text;
    });

    if (isEmailValid! && isPasswordValid! && isConfirmPasswordValid!) {
      print("📌 회원가입 요청 시작...");
      String result = await authViewModel.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (result == "✅ 회원가입 성공") {
        print("✅ 회원가입 성공! 로그인 화면으로 이동");

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, "/");
        });
      } else {
        print("❌ 회원가입 실패! 이유: $result");
      }
    } else {
      print("❌ 이메일 또는 비밀번호 입력이 올바르지 않음.");
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 바탕을 터치하면 키보드 내려감
      },
      child: Scaffold(
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
                        width: 250.w,
                        height: 50.h,
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
                      helperText: "Enter your email",
                      errorText: isEmailValid == false
                          ? "Enter a valid email address"
                          : null,
                      controller: emailController,
                      isValid: isEmailValid ?? true,
                    ),
                    Gaps.v32,
                    CustomTextField(
                      hintText: "Password",
                      firstIcon: Icons.vpn_key_outlined,
                      lastIcon: Icons.visibility,
                      helperText: "Create a Password",
                      errorText: isPasswordValid == false
                          ? "Enter a valid password" // 최소 4자 이상
                          : null,
                      isValid: isPasswordValid ?? true,
                      controller: passwordController,
                    ),
                    Gaps.v32,
                    CustomTextField(
                      hintText: "Confirm Password",
                      firstIcon: Icons.vpn_key_outlined,
                      lastIcon: Icons.visibility,
                      helperText: "Confirm your Password",
                      errorText: isConfirmPasswordValid == false
                          ? "Passwords do not match" // 최소 4자 이상
                          : null,
                      isValid: isConfirmPasswordValid ?? true,
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
                bottomMsdl(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
