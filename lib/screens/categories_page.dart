import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:globingo/providers/visited_countries_provider.dart';
import 'package:globingo/providers/toast_provider.dart';
import 'package:globingo/services/country_data_service.dart';
import 'package:globingo/services/achievement_service.dart';
import 'package:flutter/services.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  Map<String, List<Map<String, dynamic>>> _categorizedCountries = {};
  List<Achievement> _unlockedAchievements = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _loadCountries();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    final countries = await CountryDataService.getAllCountries();
    _categorizeCountries(countries);
    
    // Initialize achievements
    final notifier = ref.read(visitedCountriesNotifierProvider.notifier);
    _unlockedAchievements = notifier.getUnlockedAchievements(countries);
    
    _animationController.forward();
  }

  void _categorizeCountries(List<Map<String, dynamic>> countries) {
    final categories = CountryDataService.getRegionCategories();
    final categorized = <String, List<Map<String, dynamic>>>{};
    
    for (final category in categories.keys) {
      categorized[category] = [];
    }
    
    for (final country in countries) {
      final region = country['region'] as String;
      if (categories.containsKey(region)) {
        categorized[region]!.add(country);
      }
    }
    
    setState(() {
      _categorizedCountries = categorized;
    });
  }

  @override
  Widget build(BuildContext context) {
    final visitedCountries = ref.watch(visitedCountriesNotifierProvider);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Categories',
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
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _categorizedCountries.length,
                  itemBuilder: (context, index) {
                    final category = _categorizedCountries.keys.elementAt(index);
                    final countries = _categorizedCountries[category]!;
                    final visitedInCategory = countries.where((country) {
                      final countryCode = country['code'].toString().toLowerCase();
                      return visitedCountries.map((code) => code.toLowerCase()).contains(countryCode);
                    }).length;
                    
                    return _buildCategoryCard(
                      category,
                      countries,
                      visitedInCategory,
                      visitedCountries,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    String category,
    List<Map<String, dynamic>> countries,
    int visitedCount,
    List<String> visitedCountries,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            _getCategoryIcon(category),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$visitedCount/${countries.length}',
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        iconColor: Colors.white70,
        collapsedIconColor: Colors.white70,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                childAspectRatio: 0.7,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
                final countryCode = country['code'].toString().toLowerCase();
                final isVisited = visitedCountries.map((code) => code.toLowerCase()).contains(countryCode);
                
                return _buildCountryCard(
                  country,
                  isVisited,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCategoryIcon(String category) {
    IconData iconData;
    Color iconColor;
    
    switch (category) {
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
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildCountryCard(
    Map<String, dynamic> country,
    bool isVisited,
  ) {
    final flag = country['flag'] ?? '🏳️';
    final code = country['code'] ?? '';
    
    return GestureDetector(
      onTap: () async {
        // Haptic feedback
        HapticFeedback.lightImpact();
        
        ref.read(visitedCountriesNotifierProvider.notifier).toggleCountry(code);
        
        // Check for new achievements after a short delay to ensure state is updated
        Future.delayed(const Duration(milliseconds: 100), () async {
          final countries = await CountryDataService.getAllCountries();
          final notifier = ref.read(visitedCountriesNotifierProvider.notifier);
          final newlyUnlocked = notifier.getNewlyUnlockedAchievements(_unlockedAchievements, countries);
          
          if (newlyUnlocked.isNotEmpty) {
            // Stronger haptic feedback for achievements
            HapticFeedback.heavyImpact();
            setState(() {
              _unlockedAchievements = notifier.getUnlockedAchievements(countries);
            });
            
            // Show toasts using global provider
            for (final achievement in newlyUnlocked) {
              ref.read(toastProvider.notifier).showAchievement(achievement);
            }
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Container(
          decoration: BoxDecoration(
            color: isVisited 
                ? Colors.amber[300]!.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isVisited 
                  ? Colors.amber[400]!
                  : Colors.white.withValues(alpha: 0.1),
              width: isVisited ? 2 : 1,
            ),
          ),
          child: Stack(
            children: [
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Flag
                    Text(
                      flag,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    
                    // Country code
                    Text(
                      code.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // Visited indicator
              if (isVisited)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.amber[400],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 6,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 