import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:globingo/screens/all_countries_page.dart';
import 'package:globingo/screens/categories_page.dart';
import 'package:globingo/screens/stats_page.dart';
import 'package:globingo/providers/visited_countries_provider.dart';
import 'package:globingo/widgets/global_toast_overlay.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Globingo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2d1810),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'IBM-Plex',
      ),
      home: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AllCountriesPage(),
    const CategoriesPage(),
    const StatsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GlobalToastOverlay(
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1F1F1F),
                const Color(0xFF2d1810),
                const Color(0xFF171717),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.amber[400],
            unselectedItemColor: Colors.white70,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.public),
                label: 'All',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics),
                label: 'Stats',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
