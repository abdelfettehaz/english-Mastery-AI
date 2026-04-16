import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/theme/colors.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/bottom_nav.dart';
import '../../services/ai_service.dart';

class Message {
  final String text;
  final bool isAI;
  Message({required this.text, required this.isAI});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [
    Message(
      isAI: true,
      text: "Hello! I'm your AI English tutor. I can help you with grammar, vocabulary, pronunciation tips, writing feedback, or exam preparation. What would you like to work on today?",
    ),
  ];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AIService _aiService = AIService();
  bool _isLoading = false;

  final List<String> _quickPrompts = [
    "Check my grammar",
    "Explain Present Perfect",
    "Help with IELTS writing",
    "Vocabulary exercises",
  ];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage([String? text]) async {
    final msg = text ?? _controller.text.trim();
    if (msg.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(Message(text: msg, isAI: false));
      _isLoading = true;
      if (text == null) _controller.clear();
    });
    _scrollToBottom();

    final history = _messages
        .where((m) => m.text != msg) // Exclude current user message from history sent, it's sent separately
        .map((m) => {'role': m.isAI ? 'assistant' : 'user', 'content': m.text})
        .toList();

    final response = await _aiService.getCompletion(msg, history);

    setState(() {
      _messages.add(Message(text: response, isAI: true));
      _isLoading = false;
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: 'AI Tutor',
        onBack: () => context.go('/dashboard'),
        rightSlot: Row(
          children: [
            Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF4CAF50))),
            const SizedBox(width: 8),
            const Text('Online', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 180),
                  itemCount: _messages.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length) return _buildLoadingBubble();
                    return _buildChatBubble(_messages[index]);
                  },
                ),
              ),
            ],
          ),
          // Input Area
          _buildInputArea(),
          const BottomNav(currentRoute: '/chat'),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Message msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: msg.isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (msg.isAI)
            Container(
              margin: const EdgeInsets.only(right: 10),
              width: 36,
              height: 36,
              decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
              child: const Icon(Symbols.auto_awesome, size: 18, color: Colors.white, fill: 1),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                gradient: msg.isAI ? null : AppColors.primaryGradient,
                color: msg.isAI ? AppColors.surfaceContainerLowest : null,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(msg.isAI ? 4 : 20),
                  bottomRight: Radius.circular(msg.isAI ? 20 : 4),
                ),
                boxShadow: msg.isAI ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16)] : null,
              ),
              child: Text(
                msg.text,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: msg.isAI ? AppColors.onSurface : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildLoadingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            width: 36,
            height: 36,
            decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
            child: const Icon(Symbols.auto_awesome, size: 18, color: Colors.white, fill: 1),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20), bottomLeft: Radius.circular(4)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16)],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) => Container(
                  margin: const EdgeInsets.only(right: 4),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.outlineVariant),
                ).animate(onPlay: (c) => c.repeat()).scale(delay: (i * 200).ms, duration: 600.ms, begin: const Offset(1, 1), end: const Offset(1.5, 1.5)).then().scale(duration: 600.ms, begin: const Offset(1.5, 1.5), end: const Offset(1, 1)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Positioned(
      bottom: 85, // Above bottom nav
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.9),
          border: Border(top: BorderSide(color: AppColors.outlineVariant.withOpacity(0.2))),
        ),
        child: Column(
          children: [
            // Quick Prompts
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 4),
                itemCount: _quickPrompts.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) => InkWell(
                  onTap: () => _sendMessage(_quickPrompts[index]),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: Text(_quickPrompts[index], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: 4,
                      minLines: 1,
                      style: const TextStyle(fontSize: 15),
                      decoration: const InputDecoration(
                        hintText: 'Ask your AI tutor anything...',
                        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
                  child: IconButton(
                    onPressed: () => _sendMessage(),
                    icon: const Icon(Symbols.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
