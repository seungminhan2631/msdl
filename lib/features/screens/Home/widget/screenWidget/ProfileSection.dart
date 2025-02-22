import 'package:flutter/material.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/screens/Home/model/home_model.dart';
import 'package:msdl/features/screens/Home/viewModel/home_viewModel.dart';
import 'package:msdl/features/screens/Home/widget/common/customContainer.dart';
import 'package:msdl/features/screens/Home/widget/common/profileAvatar.dart';
import 'package:msdl/features/screens/Home/widget/screenWidget/ClockInOutButton.dart';
import 'package:provider/provider.dart';

class ProfileSection extends StatelessWidget {
  final HomeModel? homeData;

  const ProfileSection({Key? key, this.homeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return CustomContainer(
      child: Stack(
        children: [
          Positioned(
            left: Sizes.size60,
            top: Sizes.size16,
            child: Text(
              homeViewModel.getWorkStatusText(), // ✅ 현재 출퇴근 상태 표시
              style: TextStyle(
                fontFamily: 'Andika',
                fontSize: Sizes.size16 + Sizes.size1,
                color: Color(0xffF1F1F1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
              left: Sizes.size32, top: Sizes.size60, child: ProfileAvatar()),
          Positioned(
            left: Sizes.size96 + Sizes.size20,
            top: Sizes.size60,
            child: Text(
              homeData?.name ?? "name...",
              style: TextStyle(
                fontFamily: 'Andika',
                fontSize: Sizes.size20,
                color: Color(0xffF1F1F1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: Sizes.size96 + Sizes.size20,
            top: Sizes.size11 + Sizes.size56,
            child: ClockInOutButton(),
          ),
        ],
      ),
    );
  }
}
