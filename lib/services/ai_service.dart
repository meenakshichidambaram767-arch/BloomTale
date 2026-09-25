import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/bloom_ai.dart';

abstract class AiService {
  Future<List<BloomAiMessage>> getConversationHistory();
  Future<BloomAiMessage> sendMessage(String userMessage, {BloomContext? context});
  Future<List<BloomAiMessage>> getSavedAnswers();
  Future<List<BloomAiMessage>> toggleSaveAnswer(BloomAiMessage message);
  Future<List<BloomTopic>> getTopics();
  Future<List<BloomPrepItem>> getPrepItems();
  Future<List<BloomPrepItem>> savePrepItems(List<BloomPrepItem> items);
  Future<List<BloomJournalEntry>> getJournalEntries();
  Future<BloomJournalEntry> saveJournalEntry(String mood, String note);
  Future<String> generateTellSomeoneStarter(String recipient, String topic, {String style = 'standard'});
}

class BloomAiLocalDataSource {
  static const String _savedAnswersKey = 'bloom_saved_answers';
  static const String _prepItemsKey = 'bloom_prep_items';
  static const String _journalEntriesKey = 'bloom_journal_entries';

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

class MockAiService implements AiService {
  final BloomAiLocalDataSource _localDataSource = BloomAiLocalDataSource();
  final _uuid = const Uuid();

  final List<BloomAiMessage> _messages = [
    BloomAiMessage(
      id: '1',
      text: "Hi! I'm Bloom Your safe space to ask, learn, and grow. What would you like to talk about today?",
      detailedText: "Hi there! I'm Bloom . I am your safe, friendly educational companion designed to help you understand puberty, periods, emotions, body changes, and self-confidence with age-appropriate, non-judgmental guidance.",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      expression: BloomExpression.happy,
      suggestedFollowUps: [
        "Why do I get cramps?",
        "Why does my mood change?",
        "How do I prepare for my period?",
      ],
    ),
  ];

  @override
  Future<List<BloomAiMessage>> getConversationHistory() async {
    return List.from(_messages);
  }

  @override
  Future<BloomAiMessage> sendMessage(String userMessage, {BloomContext? context}) async {
    final sanitizedInput = BloomAiSafety.sanitizeInput(userMessage);

    final userMsgObj = BloomAiMessage(
      id: _uuid.v4(),
      text: sanitizedInput,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsgObj);

    await Future.delayed(const Duration(milliseconds: 700));

    final safetyCategory = BloomAiSafety.checkSafetyCategory(sanitizedInput);

    if (safetyCategory == SafetyCategory.crisis) {
      final crisisText = BloomAiSafety.getCrisisEscalationResponse();
      final crisisMsg = BloomAiMessage(
        id: _uuid.v4(),
        text: crisisText,
        isUser: false,
        timestamp: DateTime.now(),
        expression: BloomExpression.concerned,
        safetyCategory: SafetyCategory.crisis,
        suggestedFollowUps: ["Help me tell someone", "I'm okay now"],
      );
      _messages.add(crisisMsg);
      return crisisMsg;
    }

    final (replyText, detailText, expression, storyId, followUps) = _generateContextualAiReply(sanitizedInput, context);
    final safeReply = BloomAiSafety.formatSafeResponse(replyText, safetyCategory);

    final aiMsgObj = BloomAiMessage(
      id: _uuid.v4(),
      text: safeReply,
      detailedText: detailText,
      isUser: false,
      timestamp: DateTime.now(),
      expression: expression,
      explanationLevel: context?.preferredExplanationLevel ?? ExplanationLevel.simple,
      relatedStoryId: storyId,
      suggestedFollowUps: followUps,
      safetyCategory: safetyCategory,
    );

    _messages.add(aiMsgObj);
    return aiMsgObj;
  }

  (String, String?, BloomExpression, String?, List<String>) _generateContextualAiReply(
    String input,
    BloomContext? context,
  ) {
    final lower = input.toLowerCase();

    if (lower.contains('cramp') || lower.contains('period pain')) {
      return (
        "Period cramps happen because your uterus muscles contract to shed its lining. Mild discomfort is common and normal!",
        "During your menstrual cycle, your body produces natural substances called prostaglandins that make the muscular walls of your uterus contract. This helps release the lining during your period. Resting with a cozy warm heating pad, drinking warm chamomile tea, staying hydrated, and gentle stretching can ease cramp discomfort.",
        BloomExpression.reassuring,
        'bursting_myths',
        ["What can help with cramps?", "Is this normal?", "Learn more in Stories"]
      );
    }

    if (lower.contains('mood') || lower.contains('emotional') || lower.contains('cry') || lower.contains('angry')) {
      return (
        "Hormones fluctuate during puberty and cycle phases. One day you might feel super energetic, and another day emotional. That's 100% normal!",
        "Estrogen and progesterone hormones naturally rise and shift throughout your cycle. These natural chemical changes influence neurotransmitters like serotonin in your brain. Writing in your Bloom Journal, taking quiet outdoor breaks, and remembering that feelings come in waves are great ways to honor your emotions.",
        BloomExpression.calm,
        'bursting_myths',
        ["Why do hormones shift?", "How can I feel better?", "Write in Journal"]
      );
    }

    if (lower.contains('prepare') || lower.contains('pack') || lower.contains('kit') || lower.contains('sports day')) {
      return (
        "A little preparation goes a long way! Packing a small pouch with pads, extra underwear, and wet wipes keeps you feeling ready and confident.",
        "Having a personal period kit ready beforehand takes away unexpected stress—especially during school days, sports events, or trips. Keep a small zipper pouch in your backpack with 2-3 pads, clean spare underwear, tissues, and know where private restrooms are located.",
        BloomExpression.encouraging,
        'bursting_myths',
        ["Open Period Prep Assistant", "What else should I pack?", "Who can I ask for help?"]
      );
    }

    if (lower.contains('tell') || lower.contains('mom') || lower.contains('embarrassed') || lower.contains('talk')) {
      return (
        "It's completely okay to feel embarrassed talking about periods or body changes. You don't have to figure it out alone!",
        "Reaching out to a trusted adult—like a parent, aunt, teacher, or school nurse—is easier when you have a warm conversation starter ready. You can say: 'I have some questions about growing up that I'd like to ask you.'",
        BloomExpression.reassuring,
        'bursting_myths',
        ["Try Tell Someone Assistant", "Make a short starter", "Talk to Bloom first"]
      );
    }

    if (lower.contains('puberty') || lower.contains('body') || lower.contains('breast') || lower.contains('acne')) {
      return (
        "Puberty is your body's amazing way of growing into a young adult! Everyone goes through changes at their own unique pace.",
        "During puberty, your brain signals your body to produce hormones that stimulate growth spurts, skin oil changes, body hair, breast tissue development, and menstruation. No two people develop on the exact same timeline, so comparing yourself to friends is unnecessary!",
        BloomExpression.celebrating,
        'bursting_myths',
        ["Why do pimples happen?", "What is a growth spurt?", "Explore Topics"]
      );
    }

    return (
      "That is a great question! Growing up brings so many new experiences. Remember every change your body and mind experience is part of your unique story.",
      "As you grow up, your body and emotions naturally change. Asking questions and learning how your body works helps you feel confident, healthy, and self-assured every single day.",
      BloomExpression.curious,
      null,
      ["Why do periods happen?", "How can I feel confident?", "Explore Topics"]
    );
  }

  @override
  Future<List<BloomAiMessage>> getSavedAnswers() async {
    return _localDataSource.getSavedAnswers();
  }

  @override
  Future<List<BloomAiMessage>> toggleSaveAnswer(BloomAiMessage message) async {
    await _localDataSource.toggleSaveAnswer(message);
    return getSavedAnswers();
  }

  @override
  Future<List<BloomTopic>> getTopics() async {
    return const [
      BloomTopic(
        id: 'puberty',
        title: 'Puberty & Body Changes',
        description: 'Understand how your body grows, skin changes, and growth spurts.',
        iconName: 'spa',
        colorHex: 0xFFFF85A1,
        suggestedQuestions: [
          'What happens during puberty?',
          'Why do pimples happen?',
          'Is it normal to grow fast?',
        ],
        relatedStoryId: 'bursting_myths',
      ),
      BloomTopic(
        id: 'periods',
        title: 'Periods & Cycle',
        description: 'Learn why periods happen, cramps, cycle phases, and prep tips.',
        iconName: 'water_drop',
        colorHex: 0xFFFFC2D1,
        suggestedQuestions: [
          'Why do I get cramps?',
          'Why do periods happen?',
          'What is irregular bleeding?',
        ],
        relatedStoryId: 'bursting_myths',
      ),
      BloomTopic(
        id: 'emotions',
        title: 'Emotions & Wellbeing',
        description: 'Navigate mood shifts, vulnerability, feeling overwhelmed, and calm.',
        iconName: 'favorite',
        colorHex: 0xFFD8BBFF,
        suggestedQuestions: [
          'Why does my mood change?',
          'How can I feel calm?',
          'Why do I feel emotional?',
        ],
        relatedStoryId: 'bursting_myths',
      ),
      BloomTopic(
        id: 'hygiene',
        title: 'Hygiene & Self-Care',
        description: 'Daily care routines, gentle skin care, shower tips, and freshness.',
        iconName: 'clean_hands',
        colorHex: 0xFFB8F2E6,
        suggestedQuestions: [
          'How to build a gentle skin routine?',
          'What is best hygiene during period?',
          'How often to change pads?',
        ],
        relatedStoryId: 'bursting_myths',
      ),
      BloomTopic(
        id: 'confidence',
        title: 'Confidence & Growth',
        description: 'Build self-esteem, embrace your uniqueness, and feel empowered.',
        iconName: 'star',
        colorHex: 0xFFFFE5EC,
        suggestedQuestions: [
          'How can I feel more confident?',
          'How to stop comparing myself?',
          'How to celebrate my body?',
        ],
        relatedStoryId: 'bursting_myths',
      ),
      BloomTopic(
        id: 'everyday',
        title: 'Everyday Questions',
        description: 'Quick safe answers about sports, school, sleep, and nutrition.',
        iconName: 'help_outline',
        colorHex: 0xFFFF9F1C,
        suggestedQuestions: [
          'Can I do sports during my period?',
          'What snacks help energy?',
          'How much sleep do I need?',
        ],
        relatedStoryId: 'bursting_myths',
      ),
    ];
  }

  @override
  Future<List<BloomPrepItem>> getPrepItems() async {
    return _localDataSource.getPrepItems();
  }

  @override
  Future<List<BloomPrepItem>> savePrepItems(List<BloomPrepItem> items) async {
    await _localDataSource.savePrepItems(items);
    return getPrepItems();
  }

  @override
  Future<List<BloomJournalEntry>> getJournalEntries() async {
    return _localDataSource.getJournalEntries();
  }

  @override
  Future<BloomJournalEntry> saveJournalEntry(String mood, String note) async {
    String feedback;
    switch (mood.toLowerCase()) {
      case 'happy':
        feedback = "It's wonderful to celebrate bright, happy moments! Keep shining and enjoying your day.";
        break;
      case 'calm':
        feedback = "Finding calm and inner peace is a beautiful strength. Take a deep breath and stay cozy.";
        break;
      case 'worried':
        feedback = "It's completely okay to feel worried sometimes. Writing it down takes away some of its weight. You've got this!";
        break;
      case 'stressed':
        feedback = "Things might feel overwhelming right now. Remember to pause, take 3 deep breaths, and give yourself grace.";
        break;
      case 'tired':
        feedback = "Your body and mind deserve restful recovery. Treat yourself to a warm drink and early sleep tonight.";
        break;
      default:
        feedback = "Thank you for checking in with yourself today. Honoring all your emotions helps you grow strong!";
    }

    final entry = BloomJournalEntry(
      id: _uuid.v4(),
      mood: mood,
      note: note,
      timestamp: DateTime.now(),
      bloomFeedback: feedback,
    );

    await _localDataSource.saveJournalEntry(entry);
    return entry;
  }

  @override
  Future<String> generateTellSomeoneStarter(String recipient, String topic, {String style = 'standard'}) async {
    final rec = recipient.toLowerCase();
    final top = topic.toLowerCase();

    if (style == 'shorter') {
      return '"$recipient, can we talk privately for a moment about something I\'ve been asking about?"';
    }

    if (style == 'casual') {
      return '"Hey $recipient! I had a quick question about growing up and body changes, do you have a few minutes?"';
    }

    if (top.contains('period')) {
      return '"$recipient, I noticed some changes with my period recently and I\'ve been a little uncertain. Could we talk about it together?"';
    }

    if (top.contains('worried') || top.contains('feeling')) {
      return '"$recipient, I\'ve had a few things on my mind lately that feel a bit overwhelming. Can I share how I\'m feeling with you?"';
    }

    return '"$recipient, I have a question about growing up that I\'d feel much better talking through with you. When is a good time to chat?"';
  }
}
