import 'package:msdl/data/database_helper.dart';
import 'package:msdl/features/screens/Home/model/home_model.dart';

class HomeRepository {
  final db = DatabaseHelper.instance;

  // 🔥 최근 7일 출근 기록 가져오기
  Future<List<Map<String, dynamic>>> getWeeklyAttendance(int userId) async {
    final _db = await db.database;
    final result = await _db.rawQuery('''
      SELECT date, status FROM week
      WHERE user_id = ? 
      AND date BETWEEN date('now', '-6 days') AND date('now')
      ORDER BY date ASC
    ''', [userId]);

    print("📅 주간 출근 기록 가져오기: $result"); // 🔥 디버깅 추가
    return result;
  }

  Future<bool> isUserCheckedIn(int userId) async {
    final _db = await db.database;
    final result = await _db.rawQuery('''
      SELECT is_checked_in FROM attendance 
      WHERE user_id = ? AND date = date('now')
    ''', [userId]);

    print("🟢 출근 상태: $result"); // 🔥 디버깅 추가
    return result.isNotEmpty && (result.first['is_checked_in'] as int) == 1;
  }

  Future<void> updateAttendance(int userId, bool isClockIn) async {
    final _db = await db.database;
    final String timeNow =
        DateTime.now().toString().substring(11, 16); // HH:mm 형식
    final String todayDate =
        DateTime.now().toString().substring(0, 10); // YYYY-MM-DD 형식

    await _db.rawInsert('''
    INSERT INTO attendance (user_id, date, is_checked_in, check_in_time, check_out_time)
    VALUES (?, ?, ?, ?, ?)
    ON CONFLICT(user_id, date) 
    DO UPDATE SET 
      is_checked_in = excluded.is_checked_in, 
      check_in_time = CASE WHEN excluded.is_checked_in = 1 THEN excluded.check_in_time ELSE attendance.check_in_time END,
      check_out_time = CASE WHEN excluded.is_checked_in = 0 THEN excluded.check_out_time ELSE attendance.check_out_time END
  ''', [
      userId,
      todayDate,
      isClockIn ? 1 : 0,
      isClockIn ? timeNow : null,
      isClockIn ? null : timeNow
    ]);

    print(isClockIn ? "✅ 출근 기록 정상 저장: $timeNow" : "🚪 퇴근 기록 정상 저장: $timeNow");
  }

  // 🔥 사용자 정보 + 출근 상태 + 근무 위치 + 주간 출근 기록 가져오기
  Future<HomeModel> getHomeData(int userId) async {
    final _db = await db.database;

    final userResult = await _db.rawQuery('''
    SELECT users.id, users.name, users.role, 
           IFNULL(attendance.is_checked_in, 0) as is_checked_in, 
           IFNULL(attendance.check_in_time, '--:--') as check_in_time,
           IFNULL(attendance.check_out_time, '--:--') as check_out_time,
           attendance.work_category, work_locations.location_name
    FROM users
    LEFT JOIN attendance ON users.id = attendance.user_id
    LEFT JOIN work_locations ON users.id = work_locations.user_id
    WHERE users.id = ?
  ''', [userId]);

    if (userResult.isEmpty) {
      throw Exception("User not found");
    }

    print("👤 사용자 정보 가져오기 (수정 후): $userResult");

    final weeklyTimeline = await getWeeklyAttendance(userId);

    return HomeModel.fromMap(userResult.first, weeklyTimeline);
  }
}
