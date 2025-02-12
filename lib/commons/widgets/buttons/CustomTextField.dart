import 'package:flutter/material.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/msdl_theme.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller; // ✅ 외부에서 컨트롤러 전달받도록 변경
  final String hintText;
  final IconData firstIcon;
  final IconData lastIcon;
  final String? helperText;
  final String? errorText;
  final bool isValid; // ✅ 유효성 검사 결과를 받는 변수 추가

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.firstIcon,
    required this.lastIcon,
    this.helperText,
    this.errorText,
    required this.isValid,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPasswordField = widget.lastIcon == Icons.visibility;

    return SizedBox(
      child: TextField(
        controller: widget.controller, // ✅ 컨트롤러 사용
        focusNode: _focusNode,
        obscureText: isPasswordField ? !_isPasswordVisible : false,
        style: TextStyle(
          color: Colors.white,
          fontSize: Sizes.size20,
          fontFamily: 'Andika',
          fontWeight: FontWeight.w200,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              vertical: Sizes.size5, horizontal: Sizes.size10),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Color(0xffCACACA),
            fontSize: Sizes.size1 + Sizes.size16,
            fontFamily: 'Andika',
            fontWeight: FontWeight.bold,
          ),
          helperText: widget.helperText,
          errorText: widget.errorText, // ✅ 에러 메시지 적용
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.size2),
            borderSide: BorderSide(
              color: widget.isValid
                  ? Color(0xffAAAAAA)
                  : Color(0xFFB1384E), // ✅ 유효성 검사 실패 시 테두리 색상 빨간색
              width: Sizes.size2,
            ),
          ),
          prefixIcon: Icon(
            widget.firstIcon,
            color: Color(0xffCACACA),
            size: 28.w,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                if (isPasswordField) {
                  _isPasswordVisible = !_isPasswordVisible;
                } else {
                  widget.controller.clear();
                }
              });
            },
            child: Icon(
              widget.lastIcon,
              color: Color(0xffCACACA),
              size: 20.w,
            ),
          ),
        ),
      ),
    );
  }
}
