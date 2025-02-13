import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/bottomMsdl.dart';
import 'package:msdl/commons/widgets/buttons/customButton.dart';
import 'package:msdl/commons/widgets/toptitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/screens/authentication/viewModel/viewModel.dart';
import 'package:msdl/msdl_theme.dart';

class ChooseRoleScreen extends StatefulWidget {
  const ChooseRoleScreen({super.key});

  @override
  State<ChooseRoleScreen> createState() => _ChooseRoleState();
}

class _ChooseRoleState extends State<ChooseRoleScreen> {
  List<bool> isChecked = [false, false, false, false];
  int? selectedIndex;
  bool hasError = false; // ✅ 에러 상태 추가
  final AuthViewModel _authViewModel = AuthViewModel();

  final List<IconData> icons = [
    Icons.account_balance_outlined,
    Icons.library_books_outlined,
    Icons.school_outlined,
    Icons.auto_stories_outlined,
  ];

  Color _iconColor(int index) {
    switch (index) {
      case 0:
        return Color(0xFFF59E0B); // Professor 아이콘 색상
      case 1:
        return Color(0xFF31B454); // Ph.D Student 아이콘 색상
      case 2:
        return Color(0xFF935E38); // MS Student 아이콘 색상
      case 3:
        return Color(0xFF3F51B5); // BS Student 아이콘 색상
      default:
        return Colors.black; // 기본 색상
    }
  }

  final List<String> roles = [
    "Professor",
    "Ph.D Student",
    "MS Student",
    "BS Student",
  ];

  void _onClick(int index) {
    setState(() {
      selectedIndex = index;
      hasError = false;
    });
  }

  final TextStyle? headlineLarge = msdlTheme.primaryTextTheme.headlineLarge;

  @override
  Widget build(BuildContext context) {
    GestureDetector gestureDetector = router(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: Sizes.size96 + Sizes.size12),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TopTitle(text: "Sign Up"),
              Gaps.v40,
              TopTitle(
                text: "Choose Your Academic Role",
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w700,
                opacity: 0.7,
              ),
              Gaps.v1,

              // ✅ 에러 메시지 추가

              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: roles.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.size40),
                      child: Row(
                        children: [
                          Icon(
                            icons[index],
                            color: _iconColor(index),
                          ),
                          Gaps.h32,
                          Expanded(
                            child: Text(
                              roles[index],
                              style: TextStyle(
                                fontFamily: "Andika",
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: Sizes.size20,
                              ),
                            ),
                          ),
                          Checkbox(
                            value: selectedIndex == index,
                            activeColor: Color(0xffFFFFFF),
                            checkColor: msdlTheme.shadowColor,
                            onChanged: (value) => _onClick(index),
                            side: BorderSide(
                              color: hasError && selectedIndex == null
                                  ? Color(0xFFB1384E) // ✅ 선택 안 했을 때 빨간 테두리
                                  : Color(0xffAAAAAA), // ✅ 정상 상태에서는 흰색
                              width: 2,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (hasError)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: Sizes.size16,
                    top: Sizes.size16,
                  ),
                  child: Text(
                    "Please select a role.",
                    style: TextStyle(
                      fontFamily: "Andika",
                      color: Colors.red,
                      fontSize: Sizes.size16,
                    ),
                  ),
                ),
              Gaps.v28,
              CustomButton(
                text: "Next",
                routeName: "/SignupScreen",
                onPressed: _validateAndProceed, // ✅ 유효성 검사 추가
              ),
              Gaps.v14,
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
                  gestureDetector,
                ],
              ),
              Gaps.v48,
              bottomMsdlScreen()
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndProceed() {
    if (selectedIndex == null) {
      setState(() {
        hasError = true; // ✅ 선택 안 하면 에러 활성화
      });
    } else if (selectedIndex != null) {
      _authViewModel.setRole(roles[selectedIndex!]); // ✅ role 저장
      Navigator.pushNamed(context, "/SignupScreen"); // ✅ 이름 입력 화면으로 이동
    }
  }

  GestureDetector router(BuildContext context) {
    return GestureDetector(
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
    );
  }
}
