import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../../domain/bloom_ai_message.dart';
import '../../domain/entities/bloom_enums.dart';
import '../../domain/entities/bloom_context.dart';
import '../../domain/entities/bloom_topic.dart';
import '../../domain/entities/bloom_prep_item.dart';
import '../../domain/entities/bloom_journal_entry.dart';
import '../../data/bloom_ai_repository.dart';

// Current Bloom Avatar Expression Provider
final bloomAvatarExpressionProvider = StateProvider<BloomExpression>((ref) {
 return BloomExpression.happy;
});

// Main Chat State Notifier
class BloomChatState {
 final List<BloomAiMessage> messages;
 final bool isLoading;
 final ExplanationLevel activeExplanationLevel;
 final BloomContext? currentContext;
 final String? error;

 const BloomChatState({
 this.messages = const [],
 this.isLoading = false,
 this.activeExplanationLevel = ExplanationLevel.simple,
 this.currentContext,
 this.error,
 });

 BloomChatState copyWith({
 List<BloomAiMessage>? messages,
 bool? isLoading,
 ExplanationLevel? activeExplanationLevel,
 BloomContext? currentContext,
 String? error,
 }) {
 return BloomChatState(
 messages: messages ?? this.messages,
 isLoading: isLoading ?? this.isLoading,
 activeExplanationLevel: activeExplanationLevel ?? this.activeExplanationLevel,
 currentContext: currentContext ?? this.currentContext,
 error: error,
 );
 }
}

class BloomChatNotifier extends StateNotifier<BloomChatState> {
 final BloomAiRepository _repo;
 final Ref _ref;

 BloomChatNotifier(this._repo, this._ref) : super(const BloomChatState()) {
 loadHistory();
 }

 Future<void> loadHistory() async {
 state = state.copyWith(isLoading: true);
 try {
 final history = await _repo.getConversationHistory();
 state = state.copyWith(messages: history, isLoading: false);
 } catch (e) {
 state = state.copyWith(isLoading: false, error: e.toString());
 }
 }

 void setContext(BloomContext context) {
 state = state.copyWith(
 currentContext: context,
 activeExplanationLevel: context.preferredExplanationLevel,
 );
 }

 void setExplanationLevel(ExplanationLevel level) {
 state = state.copyWith(activeExplanationLevel: level);
 }

 Future<void> sendMessage(String text, {BloomContext? contextOverride}) async {
 if (text.trim().isEmpty) return;
 
 final ctx = contextOverride ?? state.currentContext;

 final userMsg = BloomAiMessage(
 id: DateTime.now().millisecondsSinceEpoch.toString(),
 text: text,
 isUser: true,
 timestamp: DateTime.now(),
 explanationLevel: state.activeExplanationLevel,
 );

 state = state.copyWith(
 messages: [...state.messages, userMsg],
 isLoading: true,
 );

 // Update avatar expression to thinking
 _ref.read(bloomAvatarExpressionProvider.notifier).state = BloomExpression.thinking;

 try {
 final aiReply = await _repo.sendMessage(text, context: ctx);
 
 // Update avatar expression based on reply
 _ref.read(bloomAvatarExpressionProvider.notifier).state = aiReply.expression;

 state = state.copyWith(
 messages: [...state.messages, aiReply],
 isLoading: false,
 );
 } catch (e) {
 state = state.copyWith(
 isLoading: false,
 error: 'Bloom is taking a short break. Please try asking again in a moment! ',
 );
 }
 }

 Future<void> toggleSaveAnswer(BloomAiMessage message) async {
 final updatedSaved = await _repo.toggleSaveAnswer(message);
 _ref.read(savedAnswersProvider.notifier).updateList(updatedSaved);
 
 // Update message state locally
 final updatedMessages = state.messages.map((m) {
 if (m.id == message.id || m.text == message.text) {
 return m.copyWith(isSaved: !m.isSaved);
 }
 return m;
 }).toList();

 state = state.copyWith(messages: updatedMessages);
 }
}

final bloomChatProvider = StateNotifierProvider<BloomChatNotifier, BloomChatState>((ref) {
 return BloomChatNotifier(ref.watch(bloomAiRepositoryProvider), ref);
});

// Saved Answers State Notifier
class SavedAnswersNotifier extends StateNotifier<List<BloomAiMessage>> {
 final BloomAiRepository _repo;

 SavedAnswersNotifier(this._repo) : super([]) {
 loadSavedAnswers();
 }

 Future<void> loadSavedAnswers() async {
 final list = await _repo.getSavedAnswers();
 state = list;
 }

 void updateList(List<BloomAiMessage> newList) {
 state = newList;
 }

 Future<void> removeAnswer(BloomAiMessage message) async {
 final updated = await _repo.toggleSaveAnswer(message);
 state = updated;
 }
}

final savedAnswersProvider = StateNotifierProvider<SavedAnswersNotifier, List<BloomAiMessage>>((ref) {
 return SavedAnswersNotifier(ref.watch(bloomAiRepositoryProvider));
});

// Topics Provider
final bloomTopicsProvider = FutureProvider<List<BloomTopic>>((ref) async {
 final repo = ref.watch(bloomAiRepositoryProvider);
 return repo.getTopics();
});

// Period Prep Items Notifier
class BloomPrepNotifier extends StateNotifier<AsyncValue<List<BloomPrepItem>>> {
 final BloomAiRepository _repo;

 BloomPrepNotifier(this._repo) : super(const AsyncValue.loading()) {
 loadItems();
 }

 Future<void> loadItems() async {
 try {
 final items = await _repo.getPrepItems();
 state = AsyncValue.data(items);
 } catch (e, st) {
 state = AsyncValue.error(e, st);
 }
 }

 Future<void> toggleItem(String id) async {
 final current = state.value ?? [];
 final updated = current.map((item) {
 if (item.id == id) {
 return item.copyWith(isCompleted: !item.isCompleted);
 }
 return item;
 }).toList();

 state = AsyncValue.data(updated);
 await _repo.savePrepItems(updated);
 }

 Future<void> addItem(String title) async {
 if (title.trim().isEmpty) return;
 final current = state.value ?? [];
 final newItem = BloomPrepItem(
 id: DateTime.now().millisecondsSinceEpoch.toString(),
 title: title.trim(),
 isCompleted: false,
 isCustom: true,
 );
 final updated = [...current, newItem];
 state = AsyncValue.data(updated);
 await _repo.savePrepItems(updated);
 }

 Future<void> removeItem(String id) async {
 final current = state.value ?? [];
 final updated = current.where((item) => item.id != id).toList();
 state = AsyncValue.data(updated);
 await _repo.savePrepItems(updated);
 }
}

final bloomPrepProvider = StateNotifierProvider<BloomPrepNotifier, AsyncValue<List<BloomPrepItem>>>((ref) {
 return BloomPrepNotifier(ref.watch(bloomAiRepositoryProvider));
});

// Journal Notifier
class BloomJournalNotifier extends StateNotifier<AsyncValue<List<BloomJournalEntry>>> {
 final BloomAiRepository _repo;

 BloomJournalNotifier(this._repo) : super(const AsyncValue.loading()) {
 loadEntries();
 }

 Future<void> loadEntries() async {
 try {
 final entries = await _repo.getJournalEntries();
 state = AsyncValue.data(entries);
 } catch (e, st) {
 state = AsyncValue.error(e, st);
 }
 }

 Future<BloomJournalEntry> addEntry(String mood, String note) async {
 final entry = await _repo.saveJournalEntry(mood, note);
 await loadEntries();
 return entry;
 }
}

final bloomJournalProvider = StateNotifierProvider<BloomJournalNotifier, AsyncValue<List<BloomJournalEntry>>>((ref) {
 return BloomJournalNotifier(ref.watch(bloomAiRepositoryProvider));
});
