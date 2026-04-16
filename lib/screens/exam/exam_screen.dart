import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/theme/colors.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/bottom_nav.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  bool _started = false;
  int _currentSection = 0;
  int _timeLeft = 7200; // 120 minutes
  Timer? _timer;
  final Map<String, int> _answers = {};
  bool _done = false;

  final List<Map<String, dynamic>> _sections = [
    {
      'name': 'Reading',
      'icon': Symbols.auto_stories,
      'questions': [
        {'q': 'The passage implies that the author believes:', 'options': ['Technology improves all aspects of life', 'Technology should be used cautiously', 'Technology is irrelevant to education', 'Technology replaces human teachers'], 'correct': 1},
        {'q': 'The word "proliferation" in paragraph 2 most closely means:', 'options': ['Decline', 'Rapid spread', 'Control', 'Limitation'], 'correct': 1},
      ],
    },
    {
      'name': 'Use of English',
      'icon': Symbols.spellcheck,
      'questions': [
        {'q': 'Choose the word that best completes: "Despite the heavy rain, she _____ to arrive on time."', 'options': ['managed', 'succeeded', 'could', 'was able'], 'correct': 0},
        {'q': 'Which sentence contains a grammatical error?', 'options': ['She has been working here since 2015.', 'They have went to the market.', 'We had already eaten.', 'I will have finished by noon.'], 'correct': 1},
      ],
    },
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startExam() {
    setState(() => _started = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _timer?.cancel();
        _submit();
      }
    });
  }

  void _submit() {
    _timer?.cancel();
    setState(() => _done = true);
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) return _buildIntro();
    if (_done) return _buildResults();
    return _buildExam();
  }

  Widget _buildIntro() {
    return Scaffold(
      appBar: TopBar(title: 'BAC Exam Prep', onBack: () => context.go('/dashboard')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 32, offset: const Offset(0, 8))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(999)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Symbols.workspace_premium, size: 14, color: Colors.white, fill: 1),
                                SizedBox(width: 6),
                                Text('OFFICIAL BAC FORMAT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text('BAC English\nMock Exam', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1)),
                          const SizedBox(height: 16),
                          Text('Test your skills under real exam conditions. 2 sections, timed experience, immediate AI feedback.', 
                            style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 16, height: 1.6)),
                        ],
                      ),
                    ).animate().slideY(begin: 0.1, end: 0).fadeIn(),
                    const SizedBox(height: 24),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.4,
                      children: [
                        _buildInfoCard(Symbols.schedule, 'Duration', '120 min'),
                        _buildInfoCard(Symbols.quiz, 'Sections', '2 Sections'),
                        _buildInfoCard(Symbols.stars, 'Max XP', '+200 XP'),
                        _buildInfoCard(Symbols.psychology, 'AI Grading', 'Instant'),
                      ],
                    ).animate().delay(100.ms).fadeIn(),
                    const SizedBox(height: 32),
                    SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _startExam, child: const Text('Start Mock Exam'))),
                  ],
                ),
              ),
            ),
          ),
          const BottomNav(currentRoute: '/exam'),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.secondary, size: 20),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildExam() {
    final section = _sections[_currentSection];
    return Scaffold(
      appBar: TopBar(
        title: section['name'],
        rightSlot: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _timeLeft < 300 ? const Color(0xFFFFDAD6) : AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Symbols.schedule, size: 16, color: _timeLeft < 300 ? const Color(0xFFBA1A1A) : AppColors.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(_formatTime(_timeLeft), style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700, fontSize: 16, color: _timeLeft < 300 ? const Color(0xFFBA1A1A) : AppColors.onSurface)),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Section Tabs
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.8),
                border: Border(bottom: BorderSide(color: AppColors.outlineVariant.withOpacity(0.2))),
              ),
              child: Row(
                children: List.generate(_sections.length, (i) {
                  final isCurrent = i == _currentSection;
                  return Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _currentSection = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: isCurrent ? AppColors.primary : Colors.transparent, width: 2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_sections[i]['icon'], size: 16, color: isCurrent ? AppColors.primary : AppColors.onSurfaceVariant),
                            const SizedBox(width: 8),
                            Text(_sections[i]['name'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isCurrent ? AppColors.primary : AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 70, 20, 100),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Column(
                  children: [
                    ...List.generate(section['questions'].length, (qi) {
                      final q = section['questions'][qi];
                      final key = '$_currentSection-$qi';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Question ${qi + 1}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.secondary)),
                            const SizedBox(height: 12),
                            Text(q['q'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.5)),
                            const SizedBox(height: 20),
                            ...List.generate(q['options'].length, (oi) {
                              final isSelected = _answers[key] == oi;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: InkWell(
                                  onTap: () => setState(() => _answers[key] = oi),
                                  borderRadius: BorderRadius.circular(14),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.secondaryContainer.withOpacity(0.1) : AppColors.surfaceContainerLowest,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: isSelected ? AppColors.secondary : AppColors.outlineVariant, width: 2),
                                    ),
                                    child: Row(
                                      children: [
                                        Text('${String.fromCharCode(65 + oi)}.', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.secondary)),
                                        const SizedBox(width: 12),
                                        Expanded(child: Text(q['options'][oi], style: const TextStyle(fontWeight: FontWeight.w600))),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    if (_currentSection < _sections.length - 1)
                      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => setState(() => _currentSection++), child: const Text('Next Section')))
                    else
                      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _submit, child: const Text('Submit Exam'))),
                  ],
                ),
              ),
            ),
          ),
          const BottomNav(currentRoute: '/exam'),
        ],
      ),
    );
  }

  Widget _buildResults() {
    int totalCorrect = 0;
    int total = 0;
    for (int si = 0; si < _sections.length; si++) {
      final section = _sections[si];
      for (int qi = 0; qi < section['questions'].length; qi++) {
        total++;
        if (_answers['$si-$qi'] == section['questions'][qi]['correct']) {
          totalCorrect++;
        }
      }
    }
    int scorePercent = ((totalCorrect / total) * 100).round();

    return Scaffold(
      appBar: const TopBar(title: 'Exam Results'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
                  child: const Icon(Symbols.emoji_events, size: 48, color: Colors.white, fill: 1),
                ),
                const SizedBox(height: 24),
                Text('Exam Complete!', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 36, fontWeight: FontWeight.w900)),
                const Text('Your AI analysis is ready', style: TextStyle(color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 32, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    children: [
                      Text('$scorePercent%', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 64, fontWeight: FontWeight.w900, letterSpacing: -2)),
                      Text('$totalCorrect/$total correct answers', style: const TextStyle(color: AppColors.onSurfaceVariant)),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                        child: const Text(
                          '🎯 Strong performance in Use of English. Focus on Reading comprehension strategies to boost your score further.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => context.go('/dashboard'), child: const Text('Back to Dashboard'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
