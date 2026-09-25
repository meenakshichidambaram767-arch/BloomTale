import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/achievement.dart';
import '../models/avatar.dart';
import '../models/bloom_ai.dart';
import '../models/cycle.dart';
import '../models/progress.dart';
import '../models/story.dart';
import '../models/user.dart';

import '../services/achievement_service.dart';
import '../services/ai_service.dart';
import '../services/auth_service.dart';
import '../services/avatar_service.dart';
import '../services/story_service.dart';
import '../services/tracker_service.dart';

// --- Services / Repositories Providers ---
final authServiceProvider = Provider<AuthService>((ref) {
  return MockAuthService();
});

final authRepositoryProvider = authServiceProvider;

final avatarServiceProvider = Provider<AvatarService>((ref) {
  return MockAvatarService();
});

final storyServiceProvider = Provider<StoryService>((ref) {
  return MockStoryService();
});

final storyRepositoryProvider = storyServiceProvider;

final aiServiceProvider = Provider<AiService>((ref) {
  return MockAiService();
});

final bloomAiRepositoryProvider = aiServiceProvider;

final trackerServiceProvider = Provider<TrackerService>((ref) {
  return MockTrackerService();
});

final cycleRepositoryProvider = trackerServiceProvider;

final achievementServiceProvider = Provider<AchievementService>((ref) {
  return MockAchievementService();
});

// --- State Notifiers & Async Providers ---

// User Profile Provider
class UserNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final AuthService _authRepo;

  UserNotifier(this._authRepo) : super(const AsyncValue.loading()) {
    loadUser();
  }

  Future<void> loadUser() async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepo.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> completeOnboarding(String name) async {
    final current = state.value;
    if (current != null) {
      final updated = current.copyWith(
        name: name,
      );
      final saved = await _authRepo.updateProfile(updated);
      state = AsyncValue.data(saved);
    } else {
      final newUser = await _authRepo.signUp(name, '$name@bloomtale.app', 'demo123');
      state = AsyncValue.data(newUser);
    }
  }

  Future<void> addXp(int xp) async {
    final current = state.value;
    if (current != null) {
      final updated = current.copyWith(xp: current.xp + xp);
      state = AsyncValue.data(await _authRepo.updateProfile(updated));
    }
  }

  Future<void> selectAvatar(String avatarId) async {
    final current = state.value;
    if (current != null) {
      final updated = current.copyWith(avatarId: avatarId);
      final saved = await _authRepo.updateProfile(updated);
      state = AsyncValue.data(saved);
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<UserProfile?>>((ref) {
  return UserNotifier(ref.watch(authServiceProvider));
});

// Default Avatar Provider
final avatarProvider = FutureProvider<Avatar>((ref) async {
  final service = ref.watch(avatarServiceProvider);
  return service.getDefaultAvatar();
});

// Selected Companion Avatar Provider
final selectedAvatarProvider = FutureProvider<Avatar>((ref) async {
  final userAsync = ref.watch(userProvider);
  final service = ref.watch(avatarServiceProvider);
  final avatarId = userAsync.asData?.value?.avatarId ?? 'ananya';
  return service.getAvatarById(avatarId);
});

// Available Bloom Friends Provider
final availableAvatarsProvider = FutureProvider<List<Avatar>>((ref) async {
  final service = ref.watch(avatarServiceProvider);
  return service.getAvailableAvatars();
});

// Stories Provider
final storyListProvider = FutureProvider<List<Story>>((ref) async {
  final service = ref.watch(storyServiceProvider);
  return service.getStories();
});

// Bloom AI Chat Notifier
class BloomAiNotifier extends StateNotifier<AsyncValue<List<BloomAiMessage>>> {
  final AiService _service;

  BloomAiNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final history = await _service.getConversationHistory();
      state = AsyncValue.data(history);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> sendMessage(String text) async {
    final currentMessages = state.value ?? [];
    final optimisticUserMsg = BloomAiMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    state = AsyncValue.data([...currentMessages, optimisticUserMsg]);

    try {
      await _service.sendMessage(text);
      final updatedHistory = await _service.getConversationHistory();
      state = AsyncValue.data(updatedHistory);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final bloomAiProvider = StateNotifierProvider<BloomAiNotifier, AsyncValue<List<BloomAiMessage>>>((ref) {
  return BloomAiNotifier(ref.watch(aiServiceProvider));
});

// Bloom Prep Items Notifier
class PrepItem {
  final String id;
  final String title;
  final bool isCompleted;
  final bool isCustom;

  PrepItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.isCustom = false,
  });

  PrepItem copyWith({String? id, String? title, bool? isCompleted, bool? isCustom}) {
    return PrepItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}

class BloomPrepNotifier extends StateNotifier<AsyncValue<List<PrepItem>>> {
  BloomPrepNotifier()
      : super(AsyncValue.data([
          PrepItem(id: '1', title: 'Pads / Hygiene essentials'),
          PrepItem(id: '2', title: 'Spare underwear in pouch'),
          PrepItem(id: '3', title: 'Comfortable clothing'),
          PrepItem(id: '4', title: 'Hydration bottle'),
        ]));

  void toggleItem(String id) {
    final list = state.value ?? [];
    state = AsyncValue.data(list.map((i) => i.id == id ? i.copyWith(isCompleted: !i.isCompleted) : i).toList());
  }

  void addItem(String title) {
    final list = state.value ?? [];
    final newItem = PrepItem(id: DateTime.now().millisecondsSinceEpoch.toString(), title: title, isCustom: true);
    state = AsyncValue.data([...list, newItem]);
  }

  void removeItem(String id) {
    final list = state.value ?? [];
    state = AsyncValue.data(list.where((i) => i.id != id).toList());
  }
}

final bloomPrepProvider = StateNotifierProvider<BloomPrepNotifier, AsyncValue<List<PrepItem>>>((ref) {
  return BloomPrepNotifier();
});

// Bloom Journal Notifier
class BloomJournalNotifier extends StateNotifier<AsyncValue<List<BloomJournalEntry>>> {
  BloomJournalNotifier() : super(const AsyncValue.data([]));

  Future<BloomJournalEntry> addEntry(String mood, String note) async {
    final entry = BloomJournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      mood: mood,
      note: note,
      bloomFeedback: "Thank you for sharing. Remember to be extra kind to yourself today! 💖",
    );
    final current = state.value ?? [];
    state = AsyncValue.data([entry, ...current]);
    return entry;
  }
}

final bloomJournalProvider = StateNotifierProvider<BloomJournalNotifier, AsyncValue<List<BloomJournalEntry>>>((ref) {
  return BloomJournalNotifier();
});

// Saved Answers Notifier
class SavedAnswersNotifier extends StateNotifier<List<BloomAiMessage>> {
  SavedAnswersNotifier() : super([]);

  void removeAnswer(BloomAiMessage message) {
    state = state.where((m) => m.id != message.id).toList();
  }

  void toggleSave(BloomAiMessage message) {
    if (state.any((m) => m.id == message.id)) {
      state = state.where((m) => m.id != message.id).toList();
    } else {
      state = [...state, message];
    }
  }
}

final savedAnswersProvider = StateNotifierProvider<SavedAnswersNotifier, List<BloomAiMessage>>((ref) {
  return SavedAnswersNotifier();
});

// Bloom Chat State & Provider
class BloomChatState {
  final List<BloomAiMessage> messages;
  final bool isLoading;
  final ExplanationLevel explanationLevel;

  BloomChatState({
    this.messages = const [],
    this.isLoading = false,
    this.explanationLevel = ExplanationLevel.simple,
  });

  BloomChatState copyWith({
    List<BloomAiMessage>? messages,
    bool? isLoading,
    ExplanationLevel? explanationLevel,
  }) {
    return BloomChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      explanationLevel: explanationLevel ?? this.explanationLevel,
    );
  }
}

class BloomChatNotifier extends StateNotifier<BloomChatState> {
  final AiService _service;

  BloomChatNotifier(this._service)
      : super(BloomChatState(messages: [
          BloomAiMessage(
            id: '1',
            text: 'Hello! I am your Bloom Companion. How can I help you today?',
            isUser: false,
            timestamp: DateTime.now(),
          )
        ]));

  void setContext(BloomContext ctx) {}

  void setExplanationLevel(ExplanationLevel level) {
    state = state.copyWith(explanationLevel: level);
  }

  void toggleSaveAnswer(BloomAiMessage msg) {}

  Future<void> sendMessage(String text) async {
    final userMsg = BloomAiMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(messages: [...state.messages, userMsg], isLoading: true);

    try {
      final aiMsg = await _service.sendMessage(text);
      state = state.copyWith(messages: [...state.messages, aiMsg], isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final bloomChatProvider = StateNotifierProvider<BloomChatNotifier, BloomChatState>((ref) {
  return BloomChatNotifier(ref.watch(aiServiceProvider));
});

final bloomAvatarExpressionProvider = Provider<BloomExpression>((ref) => BloomExpression.happy);

final bloomTopicsProvider = FutureProvider<List<BloomTopic>>((ref) async {
  return ref.watch(aiServiceProvider).getTopics();
});

// Cycle Tracker Notifier
class CycleTrackerNotifier extends StateNotifier<AsyncValue<List<PeriodLog>>> {
  final TrackerService _service;

  CycleTrackerNotifier(this._service) : super(const AsyncValue.loading()) {
    loadLogs();
  }

  Future<void> loadLogs() async {
    try {
      final logs = await _service.getLogs();
      final periodLogs = logs.map((l) => PeriodLog(
        id: l.id,
        userId: 'demo_user',
        startDate: l.date,
        flow: l.flow,
        notes: l.notes,
        createdAt: l.date,
      )).toList();
      state = AsyncValue.data(periodLogs);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addLog(PeriodLog log) async {
    await _service.saveLog(CycleLog(
      id: log.id,
      date: log.startDate,
      flow: log.flow,
      mood: 'Calm',
      symptoms: const [],
      notes: log.notes ?? '',
    ));
    await loadLogs();
  }
}

final cycleTrackerProvider = StateNotifierProvider<CycleTrackerNotifier, AsyncValue<List<PeriodLog>>>((ref) {
  return CycleTrackerNotifier(ref.watch(trackerServiceProvider));
});

final periodLogsProvider = FutureProvider<List<PeriodLog>>((ref) async {
  final service = ref.watch(trackerServiceProvider);
  final logs = await service.getLogs();
  return logs.map((l) => PeriodLog(
    id: l.id,
    userId: 'demo_user',
    startDate: l.date,
    flow: l.flow,
    notes: l.notes,
    createdAt: l.date,
  )).toList();
});

final cyclePredictionProvider = FutureProvider<CyclePrediction>((ref) async {
  final logs = await ref.watch(periodLogsProvider.future);
  return CalculatePrediction().execute(logs);
});

final recommendationsProvider = FutureProvider<List<Recommendation>>((ref) async {
  final logs = await ref.watch(periodLogsProvider.future);
  return GetRecommendations().execute(
    periodLogs: logs,
    checkIns: const [],
    upcomingEvents: const [],
  );
});

final trackerInsightsProvider = FutureProvider<List<CycleInsight>>((ref) async {
  return [
    CycleInsight(
      id: 'insight_1',
      title: 'Cycle Rhythm',
      description: 'Your cycle is following a predictable, healthy rhythm.',
      type: 'summary',
      createdAt: DateTime.now(),
    ),
  ];
});

final calendarEventsProvider = FutureProvider<List<CalendarEvent>>((ref) async {
  return const [];
});

// Progress Provider
final progressProvider = Provider<ProgressData>((ref) {
  final userState = ref.watch(userProvider);
  final user = userState.asData?.value;

  return ProgressData(
    currentXp: user?.xp ?? 45,
    streakDays: 3,
    totalStoriesCompleted: 1,
    currentLevel: user?.level ?? 1,
    totalCheckIns: 4,
    xpForNextLevel: 100,
  );
});

// Achievements Provider
final achievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final service = ref.watch(achievementServiceProvider);
  return service.getAchievements();
});
