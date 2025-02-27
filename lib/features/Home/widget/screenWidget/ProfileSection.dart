import 'package:flutter/material.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/Home/model/home_model.dart';
import 'package:msdl/features/Home/viewModel/home_viewModel.dart';
import 'package:msdl/features/Home/widget/common/customContainer.dart';
import 'package:msdl/features/Home/widget/common/profileAvatar.dart';
import 'package:msdl/features/Home/widget/screenWidget/ClockInOutButton.dart';
import 'package:provider/provider.dart';

class ProfileSection extends StatelessWidget {
  final HomeModel? homeData;

  const ProfileSection({Key? key, this.homeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: Sizes.size12),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                homeViewModel.getWorkStatusText(),
                style: TextStyle(
                  fontFamily: 'Andika',
                  fontSize: Sizes.size18,
                  color: Color(0xffF1F1F1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Gaps.v16,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileAvatar(),
              Gaps.h24,
              Text(
                homeData?.name ?? "Name",
                style: TextStyle(
                  fontFamily: 'Andika',
                  fontSize: Sizes.size20,
                  color: Color(0xffF1F1F1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gaps.h32,
              ClockInOutButton(),
            ],
          ),
        ],
      ),
    );
  }
}
