import 'package:flutter/material.dart';

/// Dark [ColorScheme] made with FlexColorScheme v8.1.0.
/// Requires Flutter 3.22.0 or later.
const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF90CAF9),
  onPrimary: Color(0xFF000000),
  primaryContainer: Color(0xFF0D47A1),
  onPrimaryContainer: Color(0xffFFFFFF),
  primaryFixed: Color(0xFFC5DDF8),
  primaryFixedDim: Color(0xFF97BEE9),
  onPrimaryFixed: Color(0xFF08274A),
  onPrimaryFixedVariant: Color(0xFF0A2F5A),
  secondary: Color(0xFF81D4FA),
  onSecondary: Color(0xFF000000),
  secondaryContainer: Color(0xFF004B73),
  onSecondaryContainer: Color(0xFFFFFFFF),
  secondaryFixed: Color(0xFFC3EBFE),
  secondaryFixedDim: Color(0xFF8ED5F9),
  onSecondaryFixed: Color(0xFF013F5D),
  onSecondaryFixedVariant: Color(0xFF014B6F),
  tertiary: Color(0xFFE1F5FE),
  onTertiary: Color(0xFF000000),
  tertiaryContainer: Color(0xFF1A567D),
  onTertiaryContainer: Color(0xFFFFFFFF),
  tertiaryFixed: Color(0xFFC0E4F9),
  tertiaryFixedDim: Color(0xFF8DC9EC),
  onTertiaryFixed: Color(0xFF012941),
  onTertiaryFixedVariant: Color(0xFF013553),
  error: Color(0xFFCF6679),
  onError: Color(0xFF000000),
  errorContainer: Color(0xFFB1384E),
  onErrorContainer: Color(0xFFFFFFFF),
  surface: Color(0xFF080808),
  onSurface: Color(0xFFF1F1F1),
  surfaceDim: Color(0xFF060606),
  surfaceBright: Color(0xFF2C2C2C),
  surfaceContainerLowest: Color(0xFF010101),
  surfaceContainerLow: Color(0xFF0E0E0E),
  surfaceContainer: Color(0xFF151515),
  surfaceContainerHigh: Color(0xFF1D1D1D),
  surfaceContainerHighest: Color(0xFF282828),
  onSurfaceVariant: Color(0xFFCACACA),
  outline: Color(0xFF777777),
  outlineVariant: Color(0xFF414141),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFE8E8E8),
  onInverseSurface: Color(0xFF2A2A2A),
  inversePrimary: Color(0xFF445B6B),
  surfaceTint: Color(0xFF90CAF9),
);

final ThemeData msdlTheme = ThemeData(
  // TextTheme - AppBar, Home
  primaryTextTheme: TextTheme(
    // Font of Sign Up,Log In, Welcome MSDL,Settings,Edit Your Profile,Edit Password,Save change
    headlineLarge: TextStyle(
      color: darkColorScheme.onSurface,
      fontFamily: 'Andika',
    ),
    //Font of No account?,
    labelMedium: TextStyle(
      color: darkColorScheme.onSurfaceVariant,
      fontFamily: 'Andika',
    ),
    //Font of LogOut
    labelLarge: const TextStyle(
      color: Color(0xffCF3B28),
      fontFamily: 'Andika',
    ),
    // Only Font of In : 09:00 | Out : 17:00 && 2025.02.09
    labelSmall: TextStyle(
        color: darkColorScheme.onSurface, fontFamily: 'Andika', fontSize: 15),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: darkColorScheme.surfaceBright,
    selectedItemColor: darkColorScheme.onSurfaceVariant,
    unselectedItemColor: darkColorScheme.onSurfaceVariant.withOpacity(0.2),
    elevation: 0,
    //Container로 감싸서 아래 코드 사용하여 border을 줌
    // decoration: const BoxDecoration(
    //   border: Border(
    //     top: BorderSide(color: Color(0xffAAAAAA), width: 2.0),
    //   ),
    // ),
  ),

  iconTheme: const IconThemeData(
    color: Color(0xFFFFB400),
    size: 18,
  ),

  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
    side: BorderSide(
      color: darkColorScheme.onSurfaceVariant.withOpacity(0.8),
      width: 2,
    ),
    fillColor: WidgetStateProperty.resolveWith<Color>(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return darkColorScheme.onSurfaceVariant.withOpacity(0.8);
        }
        return Colors.transparent;
      },
    ),
    checkColor: WidgetStateProperty.all(Colors.white),
  ),
);
