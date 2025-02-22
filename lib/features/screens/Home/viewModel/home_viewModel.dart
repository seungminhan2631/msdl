import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msdl/features/screens/Home/model/home_model.dart';
import 'package:msdl/features/screens/Home/repository/home_repository.dart';
import 'package:msdl/features/screens/authentication/viewModel/viewModel.dart';
import 'package:provider/provider.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository = HomeRepository();
  HomeModel? _homeData;
  bool _isButtonDisabled = false; // ✅ 버튼 활성/비활성 상태 추가

  HomeModel? get homeData => _homeData;
  bool get isButtonDisabled => _isButtonDisabled;

  // ✅ 현재 출퇴근 상태에 따라 텍스트 반환
  String getWorkStatusText() {
    if (_homeData?.isCheckedIn == false && _homeData?.checkInTime == "--:--") {
      return "출근 전";
    } else if (_homeData?.isCheckedIn == true &&
        _homeData?.checkOutTime == "--:--") {
      return "근무 중";
    } else {
      return "오늘 하루도 수고하셨습니다!";
    }
  }

  // ✅ 출퇴근 상태 토글
  Future<void> toggleAttendance(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    int? userId = authViewModel.userId;

    if (userId == null) {
      print("❌ toggleAttendance 실패: userId가 null");
      return;
    }

    bool isCheckedIn = _homeData?.isCheckedIn ?? false;
    String action = isCheckedIn ? "check_out" : "check_in";

    try {
      await _repository.updateAttendance(userId, action);
      print(isCheckedIn ? "✅ 퇴근 성공!" : "✅ 출근 성공!");

      // ✅ 퇴근한 경우 버튼 비활성화
      if (isCheckedIn) {
        _isButtonDisabled = true; // 🔥 버튼 비활성화
        _showGoodJobDialog(context);
      }

      // 최신 데이터 가져오기
      await fetchHomeData(context);
    } catch (e) {
      print("⚠️ 출퇴근 정보 업데이트 실패: $e");
    }

    notifyListeners();
  }

  // ✅ 자정(00:00) 초기화 시 버튼 다시 활성화
  void resetAttendance() {
    if (homeData != null) {
      _homeData = homeData!.copyWith(
        checkInTime: "--:--",
        checkOutTime: "--:--",
        isCheckedIn: false,
      );
      _isButtonDisabled = false; // ✅ 버튼 다시 활성화
      notifyListeners();
    }
  }

  // ✅ "오늘 하루도 수고하셨습니다!" 메시지 띄우기
  void _showGoodJobDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("퇴근 처리 "),
        content: Text("퇴근처리가 되었습니다 !"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
            },
            child: Text("확인"),
          ),
        ],
      ),
    );
  }

  Future<void> fetchHomeData(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    int? userId = authViewModel.userId;

    if (userId == null) {
      print("❌ fetchHomeData 실패: userId가 null");
      return;
    }

    try {
      _homeData = await _repository.fetchHomeData(userId);
      notifyListeners();
    } catch (e) {
      print("⚠️ 데이터 가져오기 실패: $e");
    }
  }
}
