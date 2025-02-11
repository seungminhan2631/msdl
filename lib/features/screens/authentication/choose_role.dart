import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/toptitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/msdl_theme.dart';

class ChooseRole extends StatefulWidget {
  static const routeName = 'ChooseRole';
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

  final TextStyle? headlineLarge = msdlTheme.primaryTextTheme.headlineLarge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 102,
          ),
          child: Column(
            children: [
              TopTitle(
                title: "Sign Up",
              ),
              Gaps.v44,
              Text(
                "Choose Your Academic Role",
                style: headlineLarge?.copyWith(
                  fontSize: Sizes.size24 + Sizes.size4,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                width: Sizes.size32,
                decoration: BoxDecoration(),
                child: ListView(
                  children: List.generate(
                    isChecked.length,
                    (index) {
                      return ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.size32),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                icons[index],
                                color: _iconColor(index),
                              ),
                              SizedBox(
                                width: Sizes.size28.w,
                              ),
                              Text(
                                roles[index],
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: Sizes.size24.w,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Checkbox(
                          value: isChecked[index],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          side: BorderSide(
                            color: darkColorScheme.onSurfaceVariant
                                .withOpacity(0.8),
                            width: 2,
                          ),
                          fillColor: WidgetStateProperty.resolveWith<Color>(
                            (states) {
                              if (states.contains(WidgetState.selected)) {
                                return darkColorScheme.onSurfaceVariant
                                    .withOpacity(0.8);
                              }
                              return Colors.transparent;
                            },
                          ),
                          checkColor: msdlTheme
                              .colorScheme.onSurfaceVariant, // 체크 시 박스 사라짐 수정요망
                          onChanged: (bool? value) {
                            setState(
                              () {
                                isChecked[index] = value ?? false;
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: Sizes.size32,
                height: Sizes.size40,
                decoration: BoxDecoration(
                  color: const Color(0xff4F6F89),
                  border: Border.all(
                    color: Color(
                      0xFFAAAAAA,
                    ),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: CupertinoButton(
                  onPressed: () {},
                  padding: EdgeInsets.symmetric(
                    vertical: Sizes.size20,
                    horizontal: Sizes.size40,
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: Color(0xFFF1F1F1),
                      fontSize: Sizes.size24.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
