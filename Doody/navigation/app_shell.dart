// ============================================================
//  navigation/app_shell.dart
//
//  Root shell — owns the PageView and BottomNavBar.
//  Both horizontal swipe (via PageView) and tapping the nav
//  bar are kept in sync through a single PageController.
// ============================================================

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../screens/home_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/garden_screen.dart';
import '../screens/shop_screen.dart';
import '../screens/profile_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_bottom_nav.dart';

/// Metadata for each tab entry.
class _TabMeta {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _TabMeta({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

const _tabs = [
  _TabMeta(
    label: 'Home',
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
  ),
  _TabMeta(
    label: 'Explore',
    icon: Icons.explore_outlined,
    activeIcon: Icons.explore,
  ),
  _TabMeta(
    label: 'Garden',
    icon: Icons.eco_outlined,
    activeIcon: Icons.eco,
  ),
  _TabMeta(
    label: 'Shop',
    icon: Icons.shopping_bag_outlined,
    activeIcon: Icons.shopping_bag,
  ),
  _TabMeta(
    label: 'Profile',
    icon: Icons.person_outline_rounded,
    activeIcon: Icons.person_rounded,
  ),
];

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // Single source of truth for the current page index.
  int _currentIndex = 0;

  // PageController drives both swipe and programmatic jumps.
  late final PageController _pageCtrl;

  // The five page widgets — created once and kept alive.
  static final List<Widget> _pages = const [
    HomeScreen(),
    ExploreScreen(),
    GardenScreen(),
    ShopScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(initialPage: 0);

    // Keep _currentIndex in sync when the user swipes manually.
    _pageCtrl.addListener(() {
      final page = _pageCtrl.page?.round() ?? 0;
      if (page != _currentIndex) {
        setState(() => _currentIndex = page);
      }
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  /// Called when the user taps a nav item — animates the page.
  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    _pageCtrl.animateToPage(
      index,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Extend body behind the nav bar for the gradient to show through.
      extendBody: true,
      body: PageView(
        controller: _pageCtrl,
        // Smooth physics — same feel as iOS home screen swipe.
        physics: const BouncingScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        tabs: _tabs
            .map((t) => NavItem(
                  label: t.label,
                  icon: t.icon,
                  activeIcon: t.activeIcon,
                ))
            .toList(),
      ),
    );
  }
}
