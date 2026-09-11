class UserProfile {
 final String id;
 final String name;
 final String avatarId;
 final DateTime createdAt;
 final bool onboardingCompleted;
 final int learningStreak;
 final int totalStoriesCompleted;
 final int totalXp;

 const UserProfile({
 required this.id,
 required this.name,
 this.avatarId = 'default_avatar',
 required this.createdAt,
 this.onboardingCompleted = false,
 this.learningStreak = 1,
 this.totalStoriesCompleted = 0,
 this.totalXp = 0,
 });

 UserProfile copyWith({
 String? id,
 String? name,
 String? avatarId,
 DateTime? createdAt,
 bool? onboardingCompleted,
 int? learningStreak,
 int? totalStoriesCompleted,
 int? totalXp,
 }) {
 return UserProfile(
 id: id ?? this.id,
 name: name ?? this.name,
 avatarId: avatarId ?? this.avatarId,
 createdAt: createdAt ?? this.createdAt,
 onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
 learningStreak: learningStreak ?? this.learningStreak,
 totalStoriesCompleted: totalStoriesCompleted ?? this.totalStoriesCompleted,
 totalXp: totalXp ?? this.totalXp,
 );
 }

 Map<String, dynamic> toJson() {
 return {
 'id': id,
 'name': name,
 'avatarId': avatarId,
 'createdAt': createdAt.toIso8601String(),
 'onboardingCompleted': onboardingCompleted,
 'learningStreak': learningStreak,
 'totalStoriesCompleted': totalStoriesCompleted,
 'totalXp': totalXp,
 };
 }

 factory UserProfile.fromJson(Map<String, dynamic> json) {
 return UserProfile(
 id: json['id'] as String,
 name: json['name'] as String,
 avatarId: (json['avatarId'] as String?) ?? 'default_avatar',
 createdAt: DateTime.parse(json['createdAt'] as String),
 onboardingCompleted: (json['onboardingCompleted'] as bool?) ?? false,
 learningStreak: (json['learningStreak'] as int?) ?? 1,
 totalStoriesCompleted: (json['totalStoriesCompleted'] as int?) ?? 0,
 totalXp: (json['totalXp'] as int?) ?? 0,
 );
 }
}
