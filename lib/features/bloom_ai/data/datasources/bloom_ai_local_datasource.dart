import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/bloom_ai_message.dart';
import '../../domain/entities/bloom_prep_item.dart';
import '../../domain/entities/bloom_journal_entry.dart';
import '../../domain/entities/bloom_enums.dart';

class BloomAiLocalDataSource {
 static const String _savedAnswersKey = 'bloom_saved_answers';
 static const String _prepItemsKey = 'bloom_prep_items';
 static const String _journalEntriesKey = 'bloom_journal_entries';

 // Saved Answers
 Future<List<BloomAiMessage>> getSavedAnswers() async {
 final prefs = await SharedPreferences.getInstance();
 final String? dataStr = prefs.getString(_savedAnswersKey);
 if (dataStr == null) return [];
 try {
 final List<dynamic> jsonList = jsonDecode(dataStr);
 return jsonList.map((item) {
 return BloomAiMessage(
 id: item['id'] ?? '',
 text: item['text'] ?? '',
 detailedText: item['detailedText'],
 isUser: false,
 timestamp: DateTime.tryParse(item['timestamp'] ?? '') ?? DateTime.now(),
 expression: BloomExpression.values.firstWhere(
 (e) => e.name == item['expression'],
 orElse: () => BloomExpression.happy,
 ),
 isSaved: true,
 relatedStoryId: item['relatedStoryId'],
 );
 }).toList();
 } catch (_) {
 return [];
 }
 }

 Future<void> toggleSaveAnswer(BloomAiMessage message) async {
 final current = await getSavedAnswers();
 final exists = current.any((m) => m.id == message.id || m.text == message.text);
 List<BloomAiMessage> updated;
 if (exists) {
 updated = current.where((m) => m.id != message.id && m.text != message.text).toList();
 } else {
 updated = [...current, message.copyWith(isSaved: true)];
 }
 final prefs = await SharedPreferences.getInstance();
 final jsonList = updated.map((m) => {
 'id': m.id,
 'text': m.text,
 'detailedText': m.detailedText,
 'timestamp': m.timestamp.toIso8601String(),
 'expression': m.expression.name,
 'relatedStoryId': m.relatedStoryId,
 }).toList();
 await prefs.setString(_savedAnswersKey, jsonEncode(jsonList));
 }

 // Period Prep Items
 Future<List<BloomPrepItem>> getPrepItems() async {
 final prefs = await SharedPreferences.getInstance();
 final String? dataStr = prefs.getString(_prepItemsKey);
 if (dataStr == null) {
 return const [
 BloomPrepItem(id: '1', title: 'Period products (pads/tampons)', isCompleted: true),
 BloomPrepItem(id: '2', title: 'Extra underwear', isCompleted: true),
 BloomPrepItem(id: '3', title: 'Small discrete pouch', isCompleted: false),
 BloomPrepItem(id: '4', title: 'Tissues / wet wipes', isCompleted: false),
 BloomPrepItem(id: '5', title: 'Know where to change privately', isCompleted: false),
 BloomPrepItem(id: '6', title: 'Know who I can ask for help', isCompleted: false),
 ];
 }
 try {
 final List<dynamic> jsonList = jsonDecode(dataStr);
 return jsonList.map((item) => BloomPrepItem(
 id: item['id'],
 title: item['title'],
 isCompleted: item['isCompleted'] ?? false,
 isCustom: item['isCustom'] ?? false,
 )).toList();
 } catch (_) {
 return [];
 }
 }

 Future<void> savePrepItems(List<BloomPrepItem> items) async {
 final prefs = await SharedPreferences.getInstance();
 final jsonList = items.map((item) => {
 'id': item.id,
 'title': item.title,
 'isCompleted': item.isCompleted,
 'isCustom': item.isCustom,
 }).toList();
 await prefs.setString(_prepItemsKey, jsonEncode(jsonList));
 }

 // Journal Entries
 Future<List<BloomJournalEntry>> getJournalEntries() async {
 final prefs = await SharedPreferences.getInstance();
 final String? dataStr = prefs.getString(_journalEntriesKey);
 if (dataStr == null) return [];
 try {
 final List<dynamic> jsonList = jsonDecode(dataStr);
 return jsonList.map((item) => BloomJournalEntry(
 id: item['id'],
 mood: item['mood'],
 note: item['note'],
 timestamp: DateTime.parse(item['timestamp']),
 bloomFeedback: item['bloomFeedback'],
 )).toList();
 } catch (_) {
 return [];
 }
 }

 Future<void> saveJournalEntry(BloomJournalEntry entry) async {
 final current = await getJournalEntries();
 final updated = [entry, ...current];
 final prefs = await SharedPreferences.getInstance();
 final jsonList = updated.map((e) => {
 'id': e.id,
 'mood': e.mood,
 'note': e.note,
 'timestamp': e.timestamp.toIso8601String(),
 'bloomFeedback': e.bloomFeedback,
 }).toList();
 await prefs.setString(_journalEntriesKey, jsonEncode(jsonList));
 }
}
