import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:globingo/services/achievement_service.dart';
import 'package:globingo/services/country_data_service.dart';

class VisitedCountriesNotifier extends StateNotifier<List<String>> {
  VisitedCountriesNotifier() : super([]) {
    _loadVisitedCountries();
  }

  static const String _storageKey = 'visited_countries';

  Future<void> _loadVisitedCountries() async {
    final prefs = await SharedPreferences.getInstance();
    final visitedCountries = prefs.getStringList(_storageKey) ?? [];
    state = visitedCountries;
  }

  Future<void> _saveVisitedCountries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, state);
  }

  void toggleCountry(String countryCode) {
    final countryCodeLower = countryCode.toLowerCase();
    final newState = List<String>.from(state);
    
    if (newState.contains(countryCodeLower)) {
      newState.remove(countryCodeLower);
    } else {
      newState.add(countryCodeLower);
    }
    
    state = newState;
    _saveVisitedCountries();
  }

  List<Achievement> getUnlockedAchievements(List<Map<String, dynamic>> allCountries) {
    return AchievementService.checkUnlockedAchievements(state, allCountries);
  }

  List<Achievement> getNewlyUnlockedAchievements(
    List<Achievement> previouslyUnlocked,
    List<Map<String, dynamic>> allCountries,
  ) {
    return AchievementService.getNewlyUnlockedAchievements(
      previouslyUnlocked, 
      state, 
      allCountries
    );
  }

  bool isVisited(String countryCode) {
    return state.contains(countryCode.toLowerCase());
  }

  int get visitedCount => state.length;

  Future<void> resetAll() async {
    state = [];
    await _saveVisitedCountries();
  }
}

final visitedCountriesNotifierProvider = StateNotifierProvider<VisitedCountriesNotifier, List<String>>(
  (ref) => VisitedCountriesNotifier(),
); 