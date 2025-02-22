import 'dart:async';

import 'package:flutter/material.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:intl/intl.dart';
import 'package:msdl/features/screens/Home/model/home_model.dart';
import 'package:msdl/features/screens/Home/viewModel/home_viewModel.dart';
import 'package:msdl/features/screens/Home/widget/customContainer.dart';
import 'package:msdl/features/screens/Home/widget/profileAvatar.dart';
import 'package:msdl/features/screens/Home/widget/sectionTitle.dart';
import 'package:msdl/commons/widgets/buttons/customBottomNavigationbar.dart';
import 'package:msdl/features/screens/Group/group_Screen.dart';
import 'package:msdl/features/screens/authentication/viewModel/viewModel.dart';
import 'package:msdl/features/screens/settings/setting_Screen.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 1;
  Timer? _midnightTimer;
  Timer? _timer;
  Duration _workDuration = Duration.zero;

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

    _midnightTimer?.cancel(); // 🔥 기존 타이머 해제 (중복 실행 방지)
    _midnightTimer = Timer(timeUntilMidnight, () {
      setState(() {
        _workDuration = Duration.zero; // ✅ 근무시간 리셋
        final homeViewModel =
            Provider.of<HomeViewModel>(context, listen: false);
        homeViewModel.resetAttendance(); // ✅ 출근/퇴근 시간 초기화
      });
      _scheduleMidnightReset(); // 🔥 다음날 00:00을 다시 예약
    });
  }

  void _loadUserData() async {
    final userId = Provider.of<AuthViewModel>(context, listen: false).userId;
    if (userId != null) {
      await Provider.of<HomeViewModel>(context, listen: false)
          .fetchHomeData(context);
      setState(() {});
    } else {
      print("❌ 로그인된 사용자 ID 없음!");
    }
  }

  void _handleClockInOut() {
    final homeData =
        Provider.of<HomeViewModel>(context, listen: false).homeData;

    if (homeData?.checkInTime == "--:--") {
      // 출근 처리
      Provider.of<HomeViewModel>(context, listen: false)
          .toggleAttendance(context);
    } else if (homeData?.checkOutTime == "--:--") {
      // 퇴근 처리
      Provider.of<HomeViewModel>(context, listen: false)
          .toggleAttendance(context);
    } else {
      // 이미 퇴근한 상태일 경우, 덮어쓰기를 확인하는 다이얼로그 띄우기
      _showEndOfDayDialog();
    }

    setState(() {});
  }

  void _showEndOfDayDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("오늘은 하루가 끝났습니다."),
        content: Text("오늘은 더 이상 출근할 수 없습니다."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
            },
            child: Text("확인"),
          ),
        ],
      ),
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        final homeData =
            Provider.of<HomeViewModel>(context, listen: false).homeData;
        if (homeData?.isCheckedIn == true && homeData?.checkInTime != "--:--") {
          DateTime checkInDateTime =
              DateFormat('HH:mm:ss').parse(homeData!.checkInTime);
          _workDuration = DateTime.now().difference(DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            checkInDateTime.hour,
            checkInDateTime.minute,
            checkInDateTime.second,
          ));
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _workDuration = Duration.zero;
  }

  String getStatusText(HomeModel? homeData) {
    String todayDate = DateFormat('M월 d일 E요일', 'ko_KR').format(DateTime.now());

    if (homeData?.checkInTime == "--:--") {
      return "오늘은 $todayDate"; // 출근 전
    } else if (homeData?.checkOutTime == "--:--") {
      return "근무중 ${_formatDuration(_workDuration)}"; // 근무 중 (타이머)
    } else {
      return "퇴근완료 ${homeData!.checkOutTime.substring(0, 5)}"; // 퇴근 완료 (퇴근 시간 표시 - 시:분)
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inHours)}:"
        "${twoDigits(duration.inMinutes.remainder(60))}:"
        "${twoDigits(duration.inSeconds.remainder(60))}";
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
    _timer?.cancel();
    _midnightTimer?.cancel(); // ✅ 메모리 누수 방지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('yyyy.MM.dd').format(DateTime.now());
    final homeData = Provider.of<HomeViewModel>(context).homeData;
    final userId = Provider.of<AuthViewModel>(context).userId;

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
            horizontal: Sizes.size28, vertical: Sizes.size36),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Sectiontitle(
              icon: Icons.work,
              text: "Medical Solution & Device Lab",
              iconColor: Color(0xff935E38),
            ),
            Gaps.v14,
            CustomContainer(
              child: Stack(
                children: [
                  Positioned(
                    left: Sizes.size20,
                    top: Sizes.size20,
                    child: Text(
                      getStatusText(homeData),
                      style: TextStyle(
                        fontFamily: 'Andika',
                        fontSize: Sizes.size16 + Sizes.size1,
                        color: Color(0xffF1F1F1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    left: Sizes.size32,
                    top: Sizes.size60,
                    child: ProfileAvatar(),
                  ),
                  Positioned(
                    left: Sizes.size96 + Sizes.size20, // 🔥 프로필 아이콘 오른쪽에 배치
                    top: Sizes.size60,
                    child: Text(
                      homeData?.name ?? "name...",
                      style: TextStyle(
                        fontFamily: 'Andika',
                        fontSize: Sizes.size20,
                        color: Color(0xffF1F1F1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    left: Sizes.size96 + Sizes.size96,
                    top: Sizes.size11 + Sizes.size1,
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: _handleClockInOut,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: homeData?.checkInTime == "--:--"
                                ? Color(0xff2C2C2C) // 출근 상태
                                : Color(0xffDE4141), // 퇴근 상태
                            minimumSize: Size(60.w, 32.h),
                          ),
                          child: Text(
                            homeData?.checkInTime == "--:--"
                                ? "Clock In"
                                : "Clock Out",
                            style: TextStyle(
                              fontSize: Sizes.size16,
                              color: Color.fromARGB(255, 0, 89, 173),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gaps.v24,
            Sectiontitle(
              icon: Icons.location_on,
              text: "My Workplace",
              iconColor: Color(0xff3F51B5),
            ),
            Gaps.v8,
            CustomContainer(
              child: Column(),
            ),
            Gaps.v24,
            Sectiontitle(
              iconAngle: 30,
              icon: Icons.push_pin,
              text: "Weekly Timeline",
              iconColor: Color(0xffFFB400).withOpacity(0.9),
            ),
            Gaps.v8,
            CustomContainer(
              child: Column(),
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
