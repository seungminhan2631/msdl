import 'package:flutter/material.dart';
import 'package:msdl/features/authentication/viewModel/viewModel.dart';
import 'package:provider/provider.dart';
import '../model/workplace_model.dart';
import '../repository/workplace_repository.dart';

class WorkplaceViewModel extends ChangeNotifier {
  final WorkplaceRepository _repository;
  Workplace? _workplace;
  bool _isLoading = false;

  WorkplaceViewModel(this._repository);

  Workplace? get workplace => _workplace;
  bool get isLoading => _isLoading;

  // ✅ 특정 유저의 Workplace 데이터 가져오기
  Future<void> fetchUserWorkplace(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _workplace = await _repository.fetchUserWorkplace(userId);
    } catch (e) {
      print("❌ Workplace 데이터를 불러오는 중 오류 발생: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ AuthViewModel에서 userId를 가져와 Workplace 업데이트
  Future<void> updateUserWorkplace(
      BuildContext context, String location, String category) async {
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      int? userId = authViewModel.userId;

      if (userId == null) {
        print("❌ 오류: userId가 null입니다. Workplace 추가 불가");
        return;
      }

      await _repository.updateUserWorkplace(userId, location, category);

      // ✅ Workplace 데이터 갱신
      _workplace = Workplace(
        id: userId,
        userId: userId,
        currentLocation: location,
        category: category,
      );
      notifyListeners();

      print("✅ Workplace 업데이트 완료!");
    } catch (e) {
      print("❌ Workplace 업데이트 실패: $e");
    }
  }

  // ✅ 특정 유저의 Workplace 추가 (이제 UI에서 직접 호출할 필요 없음)
  Future<void> addWorkPlace(
      BuildContext context, String location, String category) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    int? userId = authViewModel.userId;

    if (userId == null) {
      print("❌ 오류: userId가 null입니다. Workplace 추가 불가");
      return;
    }

    print("📡 userId: $userId");
    print("📡 현재 주소 (Flutter): $location");

    try {
      print("📡 서버로 Workplace 추가 요청 시작...");
      await _repository.updateUserWorkplace(userId, location, category);

      // ✅ Workplace 업데이트 후 데이터 갱신
      _workplace = Workplace(
          id: userId,
          userId: userId,
          currentLocation: location,
          category: category);
      notifyListeners();

      print("✅ Workplace 추가 및 동기화 완료!");
    } catch (e) {
      print("❌ Workplace 업데이트 실패: $e");
    }
  }
}
