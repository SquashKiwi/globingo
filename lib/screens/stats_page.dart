import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:globingo/providers/visited_countries_provider.dart';
import 'package:globingo/providers/toast_provider.dart';
import 'package:globingo/services/country_data_service.dart';
import 'package:globingo/services/achievement_service.dart';

class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({super.key});

  @override
  ConsumerState<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  
  List<Map<String, dynamic>> _allCountries = [];
  Map<String, int> _regionalStats = {};
  List<Achievement> _unlockedAchievements = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(_animationController);
    
    // Load data and start animation
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get visited countries
    final visitedCountries = ref.read(visitedCountriesNotifierProvider);
    // Update unlocked achievements
    _unlockedAchievements = AchievementService.checkUnlockedAchievements(
      visitedCountries,
      _allCountries
    );
    // Calculate regional stats
    _calculateStats();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final countries = await CountryDataService.getAllCountries();
    
    if (mounted) {
      setState(() {
        _allCountries = countries;
      });
      
      // Now that countries are loaded, calculate stats
      _calculateStats();
      _animationController.forward();
    }
  }

  void _calculateStats() {
    if (_allCountries.isEmpty) return; // Guard against empty countries
    
    final visitedCountries = ref.read(visitedCountriesNotifierProvider);
    final categories = CountryDataService.getRegionCategories();
    final regionalStats = <String, int>{};
    
    // Initialize all regions to 0 first
    for (final category in categories.keys) {
      regionalStats[category] = 0;
    }

    // Count visited countries by region
    for (final visitedCode in visitedCountries) {
      final country = _allCountries.firstWhere(
        (country) => country['code'].toString().toLowerCase() == visitedCode.toLowerCase(),
        orElse: () => <String, dynamic>{},
      );
      
      if (country.isNotEmpty) {
        final region = country['region'] as String;
        regionalStats[region] = (regionalStats[region] ?? 0) + 1;
      }
    }
    
    setState(() {
      _regionalStats = regionalStats;
      // Also update achievements here since we have the data
      _unlockedAchievements = AchievementService.checkUnlockedAchievements(
        visitedCountries,
        _allCountries
      );
    });
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2d1810),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Reset Progress',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to reset all your visited countries? This action cannot be undone.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(visitedCountriesNotifierProvider.notifier).resetAll();
                _calculateStats();
              },
              child: const Text(
                'Reset',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final visitedCountries = ref.watch(visitedCountriesNotifierProvider);
    final totalCountries = _allCountries.length;
    final visitedCount = visitedCountries.length;
    final percentage = totalCountries > 0 ? (visitedCount / totalCountries * 100) : 0.0;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Your Stats',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1F1F1F),
              Color(0xFF2d1810),
              Color(0xFF171717),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMainStatsCard(visitedCount, totalCountries, percentage),
                        const SizedBox(height: 20),
                        _buildProgressCard(percentage),
                        const SizedBox(height: 20),
                        _buildRegionalStatsCard(),
                        const SizedBox(height: 20),
                        _buildAchievementsCard(visitedCount),
                        const SizedBox(height: 40),
                        _buildResetButton(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainStatsCard(int visitedCount, int totalCountries, double percentage) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.withValues(alpha: 0.2),
            Colors.orange.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Countries Visited',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$visitedCount',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total Countries',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$totalCountries',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '${percentage.toStringAsFixed(1)}% of the world explored',
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(double percentage) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1500),
                height: 12,
                width: MediaQuery.of(context).size.width * 0.8 * (percentage / 100),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.amber, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${percentage.toStringAsFixed(1)}% complete',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionalStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Regional Breakdown',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ..._regionalStats.entries.map((entry) {
            final region = entry.key;
            final visitedCount = entry.value;
            // Calculate total countries in region
            final totalInRegion = _allCountries
              .where((country) => country['region'] == region)
              .length;
            // Calculate percentage with null check
            final percentage = totalInRegion > 0 
              ? (visitedCount / totalInRegion * 100) 
              : 0.0;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  _getRegionIcon(region),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          region,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '$visitedCount/$totalInRegion countries',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _getRegionIcon(String region) {
    IconData iconData;
    Color iconColor;
    
    switch (region) {
      case 'Europe':
        iconData = Icons.location_on;
        iconColor = Colors.blue[300]!;
        break;
      case 'Asia':
        iconData = Icons.landscape;
        iconColor = Colors.green[300]!;
        break;
      case 'Americas':
        iconData = Icons.public;
        iconColor = Colors.red[300]!;
        break;
      case 'Africa':
        iconData = Icons.terrain;
        iconColor = Colors.orange[300]!;
        break;
      case 'Oceania':
        iconData = Icons.water;
        iconColor = Colors.cyan[300]!;
        break;
      default:
        iconData = Icons.flag;
        iconColor = Colors.grey[300]!;
    }
    
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 16,
      ),
    );
  }

  Widget _buildAchievementsCard(int visitedCount) {
    final allAchievements = AchievementService.getAllAchievements();
    final unlockedAchievementIds = _unlockedAchievements.map((a) => a.id).toSet();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Achievements',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...allAchievements.map((achievement) {
            final isUnlocked = unlockedAchievementIds.contains(achievement.id);
            final achievementColor = AchievementService.getAchievementColor(achievement);
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isUnlocked 
                          ? achievementColor.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isUnlocked 
                            ? achievementColor.withValues(alpha: 0.5)
                            : Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        achievement.icon,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (achievement.isHidden && !isUnlocked)
                              const Icon(
                                Icons.visibility_off,
                                color: Colors.white70,
                                size: 14,
                              ),
                            if (achievement.isHidden && !isUnlocked)
                              const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                isUnlocked ? achievement.title : (achievement.isHidden ? 'Hidden Achievement' : achievement.title),
                                style: TextStyle(
                                  color: isUnlocked ? Colors.white : Colors.white70,
                                  fontSize: 16,
                                  fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (isUnlocked || !achievement.isHidden)
                          Text(
                            AchievementService.getAchievementDescription(achievement, isUnlocked),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    isUnlocked ? Icons.emoji_events : Icons.lock,
                    color: isUnlocked ? achievementColor : Colors.white70,
                    size: 20,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildResetButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: ElevatedButton(
          onPressed: _showResetConfirmation,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text(
            'Reset All Visited Countries',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}