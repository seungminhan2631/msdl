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
      // ✅ API 호출하여 서버에 출퇴근 요청 및 시간 받아오기
      String? recordedTime =
          await _repository.updateAttendance(userId, isClockIn);
      if (recordedTime == null) return;

      // ✅ UI 상태 즉시 업데이트 (출퇴근 시간 반영)
      _homeData = HomeModel(
        id: _homeData!.id,
        name: _homeData!.name,
        role: _homeData!.role,
        isCheckedIn: isClockIn,
        workCategory: _homeData!.workCategory,
        workLocation: _homeData!.workLocation,
        checkInTime:
            isClockIn ? recordedTime : _homeData!.checkInTime, // ✅ 출근 시간 갱신
        checkOutTime:
            isClockIn ? _homeData!.checkOutTime : recordedTime, // ✅ 퇴근 시간 갱신
        weeklyTimeline: _homeData!.weeklyTimeline,
      );

      notifyListeners(); // 🔥 UI 즉시 반영

      // ✅ 0.5초 후 서버에서 최신 데이터 가져오기
      Future.delayed(Duration(milliseconds: 500), () {
        fetchHomeData(context);
      });
    } catch (e) {
      debugPrint("⚠️ Error updating attendance: $e");
    }
  }
}
