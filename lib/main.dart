import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart' hide initializeDateFormatting;
import 'package:intl/intl.dart';
import 'package:msdl/features/Edit/screens/edit_password_Screen.dart';
import 'package:msdl/features/Edit/screens/edit_your_profile_Screen.dart';
import 'package:msdl/features/Group/screens/group_Screen.dart';
import 'package:msdl/features/Group/viewModel/viewModel.dart';
import 'package:msdl/features/Home/screens/home_Screen.dart';
import 'package:msdl/features/Home/viewModel/home_viewModel.dart';
import 'package:msdl/features/Home/viewModel/weekly_viewModel.dart';
import 'package:msdl/features/Home/viewModel/workplace_viewModel.dart';
import 'package:msdl/features/authentication/screens/choose_role_Screen.dart';
import 'package:msdl/features/authentication/screens/login_Screen.dart';
import 'package:msdl/features/authentication/screens/name_Screen.dart';
import 'package:msdl/features/authentication/screens/signUp_Screen.dart';
import 'package:msdl/features/authentication/viewModel/viewModel.dart';

import 'package:msdl/features/screens/settings/setting_Screen.dart';
import 'package:msdl/features/workplace/repository/workplace_repository.dart';
import 'package:msdl/features/workplace/screens/workplace_Screen.dart';
import 'package:msdl/features/workplace/viewModel/workplace_viewmodel.dart';
import 'package:msdl/msdl_theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => GroupViewModel()),
        ChangeNotifierProvider(create: (_) => HomeWorkplaceViewModel()),
        ChangeNotifierProvider(
            create: (_) => WorkplaceViewModel(WorkplaceRepository())),
        ChangeNotifierProvider(
            create: (context) => WeeklyAttendanceViewModel()),
      ],
      child: const MsdlApp(),
    ),
  );
}

class MsdlApp extends StatelessWidget {
  const MsdlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
          onGenerateRoute: (settings) {
            WidgetBuilder builder;
            bool applySlideAnimation = false; // 🔥 기본적으로 슬라이드 애니메이션 적용 안 함
            switch (settings.name) {
              case "/":
                builder = (context) => LoginScreen();
                applySlideAnimation = true; // 🔥 슬라이드 애니메이션 적용
                break;
              case "/chooseRole_Screen":
                builder = (context) => ChooseRoleScreen();
                applySlideAnimation = true; // 🔥 슬라이드 애니메이션 적용
                break;
              case "/nameScreen":
                builder = (context) => NameScreen();
                applySlideAnimation = true; // 🔥 슬라이드 애니메이션 적용
                break;
              case "/createAccount_Screen":
              case "/SignupScreen":
                builder = (context) => SignupScreen();
                applySlideAnimation = true; // 🔥 슬라이드 애니메이션 적용
                break;
              case "/settingsScreen":
                builder = (context) => SettingsScreen();
                break;
              case "/editYourProfileScreen":
                builder = (context) => EditYourProfileScreen();
                applySlideAnimation = true; // 🔥 슬라이드 애니메이션 적용
                break;
              case "/editPasswordScreen":
                builder = (context) => EditPasswordScreen();
                applySlideAnimation = true; // 🔥 슬라이드 애니메이션 적용
                break;
              case "/homeScreen":
                builder = (context) => Homescreen();
                break;
              case "/workplaceScreen":
                builder = (context) => WorkplaceScreen();
                break;
              case "/groupScreen":
                builder = (context) => GroupScreen();
                break;
              default:
                throw Exception("Invalid route: ${settings.name}");
            }

            // ✅ 특정 화면에만 슬라이드 애니메이션 적용
            if (applySlideAnimation) {
              return PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    builder(context),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0); // 오른쪽에서 왼쪽으로 슬라이드
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              );
            }

            // ✅ 나머지 화면은 기본 MaterialPageRoute 사용
            return MaterialPageRoute(builder: builder, settings: settings);
          },
        );
      },
    );
  }
}
