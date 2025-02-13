import 'package:flutter/material.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2C2C2C), // 배경색 설정
        border: Border(
          top: BorderSide(
            color: Color(0xFFCACACA), // ✅ 테두리 색상 설정
            width: 2.0, // ✅ 테두리 두께 설정
          ),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        enableFeedback: false,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: selectedIndex, // 현재 선택된 인덱스
        onTap: onItemTapped, // 탭 클릭 시 호출되는 함수
        backgroundColor: Colors.transparent, // ✅ 투명 처리 (Container의 배경 유지)
        selectedItemColor: Color(0xFFCACACA), // 선택된 아이콘 색상
        unselectedItemColor:
            Color(0xFFCACACA).withOpacity(0.2), // 선택되지 않은 아이콘 색상
        iconSize: 40, // ✅ 아이콘 크기 최적화
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: Icon(
                selectedIndex == 0
                    ? Icons.people_alt // ✅ 선택된 경우 (채워진 아이콘)
                    : Icons.people_alt_outlined, // ✅ 선택되지 않은 경우 (Outlined 아이콘)
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: Icon(
                selectedIndex == 1
                    ? Icons.home // ✅ 선택된 경우 (채워진 아이콘)
                    : Icons.home_outlined, // ✅ 선택되지 않은 경우 (Outlined 아이콘)
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: Icon(
                selectedIndex == 2
                    ? Icons.settings // ✅ 선택된 경우 (채워진 아이콘)
                    : Icons.settings_outlined, // ✅ 선택되지 않은 경우 (Outlined 아이콘)
              ),
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
