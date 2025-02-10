import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/toptitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/msdl_theme.dart';

class ChooseRole extends StatelessWidget {
  static const routeName = 'ChooseRole';
  static const routeUrl = '/';

  ChooseRole({super.key});

  final TextStyle? headlineLarge = msdlTheme.primaryTextTheme.headlineLarge;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 102,
          ),
          child: Column(
            children: [
              TopTitle(
                title: "Msdl",
              ),
              Gaps.v44,
              Text(
                "Choose Your Academic Role",
                style: headlineLarge?.copyWith(
                  fontSize: Sizes.size24 + Sizes.size4,
                  fontWeight: FontWeight.w600,
                ),
              ),
              CheckboxListTile(
                value: false,
                onChanged: _check,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
