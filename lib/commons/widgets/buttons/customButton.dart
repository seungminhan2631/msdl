import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xff4F6F89),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          minimumSize: const Size(300, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xffAAAAAA), width: 2),
          ),
        ),
        onPressed: () {
          // 버튼 클릭 이벤트
        },
        child: const Text(
          "Next",
          style: TextStyle(
            fontFamily: 'Andika',
            fontSize: 22, // 텍스트 크기 조절
            color: Colors.white, // 텍스트 색상
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
