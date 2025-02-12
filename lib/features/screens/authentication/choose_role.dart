import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/bottomMsdl.dart';
import 'package:msdl/commons/widgets/buttons/customButton.dart';
import 'package:msdl/commons/widgets/toptitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/msdl_theme.dart';

class ChooseRole extends StatefulWidget {
  static const routeName = '/ChooseRole';
  static const routeUrl = '/';

  const ChooseRole({super.key});

  @override
  State<ChooseRole> createState() => _ChooseRoleState();
}

class _ChooseRoleState extends State<ChooseRole> {
  List<bool> isChecked = [false, false, false, false];
  int? selectedIndex;

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

  List<bool> selectedRoles = [false, false, false, false]; // 체크 상태 관리
  void _onClick(int index) {
    setState(() {
      if (selectedIndex == index) {
        selectedIndex = null; // 같은 항목을 누르면 선택 해제
      } else {
        selectedIndex = index; // 새 항목 선택
      }
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
              Gaps.v7,
              Flexible(
                child: ListView.builder(
                  //아래 두개 :1. 공간차지를 리스트 인덱스 개수까지, 2.스크롤 X
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: roles.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Sizes.size40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              icons[index],
                              color: _iconColor(index),
                            ),
                            Gaps.h32,
                            Text(
                              roles[index],
                              style: TextStyle(
                                fontFamily: "Andika",
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: Sizes.size20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      value: selectedIndex == index,
                      activeColor: Color(0xffFFFFFF),
                      checkColor: msdlTheme.shadowColor,
                      onChanged: (value) => _onClick(index),
                    );
                  },
                ),
              ),
              Gaps.v56,
              CustomButton(
                text: "Next",
                routeName: "/SignupScreen",
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

  GestureDetector router(BuildContext context) {
    var gestureDetector = GestureDetector(
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
    return gestureDetector;
  }
}
