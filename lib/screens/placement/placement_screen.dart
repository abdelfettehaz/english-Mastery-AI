import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/theme/colors.dart';
import '../../widgets/top_bar.dart';

class Question {
  final String q;
  final List<String> options;
  final int correct;

  Question({required this.q, required this.options, required this.correct});
}

class PlacementScreen extends StatefulWidget {
  const PlacementScreen({super.key});

  @override
  State<PlacementScreen> createState() => _PlacementScreenState();
}

class _PlacementScreenState extends State<PlacementScreen> {
  final List<Question> _questions = [
    Question(
      q: "Choose the correct sentence:",
      options: [
        "She don't like coffee.",
        "She doesn't likes coffee.",
        "She doesn't like coffee.",
        "She not like coffee.",
      ],
      correct: 2,
    ),
    Question(
      q: "Which tense is: 'I have been studying for two hours'?",
      options: ["Simple Past", "Present Perfect Continuous", "Past Perfect", "Future Perfect"],
      correct: 1,
    ),
    Question(
      q: "Fill in the blank: 'If I _____ rich, I would travel the world.'",
      options: ["am", "was", "were", "be"],
      correct: 2,
    ),
    Question(
      q: "The word 'ubiquitous' means:",
      options: ["Rare and unique", "Found everywhere", "Very old", "Extremely small"],
      correct: 1,
    ),
    Question(
      q: "Which is the correct passive voice of 'They built this house in 1990'?",
      options: [
        "This house was built in 1990.",
        "This house is built in 1990.",
        "This house has been built in 1990.",
        "This house were built in 1990.",
      ],
      correct: 0,
    ),
  ];

  int _currentIndex = 0;
  int? _selected;
  bool _answered = false;
  int _score = 0;
  bool _done = false;

  void _handleSelect(int idx) {
    if (_answered) return;
    setState(() {
      _selected = idx;
      _answered = true;
      if (idx == _questions[_currentIndex].correct) _score++;
    });
  }

  void _next() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selected = null;
        _answered = false;
      });
    } else {
      setState(() {
        _done = true;
      });
    }
  }

  Map<String, dynamic> _getLevel() {
    if (_score >= 5) return {'level': "C1 – Advanced", 'color': AppColors.secondary};
    if (_score >= 4) return {'level': "B2 – Upper Intermediate", 'color': AppColors.primaryContainer};
    if (_score >= 3) return {'level': "B1 – Intermediate", 'color': const Color(0xFF1F4A6C)};
    if (_score >= 2) return {'level': "A2 – Elementary", 'color': AppColors.onSurfaceVariant};
    return {'level': "A1 – Beginner", 'color': const Color(0xFF72777E)};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: 'Linguist AI',
        onBack: () => context.go('/welcome'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: !_done ? _buildQuiz() : _buildResults(),
          ),
        ),
      ),
    );
  }

  Widget _buildQuiz() {
    final q = _questions[_currentIndex];
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Symbols.quiz, size: 14, color: AppColors.onSecondaryContainer),
              SizedBox(width: 6),
              Text('LEVEL PLACEMENT TEST', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Question ${_currentIndex + 1} of ${_questions.length}',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 20),
        // Progress Bar
        Stack(
          children: [
            Container(height: 8, decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(999))),
            AnimatedContainer(
              duration: 600.ms,
              height: 8,
              width: MediaQuery.of(context).size.width * ((_currentIndex + (_answered ? 1 : 0)) / _questions.length),
              decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(999)),
            ),
          ],
        ),
        const SizedBox(height: 40),
        // Question Card
        Card(
          elevation: 0,
          color: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(q.q, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 19, fontWeight: FontWeight.w700)),
                const SizedBox(height: 28),
                ...List.generate(q.options.length, (i) {
                  bool isCorrect = i == q.correct;
                  bool isSelected = i == _selected;
                  Color borderColor = AppColors.outlineVariant;
                  Color bgColor = AppColors.surfaceContainerLowest;
                  
                  if (_answered) {
                    if (isCorrect) {
                      borderColor = AppColors.secondary;
                      bgColor = AppColors.secondaryContainer.withOpacity(0.12);
                    } else if (isSelected) {
                      borderColor = Colors.red;
                      bgColor = Colors.red.withOpacity(0.05);
                    }
                  } else if (isSelected) {
                    borderColor = AppColors.secondary;
                    bgColor = AppColors.secondaryContainer.withOpacity(0.05);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: InkWell(
                      onTap: () => _handleSelect(i),
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: 200.ms,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: 2),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${String.fromCharCode(65 + i)}.',
                              style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.secondary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(q.options[i], style: const TextStyle(fontWeight: FontWeight.w500))),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ).animate().slideY(begin: 0.1, end: 0).fadeIn(),
        if (_answered)
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _next,
                child: Text(_currentIndex < _questions.length - 1 ? 'Next Question' : 'See Results'),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildResults() {
    final levelData = _getLevel();
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
          child: const Icon(Symbols.emoji_events, size: 48, color: Colors.white, fill: 1),
        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 28),
        Text('Test Complete!', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 36, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text('You scored $_score out of ${_questions.length}', style: const TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 32),
        Card(
          elevation: 0,
          color: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                const Text('YOUR LEVEL', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 1.1, color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 12),
                Text(
                  levelData['level'],
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(color: levelData['color'], fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your personalized learning path has been created based on these results.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.6),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.go('/dashboard'),
            child: const Text('Start Learning Journey'),
          ),
        ),
      ],
    );
  }
}
