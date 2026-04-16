import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../core/theme/colors.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? rightSlot;

  const TopBar({
    super.key,
    required this.title,
    this.onBack,
    this.rightSlot,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 70 + MediaQuery.of(context).padding.top,
      borderRadius: 0,
      blur: 20,
      alignment: Alignment.bottomCenter,
      border: 0,
      linearGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.surface.withOpacity(0.8),
          AppColors.surface.withOpacity(0.6),
        ],
      ),
      borderGradient: const LinearGradient(
        colors: [Colors.transparent, Colors.transparent],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            if (onBack != null)
              IconButton(
                onPressed: onBack,
                icon: const Icon(Symbols.arrow_back, color: AppColors.onSurface),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerLow.withOpacity(0.5),
                ),
              ),
            if (onBack != null) const SizedBox(width: 12),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Symbols.auto_awesome, size: 20, color: Colors.white, fill: 1),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    letterSpacing: -0.5,
                  ),
            ),
            const Spacer(),
            if (rightSlot != null) rightSlot!,
          ],
        ),
      ),
    );
  }
}
