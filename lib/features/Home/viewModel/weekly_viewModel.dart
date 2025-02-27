import 'package:flutter/material.dart';
import 'package:msdl/features/screens/Home/model/WeeklyAttendance%20_mdel.dart';
import 'package:msdl/features/screens/Home/repository/WeeklyAttendanceRepository.dart';

class WeeklyAttendanceViewModel extends ChangeNotifier {
  final WeeklyAttendanceRepository _repository = WeeklyAttendanceRepository();
  List<WeeklyAttendance> _weeklyAttendance = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<WeeklyAttendance> get weeklyAttendance => _weeklyAttendance;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // ✅ 주간 출석 데이터 가져오기
  Future<void> fetchWeeklyAttendance(int userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _weeklyAttendance = await _repository.fetchWeeklyAttendance(userId);
    } catch (e) {
      _errorMessage = "❌ 주간 출석 데이터를 불러오지 못했습니다.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ 특정 날짜의 출석 여부 확인 (달력에 반영)
  String getAttendanceStatus(DateTime date) {
    String formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    for (var record in _weeklyAttendance) {
      if (record.date == formattedDate) {
        if (record.checkOutTime != "--:--") {
          return "checkOut"; // 🏠 퇴근 (파란색)
        } else {
          return "checkIn"; // ✅ 출근 (초록색)
        }
      }
    }
    return ""; // ❌ 아무 기록 없음
  }
}
