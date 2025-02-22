import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart' hide initializeDateFormatting;
import 'package:intl/intl.dart';
import 'package:msdl/data/database_helper.dart';
import 'package:msdl/data/dbPrint.dart';
import 'package:msdl/dbReset.dart';
import 'package:msdl/features/screens/Home/home_Screen.dart';
import 'package:msdl/features/screens/Home/viewModel/home_viewModel.dart';
import 'package:msdl/features/screens/authentication/choose_role_Screen.dart';
import 'package:msdl/features/screens/Group/group_Screen.dart';
import 'package:msdl/features/screens/authentication/name_Screen.dart';
import 'package:msdl/features/screens/authentication/signUp_Screen.dart';
import 'package:msdl/features/screens/authentication/login_Screen.dart';
import 'package:msdl/features/screens/authentication/viewModel/viewModel.dart';
import 'package:msdl/features/screens/group/viewModel/viewModel.dart';
import 'package:msdl/features/screens/settings/edit_password_Screen.dart';
import 'package:msdl/features/screens/settings/edit_your_profile_Screen.dart';
import 'package:msdl/features/screens/settings/setting_Screen.dart';
import 'package:msdl/features/screens/workplace/workplace_Screen.dart';
import 'package:msdl/msdl_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

// import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR');

  // resetDatabase(); //db리셋시 주석 해제
  // printAllTables(); // 테이블의 전체 내용을 보고싶을떄
  // await initializeDateFormatting('ko_KR', null);
  try {
    // await DatabaseHelper.instance.database;
    // await DatabaseHelper.instance.printAllUsers();
    print("데이터베이스 정상적으로 로드됨!");
  } catch (e) {
    print("데이터베이스 로드 중 오류 발생: $e");
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(
            create: (context) => GroupViewModel()..fetchGroupData()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
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
            "/": (context) => SettingsScreen(),
            "/chooseRole_Screen": (context) => ChooseRoleScreen(),
            "/nameScreen": (context) => NameScreen(),
            "/createAccount_Screen": (context) => SignupScreen(),
            "/SignupScreen": (context) => SignupScreen(),
            "/settingsScreen": (context) => SettingsScreen(),
            "/homeScreen": (context) => Homescreen(),
            "/workplaceScreen": (context) => WorkplaceScreen(),
            "/groupScreen": (context) => GroupScreen(),
            "/editYourProfileScreen": (context) => EditYourProfileScreen(),
            "/editPasswordScreen": (context) => EditPasswordScreen(),
          },
        );
      },
    );
  }
}
