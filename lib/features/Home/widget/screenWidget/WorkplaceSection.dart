import 'package:flutter/material.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/Home/viewModel/workplace_viewModel.dart';
import 'package:msdl/features/Home/widget/common/checkWorkplaceBox.dart';
import 'package:msdl/features/Home/widget/common/customContainer.dart';
import 'package:msdl/features/Home/widget/common/sectionTitle.dart';
import 'package:provider/provider.dart';

class WorkplaceSection extends StatefulWidget {
  const WorkplaceSection({super.key});

  @override
  _WorkplaceSectionState createState() => _WorkplaceSectionState();
}

class _WorkplaceSectionState extends State<WorkplaceSection> {
  @override
  void initState() {
    super.initState();

    // ✅ ViewModel에서 Workplace 데이터 가져오기
    Future.delayed(Duration.zero, () {
      final homeWorkplaceViewModel =
          Provider.of<HomeWorkplaceViewModel>(context, listen: false);
      homeWorkplaceViewModel.fetchWorkplaces(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeWorkplaceViewModel>(
      builder: (context, homeWorkplaceViewModel, child) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Sectiontitle(
                  icon: Icons.location_on,
                  text: "My Workplace",
                  iconColor: const Color(0xff3F51B5),
                ),
                Gaps.h10,
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/workplaceScreen");
                  },
                  child: Transform.translate(
                    offset: Offset(0, 2.h),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFFAAAAAA),
                      size: Sizes.size24,
                    ),
                  ),
                ),
              ],
            ),
            Gaps.v8,
            CustomContainer(
              child: SizedBox(
                height: 150.h,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // ✅ Workplace 리스트 동적 생성
                      ...homeWorkplaceViewModel.workplaces.map((workplace) {
                        return checkWorkplaceBox(
                          title: workplace.category, // ✅ 올바른 데이터 사용
                          value: homeWorkplaceViewModel.selectedCategory ==
                              workplace.category,
                          onChanged: (bool? value) {
                            if (value == true) {
                              homeWorkplaceViewModel
                                  .selectCategory(workplace.category);
                            }
                          },
                        );
                      }).toList(),

                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/workplaceScreen");
                            },
                            icon: Icon(
                              Icons.add_location_alt_outlined,
                              size: Sizes.size28,
                              color: Color(0xff3F51B5),
                            ),
                          ),
                          Text(
                            "Add New Workplace",
                            style: TextStyle(
                              fontFamily: "Andika",
                              fontSize: 15.w,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFF1F1F1).withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
