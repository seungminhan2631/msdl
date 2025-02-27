import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/Home/model/home_model.dart';
import 'package:msdl/features/Home/viewModel/home_viewModel.dart';
import 'package:msdl/features/Home/viewModel/workplace_viewModel.dart';
import 'package:msdl/features/Home/widget/common/customContainer.dart';
import 'package:msdl/features/Home/widget/common/sectionTitle.dart';
import 'package:msdl/features/Home/widget/screenWidget/ProfileSection.dart';
import 'package:msdl/commons/widgets/buttons/customBottomNavigationbar.dart';
import 'package:msdl/features/Home/widget/screenWidget/WeeklyTimelineSection.dart';
import 'package:msdl/features/Home/widget/screenWidget/WorkplaceSection.dart';
import 'package:msdl/features/authentication/viewModel/viewModel.dart';
import 'package:msdl/features/workplace/screens/workplace_Screen.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 1;
  Timer? _midnightTimer;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _scheduleMidnightReset();
  }

  void _scheduleMidnightReset() {
    DateTime now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
    Duration timeUntilMidnight = midnight.difference(now);

    _midnightTimer?.cancel();
    _midnightTimer = Timer(timeUntilMidnight, () {
      final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      homeViewModel.resetAttendance();
      _scheduleMidnightReset(); // 🔥 다음날 00:00을 다시 예약
    });
  }

  void _loadUserData() async {
    final userId = Provider.of<AuthViewModel>(context, listen: false).userId;
    if (userId != null) {
      await Provider.of<HomeViewModel>(context, listen: false)
          .fetchHomeData(context);
    } else {
      print("❌ 로그인된 사용자 ID 없음!");
    }
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
  void dispose() {
    _midnightTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeData = Provider.of<HomeViewModel>(context).homeData;
    String todayDate = DateFormat('yyyy.MM.dd').format(DateTime.now());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff151515).withOpacity(0.98),
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(left: Sizes.size32 + Sizes.size24),
          child: Row(
            children: [
              Text(
                "Today",
                style: TextStyle(
                  color: Color(0xffF1F1F1),
                  fontFamily: "Andika",
                  fontWeight: FontWeight.bold,
                  fontSize: Sizes.size40,
                ),
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
                    fontSize: Sizes.size16 + Sizes.size1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.size28, vertical: Sizes.size36),
          child: Column(
            children: [
              Sectiontitle(
                icon: Icons.work,
                text: "Medical Solution & Device Lab",
                iconColor: Color(0xff935E38),
              ),
              Gaps.v8,
              ProfileSection(homeData: homeData),
              Gaps.v32,
              WorkplaceSection(),
              Gaps.v32,
              Sectiontitle(
                iconAngle: 30,
                icon: Icons.push_pin,
                text: "Weekly Timeline",
                iconColor: Color(0xffFFB400).withOpacity(0.9),
              ),
              Gaps.v8,
              CustomContainer(
                child: Column(
                  children: [
                    Expanded(
                      child: Weeklytimelinesection(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped, // ✅ 변경된 함수 전달
      ),
    );
  }
}
