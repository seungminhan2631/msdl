import 'package:flutter/material.dart';
import 'package:msdl/features/screens/Home/viewModel/home_viewModel.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Weeklytimelinesection extends StatefulWidget {
  const Weeklytimelinesection({super.key});

  @override
  State<Weeklytimelinesection> createState() => _WeeklytimelinesectionState();
}

class _WeeklytimelinesectionState extends State<Weeklytimelinesection> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    final List<DateTime> attendanceDays = homeViewModel.attendanceDays;

    final List<DateTime> checkoutDays = homeViewModel.checkoutDays;

    final List<DateTime> absentDays = homeViewModel.absentDays;

    // 출근, 퇴근, 결석 날짜를 저장
    Map<DateTime, bool> markedDates = {};

    // 출근한 날짜
    for (var day in attendanceDays) {
      markedDates[DateTime(day.year, day.month, day.day)] = true; // 출근 (초록색색)
    }

    // 결석한 날짜
    for (var day in checkoutDays) {
      markedDates[DateTime(day.year, day.month, day.day)] = false; // 퇴근 (파란색)
    }

    for (var day in absentDays) {
      markedDates[DateTime(day.year, day.month, day.day)] =
          "absent" as bool; // 결석 (빨간색색)
    }

    return TableCalendar(
      calendarFormat: _calendarFormat, // 주 단위로 설정
      focusedDay: _focusedDay,
      firstDay: DateTime(2025, 1, 1),
      lastDay: DateTime(2025, 12, 31),
      locale: 'en_US',
      daysOfWeekHeight: 25,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarStyle: CalendarStyle(
        defaultTextStyle: TextStyle(
          color: Color(0XFFF1F1F1),
          fontFamily: "Andika",
        ),
        weekendTextStyle: TextStyle(
          color: Color(0XFFF1F1F1),
          fontFamily: "Andika",
        ),
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.green, width: 1.5),
        ),
        todayTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronVisible: true,
        rightChevronVisible: true,
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, _) {
          final normalizedDate = DateTime(date.year, date.month, date.day);

          if (markedDates[normalizedDate] == "checkIn") {
            return _buildMarker(date, Colors.green, "출근");
          } else if (markedDates[normalizedDate] == "checkOut") {
            return _buildMarker(date, Colors.blue, "퇴근");
          } else if (markedDates[normalizedDate] == "absent") {
            return _buildMarker(date, Colors.red, "X");
          }

          return null;
        },
      ),
    );
  }

  Widget _buildMarker(DateTime date, Color color, String text) {
    return Center(
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
