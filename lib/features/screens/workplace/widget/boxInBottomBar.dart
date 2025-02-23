import 'package:flutter/material.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/sizes.dart';

class BoxInBottomBar extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onPressed; // ✅ 버튼 클릭 시 실행할 함수 추가

  const BoxInBottomBar({
    required this.text,
    required this.icon,
    required this.iconColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // ✅ 터치 이벤트 감지
      child: Container(
        width: Sizes.size80 + Sizes.size5,
        height: Sizes.size80 + Sizes.size20,
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(5),
          border:
              Border.all(color: const Color(0xFFAAAAAA), width: Sizes.size1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor),
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
