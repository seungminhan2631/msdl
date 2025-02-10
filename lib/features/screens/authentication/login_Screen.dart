import 'package:flutter/material.dart';
import 'package:msdl/msdl_theme.dart';

class login_Screen extends StatelessWidget {
  login_Screen({super.key});
  static const routeName = 'logIn';
  static const routeUrl = '/';
  final TextStyle? headlineStyle = msdlTheme.textTheme.headlineLarge;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            "Log In",
            style: headlineStyle,
          )
        ],
      ),
    );
  }
}
