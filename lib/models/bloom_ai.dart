enum BloomExpression {
  happy,
  calm,
  thinking,
  curious,
  concerned,
  reassuring,
  encouraging,
  celebrating,
}

enum ExplanationLevel {
  simple,
  detail,
}

enum SafetyCategory {
  safe,
  medicalDisclaimer,
  crisis,
}

class BloomAiMessage {
  final String id;
  final String text;
  final String? detailedText;
  final bool isUser;
  final DateTime timestamp;
  final BloomExpression expression;
  final bool isSaved;
  final ExplanationLevel explanationLevel;
  final String? relatedStoryId;
  final List<String> suggestedFollowUps;
  final SafetyCategory safetyCategory;

  const BloomAiMessage({
    required this.id,
    required this.text,
    this.detailedText,
    required this.isUser,
    required this.timestamp,
    this.expression = BloomExpression.happy,
    this.isSaved = false,
    this.explanationLevel = ExplanationLevel.simple,
    this.relatedStoryId,
    this.suggestedFollowUps = const [],
    this.safetyCategory = SafetyCategory.safe,
  });

  String get activeText =>
      (explanationLevel == ExplanationLevel.detail && detailedText != null)
          ? detailedText!
          : text;

  BloomAiMessage copyWith({
    String? id,
    String? text,
    String? detailedText,
    bool? isUser,
    DateTime? timestamp,
    BloomExpression? expression,
    bool? isSaved,
    ExplanationLevel? explanationLevel,
    String? relatedStoryId,
    List<String>? suggestedFollowUps,
    SafetyCategory? safetyCategory,
  }) {
    return BloomAiMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      detailedText: detailedText ?? this.detailedText,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      expression: expression ?? this.expression,
      isSaved: isSaved ?? this.isSaved,
      explanationLevel: explanationLevel ?? this.explanationLevel,
      relatedStoryId: relatedStoryId ?? this.relatedStoryId,
      suggestedFollowUps: suggestedFollowUps ?? this.suggestedFollowUps,
      safetyCategory: safetyCategory ?? this.safetyCategory,
    );
  }
}

class BloomTopic {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final int colorHex;
  final List<String> suggestedQuestions;
  final String? relatedStoryId;

  const BloomTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.colorHex,
    required this.suggestedQuestions,
    this.relatedStoryId,
  });
}

class BloomJournalEntry {
  final String id;
  final String mood;
  final String note;
  final DateTime timestamp;
  final String? bloomFeedback;

  const BloomJournalEntry({
    required this.id,
    required this.mood,
    required this.note,
    required this.timestamp,
    this.bloomFeedback,
  });
}

class BloomPrepItem {
  final String id;
  final String title;
  final bool isCompleted;
  final bool isCustom;

  const BloomPrepItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.isCustom = false,
  });

  BloomPrepItem copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    bool? isCustom,
  }) {
    return BloomPrepItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}

class BloomContext {
  final String? source;
  final String? topic;
  final String? initialQuestion;
  final String? symptomContext;
  final String? moodContext;
  final String? upcomingEvent;
  final String? storyId;
  final ExplanationLevel preferredExplanationLevel;

  const BloomContext({
    this.source,
    this.topic,
    this.initialQuestion,
    this.symptomContext,
    this.moodContext,
    this.upcomingEvent,
    this.storyId,
    this.preferredExplanationLevel = ExplanationLevel.simple,
  });

  bool get hasContext =>
      source != null ||
      topic != null ||
      symptomContext != null ||
      upcomingEvent != null ||
      storyId != null;

  BloomContext copyWith({
    String? source,
    String? topic,
    String? initialQuestion,
    String? symptomContext,
    String? moodContext,
    String? upcomingEvent,
    String? storyId,
    ExplanationLevel? preferredExplanationLevel,
  }) {
    return BloomContext(
      source: source ?? this.source,
      topic: topic ?? this.topic,
      initialQuestion: initialQuestion ?? this.initialQuestion,
      symptomContext: symptomContext ?? this.symptomContext,
      moodContext: moodContext ?? this.moodContext,
      upcomingEvent: upcomingEvent ?? this.upcomingEvent,
      storyId: storyId ?? this.storyId,
      preferredExplanationLevel: preferredExplanationLevel ?? this.preferredExplanationLevel,
    );
  }
}

class BloomAiSafety {
  static const String systemInstruction = '''
You are Bloom , a supportive, warm, educational AI companion for adolescent girls (aged 10-18).
Guidelines:
1. Always maintain a warm, gentle, encouraging, and age-appropriate tone.
2. Provide clear, medically accurate facts regarding puberty, hygiene, menstruation, and emotional well-being without overwhelming jargon.
3. NEVER diagnose medical conditions or prescribe treatments. Always recommend talking to a parent, trusted adult, school nurse, or healthcare professional for health concerns.
4. Keep interactions safe, non-judgmental, and private. Never request personal identifying information like full name, school, address, or phone number.
5. If the user expresses severe distress, self-harm, suicidal thoughts, abuse, or emergency, gently direct them to contact emergency services or a trusted adult immediately.
''';

  static String sanitizeInput(String input) {
    return input.trim();
  }

  static SafetyCategory checkSafetyCategory(String input) {
    final lower = input.toLowerCase();

    if (lower.contains('die') ||
        lower.contains('dying') ||
        lower.contains('kill') ||
        lower.contains('suicide') ||
        lower.contains('suicidal') ||
        lower.contains('self-harm') ||
        lower.contains('harm') ||
        lower.contains('cut myself') ||
        lower.contains('abused') ||
        lower.contains('hurt me') ||
        lower.contains('emergency') ||
        lower.contains('danger')) {
      return SafetyCategory.crisis;
    }

    if (lower.contains('faint') ||
        lower.contains('severe pain') ||
        lower.contains('extreme bleeding') ||
        lower.contains('disease') ||
        lower.contains('infection') ||
        lower.contains('medicine') ||
        lower.contains('pill') ||
        lower.contains('doctor')) {
      return SafetyCategory.medicalDisclaimer;
    }

    return SafetyCategory.safe;
  }

  static String getCrisisEscalationResponse() {
    return " I'm really glad you reached out to me. You deserve support and you don't have to carry this alone.\n\n"
        "Please tell a parent, teacher, school nurse, or trusted adult right away who can help support you.\n\n"
        "If you feel in immediate danger or need urgent help, please reach out to emergency services or call/text a local crisis helpline immediately.";
  }

  static String formatSafeResponse(String rawResponse, SafetyCategory category) {
    if (category == SafetyCategory.crisis) {
      return getCrisisEscalationResponse();
    }
    if (category == SafetyCategory.medicalDisclaimer && !rawResponse.contains('trusted adult')) {
      return '$rawResponse\n\n *Tip: Please remember that if you feel severe discomfort or have health concerns, talking to a parent, doctor, or trusted adult is always the best step!*';
    }
    return rawResponse;
  }
}
