import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:msdl/features/screens/Home/model/WeeklyAttendance%20_mdel.dart';
import 'package:msdl/features/screens/Home/model/home_model.dart';
import 'package:msdl/features/screens/Home/repository/home_repository.dart';
import 'package:msdl/features/screens/Home/viewModel/workplace_viewModel.dart';
import 'package:msdl/features/screens/authentication/viewModel/viewModel.dart';
import 'package:provider/provider.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository = HomeRepository();
  HomeModel? _homeData;
  bool _isButtonDisabled = false; // ✅ 버튼 활성/비활성 상태 추가
  HomeModel? get homeData => _homeData;
  bool get isButtonDisabled => _isButtonDisabled;
  final String _baseUrl = "http://220.69.203.99:5000/"; // ✅ Flask 서버 URL

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
    final workplaceViewModel = Provider.of<HomeWorkplaceViewModel>(context,
        listen: false); // ✅ 근무지 정보 가져오기
    int? userId = authViewModel.userId;

    if (userId == null) {
      print("❌ toggleAttendance 실패: userId가 null");
      return;
    }

    try {
      bool isCurrentlyCheckedIn = _homeData?.isCheckedIn ?? false;
      String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      String action = isCurrentlyCheckedIn ? "check_out" : "check_in";

      // ✅ Flask 서버에 출퇴근 요청 보내기
      final response = await http.post(
        Uri.parse("$_baseUrl/attendance/update"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "user_id": userId,
          "action": action,
        }),
      );

      _homeData = _homeData!.copyWith(
        isCheckedIn: !isCurrentlyCheckedIn,
        checkInTime:
            isCurrentlyCheckedIn ? _homeData!.checkInTime : currentTime,
        checkOutTime:
            isCurrentlyCheckedIn ? currentTime : _homeData!.checkOutTime,
      );

      print(isCurrentlyCheckedIn ? "✅ 퇴근 성공!" : "✅ 출근 성공!");

      // ✅ UI 갱신
      notifyListeners();

      if (isCurrentlyCheckedIn) {
        _showGoodJobDialog(context); // 퇴근 처리 다이얼로그 띄우기
        _isButtonDisabled = true; // 🔥 버튼 비활성화
      } else {
        print("❌ 출퇴근 업데이트 실패: ${response.statusCode}");
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

  // ✅ Flask 서버에서 출퇴근 상태 불러오기
  Future<void> fetchHomeData(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    int? userId = authViewModel.userId;

    if (userId == null) {
      print("❌ fetchHomeData 실패: userId가 null");
      return;
    }

    try {
      print("📡 Home 데이터 요청: userId=$userId");
      final response = await http.get(Uri.parse("$_baseUrl/home/$userId"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _homeData = HomeModel(
          id: data['id'] ?? 0, // ✅ user_id 추가
          name: data['name'] ?? 'Unknown', // ✅ name 추가
          role: data['role'] ?? 'Unknown', // ✅ role 추가
          isCheckedIn: data['is_checked_in'] ?? false,
          checkInTime: data['check_in_time'] ?? "--:--",
          checkOutTime: data['check_out_time'] ?? "--:--",
          weeklyTimeline: (data.containsKey('weeklyTimeline') &&
                  data['weeklyTimeline'] != null)
              ? (data['weeklyTimeline'] as List<dynamic>)
                  .map((e) => WeeklyAttendance.fromJson(e))
                  .toList()
              : [], // ✅ weeklyTimeline이 없으면 빈 리스트로 설정
        );
        print("✅ Home 데이터 불러오기 성공: ${data['name']}");
      } else {
        print("❌ 서버 응답 오류: ${response.statusCode}");
      }

      notifyListeners();
    } catch (e) {
      print("🔥 fetchHomeData 실패: $e");
    }
  }
}
