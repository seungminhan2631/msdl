import 'package:flutter/material.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';

class CustomContainer extends StatelessWidget {
  final Widget? child; // 내부 레이아웃을 유연하게 적용할 수 있도록 child 추가
  final double width;
  final double height;

  const CustomContainer({
    Key? key,
    this.child,
    this.width = 372,
    this.height = 125,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        color: Color(0xff2C2C2C).withOpacity(0.8),
        borderRadius: BorderRadius.circular(Sizes.size6),
        border: Border.all(
          width: Sizes.size2,
          color: Color(0xffAAAAAA),
        ),
      ),
      child: child, // 내부 콘텐츠를 자유롭게 배치할 수 있도록 child 적용
    );
  }
}
