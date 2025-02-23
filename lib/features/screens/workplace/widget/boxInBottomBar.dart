import 'package:flutter/material.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/sizes.dart';

class BoxInBottomBar extends StatelessWidget {
  final String text; // 버튼의 텍스트
  final IconData icon; // 버튼 아이콘
  final Color iconColor; // 아이콘 색상
  final VoidCallback? onPressed; // 클릭 이벤트 핸들러
  final bool isSelected; // ✅ 버튼이 선택되었는지 여부

  const BoxInBottomBar({
    required this.text,
    required this.icon,
    required this.iconColor,
    this.onPressed,
    this.isSelected = false, // 기본적으로 선택되지 않음
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        width: Sizes.size80 + Sizes.size5,
        height: Sizes.size80 + Sizes.size20,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFB1384E) : const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const Color(0xFFAAAAAA), // ✅ 테두리 색 변경
            width: Sizes.size1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor), // 아이콘 표시
            Gaps.v5,
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Andika",
                fontWeight: FontWeight.w700,
                fontSize: Sizes.size14 + Sizes.size1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
