// ============================================================
//  screens/shop_screen.dart — Page 4
// ============================================================

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _coins = 340;
  final List<_ShopItem> _items = [
    _ShopItem('🎩', 'Top Hat', 'Fancy headwear', 80, AppTheme.secondary),
    _ShopItem('🕶️', 'Cool Shades', 'Look stylish', 60, AppTheme.accent),
    _ShopItem('🌈', 'Rainbow Skin', 'Colourful body', 150, AppTheme.primary),
    _ShopItem('⚡', 'Speed Boost', '+20% movement', 120, Colors.yellow),
    _ShopItem('💎', 'Diamond Aura', 'Rare glow effect', 200, Colors.cyan),
    _ShopItem('🦋', 'Butterfly Wings', 'Soar freely', 95, Colors.pink),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shop', style: AppTheme.displayLarge),
                  // Coin balance
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppTheme.accent.withOpacity(0.35)),
                    ),
                    child: Row(
                      children: [
                        const Text('🪙', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 6),
                        Text('$_coins',
                            style: TextStyle(
                              color: AppTheme.accent,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              Text('Customize your worm', style: AppTheme.bodyMedium),
              const SizedBox(height: 20),

              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _items.length,
                  itemBuilder: (_, i) => _ShopCard(
                    item: _items[i],
                    onBuy: _coins >= _items[i].price
                        ? () => setState(() {
                              _coins -= _items[i].price;
                            })
                        : null,
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

class _ShopItem {
  final String emoji;
  final String name;
  final String desc;
  final int price;
  final Color color;
  const _ShopItem(this.emoji, this.name, this.desc, this.price, this.color);
}

class _ShopCard extends StatelessWidget {
  final _ShopItem item;
  final VoidCallback? onBuy;
  const _ShopCard({required this.item, this.onBuy});

  @override
  Widget build(BuildContext context) {
    final bool canAfford = onBuy != null;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: item.color.withOpacity(canAfford ? 0.3 : 0.1)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.card,
            item.color.withOpacity(0.07),
          ],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item.emoji, style: const TextStyle(fontSize: 38)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name,
                  style: AppTheme.headlineMedium.copyWith(fontSize: 14)),
              Text(item.desc,
                  style: AppTheme.bodyMedium.copyWith(fontSize: 11)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onBuy,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: canAfford
                        ? item.color.withOpacity(0.18)
                        : AppTheme.divider,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🪙',
                          style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        '${item.price}',
                        style: TextStyle(
                          color: canAfford
                              ? item.color
                              : AppTheme.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
