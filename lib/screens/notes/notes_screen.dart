import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/theme/colors.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/bottom_nav.dart';

class Note {
  final String id;
  final String title;
  final String body;
  final String tag;
  final String date;

  Note({required this.id, required this.title, required this.body, required this.tag, required this.date});
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<Note> _notes = [
    Note(id: '1', title: 'Present Perfect Rules', body: "Use 'have/has + V3' for actions with present relevance. Key words: already, yet, ever, never, just, recently.", tag: 'Grammar', date: 'Today'),
    Note(id: '2', title: 'Conditional Sentences', body: "Zero: If + present + present. First: If + present + will. Second: If + past + would. Third: If + past perfect + would have.", tag: 'Grammar', date: 'Yesterday'),
    Note(id: '3', title: 'IELTS Vocabulary - Technology', body: "proliferation, ubiquitous, algorithm, artificial intelligence, automation, disruptive innovation, digital transformation", tag: 'Vocabulary', date: '2 days ago'),
  ];

  bool _showNewNote = false;
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  void _addNote() {
    if (_titleController.text.trim().isEmpty) return;
    setState(() {
      _notes.insert(0, Note(
        id: DateTime.now().toString(),
        title: _titleController.text,
        body: _bodyController.text,
        tag: 'General',
        date: 'Just now',
      ));
      _showNewNote = false;
      _titleController.clear();
      _bodyController.clear();
    });
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'Grammar': return AppColors.secondary;
      case 'Vocabulary': return AppColors.tertiary;
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: 'AI Notes',
        onBack: () => context.go('/dashboard'),
        rightSlot: ElevatedButton.icon(
          onPressed: () => setState(() => _showNewNote = true),
          icon: const Icon(Symbols.add, size: 18),
          label: const Text('New Note', style: TextStyle(fontSize: 13)),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: Column(
                  children: [
                    if (_showNewNote) _buildNewNoteForm().animate().slideY(begin: 0.1, end: 0).fadeIn(),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        childAspectRatio: 1.6,
                      ),
                      itemCount: _notes.length,
                      itemBuilder: (context, i) {
                        final note = _notes[i];
                        return _buildNoteCard(note).animate().delay((i * 80).ms).fadeIn();
                      },
                    ),
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

  Widget _buildNewNoteForm() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 32, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('New Note', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Note title...',
              filled: true,
              fillColor: AppColors.surfaceContainerLow,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _bodyController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Write your note...',
              filled: true,
              fillColor: AppColors.surfaceContainerLow,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton(onPressed: _addNote, child: const Text('Save Note')),
              const SizedBox(width: 12),
              TextButton(onPressed: () => setState(() => _showNewNote = false), child: const Text('Cancel')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    final color = _getTagColor(note.tag);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(999)),
                child: Text(note.tag, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color)),
              ),
              Text(note.date, style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 12),
          Text(note.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Expanded(child: Text(note.body, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.6))),
        ],
      ),
    );
  }
}
