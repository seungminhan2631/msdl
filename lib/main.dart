import 'package:flutter/material.dart';
import 'package:msdl/features/screens/authentication/login_Screen.dart';
import 'package:msdl/msdl_theme.dart';

void main() {
  runApp(const msdl());
}

//한승민 바보
class msdl extends StatelessWidget {
  const msdl({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: Color(0xFF151515).withOpacity(0.98),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => login_Screen(),
      },
    );
  }
}
