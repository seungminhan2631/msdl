import 'package:flutter/material.dart';
import 'package:msdl/features/screens/Home/model/workplace_model.dart';
import 'package:msdl/features/screens/Home/repository/WorkplaceRepository.dart';
import 'package:msdl/features/screens/authentication/viewModel/viewModel.dart';
import 'package:provider/provider.dart';

class HomeWorkplaceViewModel extends ChangeNotifier {
  final HomeWorkplaceRepository repository = HomeWorkplaceRepository();
  List<HomeWorkplace> _workplaces = [];
  String selectedCategory = "";

  List<HomeWorkplace> get workplaces => _workplaces;
  String get currentCategory => selectedCategory;

  Future<void> fetchWorkplaces(BuildContext context) async {
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      int? userId = authViewModel.userId;
      if (userId == null) return;

      _workplaces = await repository.fetchUserWorkplaces(userId); // ✅ 서버 데이터 저장

      // ✅ 마지막에 추가된 Workplace의 카테고리를 기본 선택값으로 설정
      if (_workplaces.isNotEmpty) {
        selectedCategory = _workplaces.last.category;
      }

      notifyListeners();
    } catch (e) {
      print("❌ Workplace 데이터 로딩 실패: $e");
    }
  }

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }
}
