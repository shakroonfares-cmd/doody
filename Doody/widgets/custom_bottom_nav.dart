// ============================================================
//  widgets/custom_bottom_nav.dart
//
//  A frosted-glass bottom navigation bar with:
//    • Animated active indicator pill
//    • Icon scale + colour animation on selection
//    • Blur backdrop for depth
// ============================================================

import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Data for a single nav tab.
class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavItem> tabs;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return ClipRect(
      child: BackdropFilter(
        // Frosted glass blur
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          height: 68 + bottomPad,
          padding: EdgeInsets.only(bottom: bottomPad),
          decoration: BoxDecoration(
            // Semi-transparent surface colour
            color: AppTheme.surface.withOpacity(0.80),
            border: Border(
              top: BorderSide(
                color: AppTheme.divider.withOpacity(0.6),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: List.generate(tabs.length, (i) {
              final item = tabs[i];
              final bool active = i == currentIndex;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: _NavItemWidget(
                    item: item,
                    active: active,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItemWidget extends StatelessWidget {
  final NavItem item;
  final bool active;

  const _NavItemWidget({required this.item, required this.active});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon container with animated pill background
        AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: active
                ? AppTheme.primary.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              active ? item.activeIcon : item.icon,
              key: ValueKey(active),
              size: active ? 26 : 22,
              color: active ? AppTheme.primary : AppTheme.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 2),
        // Label
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 10,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
            color: active ? AppTheme.primary : AppTheme.textSecondary,
            letterSpacing: 0.3,
          ),
          child: Text(item.label),
        ),
      ],
    );
  }
}
