import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:globingo/services/achievement_service.dart';

class ToastNotifier extends StateNotifier<List<Achievement>> {
  ToastNotifier() : super([]);

  void showAchievement(Achievement achievement) {
    state = [...state, achievement];
  }

  void dismissAchievement(Achievement achievement) {
    state = state.where((a) => a != achievement).toList();
  }

  void clearAll() {
    state = [];
  }
}

final toastProvider = StateNotifierProvider<ToastNotifier, List<Achievement>>((ref) {
  return ToastNotifier();
}); 