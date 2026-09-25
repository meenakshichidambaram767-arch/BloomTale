import '../models/achievement.dart';

abstract class AchievementService {
  Future<List<Achievement>> getAchievements();
  Future<void> unlockAchievement(String id);
}

class MockAchievementService implements AchievementService {
  final List<Achievement> _achievements = [
    Achievement(
      id: 'first_step',
      title: 'First Step',
      description: 'Complete your first story module',
      icon: 'flag_rounded',
      category: 'Learning',
      isUnlocked: true,
      unlockedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    const Achievement(
      id: 'story_explorer',
      title: 'Story Explorer',
      description: 'Complete 5 educational stories',
      icon: 'auto_stories_rounded',
      category: 'Learning',
      isUnlocked: false,
    ),
    Achievement(
      id: 'period_pro',
      title: 'Period Pro',
      description: 'Complete a menstruation learning module',
      icon: 'water_drop_rounded',
      category: 'Health',
      isUnlocked: true,
      unlockedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    const Achievement(
      id: 'curious_mind',
      title: 'Curious Mind',
      description: 'Ask Bloom your first question',
      icon: 'psychology_rounded',
      category: 'AI Companion',
      isUnlocked: true,
    ),
    const Achievement(
      id: 'growing_strong',
      title: 'Growing Strong',
      description: 'Maintain a 7-day learning streak',
      icon: 'local_fire_department_rounded',
      category: 'Streak',
      isUnlocked: false,
    ),
  ];

  @override
  Future<List<Achievement>> getAchievements() async {
    return List.from(_achievements);
  }

  @override
  Future<void> unlockAchievement(String id) async {
    final index = _achievements.indexWhere((a) => a.id == id);
    if (index != -1) {
      _achievements[index] = _achievements[index].copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
    }
  }
}
