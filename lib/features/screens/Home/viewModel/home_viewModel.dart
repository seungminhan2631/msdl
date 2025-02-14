import 'package:flutter/material.dart';
import 'package:msdl/features/screens/Home/model/home_model.dart';
import 'package:msdl/features/screens/Home/repository/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository = HomeRepository();
  HomeModel? _homeData;

  HomeModel? get homeData => _homeData;

  Future<void> fetchHomeData(int userId) async {
    try {
      _homeData = await _repository.getHomeData(userId);
      // // 🔥 데이터 디버깅 확인
      // print("✅ HomeModel 데이터 가져오기 성공!");
      // print("👤 사용자 이름: ${_homeData?.name}");
      // print("📌 역할: ${_homeData?.role}");
      // print("🟢 출근 상태: ${_homeData?.isCheckedIn}");
      // print("📍 근무 위치: ${_homeData?.workLocation}");
      // print("📅 근무 카테고리: ${_homeData?.workCategory}");
      // print("📊 주간 출근 기록: ${_homeData?.weeklyTimeline}");

      notifyListeners();
    } catch (e) {
      debugPrint("⚠️ Error fetching home data: $e");
    }
  }
}
