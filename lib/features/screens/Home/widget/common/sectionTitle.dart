import 'package:flutter/material.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';

class Sectiontitle extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final double iconAngle;

  const Sectiontitle({
    super.key,
    required this.icon,
    required this.text,
    required this.iconColor,
    this.iconAngle = 0.0, //  회전 디폴트 0
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Transform.rotate(
          //회전각도 변환식섹스
          angle: iconAngle * (3.1415926535 / 180),
          child: Icon(
            icon,
            color: iconColor,
            size: Sizes.size24,
          ),
        ),
        Gaps.h8,
        Text(
          text,
          style: TextStyle(
            fontSize: Sizes.size20,
            fontFamily: "Andika",
            fontWeight: FontWeight.bold,
            color: Color(0xffF1F1F1),
          ),
        ),
      ],
    );
  }
}
