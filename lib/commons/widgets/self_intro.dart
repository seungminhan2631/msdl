import 'package:flutter/material.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/msdl_theme.dart';

class SelfIntro extends StatelessWidget {
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? opacity; // 🔹 추가: 사용자가 투명도 설정 가능
  final TextStyle? labelMedium = msdlTheme.primaryTextTheme.labelMedium;

  SelfIntro({
    super.key,
    this.fontSize,
    this.fontWeight,
    this.opacity, // 🔹 사용자가 직접 설정할 수 있음
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "Medical Solution & Device Lab",
      style: labelMedium?.copyWith(
        //??로직은 짧게말하면, C= A??B 를 예를들면, C값=  초기값은 B, A로 설정한다면 C값은 A
        fontSize: (fontSize ?? 20).w,
        fontWeight: fontWeight ?? FontWeight.w700,
        color: labelMedium?.color?.withOpacity(opacity ?? 1.0),
      ),
    );
  }
}
