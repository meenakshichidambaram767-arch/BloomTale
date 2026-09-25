class ProgressData {
  final int streakDays;
  final int totalStoriesCompleted;
  final int totalCheckIns;
  final int currentLevel;
  final int currentXp;
  final int xpForNextLevel;

  const ProgressData({
    required this.streakDays,
    required this.totalStoriesCompleted,
    required this.totalCheckIns,
    required this.currentLevel,
    required this.currentXp,
    required this.xpForNextLevel,
  });

  double get xpProgressRatio => (currentXp % 100) / 100.0;
  double get levelProgress => xpProgressRatio;
  int get storiesCompleted => totalStoriesCompleted;
}
