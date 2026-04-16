import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/bottom_nav.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: 'Linguist AI',
        rightSlot: CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primaryContainer,
          child: const Icon(Symbols.person, size: 20, color: Colors.white, fill: 1),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, Ahmed 👋',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 32, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 6),
                        const Text('Ready to refine your cognitive fluency today?', style: TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant)),
                      ],
                    ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 28),

                    // Daily Progress Card
                    _buildDailyProgress(context).animate().delay(100.ms).fadeIn().slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 24),

                    // Quick Actions
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildActionButton(context, 'Start Lesson', Symbols.play_circle, AppColors.primaryGradient, () => context.go('/lesson')),
                        _buildActionButton(context, 'AI Tutor', Symbols.smart_toy, null, () => context.go('/chat'), isSecondary: true),
                        _buildActionButton(context, 'Notes', Symbols.description, null, () => context.go('/notes'), isGhost: true),
                      ],
                    ).animate().delay(150.ms).fadeIn().slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 32),

                    // Focused Disciplines
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceOfBetween,
                      children: [
                        Text('Focused Disciplines', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                        TextButton(onPressed: () {}, child: const Text('View All')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.85,
                      children: [
                        _buildModuleCard(context, 'Grammar', 'Tense Mastery', 0.68, Symbols.spellcheck, AppColors.secondary, const Color(0x3358E6FF)),
                        _buildModuleCard(context, 'Vocabulary', 'Word Power', 0.45, Symbols.library_books, AppColors.tertiary, const Color(0x33E9DDFF)),
                        _buildModuleCard(context, 'Speaking', 'Pronunciation', 0.82, Symbols.record_voice_over, const Color(0xFF006573), const Color(0x33A1EFFF)),
                        _buildModuleCard(context, 'Writing', 'Essay Craft', 0.31, Symbols.edit, const Color(0xFF1F4A6C), const Color(0x33CEE5FF)),
                      ],
                    ).animate().delay(200.ms).fadeIn(),
                    const SizedBox(height: 32),

                    // Recent Activity
                    Text('Recent Activity', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 16),
                    _buildRecentActivityList(context).animate().delay(350.ms).fadeIn(),
                  ],
                ),
              ),
            ),
          ),
          const BottomNav(currentRoute: '/dashboard'),
        ],
      ),
    );
  }

  Widget _buildDailyProgress(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 32, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DAILY PROGRESS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.secondary, letterSpacing: 0.8)),
                  const SizedBox(height: 2),
                  Text('Almost there!', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
              const Text('72%', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: AppColors.secondary)),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(height: 8, decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(999))),
              Container(
                height: 8,
                width: MediaQuery.of(context).size.width * 0.55,
                decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(999)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Align(alignment: Alignment.centerLeft, child: Text('28 minutes to reach your daily milestone', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant))),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, Gradient? gradient, VoidCallback onTap, {bool isSecondary = false, bool isGhost = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          gradient: gradient,
          color: isSecondary ? AppColors.secondaryContainer : (isGhost ? AppColors.surfaceContainerLow : null),
          borderRadius: BorderRadius.circular(14),
          boxShadow: gradient != null ? [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 4))] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: gradient != null ? Colors.white : (isSecondary ? AppColors.onSecondaryContainer : AppColors.primary)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: gradient != null ? Colors.white : (isSecondary ? AppColors.onSecondaryContainer : AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, String title, String subtitle, double progress, IconData icon, Color color, Color bgColor) {
    return Card(
      elevation: 0,
      color: AppColors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 24),
            ),
            const Spacer(),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 16),
            Stack(
              children: [
                Container(height: 6, decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(999))),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(height: 6, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999))),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('${(progress * 100).toInt()}%', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityList(BuildContext context) {
    final activities = [
      {'title': 'Present Perfect vs Simple Past', 'type': 'Grammar', 'time': '2h ago', 'icon': Symbols.history_edu},
      {'title': 'IELTS Academic Vocabulary Set 3', 'type': 'Vocabulary', 'time': 'Yesterday', 'icon': Symbols.library_books},
      {'title': 'Conditional Sentences Practice', 'type': 'Exercise', 'time': '2 days ago', 'icon': Symbols.quiz},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 32, offset: const Offset(0, 8))],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: AppColors.outlineVariant.withOpacity(0.2)),
        itemBuilder: (context, index) {
          final item = activities[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
              child: Icon(item['icon'] as IconData, color: AppColors.secondary, size: 22),
            ),
            title: Text(item['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: Text(item['type'] as String, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
            trailing: Text(item['time'] as String, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
            onTap: () => context.go('/lesson'),
          );
        },
      ),
    );
  }
}
