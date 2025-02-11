import 'package:flutter/material.dart';
import 'package:msdl/msdl_theme.dart';

class TopTitle extends StatelessWidget {
  final String title;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? headlineLarge = msdlTheme.primaryTextTheme.headlineLarge;

  TopTitle({
    super.key,
    required this.title,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: headlineLarge?.copyWith(
        fontSize: fontSize ??
            40, //font사이즈가 null, 즉 지정해주지 않는다면 기본 값40, else : fontSize==fontSize
        fontWeight: fontWeight ?? FontWeight.w700, //위와 같은 로직
      ),
    );
  }
}
