import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/buttons/customButton.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/screens/workplace/widget/boxInBottomBar.dart';

class draglesheet extends StatelessWidget {
  const draglesheet({
    super.key,
    required DraggableScrollableController sheetController,
    required String currentAddress,
  })  : _sheetController = sheetController,
        _currentAddress = currentAddress;

  final DraggableScrollableController _sheetController;
  final String _currentAddress;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.12,
      minChildSize: 0.05,
      maxChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: Sizes.size10),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0xFFCACACA),
                width: 1.0.w,
              ),
            ),
            color: Color(0xFF2C2C2C),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: Sizes.size40 + Sizes.size40,
                  height: Sizes.size3,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Gaps.v8,
                Text(
                  "Current location : ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size16,
                    fontFamily: "Andika",
                  ),
                ),
                Text(
                  _currentAddress,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size14,
                    fontFamily: "Andika",
                  ),
                ),
                Gaps.v28,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BoxInBottomBar(
                      text: "Lab",
                      icon: Icons.science_outlined,
                      iconColor: Color(0xFFFFB400),
                    ),
                    BoxInBottomBar(
                      text: "Home",
                      icon: Icons.home_work_outlined,
                      iconColor: Color(0xFF3F51B5),
                    ),
                    BoxInBottomBar(
                      text: "Off-Site",
                      icon: Icons.business_center_outlined,
                      iconColor: Color(0xFF935E38),
                    ),
                    BoxInBottomBar(
                      text: "Other",
                      icon: Icons.more_horiz_outlined,
                      iconColor: Color(0xFF151515),
                    ),
                  ],
                ),
                Gaps.v32,
                CustomButton(
                  text: "Add New Workplace",
                  routeName: "/homeScreen",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
