import 'package:flutter/material.dart';
import 'package:msdl/constants/sizes.dart';

class TopTitle extends StatelessWidget {
  final String title;
  final TextStyle? headlineLarge;

  const TopTitle({
    super.key,
    required this.title,
    this.headlineLarge,
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
