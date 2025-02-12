import 'package:flutter/material.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/msdl_theme.dart';

class TopTitle extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? opacity;
  final TextStyle? headlineLarge = msdlTheme.primaryTextTheme.headlineLarge;

  TopTitle({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: headlineLarge?.copyWith(
        //??로직은 짧게말하면, C= A??B 를 예를들면, C값=  초기값은 B, A로 설정한다면 C값은 A
        fontSize: (fontSize ?? 40).w,
        fontFamily: "Andika",
        fontWeight: fontWeight ?? FontWeight.bold,
        color: headlineLarge?.color?.withOpacity(opacity ?? 1.0),
      ),
    );
  }
}
