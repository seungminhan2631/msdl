import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart' hide initializeDateFormatting;
import 'package:intl/intl.dart';
import 'package:msdl/data/database_helper.dart';
import 'package:msdl/data/dbPrint.dart';
import 'package:msdl/dbReset.dart';
import 'package:msdl/features/screens/Home/home_Screen.dart';
import 'package:msdl/features/screens/Home/viewModel/home_viewModel.dart';
import 'package:msdl/features/screens/Home/widget/screenWidget/WeeklyTimelineSection.dart';
import 'package:msdl/features/screens/authentication/choose_role_Screen.dart';
import 'package:msdl/features/screens/Group/group_Screen.dart';
import 'package:msdl/features/screens/authentication/name_Screen.dart';
import 'package:msdl/features/screens/authentication/signUp_Screen.dart';
import 'package:msdl/features/screens/authentication/login_Screen.dart';
import 'package:msdl/features/screens/authentication/viewModel/viewModel.dart';
import 'package:msdl/features/screens/Group/viewModel/viewModel.dart';
import 'package:msdl/features/screens/settings/edit_password_Screen.dart';
import 'package:msdl/features/screens/settings/edit_your_profile_Screen.dart';
import 'package:msdl/features/screens/settings/setting_Screen.dart';
import 'package:msdl/features/screens/workplace/workplace_Screen.dart';
import 'package:msdl/msdl_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR');

  try {} catch (e) {}
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(
            create: (context) => GroupViewModel()), // ✅ 중복 등록 제거
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
      ],
      child: const msdl(),
    ),
  );
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
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            scaffoldBackgroundColor: Color(0xFF151515).withOpacity(0.98),
          ),
          initialRoute: "/",
          routes: {
            "/": (context) => Weeklytimelinesection(),
            "/chooseRole_Screen": (context) => ChooseRoleScreen(), // 직책 선택
            "/nameScreen": (context) => NameScreen(), // 이름 설정정
            "/createAccount_Screen": (context) => SignupScreen(), // 회원가입
            "/SignupScreen": (context) => SignupScreen(), // 회원가입
            "/settingsScreen": (context) => SettingsScreen(), // 설정
            "/homeScreen": (context) => Homescreen(), // 홈
            "/workplaceScreen": (context) => WorkplaceScreen(), // 구글맵
            "/groupScreen": (context) => GroupScreen(), // 그룹
            "/editYourProfileScreen": (context) =>
                EditYourProfileScreen(), // 사진, 이름, 비밀번호, 직책 설정
            "/editPasswordScreen": (context) => EditPasswordScreen(), // 비밀번호 변경
          },
        );
      },
    );
  }
}
