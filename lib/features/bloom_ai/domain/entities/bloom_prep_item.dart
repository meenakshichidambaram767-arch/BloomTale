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
