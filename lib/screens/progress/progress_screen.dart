import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/theme/colors.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/bottom_nav.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> skills = [
      {'label': 'Grammar', 'value': 0.68, 'color': AppColors.secondary},
      {'label': 'Vocabulary', 'value': 0.45, 'color': AppColors.tertiary},
      {'label': 'Speaking', 'value': 0.82, 'color': const Color(0xFF006573)},
      {'label': 'Writing', 'value': 0.31, 'color': const Color(0xFF1F4A6C)},
      {'label': 'Listening', 'value': 0.59, 'color': AppColors.primary},
    ];

    final List<bool> streak = [true, true, true, false, true, true, false].reversed.toList();
    final List<String> weekLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].reversed.toList();

    return Scaffold(
      appBar: const TopBar(title: 'Your Progress'),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: Column(
                  children: [
                    // Level Card
                    _buildLevelCard(context).animate().fadeIn().slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 24),

                    // Weekly Activity
                    _buildWeeklyActivity(context, streak, weekLabels).animate().delay(100.ms).fadeIn().slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 24),

                    // Skill Breakdown
                    _buildSkillBreakdown(context, skills).animate().delay(150.ms).fadeIn().slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 24),

                    // Achievements
                    _buildAchievements(context).animate().delay(200.ms).fadeIn(),
                  ],
                ),
              ),
            ),
          ),
          const BottomNav(currentRoute: '/progress'),
        ],
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 32, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CURRENT LEVEL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70, letterSpacing: 1.2)),
                    const SizedBox(height: 8),
                    Text('B1', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white, fontSize: 40)),
                    const Text('Intermediate', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ],
                ),
              ),
              Column(
                children: const [
                  Text('1,240', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white)),
                  Text('Total XP', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
              const SizedBox(width: 24),
              Column(
                children: [
                  Row(
                    children: const [
                      Icon(Symbols.local_fire_department, size: 32, color: Color(0xFFFF6B35), fill: 1),
                      SizedBox(width: 4),
                      Text('5', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white)),
                    ],
                  ),
                  const Text('Day Streak', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Progress to B2', style: TextStyle(fontSize: 12, color: Colors.white70)),
              Text('62%', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(height: 6, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(999))),
              FractionallySizedBox(
                widthFactor: 0.62,
                child: Container(height: 6, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyActivity(BuildContext context, List<bool> streak, List<String> labels) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 32, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Activity', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(streak.length, (i) {
              final active = streak[i];
              return Column(
                children: [
                  Container(
                    height: 60,
                    width: 40,
                    decoration: BoxDecoration(
                      gradient: active ? AppColors.secondaryGradient : null,
                      color: active ? null : AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: active ? const Icon(Symbols.check, size: 16, color: Colors.white) : null,
                  ),
                  const SizedBox(height: 8),
                  Text(labels[i], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillBreakdown(BuildContext context, List<Map<String, dynamic>> skills) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 32, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Skill Breakdown', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          ...skills.map((skill) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(skill['label'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        Text('${(skill['value'] * 100).toInt()}%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: skill['color'])),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        Container(height: 8, decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(999))),
                        FractionallySizedBox(
                          widthFactor: skill['value'],
                          child: Container(height: 8, decoration: BoxDecoration(color: skill['color'] as Color, borderRadius: BorderRadius.circular(999))),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildAchievements(BuildContext context) {
    final List<Map<String, dynamic>> badges = [
      {'icon': Symbols.military_tech, 'label': 'First Lesson', 'unlocked': true, 'color': const Color(0xFFFFB300)},
      {'icon': Symbols.local_fire_department, 'label': '3-Day Streak', 'unlocked': true, 'color': const Color(0xFFF44336)},
      {'icon': Symbols.psychology, 'label': 'Grammar Pro', 'unlocked': true, 'color': AppColors.secondary},
      {'icon': Symbols.record_voice_over, 'label': 'Speaker', 'unlocked': false, 'color': AppColors.onSurfaceVariant},
      {'icon': Symbols.auto_stories, 'label': 'Bookworm', 'unlocked': false, 'color': AppColors.onSurfaceVariant},
      {'icon': Symbols.emoji_events, 'label': 'Champion', 'unlocked': false, 'color': AppColors.onSurfaceVariant},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Achievements', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 0.8),
          itemCount: badges.length,
          itemBuilder: (context, i) {
            final badge = badges[i];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16)],
              ),
              child: Opacity(
                opacity: badge['unlocked'] ? 1 : 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: badge['unlocked'] ? (badge['color'] as Color).withOpacity(0.15) : AppColors.surfaceContainerLow,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(badge['icon'] as IconData, size: 24, color: badge['unlocked'] ? (badge['color'] as Color) : AppColors.onSurfaceVariant, fill: 1),
                    ),
                    const SizedBox(height: 10),
                    Text(badge['label'] as String, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: badge['unlocked'] ? AppColors.onSurface : AppColors.onSurfaceVariant)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
