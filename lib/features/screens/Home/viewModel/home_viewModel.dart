import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Future<void> toggleAttendance(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    int? userId = authViewModel.userId;

    if (userId == null) {
      print("❌ toggleAttendance 실패: userId가 null");
      return;
    }

    if (_homeData == null) return;

    // ✅ 현재 상태 반전 (출근/퇴근 토글)
    bool isNowCheckedIn = !_homeData!.isCheckedIn;
    DateTime now = DateTime.now();

    // ✅ 출근 시 현재 시간 저장, 퇴근 시 기존 출근 시간 유지
    String? newCheckInTime = isNowCheckedIn
        ? DateFormat('HH:mm:ss').format(now)
        : _homeData!.checkInTime;

    // ✅ 퇴근 시 현재 시간 저장, 출근 시 기존 퇴근 시간 유지
    String? newCheckOutTime = isNowCheckedIn
        ? _homeData!.checkOutTime
        : DateFormat('HH:mm:ss').format(now);

    // ✅ UI 상태 즉시 변경 (사용자가 버튼을 다시 누를 때까지 반영됨)
    _homeData = _homeData!.copyWith(
      isCheckedIn: isNowCheckedIn,
      checkInTime: newCheckInTime,
      checkOutTime: newCheckOutTime,
    );

    notifyListeners(); // ✅ UI 즉시 반영

    try {
      // ✅ 서버에 출근/퇴근 상태 업데이트 요청
      await _repository.updateAttendance(userId, isNowCheckedIn);
      print(isNowCheckedIn ? "✅ 출근 성공!" : "🚪 퇴근 성공!");
    } catch (e) {
      debugPrint("⚠️ Error updating attendance: $e");
    }
  }

  void resetAttendance() {
    if (homeData != null) {
      _homeData = homeData!.copyWith(
        checkInTime: "--:--",
        checkOutTime: "--:--",
        isCheckedIn: false,
      );
      notifyListeners();
    }
  }
}
