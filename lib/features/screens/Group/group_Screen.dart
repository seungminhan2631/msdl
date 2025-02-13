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
import 'package:msdl/features/screens/group/viewModel/viewModel.dart';
import 'package:msdl/features/screens/settings/setting_Screen.dart';
import 'package:provider/provider.dart';
import 'package:msdl/features/screens/group/model/model.dart'; // GroupModel 추가

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

List<Map<String, dynamic>> sectionData = [
  {
    "icon": Icons.school,
    "text": "Professor ",
    "color": Color(0xFFF59E0B),
  },
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

class _GroupScreenState extends State<GroupScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      String route = index == 0
          ? "/groupScreen"
          : index == 1
              ? "/homeScreen"
              : "/settingsScreen";

      Navigator.pushReplacementNamed(context, route);
    }
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('yyyy.MM.dd').format(DateTime.now());
    final Map<String, List<GroupModel>> groupData =
        Provider.of<GroupViewModel>(context).groupedUsers;

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
                Padding(
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
                            icon: sectionData[_selectedIndex]["icon"],
                            text: sectionData[_selectedIndex]["text"],
                            iconColor: sectionData[_selectedIndex]["color"],
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: (groupData[
                                              sectionData[_selectedIndex]
                                                  ["text"]] ??
                                          [])
                                      .map((user) => groupContainerText(user))
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
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
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }

  Column groupContainerText(GroupModel user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(Icons.account_circle, color: Colors.white, size: Sizes.size40),
            SizedBox(width: Sizes.size8),
            Text(
              user.name,
              style: TextStyle(
                color: Color(0xffF1F1F1),
                fontFamily: "Andika",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Spacer(),
            Text(
              "In: ${user.checkInTime} | Out: ${user.checkOutTime}",
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
