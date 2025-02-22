import 'package:flutter/material.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/screens/Home/widget/common/customContainer.dart';
import 'package:msdl/features/screens/Home/widget/common/sectionTitle.dart';
import 'package:msdl/msdl_theme.dart';

class Workplacesection extends StatefulWidget {
  const Workplacesection({super.key});

  @override
  _WorkplacesectionState createState() => _WorkplacesectionState();
}

class _WorkplacesectionState extends State<Workplacesection> {
  bool isMSDLChecked = false;
  bool isHomeChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Sectiontitle(
              icon: Icons.location_on,
              text: "My Workplace",
              iconColor: const Color(0xff3F51B5),
            ),
            Gaps.h10,
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/workplaceScreen");
              },
              child: Transform.translate(
                offset: Offset(0, 3.h),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFFAAAAAA),
                  size: Sizes.size24,
                ),
              ),
            ),
          ],
        ),
        Gaps.v12,
        CustomContainer(
          child: SizedBox(
            height: 150.h,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildWorkplaceCheckbox(
                    title: "MSDL",
                    value: isMSDLChecked,
                    onChanged: (value) {
                      setState(() {
                        isMSDLChecked = value!;
                      });
                    },
                  ),
                  _buildWorkplaceCheckbox(
                    title: "Home",
                    value: isHomeChecked,
                    onChanged: (value) {
                      setState(() {
                        isHomeChecked = value!;
                      });
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/workplaceScreen");
                        },
                        icon: Icon(
                          Icons.add_location_alt_outlined,
                          size: Sizes.size28,
                          color: Color(0xff3F51B5),
                        ),
                      ),
                      Text(
                        "Add New Workplace",
                        style: TextStyle(
                          fontFamily: "Andika",
                          fontSize: 15.w,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFF1F1F1).withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkplaceCheckbox({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        Checkbox(
          splashRadius: 0,
          value: value,
          activeColor: const Color(0xff3F51B5),
          checkColor: const Color(0xff2C2C2C),
          onChanged: onChanged,
          side: const BorderSide(
            color: Color(0xff3F51B5),
            width: 2,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontFamily: "Andika",
            fontSize: 15.w,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFF1F1F1),
          ),
        ),
      ],
    ); //ㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁㅇ
  }
}
