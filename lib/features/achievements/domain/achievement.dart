class Achievement {
 final String id;
 final String title;
 final String description;
 final String iconName;
 final bool isUnlocked;
 final DateTime? unlockedAt;

 const Achievement({
 required this.id,
 required this.title,
 required this.description,
 required this.iconName,
 this.isUnlocked = false,
 this.unlockedAt,
 });

 Achievement copyWith({
 bool? isUnlocked,
 DateTime? unlockedAt,
 }) {
 return Achievement(
 id: id,
 title: title,
 description: description,
 iconName: iconName,
 isUnlocked: isUnlocked ?? this.isUnlocked,
 unlockedAt: unlockedAt ?? this.unlockedAt,
 );
 }
}
