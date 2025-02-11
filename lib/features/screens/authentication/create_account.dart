import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/bottomMsdl.dart';
import 'package:msdl/commons/widgets/buttons/CustomButton.dart';
import 'package:msdl/commons/widgets/buttons/CustomTextField.dart';
import 'package:msdl/commons/widgets/toptitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';

class CreateAccount extends StatefulWidget {
  static const routeName = 'CreateAccount';
  static const routeUrl = '/';

  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount>
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
  ]; // 화면에 표시할 메시지 리스트

  int currentIndex = 0; // 현재 표시할 메시지 인덱스

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 생성 (0.6초 동안 실행 → 속도 증가)
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    // Y축(Z축 방향) 회전 애니메이션 설정 (0도 → 180도)
    _animation = Tween<double>(begin: 0.0, end: 3.14).animate(_controller);

    _controller.addStatusListener((status) {
      // 애니메이션이 80% 진행되었을 때 텍스트 변경 (더 빨리 사라지는 효과)
      if (_animation.value > 3.14 * 0.8) {
        setState(() {
          currentIndex = (currentIndex + 1) % messages.length; // 다음 메시지로 변경
        });
      }

      // 애니메이션 완료 시 초기화
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });

    // 1.5초마다 애니메이션 실행하여 자동 변경 (더 빠르게 진행)
    _startTextRotation();
  }

  void _startTextRotation() {
    Future.delayed(
      Duration(milliseconds: 1500), // 1.5초마다 회전 실행 (속도 증가)
      () {
        if (mounted) {
          _controller.forward(); // 애니메이션 실행 (Y축 회전 시작)
          _startTextRotation(); // 반복 실행
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // 애니메이션 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드가 올라와도 화면 크기 변경 안 함
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.size52), // 좌우 여백 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            SizedBox(height: 130.w), // 상단 여백 추가
            Center(
              child: AnimatedSwitcher(
                duration:
                    Duration(milliseconds: 400), // 텍스트 전환 속도 증가 (더 빨리 사라짐)
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return AnimatedBuilder(
                    animation: _animation, // 애니메이션 값 감지
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.center, // 중심을 기준으로 회전
                        transform: Matrix4.rotationY(
                            _animation.value), // Y축(Z축 방향) 회전 적용
                        child: child, // 회전된 위젯
                      );
                    },
                    child: child, // AnimatedSwitcher의 새로운 위젯
                  );
                },
                child: TopTitle(
                  key: ValueKey<String>(messages[currentIndex]), // 변경된 텍스트 감지
                  text: messages[currentIndex], // 현재 인덱스의 메시지 출력
                ),
              ),
            ),
            SizedBox(height: 70.w), // 다음 UI 요소와 간격 추가
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
              hintText: "Enter your email",
              firstIcon: Icons.mail_outlined,
              lastIcon: Icons.cancel_outlined,
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
              hintText: "Enter a password",
              firstIcon: Icons.lock_outline_rounded,
              lastIcon: Icons.visibility_off_outlined,
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
              hintText: "Confirm password",
              firstIcon: Icons.check_rounded,
              lastIcon: Icons.visibility_off_outlined,
            ),
            Gaps.v72,
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomButton(
                  text: "Next",
                ),
                Gaps.v10, // 버튼과 간격 조절
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
                SizedBox(height: 100.h), // 하단 여백 추가
                SelfIntro(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
