import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/toptitle.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/msdl_theme.dart';

class ChooseRole extends StatefulWidget {
  static const routeName = 'ChooseRole';
  static const routeUrl = '/';

  const ChooseRole({super.key});

  @override
  State<ChooseRole> createState() => _ChooseRoleState();
}

class _ChooseRoleState extends State<ChooseRole> {
  List<bool> isChecked = [false, false, false, false];

  final TextStyle? headlineLarge = msdlTheme.primaryTextTheme.headlineLarge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 102,
          ),
          child: Column(
            children: [
              TopTitle(
                title: "Sign Up",
              ),
              Gaps.v44,
              Text(
                "Choose Your Academic Role",
                style: headlineLarge?.copyWith(
                  fontSize: Sizes.size24 + Sizes.size4,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: ListView(
                  children: List.generate(isChecked.length, (index) {
                    return ListTile(
                      leading: Checkbox(
                        fillColor:
                        activecolor
                            ,
                        value: isChecked[index],
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked[index] = value ?? false;
                          });
                        },
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
