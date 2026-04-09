// ============================================================
//  screens/profile_screen.dart — Page 5
// ============================================================

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _achievements = [
    _Achievement('🏆', 'First Steps', 'Played for the first time'),
    _Achievement('💯', 'Century', 'Reached level 100'),
    _Achievement('🌟', 'Star Player', 'Won 10 mini-games'),
    _Achievement('🤝', 'Social Butterfly', 'Made 5 friends'),
    _Achievement('🎭', 'Actor', 'Triggered all 3 animations'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🐛',
                            style: TextStyle(fontSize: 42)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text('WormMaster',
                        style: AppTheme.displayLarge.copyWith(fontSize: 22)),
                    const SizedBox(height: 4),
                    Text('Level 12 · Explorer',
                        style: AppTheme.bodyMedium),
                    const SizedBox(height: 20),

                    // XP bar
                    _XpBar(current: 680, max: 1000),
                    const SizedBox(height: 24),

                    // Stats row
                    Row(
                      children: const [
                        _ProfileStat('12', 'Level', AppTheme.primary),
                        _ProfileStat('87%', 'Mood', AppTheme.accent),
                        _ProfileStat('5', 'Friends', AppTheme.secondary),
                        _ProfileStat('3', 'Biomes', AppTheme.danger),
                      ],
                    ),
                    const SizedBox(height: 28),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Achievements',
                          style: AppTheme.headlineMedium),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _AchievementTile(a: _achievements[i]),
                  ),
                  childCount: _achievements.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _XpBar extends StatelessWidget {
  final int current;
  final int max;
  const _XpBar({required this.current, required this.max});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('XP Progress', style: AppTheme.bodyMedium),
            Text('$current / $max',
                style: AppTheme.bodyMedium
                    .copyWith(color: AppTheme.primary, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: AppTheme.divider,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            FractionallySizedBox(
              widthFactor: current / max,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _ProfileStat(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(value,
                style: AppTheme.headlineMedium.copyWith(
                    color: color, fontSize: 18)),
            const SizedBox(height: 2),
            Text(label,
                style: AppTheme.bodyMedium.copyWith(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _Achievement {
  final String emoji;
  final String title;
  final String desc;
  const _Achievement(this.emoji, this.title, this.desc);
}

class _AchievementTile extends StatelessWidget {
  final _Achievement a;
  const _AchievementTile({required this.a});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(a.emoji,
                  style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(a.title,
                  style:
                      AppTheme.headlineMedium.copyWith(fontSize: 14)),
              Text(a.desc, style: AppTheme.bodyMedium.copyWith(fontSize: 12)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.check_circle_rounded,
              color: AppTheme.primary, size: 20),
        ],
      ),
    );
  }
}
