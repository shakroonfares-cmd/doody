// ============================================================
//  screens/garden_screen.dart — Page 3
// ============================================================

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GardenScreen extends StatefulWidget {
  const GardenScreen({super.key});

  @override
  State<GardenScreen> createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> {
  final List<_Plant> _plants = [
    _Plant('🌱', 'Sprout', 12, AppTheme.primary),
    _Plant('🌻', 'Sunflower', 68, AppTheme.accent),
    _Plant('🍄', 'Mushroom', 45, AppTheme.danger),
    _Plant('🌺', 'Hibiscus', 90, Colors.pink),
    _Plant('🌵', 'Cactus', 33, const Color(0xFF34D399)),
    _Plant('🫐', 'Blueberry', 77, AppTheme.secondary),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Garden', style: AppTheme.displayLarge),
              Text('Grow & nurture your plants', style: AppTheme.bodyMedium),
              const SizedBox(height: 24),

              // Weather bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Row(
                  children: [
                    const Text('☀️', style: TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Perfect growing day!',
                            style: AppTheme.headlineMedium
                                .copyWith(fontSize: 14)),
                        Text('24°C · Sunny · +15% growth',
                            style: AppTheme.bodyMedium),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Your Plants',
                  style: AppTheme.headlineMedium.copyWith(fontSize: 16)),
              const SizedBox(height: 12),

              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _plants.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _PlantTile(
                    plant: _plants[i],
                    onWater: () => setState(
                        () => _plants[i] = _plants[i].watered()),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _Plant {
  final String emoji;
  final String name;
  final int health;
  final Color color;
  const _Plant(this.emoji, this.name, this.health, this.color);
  _Plant watered() => _Plant(
      emoji, name, (health + 10).clamp(0, 100), color);
}

class _PlantTile extends StatelessWidget {
  final _Plant plant;
  final VoidCallback onWater;
  const _PlantTile({required this.plant, required this.onWater});

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
          Text(plant.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plant.name,
                    style: AppTheme.headlineMedium.copyWith(fontSize: 14)),
                const SizedBox(height: 6),
                Stack(
                  children: [
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppTheme.divider,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    AnimatedFractionallySizedBox(
                      duration: const Duration(milliseconds: 400),
                      widthFactor: plant.health / 100,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: plant.color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text('${plant.health}% health', style: AppTheme.bodyMedium.copyWith(fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onWater,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: plant.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('💧', style: const TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
