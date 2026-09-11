class CycleLog {
 final String id;
 final DateTime date;
 final String flow; // 'Light', 'Medium', 'Heavy', 'Spotting', 'None'
 final String mood;
 final List<String> symptoms;
 final String notes;

 const CycleLog({
 required this.id,
 required this.date,
 required this.flow,
 required this.mood,
 required this.symptoms,
 this.notes = '',
 });

 Map<String, dynamic> toJson() {
 return {
 'id': id,
 'date': date.toIso8601String(),
 'flow': flow,
 'mood': mood,
 'symptoms': symptoms,
 'notes': notes,
 };
 }

 factory CycleLog.fromJson(Map<String, dynamic> json) {
 return CycleLog(
 id: json['id'] as String,
 date: DateTime.parse(json['date'] as String),
 flow: json['flow'] as String,
 mood: json['mood'] as String,
 symptoms: List<String>.from(json['symptoms'] as List),
 notes: (json['notes'] as String?) ?? '',
 );
 }
}
