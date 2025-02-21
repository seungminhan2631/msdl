import 'package:flutter/material.dart';
import 'package:msdl/constants/size_config.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped; // ✅ 콜백 추가

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped, // ✅ 콜백 추가
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF2C2C2C),
          border: Border(
            top: BorderSide(
              color: Color(0xFFCACACA),
              width: 2.0.w,
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
          currentIndex: selectedIndex,
          onTap: onItemTapped, // ✅ 콜백 호출
          backgroundColor: Colors.transparent,
          selectedItemColor: Color(0xFFCACACA),
          unselectedItemColor: Color(0xFFCACACA).withOpacity(0.2),
          iconSize: 40,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                selectedIndex == 0
                    ? Icons.people_alt
                    : Icons.people_alt_outlined,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                selectedIndex == 1 ? Icons.home : Icons.home_outlined,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                selectedIndex == 2 ? Icons.settings : Icons.settings_outlined,
              ),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}
