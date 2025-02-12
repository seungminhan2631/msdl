import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msdl/commons/widgets/toptitle.dart';
import 'package:msdl/constants/gaps.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('yyyy.MM.dd', 'ko_KR')
        .format(DateTime.now()); // ✅ 대한민국 날짜 형식 적용

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 70.0, horizontal: 60.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TopTitle(text: "Group"), // ✅ 왼쪽 정렬
            Text(
              todayDate, // ✅ 현재 날짜 표시
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
