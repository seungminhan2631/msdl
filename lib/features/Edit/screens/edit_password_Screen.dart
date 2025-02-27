import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/buttons/CustomButton.dart';
import 'package:msdl/commons/widgets/buttons/CustomTextField.dart';
import 'package:msdl/commons/widgets/topTitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool? isNewPasswordValid;
  bool? isConfirmPasswordValid;

  @override
  void initState() {
    super.initState();
    newPasswordController.addListener(_validateNewPassword);
    confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    newPasswordController.removeListener(_validateNewPassword);
    confirmPasswordController.removeListener(_validateConfirmPassword);
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateNewPassword() {
    setState(() {
      isNewPasswordValid = newPasswordController.text.length >= 4;
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      isConfirmPasswordValid =
          confirmPasswordController.text == newPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/editYourProfileScreen");
                      },
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Color(0xFFAAAAAA),
                      ),
                    ),
                    Spacer(),
                    TopTitle(text: "Edit Password"),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 32.h),
                Expanded(
                  child: Column(
                    children: [
                      Gaps.v32,
                      CustomTextField(
                        hintText: "New Password",
                        firstIcon: Icons.vpn_key_outlined,
                        lastIcon: Icons.visibility,
                        helperText: "Please enter your new password",
                        errorText: isNewPasswordValid == false
                            ? "Enter a valid password"
                            : null,
                        isValid: isNewPasswordValid ?? true,
                        controller: newPasswordController,
                      ),
                      Gaps.v32,
                      CustomTextField(
                        hintText: "Confirm New Password",
                        firstIcon: Icons.vpn_key_outlined,
                        lastIcon: Icons.visibility,
                        helperText: "Please confirm your new password",
                        errorText: isConfirmPasswordValid == false
                            ? "Passwords do not match"
                            : null,
                        isValid: isConfirmPasswordValid ?? true,
                        controller: confirmPasswordController,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "To ensure the highest level of security, please update your password",
                        style: TextStyle(
                          fontFamily: "Andika",
                          fontSize: Sizes.size16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFF1F1F1),
                        ),
                      ),
                      Gaps.v32,
                      CustomButton(
                        text: "Save change",
                        routeName: "/editYourProfileScreen",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
