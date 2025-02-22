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
  bool _isCheckedIn = false;
  bool get isCheckedIn => _isCheckedIn;

  // 출근 상태 업데이트
  void setCheckedIn(bool isCheckedIn) {
    _isCheckedIn = isCheckedIn;
    notifyListeners();
  }

  // 출근 상태 업데이트
  // 출근 또는 퇴근 상태 반전
  Future<void> toggleAttendance(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    int? userId = authViewModel.userId;

    if (userId == null) {
      print("❌ toggleAttendance 실패: userId가 null");
      return;
    }

    // 출근 상태 확인 (출근이 되어 있으면 퇴근을 처리하고, 퇴근 상태에서만 출근을 처리)
    bool isCheckedIn =
        _homeData?.checkInTime != "--:--"; // 출근 상태라면 true, 출근하지 않았다면 false

    DateTime now = DateTime.now();
    String newCheckInTime = isCheckedIn
        ? "--:--"
        : DateFormat('HH:mm:ss').format(now); // 출근하지 않으면 출근 시간 설정, 아니면 퇴근 시간 설정
    String newCheckOutTime = isCheckedIn
        ? DateFormat('HH:mm:ss').format(now)
        : "--:--"; // 퇴근 중이면 퇴근 시간 설정, 아니면 출근 시간 설정

    // 출퇴근 상태 반전
    if (!isCheckedIn) {
      // 출근 상태로 변경
      _homeData = _homeData!.copyWith(
        checkInTime: newCheckInTime,
        checkOutTime: newCheckOutTime,
        isCheckedIn: true, // 출근 상태로 변경
      );
    } else {
      // 퇴근 상태로 변경
      _homeData = _homeData!.copyWith(
        checkInTime: newCheckInTime,
        checkOutTime: newCheckOutTime,
        isCheckedIn: false, // 퇴근 상태로 변경
      );
    }

    try {
      // 서버에 반영 (출근 또는 퇴근 상태 반영)
      await _repository.updateAttendance(userId, !isCheckedIn);
      print(isCheckedIn ? "✅ 퇴근 성공!" : "✅ 출근 성공!");

      // 최신 데이터 가져오기
      await fetchHomeData(context); // 서버에서 최신 데이터 가져오기
    } catch (e) {
      print("⚠️ 출퇴근 정보 업데이트 실패: $e");
    }

    // UI 갱신
    notifyListeners();
  }

  // 홈 데이터 가져오기
  Future<void> fetchHomeData(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    int? userId = authViewModel.userId;

    if (userId == null) {
      print("❌ fetchHomeData 실패: userId가 null");
      return;
    }

    try {
      _homeData = await _repository.getHomeData(userId);
      notifyListeners(); // UI 갱신
    } catch (e) {
      print("⚠️ 데이터 가져오기 실패: $e");
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
