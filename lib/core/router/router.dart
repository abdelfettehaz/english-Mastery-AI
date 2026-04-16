import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/welcome/welcome_screen.dart';
import '../../screens/placement/placement_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/lesson/lesson_screen.dart';
import '../../screens/chat/chat_screen.dart';
import '../../screens/progress/progress_screen.dart';
import '../../screens/exam/exam_screen.dart';
import '../../screens/notes/notes_screen.dart';

final router = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/placement',
      builder: (context, state) => const PlacementScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/lesson',
      builder: (context, state) => const LessonScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/progress',
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: '/exam',
      builder: (context, state) => const ExamScreen(),
    ),
    GoRoute(
      path: '/notes',
      builder: (context, state) => const NotesScreen(),
    ),
  ],
);
