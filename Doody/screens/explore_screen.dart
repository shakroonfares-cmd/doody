// ============================================================
//  screens/explore_screen.dart — Page 2
// ============================================================

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  static const _items = [
    _ExploreItem('🌿', 'Green Forest', 'Peaceful meadow biome', AppTheme.primary),
    _ExploreItem('🏜️', 'Sandy Dunes', 'Warm desert adventure', AppTheme.accent),
    _ExploreItem('🌊', 'Ocean Depths', 'Underwater exploration', AppTheme.secondary),
    _ExploreItem('🏔️', 'Snow Peaks', 'Frosty mountain trails', Colors.lightBlue),
    _ExploreItem('🌋', 'Lava Fields', 'Extreme heat zone', AppTheme.danger),
    _ExploreItem('🌸', 'Cherry Blossom', 'Serene garden biome', Colors.pink),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Explore', style: AppTheme.displayLarge),
                    const SizedBox(height: 4),
                    Text('Discover new worlds', style: AppTheme.bodyMedium),
                    const SizedBox(height: 20),
                    // Search bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.divider),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: AppTheme.textSecondary,
                              size: 20),
                          const SizedBox(width: 10),
                          Text('Search biomes…',
                              style: AppTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.9,
                children: _items.map((e) => _BiomeCard(item: e)).toList(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _ExploreItem {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;

  const _ExploreItem(this.emoji, this.title, this.subtitle, this.color);
}

class _BiomeCard extends StatelessWidget {
  final _ExploreItem item;
  const _BiomeCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: item.color.withOpacity(0.25)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.card,
            item.color.withOpacity(0.08),
          ],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item.emoji, style: const TextStyle(fontSize: 36)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title,
                  style: AppTheme.headlineMedium.copyWith(fontSize: 15)),
              const SizedBox(height: 4),
              Text(item.subtitle, style: AppTheme.bodyMedium.copyWith(fontSize: 11)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Visit →',
                  style: TextStyle(
                      color: item.color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
