import 'package:flutter/material.dart';
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
    return TableCalendar(
      calendarFormat: _calendarFormat, // 주 단위로 설정
      focusedDay: _focusedDay,
      firstDay: DateTime(2025, 1, 1),
      lastDay: DateTime(2025, 12, 31),
      locale: 'ko-KR',
      daysOfWeekHeight: 30,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarStyle: CalendarStyle(
        defaultTextStyle: TextStyle(color: Colors.grey),
        weekendTextStyle: TextStyle(color: Colors.grey),
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.green, width: 1.5),
        ),
        todayTextStyle:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronVisible: true,
        rightChevronVisible: true,
      ),
    );
  }
}
