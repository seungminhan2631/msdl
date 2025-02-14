import 'package:flutter/material.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:intl/intl.dart';
import 'package:msdl/features/screens/Home/viewModel/home_viewModel.dart';
import 'package:msdl/features/screens/Home/widget/customContainer.dart';
import 'package:msdl/features/screens/Home/widget/profileAvatar.dart';
import 'package:msdl/features/screens/Home/widget/sectionTitle.dart';
import 'package:msdl/commons/widgets/buttons/customBottomNavigationbar.dart';
import 'package:msdl/features/screens/Group/group_Screen.dart';
import 'package:msdl/features/screens/settings/setting_Screen.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 1; // 홈 화면에서 시작
  @override
  void initState() {
    super.initState();
    Provider.of<HomeViewModel>(context, listen: false)
        .fetchHomeData(1); // 🔥 userId=1 기준
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
    String todayDate = DateFormat('yyyy.MM.dd').format(DateTime.now());
    final homeData = Provider.of<HomeViewModel>(context).homeData;

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
              child: Stack(
                clipBehavior: Clip.none, // 🔥 Stack 바깥으로 위젯이 나올 수 있도록 허용
                children: [
                  Positioned(
                    left: Sizes.size20,
                    top: Sizes.size36,
                    child: ProfileAvatar(), // 🔥 CircleAvatar 포함된 위젯
                  ),
                  Positioned(
                    left: Sizes.size96, // 🔥 프로필 아이콘 오른쪽에 배치

                    top: Sizes.size32,
                    child: Text(
                      homeData?.role ?? "Loading...",
                      style: TextStyle(
                        fontFamily: 'Andika',
                        fontSize: Sizes.size16 + Sizes.size1,
                        color: Color(0xffF1F1F1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    left: Sizes.size96 + Sizes.size10, // 🔥 프로필 아이콘 오른쪽에 배치
                    top: Sizes.size60,
                    child: Text(
                      homeData?.name ?? "Loading...",
                      style: TextStyle(
                        fontFamily: 'Andika',
                        fontSize: Sizes.size20,
                        color: Color(0xffF1F1F1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    left: Sizes.size96 + Sizes.size96 + Sizes.size8,
                    top: Sizes.size36 + Sizes.size1,
                    child: ElevatedButton(
                      onPressed: () {
                        print("Clock In 버튼 클릭됨");
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(117, 60),
                        backgroundColor: Color(0xff00D26A),
                        foregroundColor: Color(0xffCF3B28),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.red, width: 3),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text(
                        homeData?.isCheckedIn ?? false
                            ? "Clock Out"
                            : "Clock In",
                        style: TextStyle(
                            color: Color(0xff2C2C2C),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gaps.v16,
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
                children: homeData?.workLocation != null
                    ? [
                        Text(homeData!.workLocation,
                            style: TextStyle(color: Colors.white)),
                      ]
                    : [
                        Text("No workplace assigned",
                            style: TextStyle(color: Colors.white))
                      ],
              ),
            ),
            Gaps.v16,
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
                children: homeData?.weeklyTimeline.isNotEmpty ?? false
                    ? homeData!.weeklyTimeline.map((entry) {
                        return ListTile(
                          title: Text(entry["date"],
                              style: TextStyle(color: Colors.white)),
                          trailing: Icon(
                              entry["status"] == "Checked In"
                                  ? Icons.check
                                  : Icons.close,
                              color: Colors.green),
                        );
                      }).toList()
                    : [
                        Text("No weekly attendance data",
                            style: TextStyle(color: Colors.white))
                      ],
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
