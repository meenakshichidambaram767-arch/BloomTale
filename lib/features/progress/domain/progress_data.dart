class ProgressData {
 final int currentXp;
 final int streakDays;
 final int storiesCompleted;
 final int totalModulesExplored;

 const ProgressData({
 required this.currentXp,
 required this.streakDays,
 required this.storiesCompleted,
 required this.totalModulesExplored,
 });

 int get currentLevel => (currentXp / 50).floor() + 1;
 double get levelProgress => (currentXp % 50) / 50.0;
}
