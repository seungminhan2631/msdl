import 'package:flutter/material.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/msdl_theme.dart';

class TopTitle extends StatelessWidget {
  final String title;
  final TextStyle? headlineLarge = msdlTheme.primaryTextTheme.headlineLarge;

  TopTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: headlineLarge?.copyWith(
        fontSize: Sizes.size40,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
