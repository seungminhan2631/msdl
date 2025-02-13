import 'package:flutter/material.dart';
import 'package:msdl/features/screens/Home/home_Screen.dart';
import 'package:msdl/features/screens/authentication/choose_role_Screen.dart';
import 'package:msdl/features/screens/Group/group_Screen.dart';
import 'package:msdl/features/screens/authentication/signUp_Screen.dart';
import 'package:msdl/features/screens/authentication/login_Screen.dart';
import 'package:msdl/features/screens/settings/setting_Screen.dart';
import 'package:msdl/msdl_theme.dart';
import 'package:intl/date_symbol_data_local.dart'; // ✅ 날짜 포맷 데이터 초기화 패키지

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Flutter 엔진 초기화 (비동기 코드 사용 가능)
  await initializeDateFormatting('ko_KR', null); // ✅ 대한민국 날짜 포맷 초기화
  runApp(msdl());
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
            splashFactory: NoSplash.splashFactory, // ✅ 잔물결 효과 제거
            highlightColor: Colors.transparent, // ✅ 클릭 시 강조 효과 제거
            scaffoldBackgroundColor: Color(0xFF151515).withOpacity(0.98),
          ),
          initialRoute: "/",
          routes: {
            "/": (context) => Homescreen(),
            "/chooseRole_Screen": (context) => ChooseRoleScreen(),
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
