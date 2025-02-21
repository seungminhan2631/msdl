import 'package:flutter/material.dart';
import 'package:msdl/features/screens/Home/model/home_model.dart';
import 'package:msdl/features/screens/Home/repository/home_repository.dart';
import 'package:msdl/features/screens/authentication/viewModel/viewModel.dart';
import 'package:provider/provider.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository = HomeRepository();
  HomeModel? _homeData;

  HomeModel? get homeData => _homeData;

  Future<void> fetchHomeData(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    int? userId = authViewModel.userId;

    if (userId == null) {
      print("❌ fetchHomeData 실패: userId가 null");
      return;
    }

    try {
      print("🔍 fetchHomeData 실행 - userId: $userId");
      _homeData = await _repository.getHomeData(userId);

      if (_homeData != null) {
        print("✅ HomeModel 데이터 가져오기 성공!");
        print("👤 사용자 이름: ${_homeData?.name}");
        print("📌 역할: ${_homeData?.role}");
        print("🟢 출근 상태: ${_homeData?.isCheckedIn}");
        print("📍 근무 위치: ${_homeData?.workLocation}");
        print("📊 주간 출근 기록: ${_homeData?.weeklyTimeline}");
      } else {
        print("❌ 홈 데이터가 없습니다.");
      }

      notifyListeners();
    } catch (e) {
      debugPrint("⚠️ Error fetching home data: $e");
    }
  }

  // 🔥 출근(Clock In) 또는 퇴근(Clock Out) 기능
  Future<void> toggleAttendance(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    int? userId = authViewModel.userId;

    if (userId == null) {
      print("❌ toggleAttendance 실패: userId가 null");
      return;
    }

    if (_homeData == null) return;

    bool isClockIn = !_homeData!.isCheckedIn;

    try {
      await _repository.updateAttendance(userId, isClockIn);
      print(isClockIn ? "✅ 출근 성공!" : "🚪 퇴근 성공!");

      await fetchHomeData(context); // ✅ 변경된 데이터 반영
    } catch (e) {
      debugPrint("⚠️ Error updating attendance: $e");
    }
  }
}
