import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/book_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/profile_setup_screen.dart';
import '../screens/meet_avatar_screen.dart';
import '../screens/main_wrapper_screen.dart';
import '../screens/home_screen.dart';
import '../screens/story_library_screen.dart';
import '../screens/story_scene_screen.dart';
import '../screens/story_completion_screen.dart';
import '../screens/bloom_ai_home_screen.dart';
import '../screens/bloom_chat_screen.dart';
import '../screens/bloom_topics_screen.dart';
import '../screens/bloom_learn_screen.dart';
import '../screens/bloom_prepare_screen.dart';
import '../screens/bloom_tell_someone_screen.dart';
import '../screens/bloom_journal_screen.dart';
import '../screens/tracker_home_screen.dart';
import '../screens/tracker_calendar_screen.dart';
import '../screens/tracker_day_details_screen.dart';
import '../screens/tracker_recommendations_screen.dart';
import '../screens/tracker_period_prep_screen.dart';
import '../screens/tracker_insights_screen.dart';
import '../screens/tracker_checkin_screen.dart';
import '../screens/tracker_cycle_history_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/achievements_screen.dart';
import '../screens/settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/meet-avatar',
      builder: (context, state) => const MeetAvatarScreen(),
    ),

    // Bottom Navigation Shell Route
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainWrapperScreen(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/stories',
          builder: (context, state) => const StoryLibraryScreen(),
        ),
        GoRoute(
          path: '/bloom-ai',
          builder: (context, state) => const BloomAiHomeScreen(),
        ),
        GoRoute(
          path: '/tracker',
          builder: (context, state) => const TrackerHomeScreen(),
        ),
      ],
    ),

    // Bloom AI Connected Screens & Flows
    GoRoute(
      path: '/bloom/chat',
      builder: (context, state) {
        final initialQuestion = state.uri.queryParameters['initialQuestion'];
        final source = state.uri.queryParameters['source'];
        final topic = state.uri.queryParameters['topic'];
        return BloomChatScreen(
          initialQuestion: initialQuestion,
          source: source,
          topic: topic,
        );
      },
    ),
    GoRoute(
      path: '/bloom/topics',
      builder: (context, state) => const BloomTopicsScreen(),
    ),
    GoRoute(
      path: '/bloom/learn',
      builder: (context, state) => const BloomLearnScreen(),
    ),
    GoRoute(
      path: '/bloom/prepare',
      builder: (context, state) => const BloomPrepareScreen(),
    ),
    GoRoute(
      path: '/bloom/tell-someone',
      builder: (context, state) => const BloomTellSomeoneScreen(),
    ),
    GoRoute(
      path: '/bloom/journal',
      builder: (context, state) => const BloomJournalScreen(),
    ),

    // Book Experience Route
    GoRoute(
      path: '/books/:bookId',
      builder: (context, state) {
        final bookId = state.pathParameters['bookId'] ?? 'bursting_myths';
        final pageIndexStr = state.uri.queryParameters['pageIndex'];
        final pageIndex = int.tryParse(pageIndexStr ?? '0') ?? 0;
        return BookScreen(bookId: bookId, initialPageIndex: pageIndex);
      },
    ),

    // Sub-screens & details
    GoRoute(
      path: '/stories/:storyId',
      builder: (context, state) {
        final storyId = state.pathParameters['storyId'] ?? 'bursting_myths';
        return StorySceneScreen(storyId: storyId);
      },
    ),
    GoRoute(
      path: '/stories/:storyId/completion',
      builder: (context, state) {
        final storyId = state.pathParameters['storyId'] ?? 'bursting_myths';
        return StoryCompletionScreen(storyId: storyId);
      },
    ),
    GoRoute(
      path: '/tracker/calendar',
      builder: (context, state) => const TrackerCalendarScreen(),
    ),
    GoRoute(
      path: '/tracker/day/:dateStr',
      builder: (context, state) {
        final dateStr = state.pathParameters['dateStr'] ?? DateTime.now().toIso8601String();
        final date = DateTime.tryParse(dateStr) ?? DateTime.now();
        return DayDetailsScreen(date: date);
      },
    ),
    GoRoute(
      path: '/tracker/recommendations',
      builder: (context, state) => const TrackerRecommendationsScreen(),
    ),
    GoRoute(
      path: '/tracker/prep',
      builder: (context, state) => const PeriodPrepScreen(),
    ),
    GoRoute(
      path: '/tracker/insights',
      builder: (context, state) => const InsightsScreen(),
    ),
    GoRoute(
      path: '/tracker/checkin',
      builder: (context, state) => const CheckInScreen(),
    ),
    GoRoute(
      path: '/tracker/history',
      builder: (context, state) => const CycleHistoryScreen(),
    ),
    GoRoute(
      path: '/progress',
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: '/achievements',
      builder: (context, state) => const AchievementsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
