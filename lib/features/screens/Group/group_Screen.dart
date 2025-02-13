import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msdl/commons/widgets/buttons/customBottomNavigationbar.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/screens/Home/home_Screen.dart';
import 'package:msdl/features/screens/Home/widget/customContainer.dart';
import 'package:msdl/features/screens/Home/widget/sectionTitle.dart';
import 'package:msdl/features/screens/Group/group_Screen.dart';
import 'package:msdl/features/screens/settings/setting_Screen.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final ScrollController _scrollController = ScrollController();
  int selectedIndex = 0;

  void onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GroupScreen(),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Homescreen(),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('yyyy.MM.dd', 'ko_KR').format(DateTime.now());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff151515).withOpacity(0.98),
          elevation: 0,
          title: Padding(
            padding: EdgeInsets.only(
              left: Sizes.size72 + Sizes.size24,
              top: Sizes.size1,
            ),
            child: Row(
              children: [
                Text(
                  "Group",
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
        body: Scrollbar(
          controller: _scrollController,
          thumbVisibility: false,
          thickness: 3.0.w,
          radius: Radius.circular(100),
          trackVisibility: false,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ✅ [수정] 첫 번째 컨테이너 (왼쪽 위에 Sectiontitle 배치 + 컨테이너 중앙 정렬)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: Sizes.size36,
                            bottom: Sizes.size4,
                          ),
                          child: Sectiontitle(
                            icon: Icons.school,
                            text: "Professor",
                            iconColor: Color(0xFFF59E0B), // 주황색
                          ),
                        ),
                      ),
                      Center(
                        child: CustomContainer(
                          height: 170.h,
                          width: 340.w,
                          child: Scrollbar(
                            thumbVisibility: false,
                            trackVisibility: false,
                            thickness: 2.0.w,
                            radius: Radius.circular(6),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.all(Sizes.size8),
                                child: Column(
                                  children: [
                                    groupContainerText(),
                                    groupContainerText(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ...List.generate(
                  3,
                  (index) {
                    List<Map<String, dynamic>> sectionData = [
                      {
                        "icon": Icons.library_books_outlined,
                        "text": "Ph.D Student",
                        "color": Color(0xFF31B454),
                      },
                      {
                        "icon": Icons.school_outlined,
                        "text": "MS Student",
                        "color": Color(0xFF935E38),
                      },
                      {
                        "icon": Icons.auto_stories_outlined,
                        "text": "BS Student",
                        "color": Color(0xFF3F51B5),
                      },
                    ];

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: Sizes.size36,
                                bottom: Sizes.size4,
                              ),
                              child: Sectiontitle(
                                icon: sectionData[index]["icon"],
                                text: sectionData[index]["text"],
                                iconColor: sectionData[index]["color"],
                              ),
                            ),
                          ),
                          Center(
                            child: CustomContainer(
                              height: 170.h,
                              width: 340.w,
                              child: Scrollbar(
                                thumbVisibility: false,
                                thickness: 2.0.w,
                                radius: Radius.circular(6),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.all(Sizes.size8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        groupContainerText(),
                                        groupContainerText(),
                                        groupContainerText(),
                                        groupContainerText(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: selectedIndex,
          onItemTapped: onItemTapped,
        ),
      ),
    );
  }

  Column groupContainerText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(Icons.account_circle, color: Colors.white, size: Sizes.size40),
            SizedBox(width: Sizes.size8),
            Text(
              "민세동",
              style: TextStyle(
                color: Color(0xffF1F1F1),
                fontFamily: "Andika",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Spacer(),
            Text(
              "In : 09:00 | Out : 17:00",
              style: TextStyle(
                color: Color(0xffF1F1F1),
                fontFamily: "Andika",
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
        SizedBox(height: Sizes.size8),
      ],
    );
  }
}
