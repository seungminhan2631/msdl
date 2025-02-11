import 'package:flutter/material.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/msdl_theme.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData firstIcon;
  final IconData lastIcon;
  final String? helperText;
  final String? errorText;
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.firstIcon,
    required this.lastIcon,
    this.helperText,
    this.errorText,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isPasswordVisible = false;
  bool _isValid = true; // 유효성 상태 변수

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(
      () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPasswordField = widget.lastIcon == Icons.visibility;
    bool hasFocus = _focusNode.hasFocus;

    return SizedBox(
      child: TextField(
        controller: _controller,
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
          helperStyle: TextStyle(
            color: Color(0xffF1F1F1).withOpacity(0.7),
            fontSize: Sizes.size12 + Sizes.size1,
            fontFamily: 'Andika',
            fontWeight: FontWeight.w900,
          ),
          errorText: _isValid ? null : widget.errorText,
          errorStyle: TextStyle(
            fontSize: Sizes.size12,
            fontFamily: 'Andika',
            fontWeight: FontWeight.w900,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.size2),
            borderSide:
                BorderSide(color: Color(0xffAAAAAA), width: Sizes.size2),
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
                  _controller.clear();
                }
              });
            },
            child: Icon(
              isPasswordField
                  ? (_isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility)
                  : widget.lastIcon,
              color: Color(0xffCACACA),
              size: 20.w,
            ),
          ),
        ),
      ),
    );
  }
}
