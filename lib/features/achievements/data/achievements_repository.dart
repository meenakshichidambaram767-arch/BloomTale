import '../domain/achievement.dart';

abstract class AchievementsRepository {
 Future<List<Achievement>> getAchievements();
 Future<void> unlockAchievement(String id);
}

class MockAchievementsRepository implements AchievementsRepository {
 final List<Achievement> _achievements = [
 Achievement(
 id: 'first_step',
 title: 'First Step',
 description: 'Complete your first story module',
 iconName: 'flag_rounded',
 isUnlocked: true,
 unlockedAt: DateTime.now().subtract(const Duration(days: 2)),
 ),
 const Achievement(
 id: 'story_explorer',
 title: 'Story Explorer',
 description: 'Complete 5 educational stories',
 iconName: 'auto_stories_rounded',
 isUnlocked: false,
 ),
 Achievement(
 id: 'period_pro',
 title: 'Period Pro',
 description: 'Complete a menstruation learning module',
 iconName: 'water_drop_rounded',
 isUnlocked: true,
 unlockedAt: DateTime.now().subtract(const Duration(days: 1)),
 ),
 const Achievement(
 id: 'curious_mind',
 title: 'Curious Mind',
 description: 'Ask Bloom your first question',
 iconName: 'psychology_rounded',
 isUnlocked: true,
 ),
 const Achievement(
 id: 'growing_strong',
 title: 'Growing Strong',
 description: 'Maintain a 7-day learning streak',
 iconName: 'local_fire_department_rounded',
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
