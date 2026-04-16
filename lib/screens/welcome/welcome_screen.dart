import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/theme/colors.dart';
import '../../widgets/top_bar.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 120),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Symbols.psychology, size: 14, color: AppColors.onSecondaryContainer, fill: 1),
                            const SizedBox(width: 6),
                            Text(
                              'THE COGNITIVE SANCTUARY',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.onSecondaryContainer,
                                    letterSpacing: 1.2,
                                  ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
                      const SizedBox(height: 28),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: 'Learn English '),
                            TextSpan(
                              text: 'smarter',
                              style: TextStyle(color: AppColors.secondary),
                            ),
                            const TextSpan(text: ' with AI.'),
                          ],
                        ),
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 48,
                              height: 1.1,
                              letterSpacing: -1.5,
                            ),
                      ).animate().fadeIn(delay: 200.ms, duration: 800.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 28),
                      Text(
                        'Experience an intelligent atmosphere where language acquisition is fluid, adaptive, and tailored to your unique cognitive profile.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 18,
                              color: AppColors.onSurfaceVariant,
                              height: 1.6,
                            ),
                      ).animate().fadeIn(delay: 400.ms, duration: 800.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => context.go('/placement'),
                              child: const Text('Start for Free'),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context.go('/dashboard'),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                                backgroundColor: AppColors.surfaceContainerLow,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: const Text('View Demo'),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 600.ms, duration: 800.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 40),
                      // User social proof
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 36,
                            child: Stack(
                              children: List.generate(3, (i) {
                                return Positioned(
                                  left: i * 20.0,
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: [Color(0xFFFFB6A3), Color(0xFFA3CBF2), Color(0xFFB5EAD7)][i],
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Joined by 12,000+ learners today',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 800.ms, duration: 800.ms),
                      const SizedBox(height: 60),
                      // Orb Animation Area
                      Center(
                        child: AnimatedOrb(),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Floating Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopBar(
              title: 'Linguist AI',
              rightSlot: TextButton(
                onPressed: () => context.go('/dashboard'),
                child: Text(
                  'Sign In',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedOrb extends StatefulWidget {
  const AnimatedOrb({super.key});

  @override
  State<AnimatedOrb> createState() => _AnimatedOrbState();
}

class _AnimatedOrbState extends State<AnimatedOrb> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Orbits
          ...List.generate(3, (i) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * math.pi * (i + 1) * 0.2 * (i % 2 == 0 ? 1 : -1),
                  child: Container(
                    width: 200.0 + (i * 40.0),
                    height: 200.0 + (i * 40.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.secondary.withOpacity(0.2 - (i * 0.05)),
                        width: 1,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          // Center Orb
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: Color(0x4000263F),
                  blurRadius: 32,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Symbols.record_voice_over, size: 40, color: Colors.white, fill: 1),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                duration: 2.seconds,
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
                curve: Curves.easeInOut,
              ),
        ],
      ),
    );
  }
}
