import 'package:flutter/material.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false, // 불필요한 여백 방지
      child: Material(
        elevation: 0, // 그림자 제거
        color: Colors.transparent,
        child: Container(
          height: 60.h, // 바텀 바의 고정 높이 설정
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0xFFCACACA),
                width: 1.0.w,
              ),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Sizes.size2),
              topRight: Radius.circular(Sizes.size2),
            ),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            enableFeedback: false,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: selectedIndex,
            onTap: onItemTapped,
            backgroundColor: Color(0xFF2C2C2C), // Container의 배경색 제거 후 직접 설정
            selectedItemColor: Color(0xFFCACACA),
            unselectedItemColor: Color(0xFFCACACA).withOpacity(0.2),
            items: [
              BottomNavigationBarItem(
                icon: SizedBox(
                  height: 19.h, // 아이콘의 고정 높이
                  child: Icon(
                    size: Sizes.size36,
                    selectedIndex == 0
                        ? Icons.people_alt
                        : Icons.people_alt_outlined,
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: SizedBox(
                  height: 19.h, // 아이콘의 고정 높이
                  child: Icon(
                    size: Sizes.size36,
                    selectedIndex == 1 ? Icons.home : Icons.home_outlined,
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: SizedBox(
                  height: 19.h, // 아이콘의 고정 높이
                  child: Icon(
                    size: Sizes.size36,
                    selectedIndex == 2
                        ? Icons.settings
                        : Icons.settings_outlined,
                  ),
                ),
                label: "1212",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
