import 'package:flutter/material.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/screens/Home/model/home_model.dart';
import 'package:msdl/features/screens/Home/viewModel/home_viewModel.dart';
import 'package:provider/provider.dart';

class ClockInOutButton extends StatelessWidget {
  final HomeModel? homeData;

  const ClockInOutButton({Key? key, this.homeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return ElevatedButton(
      onPressed: homeViewModel.isButtonDisabled
          ? null // ✅ 버튼 비활성화
          : () => homeViewModel.toggleAttendance(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: homeData?.isCheckedIn == true
            ? Color(0xffDE4141) // 출근한 상태 → Clock Out (빨강)
            : Color(0xff2C2C2C), // 출근 전 상태 → Clock In (회색)
        minimumSize: Size(60.w, 32.h),
      ),
      child: Text(
        homeData?.isCheckedIn == true ? "Clock Out" : "Clock In",
        style: TextStyle(
          fontSize: Sizes.size16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
