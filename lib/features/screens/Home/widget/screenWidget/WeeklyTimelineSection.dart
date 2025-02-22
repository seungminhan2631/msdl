import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Weeklytimelinesection extends StatefulWidget {
  const Weeklytimelinesection({super.key});

  @override
  State<Weeklytimelinesection> createState() => _WeeklytimelinesectionState();
}

class _WeeklytimelinesectionState extends State<Weeklytimelinesection> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: DateTime.now(),
      firstDay: DateTime(2025, 1, 1),
      lastDay: DateTime(2025, 12, 31),
      locale: 'ko-KR',
      daysOfWeekHeight: 30,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronVisible: true,
        rightChevronVisible: true,
      ),
    );
  }
}
