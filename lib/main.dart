import 'package:flutter/material.dart';
import 'package:msdl/features/screens/authentication/choose_role.dart';
import 'package:msdl/msdl_theme.dart';

void main() {
  runApp(const msdl());
}

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
