import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/toptitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
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
  void _onClick(bool? value, int index) {
    setState(() {
      selectedRoles[index] = value ?? false;
    });
  }

  final TextStyle? headlineLarge = msdlTheme.primaryTextTheme.headlineLarge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: Sizes.size96 + Sizes.size12),
        child: Center(
          child: Column(
            children: [
              TopTitle(text: "Sign Up"),
              Gaps.v40,
              TopTitle(
                text: "Choose Your Academic Role",
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w700,
                opacity: 0.7,
              ),
              Gaps.v40,
              Expanded(
                child: ListView.builder(
                  itemCount: roles.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Row(
                        children: [
                          Icon(
                            icons[index],
                            color: _iconColor(index),
                          ),
                          SizedBox(width: 10),
                          Text(
                            roles[index],
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                      value: selectedRoles[index], // ✅ 체크 상태 연결
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                      onChanged: (value) =>
                          _onClick(value, index), // ✅ 함수 참조 오류 수정
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
