import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:msdl/commons/widgets/bottomMsdl.dart';
import 'package:msdl/commons/widgets/buttons/CustomTextField.dart';
import 'package:msdl/commons/widgets/buttons/customButton.dart';
import 'package:msdl/commons/widgets/topTitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/screens/authentication/viewModel/viewModel.dart'; // ✅ ViewModel import

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController nameController = TextEditingController();
  bool isNameValid = true;

  void _validateName() {
    setState(() {
      isNameValid =
          nameController.text.length >= 1 && nameController.text.length <= 10;
    });

    if (isNameValid) {
      // ✅ Provider에서 ViewModel 가져와서 이름 저장
      Provider.of<AuthViewModel>(context, listen: false)
          .setName(nameController.text);

      print("✅ 입력된 이름: ${nameController.text}"); // 디버깅용

      // ✅ SignupScreen으로 이동
      Navigator.pushNamed(context, "/SignupScreen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopTitle(
              text: "What is your name?",
              fontSize: Sizes.size32,
            ),
            Gaps.v32,
            CustomTextField(
              controller: nameController,
              hintText: "Enter your name",
              firstIcon: Icons.person,
              lastIcon: Icons.close,
              helperText: "",
              errorText: isNameValid
                  ? null
                  : "Please enter a name between 1 and 5 characters.",
              isValid: isNameValid,
            ),
            Gaps.v20,
            CustomButton(
              text: "Next",
              routeName: "/SignupScreen",
              onPressed: _validateName,
            ),
            Gaps.v20,
            bottomMsdl(),
          ],
        ),
      ),
    );
  }
}
