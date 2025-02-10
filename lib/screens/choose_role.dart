import 'package:flutter/material.dart';

class ChooseRole extends StatelessWidget {
  const ChooseRole({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                children: [
                    Text("Sign Up",
                    style: TextStyle(
color: ,
fontSize: Sizes.size4,
                    ),),
                    Gaps.v12,
                    Text("Choose Your Academic Role",
                    style: TextStyle(
color: ,
fontSize: Sizes.size4,
                    ),),
                    
                ],
            ),
        ),
    );
  }
}