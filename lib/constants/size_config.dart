import 'package:flutter/widgets.dart';

class SizeConfig {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double scaleFactorWidth = 1;
  static double scaleFactorHeight = 1;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    //figma의 iphone 14를 기준으로 함!!
    const double baseWidth = 390.0;
    const double baseHeight = 844.0;

    scaleFactorWidth = screenWidth / baseWidth;
    scaleFactorHeight = screenHeight / baseHeight;
  }
}

extension SizeExtension on num {
  double get w => this * SizeConfig.scaleFactorWidth;
  double get h => this * SizeConfig.scaleFactorHeight;
}
