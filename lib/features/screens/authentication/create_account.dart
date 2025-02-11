import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/buttons/CustomTextField.dart';
import 'package:msdl/commons/widgets/toptitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';

class CreateAccount extends StatefulWidget {
  static const routeName = 'CreateAccount';
  static const routeUrl = '/';

  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.size52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 130.w,
            ),
            TopTitle(text: "Welcome MSDL"),
            SizedBox(
              height: 70.w,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TopTitle(
                  text: "Email Address",
                  fontSize: Sizes.size16 + Sizes.size1,
                  fontWeight: FontWeight.w700,
                  opacity: 0.7,
                ),
              ],
            ),
            CustomTextField(
              hintText: "Enter your email",
              firstIcon: Icons.mail_outlined,
              lastIcon: Icons.cancel_outlined,
            ),
            Gaps.v44,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TopTitle(
                  text: "Create a Password",
                  fontSize: Sizes.size16 + Sizes.size1,
                  fontWeight: FontWeight.w700,
                  opacity: 0.7,
                ),
              ],
            ),
            CustomTextField(
              hintText: "Enter a password",
              firstIcon: Icons.lock_outline_rounded,
              lastIcon: Icons.visibility_off_outlined,
            ),
            Gaps.v44,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TopTitle(
                  text: "Confirm Your Password",
                  fontSize: Sizes.size16 + Sizes.size1,
                  fontWeight: FontWeight.w700,
                  opacity: 0.7,
                ),
              ],
            ),
            CustomTextField(
              hintText: "Confirm password",
              firstIcon: Icons.check_rounded,
              lastIcon: Icons.visibility_off_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
