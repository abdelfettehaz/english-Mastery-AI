import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/colors.dart';

class BottomNav extends StatelessWidget {
  final String currentRoute;

  const BottomNav({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'id': '/dashboard', 'icon': Symbols.home, 'label': 'Home'},
      {'id': '/lesson', 'icon': Symbols.menu_book, 'label': 'Learn'},
      {'id': '/chat', 'icon': Symbols.smart_toy, 'label': 'AI Tutor'},
      {'id': '/progress', 'icon': Symbols.trending_up, 'label': 'Progress'},
      {'id': '/exam', 'icon': Symbols.quiz, 'label': 'Exam'},
    ];

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 85,
        borderRadius: 24,
        blur: 20,
        alignment: Alignment.center,
        border: 1,
        linearGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surfaceContainerLow.withOpacity(0.85),
            AppColors.surfaceContainerLow.withOpacity(0.95),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            AppColors.outlineVariant.withOpacity(0.2),
            AppColors.outlineVariant.withOpacity(0.1),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) {
            final isSelected = currentRoute == item['id'];
            return InkWell(
              onTap: () => context.go(item['id'] as String),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryFixedDim.withOpacity(0.3) : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      size: 24,
                      color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                      fill: isSelected ? 1 : 0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
