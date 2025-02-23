import 'package:flutter/material.dart';
import 'package:msdl/constants/sizes.dart';

class checkWorkplaceBox extends StatelessWidget {
  const checkWorkplaceBox({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          splashRadius: 0,
          value: value,
          activeColor: const Color(0xff3F51B5),
          checkColor: const Color(0xff2C2C2C),
          onChanged: (bool? newValue) {
            if (newValue == true) {
              onChanged(true);
            }
          },
          side: const BorderSide(
            color: Color(0xff3F51B5),
            width: 2,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontFamily: "Andika",
            fontSize: Sizes.size14 + Sizes.size1,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFF1F1F1),
          ),
        ),
      ],
    );
  }
}
