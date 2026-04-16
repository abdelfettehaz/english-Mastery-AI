import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/theme/colors.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/bottom_nav.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _step = 0;
  int? _quizSelected;
  bool _quizDone = false;

  final List<Map<String, dynamic>> _content = [
    {
      'type': 'intro',
      'title': 'Present Perfect vs Simple Past',
      'subtitle': 'Grammar · Intermediate',
      'description': 'Master the distinction between these two essential tenses and understand when to use each one naturally.',
      'duration': '15 min',
      'xp': 50,
    },
    {
      'type': 'concept',
      'title': 'Simple Past',
      'body': 'Use the Simple Past for completed actions at a specific time in the past. The key is that the time is either stated or implied.',
      'examples': [
        {'en': 'I visited Paris last summer.', 'note': 'Specific time: last summer'},
        {'en': 'She graduated in 2020.', 'note': 'Specific time: 2020'},
        {'en': 'Did you see that movie?', 'note': 'Implied recent past'},
      ],
      'formula': 'Subject + V2 (or did + base verb)',
    },
    {
      'type': 'concept',
      'title': 'Present Perfect',
      'body': 'Use Present Perfect when the past action has relevance to the present, or when no specific time is mentioned.',
      'examples': [
        {'en': 'I have visited Paris.', 'note': 'The experience, not when'},
        {'en': 'She has graduated.', 'note': 'Relevant to now'},
        {'en': 'Have you seen that movie?', 'note': 'At any time up to now'},
      ],
      'formula': 'Subject + have/has + past participle (V3)',
    },
    {
      'type': 'quiz',
      'question': 'Which sentence is grammatically correct and natural?',
      'options': [
        'I have seen him yesterday.',
        'I saw him yesterday.',
        'I have saw him yesterday.',
        'I did saw him yesterday.',
      ],
      'correct': 1,
      'explanation': "'Yesterday' is a specific past time marker, so Simple Past is required. Present Perfect cannot be used with specific past time expressions.",
    },
  ];

  void _next() {
    if (_step < _content.length - 1) {
      setState(() => _step++);
    } else {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _content[_step];
    return Scaffold(
      appBar: TopBar(
        title: 'Grammar Lesson',
        onBack: () => context.go('/dashboard'),
        rightSlot: Text(
          '${_step + 1} / ${_content.length}',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant),
        ),
      ),
      body: Stack(
        children: [
          // Theme Progress Line
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              width: double.infinity,
              color: AppColors.surfaceContainerHigh,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (_step + 1) / _content.length,
                child: Container(decoration: const BoxDecoration(gradient: AppColors.primaryGradient)),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 100),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: _buildStepContent(current),
              ),
            ),
          ),
          const BottomNav(currentRoute: '/lesson'),
        ],
      ),
    );
  }

  Widget _buildStepContent(Map<String, dynamic> current) {
    switch (current['type']) {
      case 'intro':
        return _buildIntro(current).animate().fadeIn().slideY(begin: 0.1, end: 0);
      case 'concept':
        return _buildConcept(current).animate().fadeIn().slideY(begin: 0.1, end: 0);
      case 'quiz':
        return _buildQuiz(current).animate().fadeIn().slideY(begin: 0.1, end: 0);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildIntro(Map<String, dynamic> data) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(36),
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
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(999)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Symbols.menu_book, size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(data['subtitle'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(data['title'], style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 16),
              Text(data['description'], style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8), height: 1.6)),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildIntroChip(Symbols.schedule, data['duration']),
                  const SizedBox(width: 20),
                  _buildIntroChip(Symbols.stars, '+${data['xp']} XP'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: _next, child: const Text('Begin Lesson')),
        ),
      ],
    );
  }

  Widget _buildIntroChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white.withOpacity(0.8)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildConcept(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(data['title'], style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        Text(data['body'], style: const TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant, height: 1.7)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.secondaryContainer.withOpacity(0.3), borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              const Icon(Symbols.functions, color: AppColors.secondary),
              const SizedBox(width: 12),
              Text(data['formula'], style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700, color: AppColors.secondary)),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text('Examples', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        ...data['examples'].map<Widget>((ex) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16)],
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(ex['en'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(999)),
                      child: Text(ex['note'], style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 32),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _next, child: const Text('Continue'))),
      ],
    );
  }

  Widget _buildQuiz(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: AppColors.tertiary.withOpacity(0.1), borderRadius: BorderRadius.circular(999)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Symbols.quiz, size: 14, color: AppColors.tertiary),
              SizedBox(width: 6),
              Text('QUICK CHECK', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.tertiary)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(data['question'], style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, height: 1.3)),
        const SizedBox(height: 28),
        ...List.generate(data['options'].length, (i) {
          bool isCorrect = i == data['correct'];
          bool isSelected = i == _quizSelected;
          Color borderColor = AppColors.outlineVariant;
          Color bgColor = AppColors.surfaceContainerLowest;

          if (_quizDone) {
            if (isCorrect) {
              borderColor = AppColors.secondary;
              bgColor = AppColors.secondaryContainer.withOpacity(0.15);
            } else if (isSelected) {
              borderColor = Colors.red;
              bgColor = Colors.red.withOpacity(0.05);
            }
          } else if (isSelected) {
            borderColor = AppColors.secondary;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildQuizOption(i, data['options'][i], borderColor, bgColor),
          );
        }),
        if (_quizDone)
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _quizSelected == data['correct'] ? const Color(0x3358E6FF) : const Color(0x33FFDAD6),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _quizSelected == data['correct'] ? Symbols.check_circle : Symbols.cancel,
                        color: _quizSelected == data['correct'] ? AppColors.secondary : Colors.red,
                        fill: 1,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _quizSelected == data['correct'] ? 'Correct!' : 'Not quite.',
                              style: TextStyle(fontWeight: FontWeight.w800, color: _quizSelected == data['correct'] ? AppColors.secondary : Colors.red),
                            ),
                            const SizedBox(height: 4),
                            Text(data['explanation'], style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.6)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _next,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [Icon(Symbols.emoji_events), SizedBox(width: 8), Text('Complete Lesson (+50 XP)')],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildQuizOption(int idx, String text, Color borderColor, Color bgColor) {
    return InkWell(
      onTap: () {
        if (!_quizDone) setState(() { _quizSelected = idx; _quizDone = true; });
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor, width: 2)),
        child: Row(
          children: [
            Text('${String.fromCharCode(65 + idx)}.', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.secondary)),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
      ),
    );
  }
}
