import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msdl/commons/widgets/buttons/customBottomNavigationbar.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/screens/Group/repository/repository.dart';
import 'package:msdl/features/screens/Home/viewModel/home_viewModel.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<GroupViewModel>().fetchGroupData());
    _resetAttendanceIfNeeded();
  }

  void _resetAttendanceIfNeeded() {
    DateTime now = DateTime.now();
    if (now.hour == 0 && now.minute == 0) {
      GroupRepository().resetAttendance();
    }
  }

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

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('yyyy.MM').format(DateTime.now());
    final groupData = context.watch<GroupViewModel>().groupedUsers;

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
        body: groupData.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Scrollbar(
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
                              icon: role.icon,
                              text: role.displayName,
                              iconColor: role.color,
                            ),
                            Gaps.v5,
                            CustomContainer(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: groupData[role]?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final user = groupData[role]![index];
                                  return ListTile(
                                    dense: true, // ✅ 패딩 최소화

                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: Sizes.size20),
                                    visualDensity: VisualDensity(vertical: -4),
                                    leading: Icon(
                                      role.icon,
                                      color: role.color,
                                      size: Sizes.size28,
                                    ),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            user.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "Andika",
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    Sizes.size14 + Sizes.size4),
                                          ),
                                        ),
                                      ],
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
                                      "In: ${user.checkInTime.substring(0, 5)} | Out: ${user.checkOutTime.substring(0, 5)}",
                                      style: TextStyle(
                                          fontFamily: "Andika",
                                          color: Color(0xffF1F1F1),
                                          fontSize: Sizes.size12),
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
}
