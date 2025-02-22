import 'package:flutter/material.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';

class BoxInBottomBar extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;

  const BoxInBottomBar({
    required this.text,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      height: 100.h,
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color(0xFFAAAAAA),
          width: 1.w,
        ),
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
                fontSize: Sizes.size14),
          ),
        ],
      ),
    );
  }
}
