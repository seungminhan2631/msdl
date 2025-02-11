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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 200.0),
          child: Column(
            children: [
              Text(
                "Log In",
                style: headlineStyle!.copyWith(fontSize: 40),
              )
            ],
          ),
        ),
      ),
    );
  }
}
