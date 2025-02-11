import 'package:flutter/material.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData firstIcon;
  final IconData lastIcon;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.firstIcon,
    required this.lastIcon,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {}); // 포커스 변경 시 UI 업데이트
    });
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
    bool hasFocus = _focusNode.hasFocus; // 현재 포커스 상태 감지

    return TextFieldTapRegion(
      child: Container(
        width: 400.w,
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 9.w),
        decoration: BoxDecoration(
          color: Color(0xff353535),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color:
                hasFocus ? Color(0xffD62FD2) : Color(0xffAAAAAA), // 포커스 시 색상 변경
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              widget.firstIcon,
              color: Color(0xffCACACA),
              size: 28.w,
            ),
            Gaps.h2,
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                obscureText: isPasswordField ? !_isPasswordVisible : false,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Sizes.size20,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: Color(0xffCACACA),
                    fontSize: Sizes.size1 + Sizes.size16,
                    fontFamily: 'Andika',
                  ),
                ),
              ),
            ),
            Gaps.h16,
            GestureDetector(
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
          ],
        ),
      ),
    );
  }
}
