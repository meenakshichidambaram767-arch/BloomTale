import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/authentication/data/mock_auth_repository.dart';
import '../../features/authentication/domain/auth_repository.dart';
import '../../features/avatar/data/avatar_repository.dart';
import '../../features/avatar/domain/avatar.dart';
import '../../features/achievements/data/achievements_repository.dart';
import '../../features/achievements/domain/achievement.dart';
import '../../features/bloom_ai/data/bloom_ai_repository.dart';
import '../../features/bloom_ai/domain/bloom_ai_message.dart';
import '../../features/profile/domain/user_profile.dart';
import '../../features/progress/domain/progress_data.dart';
import '../../features/stories/data/story_repository.dart';
import '../../features/stories/domain/story.dart';
import '../../features/cycle_tracker/data/datasources/calendar_datasource.dart';
import '../../features/cycle_tracker/data/datasources/cycle_local_datasource.dart';
import '../../features/cycle_tracker/data/repositories/cycle_repository_impl.dart';
import '../../features/cycle_tracker/domain/entities/calendar_event.dart';
import '../../features/cycle_tracker/domain/entities/cycle_insight.dart';
import '../../features/cycle_tracker/domain/entities/period_log.dart';
import '../../features/cycle_tracker/domain/entities/recommendation.dart';
import '../../features/cycle_tracker/domain/repositories/cycle_repository.dart';
import '../../features/cycle_tracker/domain/usecases/calculate_prediction.dart';

// --- Repositories ---
final authRepositoryProvider = Provider<AuthRepository>((ref) {
 return MockAuthRepository();
});

final avatarRepositoryProvider = Provider<AvatarRepository>((ref) {
 return MockAvatarRepository();
});

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
 return MockStoryRepository();
});

final bloomAiRepositoryProvider = Provider<BloomAiRepository>((ref) {
 return MockBloomAiRepository();
});

final cycleLocalDataSourceProvider = Provider<CycleLocalDataSource>((ref) {
 return CycleLocalDataSource();
});

final calendarDataSourceProvider = Provider<CalendarDataSource>((ref) {
 return MockCalendarDataSource();
});

final cycleRepositoryProvider = Provider<CycleRepository>((ref) {
 return CycleRepositoryImpl(
 localDataSource: ref.watch(cycleLocalDataSourceProvider),
 calendarDataSource: ref.watch(calendarDataSourceProvider),
 );
});

final achievementsRepositoryProvider = Provider<AchievementsRepository>((ref) {
 return MockAchievementsRepository();
});

// --- State Notifiers & Async Providers ---

// User Profile Provider
class UserNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
 final AuthRepository _authRepo;

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
 onboardingCompleted: true,
 );
 final saved = await _authRepo.updateProfile(updated);
 state = AsyncValue.data(saved);
 } else {
 final newUser = await _authRepo.signUp(name, '$name@bloomtale.app', 'demo123');
 final updated = newUser.copyWith(onboardingCompleted: true);
 final saved = await _authRepo.updateProfile(updated);
 state = AsyncValue.data(saved);
 }
 }

 Future<void> addXp(int xp) async {
 final current = state.value;
 if (current != null) {
 final updated = current.copyWith(totalXp: current.totalXp + xp);
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
 return UserNotifier(ref.watch(authRepositoryProvider));
});

// Default Avatar Provider
final avatarProvider = FutureProvider<Avatar>((ref) async {
 final repo = ref.watch(avatarRepositoryProvider);
 return repo.getDefaultAvatar();
});

// Selected Companion Avatar Provider
final selectedAvatarProvider = FutureProvider<Avatar>((ref) async {
 final userAsync = ref.watch(userProvider);
 final repo = ref.watch(avatarRepositoryProvider);
 final avatarId = userAsync.asData?.value?.avatarId ?? 'default_avatar';
 return repo.getAvatarById(avatarId);
});

// Available Bloom Friends Provider
final availableAvatarsProvider = FutureProvider<List<Avatar>>((ref) async {
 final repo = ref.watch(avatarRepositoryProvider);
 return repo.getAvailableAvatars();
});


// Stories Provider
final storyListProvider = FutureProvider<List<Story>>((ref) async {
 final repo = ref.watch(storyRepositoryProvider);
 return repo.getStories();
});

// Bloom AI Chat Notifier
class BloomAiNotifier extends StateNotifier<AsyncValue<List<BloomAiMessage>>> {
 final BloomAiRepository _repo;

 BloomAiNotifier(this._repo) : super(const AsyncValue.loading()) {
 _loadHistory();
 }

 Future<void> _loadHistory() async {
 try {
 final history = await _repo.getConversationHistory();
 state = AsyncValue.data(history);
 } catch (e, st) {
 state = AsyncValue.error(e, st);
 }
 }

 Future<void> sendMessage(String text) async {
 final currentMessages = state.value ?? [];
 // Optimistic UI push
 final optimisticUserMsg = BloomAiMessage(
 id: DateTime.now().millisecondsSinceEpoch.toString(),
 text: text,
 isUser: true,
 timestamp: DateTime.now(),
 );
 state = AsyncValue.data([...currentMessages, optimisticUserMsg]);

 try {
 await _repo.sendMessage(text);
 final updatedHistory = await _repo.getConversationHistory();
 state = AsyncValue.data(updatedHistory);
 } catch (e, st) {
 state = AsyncValue.error(e, st);
 }
 }
}

final bloomAiProvider = StateNotifierProvider<BloomAiNotifier, AsyncValue<List<BloomAiMessage>>>((ref) {
 return BloomAiNotifier(ref.watch(bloomAiRepositoryProvider));
});

// Cycle Tracker Notifier
class CycleTrackerNotifier extends StateNotifier<AsyncValue<List<PeriodLog>>> {
 final CycleRepository _repo;

 CycleTrackerNotifier(this._repo) : super(const AsyncValue.loading()) {
 loadLogs();
 }

 Future<void> loadLogs() async {
 try {
 final logs = await _repo.getPeriodLogs();
 state = AsyncValue.data(logs);
 } catch (e, st) {
 state = AsyncValue.error(e, st);
 }
 }

 Future<void> addLog(PeriodLog log) async {
 await _repo.savePeriodLog(log);
 await loadLogs();
 }
}

final cycleTrackerProvider = StateNotifierProvider<CycleTrackerNotifier, AsyncValue<List<PeriodLog>>>((ref) {
 return CycleTrackerNotifier(ref.watch(cycleRepositoryProvider));
});

final periodLogsProvider = FutureProvider<List<PeriodLog>>((ref) async {
 final repo = ref.watch(cycleRepositoryProvider);
 return repo.getPeriodLogs();
});

final cyclePredictionProvider = FutureProvider<CyclePrediction>((ref) async {
 final logs = await ref.watch(periodLogsProvider.future);
 return CalculatePrediction().execute(logs);
});

final recommendationsProvider = FutureProvider<List<Recommendation>>((ref) async {
 final repo = ref.watch(cycleRepositoryProvider);
 return repo.getRecommendations();
});

final trackerInsightsProvider = FutureProvider<List<CycleInsight>>((ref) async {
 final repo = ref.watch(cycleRepositoryProvider);
 return repo.getInsights();
});

final calendarEventsProvider = FutureProvider<List<CalendarEvent>>((ref) async {
 final repo = ref.watch(cycleRepositoryProvider);
 return repo.getCalendarEvents();
});

// Progress Provider
final progressProvider = Provider<ProgressData>((ref) {
 final userState = ref.watch(userProvider);
 final user = userState.asData?.value;

 return ProgressData(
 currentXp: user?.totalXp ?? 45,
 streakDays: user?.learningStreak ?? 3,
 storiesCompleted: user?.totalStoriesCompleted ?? 1,
 totalModulesExplored: 4,
 );
});

// Achievements Provider
final achievementsProvider = FutureProvider<List<Achievement>>((ref) async {
 final repo = ref.watch(achievementsRepositoryProvider);
 return repo.getAchievements();
});
