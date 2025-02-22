import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/buttons/customBottomNavigationbar.dart';
import 'package:msdl/commons/widgets/topTitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/screens/Home/viewModel/home_viewModel.dart';
import 'package:msdl/features/screens/settings/setting_Screen.dart';
import 'package:msdl/msdl_theme.dart';
import 'package:provider/provider.dart';

class EditYourProfileScreen extends StatefulWidget {
  const EditYourProfileScreen({super.key});

  @override
  State<EditYourProfileScreen> createState() => _EditYourProfileScreenState();
}

class _EditYourProfileScreenState extends State<EditYourProfileScreen> {
  int? selectedIndex;
  bool hasError = false;
  int _selectedIndex = 2;

  final List<IconData> icons = [
    Icons.account_balance_outlined,
    Icons.library_books_outlined,
    Icons.school_outlined,
    Icons.auto_stories_outlined,
  ];

  Color _iconColor(int index) {
    switch (index) {
      case 0:
        return Color(0xFFF59E0B);
      case 1:
        return Color(0xFF31B454);
      case 2:
        return Color(0xFF935E38);
      case 3:
        return Color(0xFF3F51B5);
      default:
        return Colors.black;
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

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      if (index == 0) {
        Navigator.pushReplacementNamed(context, "/groupScreen");
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, "/homeScreen");
      } else if (index == 2) {
        Navigator.pushReplacementNamed(context, "/settingsScreen");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeData = Provider.of<HomeViewModel>(context).homeData;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: Sizes.size96 + Sizes.size12),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TopTitle(
                text: "Edit Your Profile",
                fontSize: 37.w,
              ),
              Gaps.v40,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage("assets/images/박보영.jpg"),
                  ),
                  SizedBox(width: 30.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SettingsProfileText(
                        text: homeData?.role ?? "이쁜이",
                      ),
                      SizedBox(height: 20.h),
                      SettingsProfileText(
                        text: homeData?.name ?? "박보영",
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
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
                                  ? Color(0xFFB1384E) // 선택 안 했을 때 빨간 테두리
                                  : Color(0xffAAAAAA), // 정상 상태에서는 흰색
                              width: 2,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomNavigationBar(
          onItemTapped: _onItemTapped,
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }
}
