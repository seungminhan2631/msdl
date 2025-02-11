import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/toptitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/msdl_theme.dart';

class login_Screen extends StatelessWidget {
  login_Screen({super.key});
  static const routeName = 'logIn';
  static const routeUrl = '/';
  final TextStyle? headlineStyle = msdlTheme.textTheme.headlineLarge;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 180.0),
        child: Column(
          children: [
            TopTitle(
              title: "Log In",
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
            Gaps.v12,
            TopTitle(
              title: "No account?",
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }
}
