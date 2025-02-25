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

    try {
      bool isCurrentlyCheckedIn = _homeData?.isCheckedIn ?? false;
      String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

      // ✅ 서버에 출퇴근 요청 보내기
      await _repository.updateAttendance(
          userId, isCurrentlyCheckedIn ? "check_out" : "check_in");

      // ✅ 로컬 데이터 업데이트
      _homeData = _homeData!.copyWith(
        isCheckedIn: !isCurrentlyCheckedIn, // 토글 (출근 ↔ 퇴근)
        checkInTime:
            isCurrentlyCheckedIn ? _homeData!.checkInTime : currentTime,
        checkOutTime:
            isCurrentlyCheckedIn ? currentTime : _homeData!.checkOutTime,
      );

      print(isCurrentlyCheckedIn ? "✅ 퇴근 성공!" : "✅ 출근 성공!");

      // ✅ UI 갱신
      notifyListeners();

      // ✅ 퇴근한 경우, 다이얼로그 띄우기
      if (isCurrentlyCheckedIn) {
        _showGoodJobDialog(context); // 퇴근 처리 다이얼로그 띄우기
        _isButtonDisabled = true; // 🔥 버튼 비활성화
      }
    } catch (e) {
      print("⚠️ 출퇴근 업데이트 실패: $e");
    }
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
      print("📡 Home 데이터 요청: userId=$userId");
      _homeData = await _repository.fetchHomeData(userId);

      if (_homeData == null) {
        print("⚠️ 서버에서 받은 Home 데이터가 null입니다.");
      } else {
        print("✅ Home 데이터 불러오기 성공: ${_homeData!.name}");
      }

      notifyListeners();
    } catch (e) {
      print("🔥 fetchHomeData 실패: $e");
    }
  }
}
