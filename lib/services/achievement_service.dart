import 'package:flutter/material.dart';
import 'package:globingo/services/country_data_service.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isHidden;
  final int requiredCount;
  final String? category;
  final String? riskLevel;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isHidden = false,
    required this.requiredCount,
    this.category,
    this.riskLevel,
  });
}

class AchievementService {
  static List<Achievement> getRegularAchievements() {
    return [
      Achievement(
        id: 'first_steps',
        title: 'First Steps',
        description: 'Visit 1 country',
        icon: '🚶',
        requiredCount: 1,
      ),
      Achievement(
        id: 'explorer',
        title: 'Explorer',
        description: 'Visit 5 countries',
        icon: '🧭',
        requiredCount: 5,
      ),
      Achievement(
        id: 'adventurer',
        title: 'Adventurer',
        description: 'Visit 10 countries',
        icon: '🗺️',
        requiredCount: 10,
      ),
      Achievement(
        id: 'globetrotter',
        title: 'Globetrotter',
        description: 'Visit 25 countries',
        icon: '✈️',
        requiredCount: 25,
      ),
      Achievement(
        id: 'world_traveler',
        title: 'World Traveler',
        description: 'Visit 50 countries',
        icon: '🌍',
        requiredCount: 50,
      ),
      Achievement(
        id: 'master_explorer',
        title: 'Master Explorer',
        description: 'Visit 100 countries',
        icon: '👑',
        requiredCount: 100,
      ),
      Achievement(
        id: 'europe_explorer',
        title: 'European Explorer',
        description: 'Visit 10 European countries',
        icon: '🏛️',
        requiredCount: 10,
        category: 'Europe',
      ),
      Achievement(
        id: 'asia_explorer',
        title: 'Asian Explorer',
        description: 'Visit 10 Asian countries',
        icon: '🏮',
        requiredCount: 10,
        category: 'Asia',
      ),
      Achievement(
        id: 'americas_explorer',
        title: 'Americas Explorer',
        description: 'Visit 10 American countries',
        icon: '🗽',
        requiredCount: 10,
        category: 'Americas',
      ),
      Achievement(
        id: 'africa_explorer',
        title: 'African Explorer',
        description: 'Visit 10 African countries',
        icon: '🦁',
        requiredCount: 10,
        category: 'Africa',
      ),
      Achievement(
        id: 'oceania_explorer',
        title: 'Oceanian Explorer',
        description: 'Visit 5 Oceanian countries',
        icon: '🏝️',
        requiredCount: 5,
        category: 'Oceania',
      ),
    ];
  }

  static List<Achievement> getHiddenAchievements() {
    return [
      Achievement(
        id: 'risk_taker',
        title: 'Risk Taker',
        description: 'You ventured into a medium-risk country! Countries like Mexico, Philippines, or Venezuela are known for their challenges but you faced them bravely.',
        icon: '⚡',
        isHidden: true,
        requiredCount: 1,
        riskLevel: 'medium',
      ),
      Achievement(
        id: 'danger_seeker',
        title: 'Danger Seeker',
        description: 'You visited a high-risk country! Places like Iraq, Pakistan, or Sudan are known for their dangerous conditions, but your adventurous spirit prevailed.',
        icon: '⚠️',
        isHidden: true,
        requiredCount: 1,
        riskLevel: 'high',
      ),
      Achievement(
        id: 'extreme_adventurer',
        title: 'Extreme Adventurer',
        description: 'You survived an extreme-risk country! Afghanistan, Syria, Yemen, or Somalia are among the most dangerous places on Earth. You truly are fearless!',
        icon: '☠️',
        isHidden: true,
        requiredCount: 1,
        riskLevel: 'extreme',
      ),
      Achievement(
        id: 'war_zone_explorer',
        title: 'War Zone Explorer',
        description: 'You\'ve visited 3 extreme-risk countries! You\'ve walked through active war zones and conflict areas. Your survival skills are legendary!',
        icon: '💥',
        isHidden: true,
        requiredCount: 3,
        riskLevel: 'extreme',
      ),
      Achievement(
        id: 'survival_expert',
        title: 'Survival Expert',
        description: 'You\'ve visited 5 high-risk or extreme-risk countries! You\'ve mastered the art of traveling in dangerous territories. Few can match your courage!',
        icon: '🛡️',
        isHidden: true,
        requiredCount: 5,
        riskLevel: 'high+',
      ),
      Achievement(
        id: 'no_fear',
        title: 'No Fear',
        description: 'You\'ve visited 10 dangerous countries! You have absolutely no fear and have proven yourself as the ultimate risk-taker. You are truly unstoppable!',
        icon: '😈',
        isHidden: true,
        requiredCount: 10,
        riskLevel: 'any',
      ),
    ];
  }

  static List<Achievement> getAllAchievements() {
    return [...getRegularAchievements(), ...getHiddenAchievements()];
  }

  static List<Achievement> checkUnlockedAchievements(
    List<String> visitedCountries,
    List<Map<String, dynamic>> allCountries,
  ) {
    final allAchievements = getAllAchievements();
    final unlockedAchievements = <Achievement>[];

    for (final achievement in allAchievements) {
      if (_isAchievementUnlocked(achievement, visitedCountries, allCountries)) {
        unlockedAchievements.add(achievement);
      }
    }

    return unlockedAchievements;
  }

  static bool _isAchievementUnlocked(
    Achievement achievement,
    List<String> visitedCountries,
    List<Map<String, dynamic>> allCountries,
  ) {
    final visitedCount = visitedCountries.length;

    // Regular count-based achievements
    if (achievement.category == null && achievement.riskLevel == null) {
      return visitedCount >= achievement.requiredCount;
    }

    // Category-based achievements
    if (achievement.category != null) {
      final categoryCountries = allCountries
          .where((country) => country['region'] == achievement.category)
          .map((country) => country['code'].toString().toLowerCase())
          .toList();
      
      final visitedInCategory = visitedCountries
          .where((code) => categoryCountries.contains(code))
          .length;
      
      return visitedInCategory >= achievement.requiredCount;
    }

    // Risk-based achievements
    if (achievement.riskLevel != null) {
      final dangerousCountries = CountryDataService.getDangerousCountries();
      final visitedDangerousCountries = visitedCountries
          .where((code) => dangerousCountries.containsKey(code.toUpperCase()))
          .toList();

      if (achievement.riskLevel == 'any') {
        return visitedDangerousCountries.length >= achievement.requiredCount;
      }

      if (achievement.riskLevel == 'high+') {
        final highRiskCountries = visitedDangerousCountries
            .where((code) {
              final country = dangerousCountries[code.toUpperCase()];
              return country != null && 
                     (country['risk'] == 'high' || country['risk'] == 'extreme');
            })
            .length;
        return highRiskCountries >= achievement.requiredCount;
      }

      final specificRiskCountries = visitedDangerousCountries
          .where((code) {
            final country = dangerousCountries[code.toUpperCase()];
            return country != null && country['risk'] == achievement.riskLevel;
          })
          .length;
      
      return specificRiskCountries >= achievement.requiredCount;
    }

    return false;
  }

  static List<Achievement> getNewlyUnlockedAchievements(
    List<Achievement> previouslyUnlocked,
    List<String> visitedCountries,
    List<Map<String, dynamic>> allCountries,
  ) {
    final currentlyUnlocked = checkUnlockedAchievements(visitedCountries, allCountries);
    final previouslyUnlockedIds = previouslyUnlocked.map((a) => a.id).toSet();
    
    return currentlyUnlocked
        .where((achievement) => !previouslyUnlockedIds.contains(achievement.id))
        .toList();
  }

  static String getAchievementDescription(Achievement achievement, bool isUnlocked) {
    if (achievement.isHidden && !isUnlocked) {
      return 'Hidden Achievement Unlocked!';
    }
    return achievement.description;
  }

  static Color getAchievementColor(Achievement achievement) {
    if (achievement.isHidden) {
      switch (achievement.riskLevel) {
        case 'extreme':
          return Colors.red;
        case 'high':
          return Colors.orange;
        case 'medium':
          return Colors.yellow;
        case 'high+':
          return Colors.deepOrange;
        case 'any':
          return Colors.purple;
        default:
          return Colors.amber;
      }
    }
    return Colors.amber;
  }
} 