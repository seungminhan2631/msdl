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
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    bool isPasswordField = widget.lastIcon == Icons.visibility;

    return TextFieldTapRegion(
      child: Container(
        width: 340.w,
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Color(0xff353535),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: Color(0xffAAAAAA), width: 2),
        ),
        child: Row(
          children: [
            Icon(
              widget.firstIcon,
              color: Color(0xffCACACA),
              size: 30.w,
            ),
            Gaps.h16,
            Expanded(
              child: TextField(
                controller: _controller,
                obscureText: isPasswordField ? !_isPasswordVisible : false,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Sizes.size20,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: Color(0xffCACACA),
                    fontSize: Sizes.size20,
                    fontFamily: 'Andika',
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            Gaps.h16,
            GestureDetector(
              onTap: () {
                if (isPasswordField) {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                } else {
                  _controller.clear();
                }
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
