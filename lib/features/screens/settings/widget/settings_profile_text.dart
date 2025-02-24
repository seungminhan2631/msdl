// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:msdl/constants/sizes.dart';

class SettingsProfileText extends StatelessWidget {
  final String text;

  const SettingsProfileText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: Sizes.size24,
        fontFamily: "Andika",
        fontWeight: FontWeight.w700,
        color: Color(0xFFF1F1F1),
      ),
    );
  }
}
