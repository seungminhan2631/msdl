import 'package:flutter/material.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final String routeName;
  final VoidCallback? onPressed; // ✅ 버튼 클릭 시 실행할 함수 추가

  const CustomButton({
    super.key,
    required this.text,
    required this.routeName,
    this.onPressed, // ✅ 선택적 매개변수 추가
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xff4F6F89).withOpacity(0.7),
          padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 12.h),
          minimumSize: Size(320.w, 60.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Color(0xffAAAAAA), width: 1.w),
          ),
        ),
        onPressed: onPressed ??
            () {
              // ✅ `onPressed` 동작 추가
              if (routeName.isNotEmpty) {
                Navigator.pushNamed(context, routeName);
              }
            },
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Andika',
            fontSize: Sizes.size24 + Sizes.size1,
            color: Color(0xffF1F1F1),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
