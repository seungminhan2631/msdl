import 'package:flutter/material.dart';
import 'package:msdl/features/screens/Home/homeScreen.dart';
import 'package:msdl/features/screens/authentication/choose_role.dart';
import 'package:msdl/features/screens/authentication/signUp_Screen.dart';
import 'package:msdl/features/screens/authentication/login_Screen.dart';
import 'package:msdl/features/screens/settings/setting_Screen.dart';
import 'package:msdl/msdl_theme.dart';

void main() {
  runApp(const msdl());
}

class msdl extends StatelessWidget {
  const msdl({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // MediaQuery에 따른 반응형 UI
      builder: (context, constraints) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
            scaffoldBackgroundColor: Color(0xFF151515).withOpacity(0.98),
          ),
          initialRoute: "/",
          routes: {
            "/": (context) => SettingsScreen(),
            "/chooseRole_Screen": (context) => ChooseRole(),
            "/createAccount_Screen": (context) => SignupScreen(),
            "/SignupScreen": (context) => SignupScreen(),
            "/SettingsScreen": (context) => SettingsScreen(),
            "/homeScreen": (context) => Homescreen(),
          },
        );
      },
    );
  }
}
