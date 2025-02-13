import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/bottomMsdl.dart';
import 'package:msdl/commons/widgets/buttons/CustomTextField.dart';
import 'package:msdl/commons/widgets/buttons/customButton.dart';
import 'package:msdl/commons/widgets/topTitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController nameController = TextEditingController();
  bool? isNameValid; // ✅ 초기에는 null 상태 (테두리 기본값 유지)

  @override
  void initState() {
    super.initState();
    nameController.addListener(_validateName); // ✅ 입력 변경 감지
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _validateName() {
    setState(() {
      if (nameController.text.isEmpty) {
        isNameValid = null; // ✅ 아무 입력도 없을 때 기본 상태 유지
      } else {
        isNameValid =
            nameController.text.length >= 1 && nameController.text.length <= 6;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 바탕을 터치하면 키보드 내려감
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 190.h),
              TopTitle(text: "What is your name?", fontSize: Sizes.size36),
              Gaps.v96,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.size40),
                child: CustomTextField(
                  controller: nameController,
                  hintText: "Enter your name",
                  firstIcon: Icons.person,
                  lastIcon: Icons.close,
                  helperText: "Enter a name (1-6 characters)",
                  errorText: isNameValid == false
                      ? "Name must be between 1 and 6 characters"
                      : null,
                  isValid: isNameValid ?? true, // ✅ null이면 기본 테두리
                ),
              ),
              Gaps.v40,
              CustomButton(
                text: "Next",
                routeName: "/SignupScreen",
                onPressed: () {
                  if (isNameValid == true) {
                    Navigator.pushNamed(context, "/SignupScreen");
                  }
                },
              ),
              Gaps.v12,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Wrong choice of role?",
                    style: TextStyle(
                      fontSize: Sizes.size16 + Sizes.size1,
                      color: Color(0xffF1F1F1).withOpacity(0.7),
                      fontFamily: "Andika",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.h10,
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/chooseRole_Screen");
                    },
                    child: Text(
                      "Change role",
                      style: TextStyle(
                        fontSize: Sizes.size16 + Sizes.size1,
                        color: Color(0xff26539C),
                        fontFamily: "Andika",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Gaps.v72,
              bottomMsdl(),
            ],
          ),
        ),
      ),
    );
  }
}
