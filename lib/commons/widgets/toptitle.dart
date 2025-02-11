import 'package:flutter/material.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/msdl_theme.dart';

class TopTitle extends StatelessWidget {
  final String title;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? opacity; // 🔹 추가: 사용자가 투명도 설정 가능
  final TextStyle? headlineLarge = msdlTheme.primaryTextTheme.headlineLarge;

  TopTitle({
    super.key,
    required this.title,
    this.fontSize,
    this.fontWeight,
    this.opacity, // 🔹 사용자가 직접 설정할 수 있음
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: headlineLarge?.copyWith(
        //??로직은 짧게말하면, C= A??B 를 예를들면, C값=  초기값은 B, A로 설정한다면 C값은 A
        fontSize: (fontSize ?? 40).w,
        fontWeight: fontWeight ?? FontWeight.bold,
        color: headlineLarge?.color?.withOpacity(opacity ?? 1.0),
      ),
    );
  }
}
