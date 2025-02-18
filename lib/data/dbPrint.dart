import 'package:msdl/data/database_helper.dart';

final database = DatabaseHelper.instance.database;

Future<void> printAllUsers() async {
  final db = await database;
  final List<Map<String, dynamic>> users = await db.query('users');

  if (users.isEmpty) {
    print("📌 users 테이블이 비어 있습니다.");
  } else {
    print("📌 users 테이블 내용:");
    for (var user in users) {
      print(
          "🔹 ID: ${user['id']}, Email: ${user['email']}, Role: ${user['role']}, Name: ${user['name']}");
    }
  }
}

Future<void> printAllAttendance() async {
  final db = await database;
  final List<Map<String, dynamic>> attendance = await db.query('attendance');

  if (attendance.isEmpty) {
    print("📌 attendance 테이블이 비어 있습니다.");
  } else {
    print("📌 attendance 테이블 내용:");
    for (var record in attendance) {
      print(
          "🔹 ID: ${record['id']}, User ID: ${record['user_id']}, Date: ${record['date']}, "
          "Check-In: ${record['check_in_time']}, Check-Out: ${record['check_out_time']}, "
          "Checked In: ${record['is_checked_in']}, Work Category: ${record['work_category']}, "
          "Work Location: ${record['work_location']}");
    }
  }
}

Future<void> printAllWeekRecords() async {
  final db = await database;
  final List<Map<String, dynamic>> week = await db.query('week');

  if (week.isEmpty) {
    print("📌 week 테이블이 비어 있습니다.");
  } else {
    print("📌 week 테이블 내용:");
    for (var record in week) {
      print(
          "🔹 ID: ${record['id']}, User ID: ${record['user_id']}, Date: ${record['date']}, Status: ${record['status']}");
    }
  }
}

Future<void> printAllWorkLocations() async {
  final db = await database;
  final List<Map<String, dynamic>> locations = await db.query('work_locations');

  if (locations.isEmpty) {
    print("📌 work_locations 테이블이 비어 있습니다.");
  } else {
    print("📌 work_locations 테이블 내용:");
    for (var location in locations) {
      print("🔹 ID: ${location['id']}, User ID: ${location['user_id']}, "
          "Latitude: ${location['latitude']}, Longitude: ${location['longitude']}, "
          "Category: ${location['category']}");
    }
  }
}

Future<void> printAllTables() async {
  print("🔥 모든 테이블 데이터 출력 시작...");
  await printAllUsers();
  await printAllAttendance();
  await printAllWeekRecords();
  await printAllWorkLocations();
  print("✅ 모든 테이블 데이터 출력 완료.");
}
