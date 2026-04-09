// ============================================================
//  screens/home_screen.dart
//
//  The primary screen:
//    • Gradient background
//    • Interactive 3-D worm widget
//    • Quick-stat cards below
//    • Reacts to worm state changes (colour-tints the status bar)
// ============================================================

import 'package:flutter/material.dart';
import '../models/worm_animation_state.dart';
import '../theme/app_theme.dart';
import '../widgets/worm_3d_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WormAnimationState _wormState = WormAnimationState.idle;

  // Background gradient shifts with the worm's mood
  LinearGradient get _bgGradient {
    switch (_wormState) {
      case WormAnimationState.idle:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D0F1A), Color(0xFF111827), Color(0xFF0A0E1A)],
        );
      case WormAnimationState.happy:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0D0F1A),
            AppTheme.accent.withOpacity(0.18),
            const Color(0xFF0A0E1A),
          ],
        );
      case WormAnimationState.sad:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0D0F1A),
            AppTheme.secondary.withOpacity(0.15),
            const Color(0xFF0A0E1A),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(gradient: _bgGradient),
      child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── App bar ─────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Worm World',
                          style: AppTheme.displayLarge.copyWith(fontSize: 26),
                        ),
                        Text(
                          'Your little companion awaits',
                          style: AppTheme.bodyMedium,
                        ),
                      ],
                    ),
                    // Mood badge
                    _MoodBadge(state: _wormState),
                  ],
                ),
              ),
            ),

            // ── Worm section ─────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 28),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 28, 16, 20),
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: AppTheme.divider.withOpacity(0.5),
                      width: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Worm3DWidget(
                    onStateChanged: (s) => setState(() => _wormState = s),
                  ),
                ),
              ),
            ),

            // ── Instruction banner ───────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _InstructionBanner(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Stat cards ──────────────────────────────
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.45,
                children: const [
                  _StatCard(
                    label: 'Happiness',
                    value: '87%',
                    icon: Icons.sentiment_very_satisfied_rounded,
                    color: AppTheme.primary,
                  ),
                  _StatCard(
                    label: 'Energy',
                    value: '64%',
                    icon: Icons.bolt_rounded,
                    color: AppTheme.accent,
                  ),
                  _StatCard(
                    label: 'Level',
                    value: '12',
                    icon: Icons.star_rounded,
                    color: AppTheme.secondary,
                  ),
                  _StatCard(
                    label: 'Friends',
                    value: '5',
                    icon: Icons.people_rounded,
                    color: AppTheme.danger,
                  ),
                ],
              ),
            ),

            // Bottom padding (accounts for nav bar)
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

// ── Widgets ─────────────────────────────────────────────────

class _MoodBadge extends StatelessWidget {
  final WormAnimationState state;
  const _MoodBadge({required this.state});

  String get _emoji {
    switch (state) {
      case WormAnimationState.idle:  return '😌';
      case WormAnimationState.happy: return '🎉';
      case WormAnimationState.sad:   return '😢';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(state),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Text(_emoji, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}

class _InstructionBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.primary.withOpacity(0.20)),
      ),
      child: Row(
        children: [
          Icon(Icons.touch_app_rounded,
              color: AppTheme.primary.withOpacity(0.8), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tap the HEAD for happy · Tap the BODY for sad · Swipe left/right to navigate',
              style: TextStyle(
                fontSize: 11.5,
                color: AppTheme.primary.withOpacity(0.85),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: AppTheme.headlineMedium.copyWith(fontSize: 22)),
              Text(label, style: AppTheme.bodyMedium.copyWith(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
