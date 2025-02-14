import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msdl/commons/widgets/buttons/customBottomNavigationbar.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/screens/group/model/model.dart';
import 'package:msdl/features/screens/Home/widget/customContainer.dart';
import 'package:msdl/features/screens/Home/widget/sectionTitle.dart';
import 'package:msdl/features/screens/group/viewModel/viewModel.dart';
import 'package:provider/provider.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

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
    final Map<Role, List<GroupModel>> groupData =
        Provider.of<GroupViewModel>(context).groupedUsers;

    print("📌 UI에서 groupData 상태: $groupData");

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
            padding: EdgeInsets.symmetric(vertical: Sizes.size1),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Sizes.size18, horizontal: Sizes.size28),
              child: Column(
                children: Role.values.map((role) {
                  return Column(
                    children: [
                      Sectiontitle(
                        icon: role.icon, // 🔥 역할에 맞는 아이콘 적용
                        text: role.displayName, // 🔥 역할에 맞는 텍스트 적용
                        iconColor: role.color,
                      ),
                      Gaps.v5,
                      CustomContainer(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: groupData[role]?.length ?? 0,
                          itemBuilder: (context, index) {
                            final user = groupData[role]![index];
                            return ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: Sizes.size20),
                              visualDensity: VisualDensity(vertical: -4),
                              leading: Icon(
                                role.icon,
                                color: role.color,
                                size: Sizes.size28,
                              ),
                              title: Text(
                                user.name,
                                style: TextStyle(
                                    fontFamily: "Andika",
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Sizes.size18),
                              ),
                              subtitle: Text(
                                user.category,
                                style: TextStyle(
                                    fontFamily: "Andika",
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Sizes.size12),
                              ),
                              trailing: Text(
                                "In: ${user.checkInTime} | Out: ${user.checkOutTime}",
                                style: TextStyle(
                                    fontFamily: "Andika",
                                    color: Color(0xffF1F1F1),
                                    fontSize: Sizes.size14),
                              ),
                            );
                          },
                        ),
                      ),
                      Gaps.v12,
                    ],
                  );
                }).toList(),
              ),
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
            Gaps.h8,
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
      ],
    );
  }
}
