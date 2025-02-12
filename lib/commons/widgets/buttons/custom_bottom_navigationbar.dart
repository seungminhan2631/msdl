import 'package:flutter/material.dart';
import 'package:msdl/features/screens/Home/homeScreen.dart';
import 'package:msdl/features/screens/authentication/group_Screen.dart';
import 'package:msdl/features/screens/settings/setting_Screen.dart';

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
    return BottomNavigationBar(
      backgroundColor: Color(0xFF2C2C2C), // 배경색 설정
      selectedItemColor: Color(0xFFCACACA), // 선택된 아이콘 색상
      unselectedItemColor: Color(0xFFCACACA).withOpacity(0.2), // 선택되지 않은 아이콘 색상
      currentIndex: selectedIndex, // 현재 선택된 인덱스
      onTap: onItemTapped, // 탭 클릭 시 호출되는 함수
      showSelectedLabels: false, // ✅ 선택된 항목의 라벨 숨기기
      showUnselectedLabels: false, // ✅ 선택되지 않은 항목의 라벨 숨기기
      iconSize: 40, // ✅ 아이콘 크기 최적화
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 0), // ✅ 아이콘과 바텀 네비게이션 간격 줄임
            child: Icon(Icons.people_alt_outlined),
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 0), // ✅ 아이콘과 바텀 네비게이션 간격 줄임
            child: Icon(Icons.home_outlined),
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 0), // ✅ 아이콘과 바텀 네비게이션 간격 줄임
            child: Icon(Icons.settings_outlined),
          ),
          label: "",
        ),
      ],
    );
  }
}
