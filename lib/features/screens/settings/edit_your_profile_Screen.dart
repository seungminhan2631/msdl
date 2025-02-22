import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/buttons/customBottomNavigationbar.dart';
import 'package:msdl/commons/widgets/topTitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/screens/Home/viewModel/home_viewModel.dart';
import 'package:provider/provider.dart';
import 'package:msdl/msdl_theme.dart';

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

  final List<String> roles = [
    "Professor",
    "Ph.D Student",
    "MS Student",
    "BS Student",
  ];

  Color _iconColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFF59E0B);
      case 1:
        return const Color(0xFF31B454);
      case 2:
        return const Color(0xFF935E38);
      case 3:
        return const Color(0xFF3F51B5);
      default:
        return Colors.black;
    }
  }

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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: Sizes.size20 + Sizes.size12),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TopTitle(
                  text: "Edit Your Profile",
                  fontSize: 37.w,
                ),
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage("assets/images/박보영.jpg"),
                ),
                Text(
                  "NAME",
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Gaps.v10,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.size40),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF151515).withOpacity(0.98),
                        hintText: "Enter your name",
                        hintStyle: TextStyle(
                          fontFamily: "Andika",
                          color: Color(0xFFF1F1F1).withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Color(0xFFAAAAAA),
                          ),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(
                  "PASSWORD",
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/editPasswordScreen");
                  },
                  child: Text(
                    "Keep Your Account Safe",
                  ),
                ),
                Gaps.v20,
                Column(
                  children: List.generate(roles.length, (index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.size40),
                      child: Row(
                        children: [
                          Icon(
                            icons[index],
                            color: _iconColor(index),
                          ),
                          Gaps.h24,
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
                            activeColor: Colors.white,
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
                  }),
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
      ),
    );
  }
}
