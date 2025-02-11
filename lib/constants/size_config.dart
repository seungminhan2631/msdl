import 'package:flutter/widgets.dart';

class SizeConfig {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double scaleFactorWidth = 1;
  static double scaleFactorHeight = 1;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    const double baseWidth = 390.0; // 기준 너비 (iPhone 14)
    const double baseHeight = 844.0; // 기준 높이 (iPhone 14)

    scaleFactorWidth = screenWidth / baseWidth;
    scaleFactorHeight = screenHeight / baseHeight;
  }
}

// 📌 `.w`, `.h` 확장(extension) 추가 → 모든 `double` 값에서 사용 가능
extension SizeExtension on num {
  double get w => this * SizeConfig.scaleFactorWidth;
  double get h => this * SizeConfig.scaleFactorHeight;
}
