import 'package:flutter/material.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:intl/intl.dart';
import 'package:msdl/features/screens/Home/widget/customContainer.dart';
import 'package:msdl/features/screens/Home/widget/profileAvatar.dart';
import 'package:msdl/features/screens/Home/widget/sectionTitle.dart';
import 'package:msdl/commons/widgets/buttons/customBottomNavigationbar.dart';
import 'package:msdl/features/screens/Group/group_Screen.dart';
import 'package:msdl/features/screens/settings/setting_Screen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 1; // 홈 화면에서 시작
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
    String todayDate = DateFormat('yyyy.MM.dd').format(DateTime.now());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff151515).withOpacity(0.98),
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(
              left: Sizes.size72 + Sizes.size24, top: Sizes.size5),
          child: Row(
            children: [
              Text(
                "Today",
                style: TextStyle(
                    color: Color(0xffF1F1F1),
                    fontFamily: "Andika",
                    fontWeight: FontWeight.bold,
                    fontSize: Sizes.size40),
              ),
              Gaps.h8,
              Padding(
                padding: EdgeInsets.only(top: Sizes.size24),
                child: Text(
                  todayDate,
                  style: TextStyle(
                      color: Color(0xffF1F1F1).withOpacity(0.9),
                      fontFamily: "Andika",
                      fontWeight: FontWeight.bold,
                      fontSize: Sizes.size16 + Sizes.size1),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.size28, vertical: Sizes.size48 + Sizes.size2),
        child: Column(
          children: [
            Sectiontitle(
              icon: Icons.work,
              text: "Medical Solution & Device Lab",
              iconColor: Color(0xff935E38),
            ),
            Gaps.v8,
            CustomContainer(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Sizes.size28, vertical: Sizes.size12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileAvatar(), // ✅ CircleAvatar 기능이 포함된 새 위젯 사용
                  ],
                ),
              ),
            ),
            Gaps.v28,
            Gaps.v3,
            Sectiontitle(
              icon: Icons.location_on,
              text: "My Workplace",
              iconColor: Color(0xff3F51B5),
            ),
            Gaps.v8,
            CustomContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
            ),
            Gaps.v28,
            Gaps.v3,
            Sectiontitle(
              iconAngle: 30,
              icon: Icons.push_pin,
              text: "Weekly Timeline",
              iconColor: Color(0xffFFB400).withOpacity(0.9),
            ),
            Gaps.v8,
            CustomContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped, // ✅ 변경된 함수 전달
      ),
    );
  }
}
