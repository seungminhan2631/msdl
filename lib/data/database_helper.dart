import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('msdl.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    print("생성된 데이터베이스 경로: $path"); // ✅ 경로 확인

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        print("데이터베이스 생성 완료: $path");
        _createDB(db, version);
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            role TEXT CHECK(role IN ('Professor', 'Ph.D. Student', 'MS Student', 'BS Student')) NOT NULL,
            name TEXT NOT NULL
        );
      ''');
      print("users 테이블 생성 완료");

      await db.execute('''
        CREATE TABLE attendance (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            date TEXT NOT NULL,
            check_in_time TEXT,
            check_out_time TEXT,
            work_category TEXT CHECK(work_category IN ('Lab', 'Home', 'Out Of Office', 'Other')),
            work_location TEXT,
            FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
        );
      ''');
      print("attendance 테이블 생성 완료");

      await db.execute('''
        CREATE TABLE work_locations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            location_name TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            work_category TEXT CHECK(work_category IN ('Lab', 'Home', 'Out Of Office', 'Other')),
            FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
        );
      ''');
      print("work_locations 테이블 생성 완료");
    } catch (e) {
      print("데이터베이스 생성 중 오류 발생: $e");
    }
  }

  Future<void> copyDatabaseToDocuments() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'msdl.db');

      final directory = await getApplicationDocumentsDirectory(); // ✅ 외부 저장소
      final newPath = join(directory.path, 'msdl_copy.db'); // 복사될 위치

      final File sourceFile = File(path);
      final File destinationFile = File(newPath);

      if (await sourceFile.exists()) {
        await sourceFile.copy(newPath);
        print("✅ 데이터베이스가 외부 저장소에 복사됨: $newPath");
      } else {
        print("❌ 데이터베이스 파일이 존재하지 않음.");
      }
    } catch (e) {
      print("❌ 데이터베이스 복사 실패: $e");
    }
  }
}
