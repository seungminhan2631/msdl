import 'package:flutter/material.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/screens/Home/widget/common/customContainer.dart';
import 'package:msdl/features/screens/Home/widget/common/sectionTitle.dart';
import 'package:msdl/msdl_theme.dart';

class Workplacesection extends StatelessWidget {
  final bool isChecked = false;
  const Workplacesection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Sectiontitle(
              icon: Icons.location_on,
              text: "My Workplace",
              iconColor: Color(0xff3F51B5),
            ),
            Gaps.h20,
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/WorkplaceScreen");
              },
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFFAAAAAA),
              ),
            ),
          ],
        ),
        Gaps.v12,
        CustomContainer(
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    activeColor: Color(0xff3F51B5),
                    checkColor: Color(0xff2C2C2C).withOpacity(0.8),
                    onChanged: (bool? isChecked) {
                      // 상태 로직 추가필
                    },
                    side: BorderSide(
                      color: Color(0xff3F51B5),
                      width: 2,
                    ),
                  ),
                  Text(
                    "MSDL",
                    style: TextStyle(
                        fontFamily: "Andika",
                        fontSize: 15.w,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF1F1F1)),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    activeColor: Color(0xff3F51B5),
                    checkColor: Color(0xff2C2C2C).withOpacity(0.8),
                    onChanged: (bool? isChecked) {
                      // 상태 로직 추가필
                    },
                    side: BorderSide(
                      color: Color(0xff3F51B5),
                      width: 2,
                    ),
                  ),
                  Text(
                    "Home",
                    style: TextStyle(
                        fontFamily: "Andika",
                        fontSize: 15.w,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF1F1F1)),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/workplaceScreen");
                    },
                    icon: Icon(
                      Icons.add_location_alt_outlined,
                      size: Sizes.size20,
                      color: Color(0xff3F51B5),
                    ),
                  ),
                  Text(
                    "Add New Workplace",
                    style: TextStyle(
                      fontFamily: "Andika",
                      fontSize: 15.w,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF1F1F1).withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
