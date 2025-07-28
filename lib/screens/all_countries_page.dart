import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:globingo/providers/visited_countries_provider.dart';
import 'package:globingo/providers/toast_provider.dart';
import 'package:globingo/services/country_data_service.dart';
import 'package:globingo/services/achievement_service.dart';
import 'package:flutter/services.dart';

class AllCountriesPage extends ConsumerStatefulWidget {
  const AllCountriesPage({super.key});

  @override
  ConsumerState<AllCountriesPage> createState() => _AllCountriesPageState();
}

class _AllCountriesPageState extends ConsumerState<AllCountriesPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredCountries = [];
  List<Map<String, dynamic>> _allCountries = [];
  List<Achievement> _unlockedAchievements = [];
  bool _showOnlyVisited = false;

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
    setState(() {
      _allCountries = countries;
      _filteredCountries = countries;
    });
    
    // Initialize achievements
    final notifier = ref.read(visitedCountriesNotifierProvider.notifier);
    _unlockedAchievements = notifier.getUnlockedAchievements(countries);
    
    _animationController.forward();
  }

  void _filterCountries(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _applyFilters() {
    final visitedCountries = ref.read(visitedCountriesNotifierProvider);
    
    var filtered = _allCountries;
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((country) {
        final name = country['name'].toString().toLowerCase();
        final code = country['code'].toString().toLowerCase();
        final queryLower = _searchQuery.toLowerCase();
        return name.contains(queryLower) || code.contains(queryLower);
      }).toList();
    }
    
    // Apply visited filter
    if (_showOnlyVisited) {
      filtered = filtered.where((country) {
        final countryCode = country['code'].toString().toLowerCase();
        final visitedLower = visitedCountries.map((code) => code.toLowerCase()).toSet();
        return visitedLower.contains(countryCode);
      }).toList();
    }
    
    setState(() {
      _filteredCountries = filtered;
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
          'All Countries',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // Test button for achievement toast
          IconButton(
            icon: const Icon(Icons.emoji_events, color: Colors.amber),
            onPressed: () async {
              HapticFeedback.mediumImpact();
              final testAchievement = AchievementService.getRegularAchievements().first;
              ref.read(toastProvider.notifier).showAchievement(testAchievement);
            },
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _showOnlyVisited = !_showOnlyVisited;
                _applyFilters();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _showOnlyVisited 
                    ? Colors.green.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _showOnlyVisited 
                      ? Colors.green.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Text(
                '${visitedCountries.length} visited',
                style: TextStyle(
                  color: _showOnlyVisited ? Colors.green[100] : Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
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
          child: Column(
            children: [
              const SizedBox(height: kToolbarHeight + 20),
              
              // Search Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        onChanged: _filterCountries,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Search countries...',
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Countries Grid
              Expanded(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                          itemCount: _filteredCountries.length,
                          itemBuilder: (context, index) {
                            final country = _filteredCountries[index];
                            final countryCode = country['code'].toString().toLowerCase();
                            final isVisited = visitedCountries.map((code) => code.toLowerCase()).contains(countryCode);
                            
                            return _buildCountryCard(
                              country,
                              isVisited,
                              index,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountryCard(
    Map<String, dynamic> country,
    bool isVisited,
    int index,
  ) {
    final flag = country['flag'] ?? '🏳️';
    final name = country['name'] ?? 'Unknown';
    final code = country['code'] ?? '';
    
    return GestureDetector(
      onTap: () async {
        // Haptic feedback
        HapticFeedback.lightImpact();
        
        ref.read(visitedCountriesNotifierProvider.notifier).toggleCountry(code);
        
        // Check for new achievements after a short delay to ensure state is updated
        Future.delayed(const Duration(milliseconds: 100), () {
          final notifier = ref.read(visitedCountriesNotifierProvider.notifier);
          final newlyUnlocked = notifier.getNewlyUnlockedAchievements(_unlockedAchievements, _allCountries);
          
          if (newlyUnlocked.isNotEmpty) {
            // Stronger haptic feedback for achievements
            HapticFeedback.heavyImpact();
            setState(() {
              _unlockedAchievements = notifier.getUnlockedAchievements(_allCountries);
            });
            
            // Show toasts using global provider
            for (final achievement in newlyUnlocked) {
              ref.read(toastProvider.notifier).showAchievement(achievement);
            }
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.elasticOut,
        child: Container(
          decoration: BoxDecoration(
            color: isVisited 
                ? Colors.amber[300]!.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isVisited 
                  ? Colors.amber[400]!
                  : Colors.white.withValues(alpha: 0.2),
              width: isVisited ? 2 : 1,
            ),
            boxShadow: isVisited ? [
              BoxShadow(
                color: Colors.amber[400]!.withValues(alpha: 0.6),
                blurRadius: 8,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.amber[300]!.withValues(alpha: 0.4),
                blurRadius: 16,
                spreadRadius: 4,
              ),
            ] : null,
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
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    // Country code
                    Text(
                      code,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Visited indicator
              if (isVisited)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.amber[400],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber[400]!.withValues(alpha: 0.6),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 8,
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