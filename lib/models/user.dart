class UserProfile {
  final String id;
  final String name;
  final int age;
  final String avatarId;
  final int xp;
  final int level;
  final DateTime? lastPeriodDate;
  final int cycleLength;

  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.avatarId,
    this.xp = 0,
    this.level = 1,
    this.lastPeriodDate,
    this.cycleLength = 28,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? avatarId,
    int? xp,
    int? level,
    DateTime? lastPeriodDate,
    int? cycleLength,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      avatarId: avatarId ?? this.avatarId,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
      cycleLength: cycleLength ?? this.cycleLength,
    );
  }
}
