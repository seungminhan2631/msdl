import 'package:flutter/material.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/Home/viewModel/weekly_viewModel.dart';
import 'package:msdl/features/authentication/viewModel/viewModel.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Weeklytimelinesection extends StatefulWidget {
  const Weeklytimelinesection({super.key});

  @override
  State<Weeklytimelinesection> createState() => _WeeklytimelinesectionState();
}

class _WeeklytimelinesectionState extends State<Weeklytimelinesection> {
  CalendarFormat _calendarFormat = CalendarFormat.week; // 📆 기본 설정: 주간 캘린더
  DateTime _focusedDay = DateTime.now(); // 🔍 현재 포커스된 날짜
  DateTime _selectedDay = DateTime.now(); // ✅ 선택된 날짜

  @override
  void initState() {
    super.initState();
    // ✅ 로그인한 사용자의 ID를 받아 ViewModel에 데이터 요청
    Future.delayed(Duration.zero, () {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final attendanceViewModel =
          Provider.of<WeeklyAttendanceViewModel>(context, listen: false);
      int? userId = authViewModel.userId;

      if (userId != null) {
        attendanceViewModel.fetchWeeklyAttendance(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final attendanceViewModel = Provider.of<WeeklyAttendanceViewModel>(context);

    return TableCalendar(
      calendarFormat: _calendarFormat, // 📅 주 단위로 설정
      focusedDay: _focusedDay, // 🔍 현재 포커스된 날짜
      firstDay: DateTime(2025, 1, 1), // 📆 시작 날짜
      lastDay: DateTime(2025, 12, 31), // 📆 종료 날짜
      locale: 'en_US', // 🌍 언어 설정 (영어)
      daysOfWeekHeight: Sizes.size18, // 📏 요일 높이 설정
      selectedDayPredicate: (day) =>
          isSameDay(_selectedDay, day), // 📌 선택된 날짜 스타일 적용
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay; // ✅ 새로운 선택 날짜 설정
          _focusedDay = focusedDay; // 🔍 새로운 포커스 날짜 설정
        });
      },
      calendarStyle: CalendarStyle(
        defaultTextStyle: const TextStyle(
          color: Color(0XFFF1F1F1),
          fontFamily: "Andika",
        ),
        weekendTextStyle: const TextStyle(
          color: Color(0XFFF1F1F1),
          fontFamily: "Andika",
        ),
        outsideDaysVisible: false, // 🔹 다른 달의 날짜 숨김
        todayDecoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.green, width: 2), // 🟢 오늘 날짜 테두리 강조
        ),
        todayTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.green, // 🟢 오늘 날짜 색상 강조
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false, // 🔘 월/주 변환 버튼 숨김
        titleCentered: true, // 🔍 캘린더 제목 중앙 정렬
        leftChevronVisible: true, // ⬅️ 왼쪽 이동 버튼
        rightChevronVisible: true, // ➡️ 오른쪽 이동 버튼
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, _) {
          final status = attendanceViewModel.getAttendanceStatus(date);
          final today = DateTime.now();

          // ✅ 현재 날짜 이전이고 기록이 없는 경우 결석 처리
          if (date.isBefore(today)) {
            return _buildMarker(date, Color(0xFFB1384E), "X"); // ❌ 빨간색 (결석)
          }

          // 📌 출근 / 퇴근 / 결석 상태에 따라 마커 표시
          if (status == "checkIn") {
            return _buildMarker(date, Colors.green, "출근"); // ✅ 초록색 (출근)
          } else if (status == "checkOut") {
            return _buildMarker(date, Colors.blue, "퇴근"); // 🏠 파란색 (퇴근)
          } else if (status == "absent") {
            return _buildMarker(date, Color(0xFFB1384E), "X"); // ❌ 빨간색 (결석)
          }

          return null; // ❌ 마커가 없는 경우 기본 스타일 유지
        },
      ),
    );
  }

  // 🔹 특정 날짜에 원형 마커 추가하는 함수
  Widget _buildMarker(DateTime date, Color color, String text) {
    return Center(
      child: Container(
        width: Sizes.size32,
        height: Sizes.size32,
        decoration: BoxDecoration(
          color: color, // 🎨 배경 색상
          shape: BoxShape.circle, // 🔵 원형 마커
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: "Andika",
              color: Colors.white, // 🎨 텍스트 색상 (흰색)
              fontWeight: FontWeight.bold,
              fontSize: Sizes.size14,
            ),
          ),
        ),
      ),
    );
  }
}
