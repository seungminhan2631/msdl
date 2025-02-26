import 'package:flutter/material.dart';
import 'package:msdl/features/screens/Group/viewModel/viewModel.dart';
import 'package:msdl/features/screens/Home/viewModel/home_viewModel.dart';
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

  Future<void> updateUserWorkplace(int userId, String location, String category,
      BuildContext context) async {
    try {
      await _repository.updateUserWorkplace(userId, location, category);

      // ✅ Workplace 업데이트 후 ViewModel 데이터 갱신
      _workplace = Workplace(
          id: userId,
          userId: userId,
          currentLocation: location,
          category: category);
      notifyListeners();

      // ✅ HomeScreen 데이터 동기화
      await Provider.of<HomeViewModel>(context, listen: false)
          .fetchHomeData(context);

      // ✅ GroupScreen 데이터 동기화
      await Provider.of<GroupViewModel>(context, listen: false)
          .fetchGroupUsers();

      print("✅ Workplace 추가 후 HomeScreen & GroupScreen 동기화 완료!");
    } catch (e) {
      print("❌ Workplace 업데이트 실패: $e");
    }
  }
}
