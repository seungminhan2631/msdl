// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/msdl_theme.dart';

class SettingsBodyText extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? textColor;
  final TextStyle? headlineLarge = msdlTheme.primaryTextTheme.headlineLarge;

  SettingsBodyText({
    super.key,
    required this.text,
    this.onTap,
    this.textColor,
  });
//qwe
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.size36),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: headlineLarge?.copyWith(
                    fontSize: 32.w,
                    fontWeight: FontWeight.w400,
                    color: textColor ?? headlineLarge?.color,
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white, size: Sizes.size20),
              ],
            ),
          ),
          SizedBox(height: Sizes.size10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.h),
            child: Divider(color: Colors.grey, thickness: 0.7.h),
          ),
        ],
      ),
    );
  }
}
